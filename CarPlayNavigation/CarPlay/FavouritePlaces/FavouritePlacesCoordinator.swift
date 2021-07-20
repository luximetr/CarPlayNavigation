//
//  FavouritePlacesCoordinator.swift
//  CarPlayNavigation
//
//  Created by Oleksandr Orlov on 20.07.2021.
//

import CarPlay

class FavouritePlacesCoordinator {
  
  private weak var interfaceController: CPInterfaceController?
  private var favouritePlacesController: FavouritePlacesController?
  private var searchPlaceCoordinator: SearchPlaceCoordinator?
  
  var onSelectItem: ((_ item: MKMapItem) -> Void)?
  
  func showFavouritePlaces(interfaceController: CPInterfaceController) {
    let controller = FavouritePlacesController()
    favouritePlacesController = controller
    self.interfaceController = interfaceController
    controller.onAdd = { [weak self] in
      self?.showSearchPlace()
    }
    controller.onSelectItem = { [weak self] mapItem in
      self?.interfaceController?.popTemplate(animated: true)
      self?.onSelectItem?(mapItem)
    }
    interfaceController.pushTemplate(controller.template, animated: true)
  }
  
  private func showSearchPlace() {
    guard let interfaceController = interfaceController else { return }
    let coordinator = SearchPlaceCoordinator()
    searchPlaceCoordinator = coordinator
    coordinator.onMapItemSelected = { [weak self] mapItem in
      self?.favouritePlacesController?.addItem(mapItem)
    }
    coordinator.showSearchTemplate(interfaceController: interfaceController)
  }
}
