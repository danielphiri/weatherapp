//
//  CurrentLocationView.swift
//  Weather App
//
//  Created by Daniel Phiri on 3/4/22.
//

import SwiftUI

struct WeatherView: View {
  
  private let padding: CGFloat = 40
  @ObservedObject var viewModel: WeatherViewModel
  
  var body: some View {
        VStack {
          if !viewModel.isLocationEnabled {
            locationPrompt
          }
          if viewModel.isLocationEnabled && viewModel.condition != "" {
            Spacer()
              .frame(height: 50)
            topAnchor
            ScrollView(.vertical) {
              Spacer()
                .frame(height: 70)
              airQuality
              Spacer()
                .frame(height: 20)
              hourlyForecast
              Spacer()
            }
          }
        }
        .padding(.top, padding)
        .frame(width: getRect().size.width, height: getRect().size.height)
  }
  
  private var locationPrompt: some View {
    VStack(spacing: 20) {
      Spacer()
      Text("Location Permission:")
        .shadow(color: .black, radius: 1)
        .foregroundColor(.white)
        .font(.system(size: 18, weight: .bold))
      Text(viewModel.locationText)
        .foregroundColor(.white.opacity(0.8))
        .font(.system(size: 18, weight: .regular))
        .multilineTextAlignment(.center)
      Button.init(action: {
        viewModel.enableLocation()
      }) {
        RoundedRectangle(cornerRadius: 15)
          .fill(Color.white.opacity(0.2))
          .overlay(
            Text("Enable Location Services")
              .shadow(color: .black, radius: 1)
              .foregroundColor(.white)
              .font(.system(size: 18, weight: .bold))
          )
      }
      .frame(height: 40)
      Spacer()
    }
    .frame(width: getRect().width - (padding * 2))
  }
  
  private var topAnchor: some View {
    VStack {
      Text(viewModel.city)
        .shadow(color: .black, radius: 1)
        .font(.system(size: 33, weight: .light))
        .foregroundColor(.white)
      Text("\(Int(viewModel.temperature))°")
        .shadow(color: .black, radius: 1)
        .font(.system(size: 70, weight: .thin))
        .foregroundColor(.white)
      Text(viewModel.condition)
        .shadow(color: .black, radius: 1)
        .font(.system(size: 25, weight: .regular))
        .foregroundColor(.white)
      Spacer()
        .frame(height: 5)
      Text("H:\(viewModel.temperatureHigh)°       L:\(viewModel.temperatureLow)°")
        .shadow(color: .black, radius: 1)
        .font(.system(size: 18, weight: .semibold))
        .foregroundColor(.white)
    }
  }
  
  private var airQuality: some View {
    VStack(spacing: 10) {
      HStack {
        Image(systemName: "wind.snow")
          .resizable()
          .shadow(color: .black, radius: 1)
          .frame(width: 15, height: 15)
          .foregroundColor(.white.opacity(0.5))
        Text("AIR QUALITY")
          .shadow(color: .black, radius: 1)
          .multilineTextAlignment(.leading)
          .foregroundColor(.white.opacity(0.5))
          .font(.system(size: 15, weight: .regular))
        Spacer()
      }
      HStack {
        Text(viewModel.airQualityTitle)
          .shadow(color: .black.opacity(0.25), radius: 2)
          .multilineTextAlignment(.leading)
          .foregroundColor(.white)
          .font(.system(size: 20, weight: .bold))
        Spacer()
      }
      HStack {
        Text(viewModel.airQualityDescription)
          .shadow(color: .black.opacity(0.25), radius: 2)
          .multilineTextAlignment(.leading)
          .foregroundColor(.white)
          .font(.system(size: 18, weight: .regular))
        Spacer()
      }
      airQualityGradient
    }
    .background(Color.black.opacity(0.1).cornerRadius(15).padding(.all, -15))
    .padding(.all, 15)
    .frame(width: getRect().width - (padding * 2))
  }
  
  private var airQualityGradient: some View {
    RoundedRectangle(cornerRadius: 10)
      .fill(
        LinearGradient(colors: [.green, .yellow, .orange, .purpleColor, .redColor, .redColor], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1))
      )
      .overlay(
        GeometryReader { frame in
          HStack {
            RoundedRectangle(cornerRadius: 5)
              .stroke(Color.backgroundColor, lineWidth: 1)
              .background(Color.white)
              .frame(width: 5)
            Spacer()
              .frame(width: frame.size.width * (1 - viewModel.airQualityOpacity))
          }
          .frame(width: frame.size.width)
        }
      )
      .frame(height: 4)
  }
  
  private var hourlyForecast: some View {
    VStack(spacing: 10) {
      HStack {
        Image(systemName: "timer")
          .resizable()
          .shadow(color: .black, radius: 1)
          .frame(width: 15, height: 15)
          .foregroundColor(.white.opacity(0.5))
        Text("HOURLY FORECAST")
          .shadow(color: .black, radius: 1)
          .multilineTextAlignment(.leading)
          .foregroundColor(.white.opacity(0.5))
          .font(.system(size: 15, weight: .regular))
        Spacer()
      }
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 30) {
          ForEach(0..<viewModel.hourlyForecast.count, id: \.self) { index in
            hourlyForecastCell(viewModel.hourlyForecast[index])
          }
        }
      }
    }
    .background(Color.black.opacity(0.1).cornerRadius(15).padding(.all, -15))
    .padding(.all, 15)
    .frame(width: getRect().width - (padding * 2))
  }
  
  private func hourlyForecastCell(_ data: WeatherModel.ForecastDay.DayConditions.HourlyForecast) -> some View {
    VStack(spacing: 10) {
      Text(data.time.getTime())
        .shadow(color: .black.opacity(0.25), radius: 2)
        .foregroundColor(.white)
        .font(.system(size: 18, weight: .semibold))
      AsyncImage(url: URL(string: "https:\(data.condition.icon.absoluteString)"))
      Text("\(Int(data.temp_f))°")
        .shadow(color: .black.opacity(0.25), radius: 2)
        .foregroundColor(.white)
        .font(.system(size: 18, weight: .semibold))
    }
  }
  
}

