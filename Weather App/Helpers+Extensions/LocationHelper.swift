//
//  LocationHelper.swift
//  Weather App
//
//  Created by Daniel Phiri on 3/4/22.
//

import Combine
import Foundation
import CoreLocation

/*
 A Helper Class for handling lower-level location management tasks and publishing updates to a Publisher or Closure. Here we are more concerned about the User's Current City more than anything else. We are also saving all of the User's Previously-visited cities and showing them when the user opens the app from another location.
*/

final class LocationHelper: NSObject {
  
  private let locationManager = CLLocationManager() // Create a CLLocationManager and assign self as delegate
  private var permissionObserver: ((Result<Bool, Error>) -> ())?
  private let defaults = UserDefaults.standard
  private let locationValue = "LocationRequested"
  private let previousCities = "PreviousCities"
  private var location: CLLocation? = nil
  var citiesUpdater = PassthroughSubject<[String], Never>()
  var cityUpdater = PassthroughSubject<String, Never>()
  private var city: String = ""
  
  override init() {
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.startUpdatingLocation()
    let cities = self.getCities() ?? []
    print(cities)
    citiesUpdater.send(cities)
  }
  
  /*
   Calls completion with a failure if we failed to request the user's location, otherwise it returns with a success result indicating whether the user enabled the location or not.
   */
  func requestLocation(completion: @escaping (Result<Bool, Error>) -> ()) {
    self.permissionObserver = completion
    locationManager.requestWhenInUseAuthorization()
    if defaults.bool(forKey: locationValue) {
      let error = NSError(domain: "Authorization Error: Looks like you have already denied us access to your location. Please try setting your location again in your settings.", code: 0, userInfo: nil)
      completion(.failure(error))
    } else {
      defaults.set(true, forKey: locationValue)
    }
  }
  
  func checkPermissions() -> CLAuthorizationStatus {
    let status = CLLocationManager.authorizationStatus()
    return status
  }
  
  func isLocationEnabled() -> Bool {
    return checkPermissions() == .authorizedAlways || checkPermissions() == .authorizedWhenInUse
  }
  
  private func getCityName() {
    guard let location = location else {
      return
    }
    location.fetchCityAndCountry { [weak self] city, country, error in
      guard let city = city, let _ = country, error == nil, let self = self else { return }
      self.addCityToCache(city)
      self.cityUpdater.send(city)
    }
  }
  
  func getCities() -> [String]? {
    let cities = self.defaults.value(forKey: self.previousCities) as? [String]
    return cities?.filter { $0 != city }
  }
  
  private func addCityToCache(_ city: String) {
    if city == "" {
      return
    }
    if var cities = self.defaults.value(forKey: self.previousCities) as? [String] {
      if !cities.contains(city) {
        cities.append(city)
        self.city = city
        self.defaults.set(cities, forKey: self.previousCities)
        self.citiesUpdater.send(cities)
        print(cities)
      }
    } else {
      self.defaults.set([city], forKey: self.previousCities)
    }
  }
  
}

extension LocationHelper: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let currentLocationCordinate = location?.coordinate, let newCoordinates = locations.first?.coordinate, (currentLocationCordinate.latitude != newCoordinates.latitude || currentLocationCordinate.longitude != newCoordinates.longitude) {
      self.location = locations.first
      getCityName()
      return
    }
    if location == nil {
      self.location = locations.first
      getCityName()
    }
  }
  
  func locationManager(
    _ manager: CLLocationManager,
    didFailWithError error: Error
  ) {
    #warning("TODO: Handle Error")
  }
  
  func locationManager(
    _ manager: CLLocationManager,
    didChangeAuthorization status: CLAuthorizationStatus
  ) {
    permissionObserver?(.success(isLocationEnabled()))
  }
  
}

extension CLLocation {
  
  func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
    CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
  }
  
}
