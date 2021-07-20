//
//  MapCoordinator.swift
//  CarPlayNavigation
//
//  Created by Oleksandr Orlov on 19.07.2021.
//

import CarPlay

class MapCoordinator {
  
  // MARK: - Dependencies
  
  private weak var interfaceController: CPInterfaceController?
  private var mapControlsController: MapControlsController?
  private var mapViewController: MapViewController?
  private var favouritePlacesCoordinator: FavouritePlacesCoordinator?
  
  // MARK: - Navigation
  
  func showMap(interfaceController: CPInterfaceController, window: CPWindow) {
    self.interfaceController = interfaceController
    let mapViewController = createMapViewController()
    window.rootViewController = mapViewController
    let controller = createMapControlsController()
    interfaceController.setRootTemplate(controller.template, animated: true)
  }
  
  private func showSearchPlace() {
    guard let interfaceController = interfaceController else { return }
    let coordinator = SearchPlaceCoordinator()
    coordinator.onMapItemSelected = { [weak self] mapItem in
      self?.mapViewController?.makeRoute(to: mapItem)
    }
    coordinator.showSearchTemplate(interfaceController: interfaceController)
  }
  
  private func showFavouritePlaces() {
    guard let interfaceController = interfaceController else { return }
    let coordinator = FavouritePlacesCoordinator()
    coordinator.onSelectItem = { [weak self] mapItem in
      self?.mapViewController?.makeRoute(to: mapItem)
    }
    favouritePlacesCoordinator = coordinator
    coordinator.showFavouritePlaces(interfaceController: interfaceController)
  }
  
  // MARK: - Create screens
  
  private func createMapViewController() -> MapViewController {
    let mapViewController = MapViewController()
    self.mapViewController = mapViewController
    return mapViewController
  }
  
  private func createMapControlsController() -> MapControlsController {
    let controller = MapControlsController()
    controller.onCenter = { [weak self] in
      self?.mapViewController?.moveToCurrentLocation()
    }
    controller.onZoomIn = { [weak self] in
      self?.mapViewController?.zoomIn()
    }
    controller.onZoomOut = { [weak self] in
      self?.mapViewController?.zoomOut()
    }
    controller.onSearch = { [weak self] in
      self?.showSearchPlace()
    }
    controller.onFavourites = { [weak self] in
      self?.showFavouritePlaces()
    }
    mapControlsController = controller
    return controller
  }
}
