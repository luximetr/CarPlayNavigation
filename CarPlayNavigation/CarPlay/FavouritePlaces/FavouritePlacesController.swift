//
//  FavouritePlacesController.swift
//  CarPlayNavigation
//
//  Created by Oleksandr Orlov on 20.07.2021.
//

import CarPlay

class FavouritePlacesController: NSObject, CPListTemplateDelegate {
  
  // MARK: - Dependencies
  
  private let favouritePlacesTemplate: CPListTemplate
  var template: CPTemplate { favouritePlacesTemplate }
  
  var onAdd: VoidAction?
  var onSelectItem: ((_ item: MKMapItem) -> Void)?
  
  // MARK: - Data
  
  private static var items: [MKMapItem] = []
  
  // MARK: - Life cycle
  
  override init() {
    favouritePlacesTemplate = CPListTemplate(title: "Favourites", sections: [])
    super.init()
    setup()
  }
  
  // MARK: - Setup
  
  private func setup() {
    favouritePlacesTemplate.delegate = self
    let addButton = createAddButton()
    favouritePlacesTemplate.trailingNavigationBarButtons = [addButton]
    updateList()
  }
  
  private func createAddButton() -> CPBarButton {
    let button = CPBarButton(type: .image) { [weak self] _ in
      self?.onAdd?()
    }
    button.image = UIImage(named: "plus")
    return button
  }
  
  // MARK: - Public
  
  func addItem(_ item: MKMapItem) {
    FavouritePlacesController.items.append(item)
    updateList()
  }
  
  // MARK: - Update list
  
  private func updateList() {
    let section = createSection()
    favouritePlacesTemplate.updateSections([section])
  }
  
  private func createSection() -> CPListSection {
    let items = FavouritePlacesController.items.map { createItem(mapItem: $0) }
    return CPListSection(items: items)
  }
  
  private func createItem(mapItem: MKMapItem) -> CPListItem {
    let item = CPListItem(text: mapItem.name, detailText: nil)
    item.userInfo = mapItem
    return item
  }
  
  // MARK: - CPListTemplateDelegate
  
  func listTemplate(
    _ listTemplate: CPListTemplate,
    didSelect item: CPListItem,
    completionHandler: @escaping () -> Void
  ) {
    if let mapItem = item.userInfo as? MKMapItem {
      onSelectItem?(mapItem)
    }
    completionHandler()
  }
}
