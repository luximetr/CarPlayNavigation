//
//  ViewController.swift
//  CarPlayNavigation
//
//  Created by Oleksandr Orlov on 16.07.2021.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
  
  private let locationManager = CLLocationManager()
  private let mapView = MKMapView()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(mapView)
    mapView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    mapView.showsUserLocation = true
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    locationManager.requestLocation()
  }

  // MARK: - CLLocationManagerDelegate
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    print(locations.last)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
  }

}

