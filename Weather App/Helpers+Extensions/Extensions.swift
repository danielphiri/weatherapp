//
//  ExtensionsHelper.swift
//  Weather App
//
//  Created by Daniel Phiri on 3/4/22.
//

import SwiftUI
import Foundation

extension String {
  
  // Return a description of the String in an hourly format. eg: 11:00 AM
  func getTime() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.current
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    guard let date = dateFormatter.date(from: self) else { return "" }
    let now = Date().formatted(date: .omitted, time: .shortened)
    let dateString = date.formatted(date: .omitted, time: .shortened)
    return isNow() ? "Now": dateString
  }
  
  // Return String as Date or the time now if not possible
  func date() -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.current
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    return dateFormatter.date(from: self) ?? Date()
  }
  
  // Returns whether the String is referring to the hour right now or not. Matches current time to time of String
  func isNow() -> Bool {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.current
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    guard let date = dateFormatter.date(from: self) else { return false }
    let now = Date().formatted(date: .omitted, time: .shortened)
    let dateString = date.formatted(date: .omitted, time: .shortened)
    let isSamePrefix = dateString.split(separator: ":")[0] == now.split(separator: ":")[0]
    let isSameSuffix = dateString.split(separator: " ").last == now.split(separator: " ").last
    return isSamePrefix && isSameSuffix
  }
  
}

extension Color {
  
  static let backgroundColor = Color("backgroundColor")
  static let redColor = Color("redColor")
  static let purpleColor = Color("purpleColor")
  
}

extension View {
  
  // The current device's Screen Size
  func getRect() -> CGRect {
    return UIScreen.main.bounds
  }
  
}
