//
//  MapView.swift
//  CarPlayNavigation
//
//  Created by Oleksandr Orlov on 16.07.2021.
//

import UIKit
import SnapKit
import MapKit

class MapView: UIView, MKMapViewDelegate {
  
  // MARK: - UI elements
  
  let mapView = MKMapView()
  
  // MARK: - Data
  
  private let zoomMultiplier: Double = 1.7
  
  // MARK: - Public
  
  func zoomIn() {
    let span = MKCoordinateSpan(
      latitudeDelta: mapView.region.span.latitudeDelta / zoomMultiplier,
      longitudeDelta: mapView.region.span.longitudeDelta / zoomMultiplier
    )
    let region = MKCoordinateRegion(center: mapView.region.center, span: span)
    mapView.setRegion(region, animated: true)
  }
  
  func zoomOut() {
    let span = MKCoordinateSpan(
      latitudeDelta: mapView.region.span.latitudeDelta * zoomMultiplier,
      longitudeDelta: mapView.region.span.longitudeDelta * zoomMultiplier
    )
    let region = MKCoordinateRegion(center: mapView.region.center, span: span)
    mapView.setRegion(region, animated: true)
  }
  
  func moveUp() {
    moveTo(latitudeChange: getMoveDistance())
  }
  
  func moveDown() {
    moveTo(latitudeChange: -getMoveDistance())
  }
  
  func moveLeft() {
    moveTo(longitudeChange: -getMoveDistance())
  }
  
  func moveRight() {
    moveTo(longitudeChange: getMoveDistance())
  }
  
  func moveToCurrentLocation() {
    let currentLocation = mapView.userLocation.coordinate
    moveTo(coordinates: currentLocation)
  }
  
  private func moveTo(latitudeChange: Double = 0, longitudeChange: Double = 0) {
    let region = MKCoordinateRegion(
      center: CLLocationCoordinate2D(
        latitude: mapView.region.center.latitude + latitudeChange,
        longitude: mapView.region.center.longitude + longitudeChange
      ),
      span: mapView.region.span
    )
    mapView.setRegion(region, animated: true)
  }
  
  private func moveTo(coordinates: CLLocationCoordinate2D) {
    let zoom: CLLocationDegrees = 0.03
    let region = MKCoordinateRegion(
      center: coordinates,
      span: MKCoordinateSpan(
        latitudeDelta: zoom,
        longitudeDelta: zoom
      )
    )
    mapView.setRegion(region, animated: true)
  }
  
  private func getMoveDistance() -> CLLocationDistance {
    return mapView.region.span.longitudeDelta / 3.5
  }
  
  func makeRoute(to mapItem: MKMapItem) {
    let request = MKDirections.Request()
    let userMapItem = MKMapItem(
      placemark:
        MKPlacemark(
          coordinate: mapView.userLocation.coordinate
        )
    )
    request.source = userMapItem
    request.destination = mapItem
    
    let directions = MKDirections(request: request)
    directions.calculate(completionHandler: { [weak self] response, error in
      guard
        let mapRoute = response?.routes.first,
        let strongSelf = self else {
          return
      }
      strongSelf.mapView.removeOverlays(strongSelf.mapView.overlays)
      strongSelf.mapView.addOverlay(mapRoute.polyline)
    })
  }
  
  // MARK: - Life cycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupMapView()
  }
  
  // MARK: - Setup mapView
  
  private func setupMapView() {
    addSubview(mapView)
    mapView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    mapView.showsUserLocation = true
    mapView.delegate = self
  }
  
  // MARK: - MKMapViewDelegate
  
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    let renderer = MKPolylineRenderer(overlay: overlay)
    renderer.strokeColor = .systemBlue
    renderer.lineWidth = 3
    return renderer
  }
}
