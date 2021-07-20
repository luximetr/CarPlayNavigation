//
//  MapControlsController.swift
//  CarPlayNavigation
//
//  Created by Oleksandr Orlov on 19.07.2021.
//

import CarPlay

protocol MapControllerOutput {
  
}

class MapControlsController: NSObject, CPMapTemplateDelegate {
  
  // MARK: - Dependencies
  
  private let mapTemplate = CPMapTemplate()
  var template: CPTemplate { mapTemplate }
  var output: MapControllerOutput!
  
  var onFavourites: VoidAction?
  var onSearch: VoidAction?
  var onZoomIn: VoidAction?
  var onZoomOut: VoidAction?
  var onCenter: VoidAction?
  
  // MARK: - Life cycle
  
  override init() {
    super.init()
    setup()
  }
  
  // MARK: - Setup
  
  private func setup() {
    mapTemplate.mapDelegate = self
    
    let panButton = createPanButton()
    let favouritesButton = createFavouritesButton()
    let searchButton = createSearchButton()
    
    let zoomInButton = createZoomInButton()
    let zoomOutButton = createZoomOutButton()
    let centerButton = createCenterButton()
    
    mapTemplate.leadingNavigationBarButtons = [panButton]
    mapTemplate.trailingNavigationBarButtons = [favouritesButton, searchButton]
    mapTemplate.mapButtons = [centerButton, zoomInButton, zoomOutButton]
  }
  
  // MARK: - Navigation buttons
  
  private func createPanButton() -> CPBarButton {
    let button = CPBarButton(type: .image) { [weak mapTemplate] _ in
      if mapTemplate?.isPanningInterfaceVisible == false {
        mapTemplate?.showPanningInterface(animated: true)
      } else {
        mapTemplate?.dismissPanningInterface(animated: true)
      }
    }
    button.image = UIImage(named: "move")
    return button
  }
  
  private func createFavouritesButton() -> CPBarButton {
    let button = CPBarButton(type: .image) { [weak self] _ in
      self?.onFavourites?()
    }
    button.image = UIImage(named: "favourites")
    return button
  }
  
  private func createSearchButton() -> CPBarButton {
    let button = CPBarButton(type: .image) { [weak self] _ in
      self?.onSearch?()
    }
    button.image = UIImage(named: "search")
    return button
  }
  
  // MARK: - Map buttons
  
  private func createZoomInButton() -> CPMapButton {
    let button = CPMapButton { [weak self] _ in
      self?.onZoomIn?()
    }
    button.image = UIImage(named: "zoom_in")
    return button
  }
  
  private func createZoomOutButton() -> CPMapButton {
    let button = CPMapButton { [weak self] _ in
      self?.onZoomOut?()
    }
    button.image = UIImage(named: "zoom_out")
    return button
  }
  
  private func createCenterButton() -> CPMapButton {
    let button = CPMapButton { [weak self] _ in
      self?.onCenter?()
    }
    button.image = UIImage(named: "center")
    return button
  }
  
  // MARK: - CPMapTemplateDelegate
  
  
}
