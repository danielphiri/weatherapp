//
//  HostingController.swift
//  Weather App
//
//  Created by Daniel Phiri on 3/4/22.
//

import SwiftUI
import Foundation

// A Custom version of the UIHostingController with appearance matching our Design Spec
final class HostingController<T: View>: UIHostingController<T> {
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
}
