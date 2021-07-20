//
//  MapViewController.swift
//  CarPlayNavigation
//
//  Created by Oleksandr Orlov on 16.07.2021.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {
  
  // MARK: - UI elements
  
  private let selfView: MapView
  
  // MARK: - Dependencies
  
  private let locationManager = CLLocationManager()
  
  // MARK: - Life cycle
  
  init() {
    selfView = MapView()
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View - Life cycle
  
  override func loadView() {
    view = selfView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    locationManager.requestLocation()
  }
  
  func zoomIn() {
    selfView.zoomIn()
  }
  
  func zoomOut() {
    selfView.zoomOut()
  }
  
  func moveUp() {
    selfView.moveUp()
  }
  
  func moveDown() {
    selfView.moveDown()
  }
  
  func moveLeft() {
    selfView.moveLeft()
  }
  
  func moveRight() {
    selfView.moveRight()
  }
  
  func moveToCurrentLocation() {
    selfView.moveToCurrentLocation()
  }
  
  func getRegion() -> MKCoordinateRegion {
    return selfView.mapView.region
  }
  
  func makeRoute(to mapItem: MKMapItem) {
    selfView.makeRoute(to: mapItem)
  }
  
  // MARK: - CLLocationManagerDelegate
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    print(locations.last)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
  }
}
