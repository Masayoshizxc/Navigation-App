//
//  GooglePLacesManager.swift
//  Navigation App
//
//  Created by Adilet on 5/4/22.
//

import Foundation
import GooglePlaces

struct Place{
    let name: String
    let identifier: String
}

final class GooglePlacesManager{
    static let shared = GooglePlacesManager()
    
    private let client = GMSPlacesClient.shared()
    
    private init() {}
    
    enum PLacesError: Error {
        case failedToFind
    }
    
    
    
    public func findPlaces(query: String, completion: @escaping (Result<[Place], Error>) -> Void){
        let filter = GMSAutocompleteFilter()
        filter.type = .geocode
        client.findAutocompletePredictions(fromQuery: query, filter: filter, sessionToken: nil){ results, error in
            guard let results = results, error == nil else{
                completion(.failure(PLacesError.failedToFind))
                return
            }
            
            let places : [Place] = results.compactMap({
                Place(
                    name: $0.attributedFullText.string,
                    identifier: $0.placeID
                )
            })
            
            completion(.success(places))
            
        }
    }
}

