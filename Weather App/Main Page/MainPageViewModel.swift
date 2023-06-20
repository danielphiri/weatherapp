//
//  MainPageViewl.swift
//  Weather App
//
//  Created by Daniel Phiri on 3/4/22.
//

import Combine
import Foundation


@MainActor final class MainPageViewModel: ObservableObject {
  
  let baseUrl                : String
  private let locationHelper = LocationHelper()
  var cities                 : [String] = []
  
  init(baseUrl: String) {
    self.baseUrl = baseUrl
    fetchCities()
  }
  
  private func fetchCities() {
    self.cities = self.locationHelper.getCities()?.reversed() ?? []
  }
  
}
