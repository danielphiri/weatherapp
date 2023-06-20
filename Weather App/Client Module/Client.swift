//
//  Client.swift
//  Weather App
//
//  Created by Daniel Phiri on 3/4/22.
//

import Foundation

final class Client: Clientable {
  
  private let baseUrl: String
  private let apiKey: String
  
  init(baseUrl: String) {
    self.baseUrl = baseUrl
    // This is a note for developers only. Would need to be removed during release.
    guard let api = ProcessInfo.processInfo.environment["API_KEY"] else {
      fatalError("Error: API Key has not been set. Please set one in the Environment Variables before running.")
    }
    self.apiKey = api
  }
  
  // Make API Call which returns a Decodable Value. Using Async/Away here
  func fetch<T: Decodable>(api: WeatherAPI, path: Parameters) async throws -> T? {
    do {
      let encodedString = baseUrl + api.rawValue + "?key=\(apiKey)\(path.getStringUrl())"
      guard let urlString = encodedString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
      guard let url = URL(string: urlString) else {
        return nil
      }
      let dataTask = try await URLSession(configuration: .default).data(from: url)
      let data = dataTask.0
      let result = try JSONDecoder().decode(T.self, from: data)
      return result
    } catch {
      throw error
    }
  }
  
}
