//
//  CarPlaySceneDelegate.swift
//  CarPlayNavigation
//
//  Created by Oleksandr Orlov on 16.07.2021.
//

import UIKit
import CarPlay
import MapKit

class CarPlaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate, CPListTemplateDelegate, CPSearchTemplateDelegate {
  
  var interfaceController: CPInterfaceController?
  var mapViewController: MapViewController?
  private var mapCoordinator: MapCoordinator?
  
  func templateApplicationScene(
    _ templateApplicationScene: CPTemplateApplicationScene,
    didConnect interfaceController: CPInterfaceController,
    to window: CPWindow
  ) {
    self.interfaceController = interfaceController
    let coordinator = MapCoordinator()
    mapCoordinator = coordinator
    coordinator.showMap(interfaceController: interfaceController, window: window)
  }
  
  func openSearchTemplate() {
    let searchTemplate = CPSearchTemplate()
    searchTemplate.delegate = self
    interfaceController?.pushTemplate(searchTemplate, animated: true)
  }
  
  func openFavourites() {
    let favouritesTemplate = CPListTemplate(
      title: "Favourites",
      sections: []
    )
    let addButton = CPBarButton(type: .image) { _ in
      self.openSearchTemplate()
    }
    addButton.image = UIImage(named: "plus")
    favouritesTemplate.trailingNavigationBarButtons = [addButton]
    interfaceController?.pushTemplate(favouritesTemplate, animated: true)
  }
  
  func templateApplicationScene(
    _ templateApplicationScene: CPTemplateApplicationScene,
    didDisconnect interfaceController: CPInterfaceController,
    from window: CPWindow
  ) {
    self.interfaceController = nil
  }
  
  // MARK: - CPListTemplateDelegate
  
  func listTemplate(
    _ listTemplate: CPListTemplate,
    didSelect item: CPListItem,
    completionHandler: @escaping () -> Void
  ) {
    print("Did select item " + (item.text ?? ""))
    completionHandler()
  }
  
  // MARK: - CPSearchTemplateDelegate
  
  func searchTemplateSearchButtonPressed(_ searchTemplate: CPSearchTemplate) {
    
  }
  
  func searchTemplate(
    _ searchTemplate: CPSearchTemplate,
    updatedSearchText searchText: String,
    completionHandler: @escaping ([CPListItem]) -> Void
  ) {
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = searchText
    if let region = mapViewController?.getRegion() {
      request.region = region
    }
    let search = MKLocalSearch(request: request)
    search.start(completionHandler: { response, error in
      if let response = response {
        let listItems = response.mapItems.map { mapItem -> CPListItem in
          let item = CPListItem(text: mapItem.name, detailText: mapItem.placemark.countryCode)
          item.userInfo = mapItem
          return item
        }
        completionHandler(listItems)
      } else {
        print(error?.localizedDescription ?? "")
        completionHandler([])
      }
    })
  }
  
  func searchTemplate(
    _ searchTemplate: CPSearchTemplate,
    selectedResult item: CPListItem,
    completionHandler: @escaping () -> Void
  ) {
    if let mapItem = item.userInfo as? MKMapItem {
      mapViewController?.makeRoute(to: mapItem)
    }
    interfaceController?.popTemplate(animated: true)
    completionHandler()
  }
}
