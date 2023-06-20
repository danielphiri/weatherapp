//
//  MainPageView.swift
//  Weather App
//
//  Created by Daniel Phiri on 3/4/22.
//

import SwiftUI
import Foundation

struct MainPageView: View {
  
  private let padding: CGFloat = 40
  @ObservedObject var viewModel: MainPageViewModel
  
  var body: some View {
    ZStack {
      backgroundImage
      tabView
    }
    .frame(width: getRect().width, height: getRect().height)
  }
  
  
  private var backgroundImage: some View {
    Image("backgroundImage")
      .resizable()
      .aspectRatio(contentMode: .fill)
      .ignoresSafeArea(.all)
  }
  
  private var tabView: some View {
    TabView {
      if viewModel.cities.count > 0 {
        ForEach(0..<viewModel.cities.count, id: \.self) { index in
          WeatherView(viewModel: WeatherViewModel(client: Client(baseUrl: viewModel.baseUrl), city: viewModel.cities[index]))
        }
      }
      if viewModel.cities.count == 0 {
        WeatherView(viewModel: WeatherViewModel(client: Client(baseUrl: viewModel.baseUrl), city: nil))
      }
    }
    .tabViewStyle(PageTabViewStyle())
    .background(Color.backgroundColor.opacity(0.95))
    .padding(.bottom, 40)
  }
  
}


