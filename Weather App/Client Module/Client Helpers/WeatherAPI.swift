//
//  WeatherAPI.swift
//  Weather App
//
//  Created by Daniel Phiri on 3/4/22.
//

import Foundation

enum WeatherAPI: String {
  case current = "/current.json"
  case forecast = "/forecast.json"
  case search = "/search.json"
  case history = "/history.json"
  case timezone = "/timezone.json"
  case sports = "/sports.json"
  case astronomy = "/astronomy.json"
  case ip = "/ip.json"
}
