
//  ViewController.swift
//  Navigation App
//
//  Created by Adilet on 29/3/22.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, UISearchResultsUpdating, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var qwe = UILabel()
    
    let mapView = MKMapView()
    
    let searchVC = UISearchController(searchResultsController: ResultsViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Maps"
        view.addSubview(mapView)
        searchVC.searchBar.backgroundColor = .secondarySystemBackground
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
        setUpTitle()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            manager.stopUpdatingLocation()
            render(location)
        }
    }
    
    func render (_ location: CLLocation){
        
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
    }
    
    func setUpTitle(){
        qwe.text = "Maps"
        qwe.font = .boldSystemFont(ofSize: 36)
        qwe.frame = CGRect(x: 20, y: 30, width: 300, height: 50)
        view.addSubview(qwe)
    }
    
    func updateSearchResults(for searchController: UISearchController){
        guard let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
                  return
              }
        
        GooglePlacesManager.shared.findPlaces(query: query) { result in
            switch result{
            case .success(let places):
                print(places)
            case .failure(let error):
                print(error)
            }
            
        }
    }
}

