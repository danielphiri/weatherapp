//
//  CurrentLocationViewModel.swift
//  Weather App
//
//  Created by Daniel Phiri on 3/4/22.
//

import Combine
import Foundation
import UIKit

@MainActor final class WeatherViewModel: ObservableObject {
  
  let client: Clientable
  private let locationHelper = LocationHelper()
  
  // Daily Forecast
  @Published var condition: String = ""
  @Published var city: String = ""
  @Published var temperature: Double = 0.0
  @Published var temperatureHigh: Int = 0
  @Published var temperatureLow: Int = 0
  
  // Air Quality
  @Published var airQualityOpacity: Double = 0.0
  @Published var airQualityTitle: String = ""
  @Published var airQualityDescription: String = ""
  
  // Hourly Forecast
  @Published var hourlyForecast: [WeatherModel.ForecastDay.DayConditions.HourlyForecast] = []
  
  // Location
  @Published var isLocationEnabled = false
  @Published var locationText = "Hi there! Welcome to the weather app. To use this app effectively, we will need access to your location. Please enable this by clicking the \"Enable Location Services\" button below. We will only use this permission to show you the weather conditions around you."
  private var cancellable: Set<AnyCancellable> = []
  
  
  init(client: Clientable, city: String?) {
    self.client = client
    fetchData(city: city)
  }
  
  func fetchData(city: String?) {
    if let city = city {
      self.city = city
      self.callAPi(withCity: city)
      self.isLocationEnabled = true
    } else {
      locationHelper.cityUpdater
        .receive(on: DispatchQueue.main)
        .sink { [weak self] city in
          self?.city = city
          self?.callAPi(withCity: city)
          self?.isLocationEnabled = true
        }
        .store(in: &cancellable)
    }
    
  }
  
  private func callAPi(withCity: String) {
    Task(priority: .background) {
      do {
        let forecast = try await fetchForecastData()
        self.temperature = forecast?.current.temp_f ?? 0.0
        self.temperatureHigh = Int(forecast?.forecast.forecastday[0].day.maxtemp_f ?? 0.0)
        self.temperatureLow = Int(forecast?.forecast.forecastday[0].day.mintemp_f ?? 0.0)
        self.condition = forecast?.forecast.forecastday[0].day.condition.text ?? ""
        let airDescription = calculateAirQuality(quality: forecast?.current.air_quality)
        self.airQualityTitle = airDescription.title
        self.airQualityDescription = airDescription.description
        self.airQualityOpacity = self.calculateAirQualityOpacity(forecast?.current.air_quality)
        self.hourlyForecast = forecast?.forecast.forecastday[0].hour.filter { $0.time.isNow() || ($0.time.date() >= Date())
        } ?? []
      } catch {
        print(error)
        handleError(error)
      }
    }
  }
  
  func enableLocation() {
    locationHelper.requestLocation { [weak self ] result in
      switch result {
        case .success(let isEnabled):
          self?.isLocationEnabled = isEnabled
          if !isEnabled {
            self?.locationText = "Unfortunately, we need access to your location for you to be able to use the app. Please update this in your settings and you should be able to use the app just fine."
          }
        case .failure(let error):
          self?.locationText = error.localizedDescription
      }
    }
  }
  
  private func fetchForecastData() async throws -> WeatherModel? {
    do {
      return try await client.fetch(api: .forecast, path: Parameters(parameters: .init(key: "aqi", value: "yes"), .init(key: "q", value: city)))
    } catch {
      throw error
    }
  }
  
  private func handleError(_ error: Error) {
    #warning("TODO: Handle Error")
  }
  
  private func calculateAirQualityOpacity(_ quality: AirQuality?) -> Double {
    guard let quality = quality else {
      return 0.0
    }
    return min(quality.pm10 / 180, 1.0)
  }
  
  func getTime(from: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.current
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    print(from)
    guard let date = dateFormatter.date(from: from) else { return "1" }
    let now = Date().formatted(date: .omitted, time: .shortened)
    let dateString = date.formatted(date: .omitted, time: .shortened)
    return now.isNow() ? "Now": dateString
  }
  
  
  private func calculateAirQuality(quality: AirQuality?) -> (title: String, description: String) {
    guard let quality = quality else {
      return ("", "")
    }
    switch quality.pm10 {
      case 0..<25:
        // Good
        return ("\(Int(quality.pm10)) - Good. The Air Quality is currently very good.", "Air quality index is \(Int(quality.pm10)), which is good and safe for all individuals.")
      case 25..<50:
        // Fair
        return ("\(Int(quality.pm10)) - Fair. The Air Quality Currenty is Fair", "Air quality index is \(Int(quality.pm10)), which is fair and safe for most individuals.")
      case 50..<90:
        // Moderate
        return ("\(Int(quality.pm10)) - Moderate. The Air Quality Currenty is Moderate.", "Air quality index is \(Int(quality.pm10)), which is moderate and safe for a good part of the population.")
      case 90..<180:
        // Poor
        return ("\(Int(quality.pm10)) - Unhealthy for Sensitive Individuals.", "Air quality index is \(quality.pm10), which is unhealthy for sensitive individuals. Wear a mask or protect yourself if you have an underlying condition.")
      default:
        // Very Poor
        return ("\(Int(quality.pm10)) - Very Poor.", "Air quality index is \(Int(quality.pm10)), which is very poor. It could be dangerous to go outside without a mask or some form of protection, even if you are very healthy.")
    }
  }
  
}
