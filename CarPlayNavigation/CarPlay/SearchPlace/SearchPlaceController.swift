//
//  SearchPlaceController.swift
//  CarPlayNavigation
//
//  Created by Oleksandr Orlov on 19.07.2021.
//

import Foundation
import CarPlay

protocol SearchPlaceControllerOutput {
  func didSelectMapItem(_ item: MKMapItem)
}

class SearchPlaceController: NSObject, CPSearchTemplateDelegate {
  
  // MARK: - Dependencies
  
  private let searchTemplate = CPSearchTemplate()
  var template: CPTemplate { searchTemplate }
  var output: SearchPlaceControllerOutput!
  
  // MARK: - Life cycle
  
  override init() {
    super.init()
    setup()
  }
  
  // MARK: - Setup
  
  private func setup() {
    searchTemplate.delegate = self
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
    guard let mapItem = item.userInfo as? MKMapItem else { return }
    output.didSelectMapItem(mapItem)
    completionHandler()
  }
}
