//
//  Parameters.swift
//  Weather App
//
//  Created by Daniel Phiri on 3/4/22.
//

import Foundation

struct Parameters {
  
  private var parameters: String
  
  init(parameters: Parameter...) {
    self.parameters = ""
    for parameter in parameters {
      self.parameters += "&\(parameter.key)=\(parameter.value)"
    }
  }
  
  func getStringUrl() -> String {
    parameters
  }
  
  struct Parameter {
    let key: String
    let value: String
  }
  
}
