//
//  SearchPlaceCoordinator.swift
//  CarPlayNavigation
//
//  Created by Oleksandr Orlov on 19.07.2021.
//

import Foundation
import CarPlay

class SearchPlaceCoordinator: SearchPlaceControllerOutput {
  
  private weak var interfaceController: CPInterfaceController?
  private var searchPlaceController: SearchPlaceController?
  var onMapItemSelected: ((_ item: MKMapItem) -> Void)?
  
  // MARK: - Navigation
  
  func showSearchTemplate(interfaceController: CPInterfaceController) {
    self.interfaceController = interfaceController
    let controller = SearchPlaceController()
    controller.output = self
    searchPlaceController = controller
    interfaceController.pushTemplate(controller.template, animated: true)
  }
  
  // MARK: - SearchPlaceControllerOutput
  
  func didSelectMapItem(_ item: MKMapItem) {
    interfaceController?.popTemplate(animated: true)
    onMapItemSelected?(item)
    searchPlaceController = nil
  }
  
}
