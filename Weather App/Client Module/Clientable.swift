//
//  Clientable.swift
//  Weather App
//
//  Created by Daniel Phiri on 3/4/22.
//

import Foundation

protocol Clientable {
  
  func fetch<T: Decodable>(api: WeatherAPI, path: Parameters) async throws -> T?
  
}
