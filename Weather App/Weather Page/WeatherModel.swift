//
//  WeatherModel.swift
//  Weather App
//
//  Created by Daniel Phiri on 3/4/22.
//

import Foundation

struct WeatherModel: Decodable {
  
  let current: CurrentConditions
  let forecast: ForecastDay
  
  struct CurrentConditions: Decodable {
    let condition: WeatherCondition
    let air_quality: AirQuality
    let temp_f: Double
    let wind_mph: Double
    let wind_kph: Double
    let wind_degree: Double
    let wind_dir: String
    let pressure_mb: Double
    let pressure_in: Double
    let precip_mm: Double
    let precip_in: Double
    let humidity: Double
    let cloud: Double
    let feelslike_c: Double
    let feelslike_f: Double
    let vis_km: Double
    let vis_miles: Double
    let uv: Double
    let gust_mph: Double
    let gust_kph: Double
    
    struct WeatherCondition: Decodable {
      let text: String
      let icon: URL
    }
  }
  
  struct ForecastDay: Decodable {
    let forecastday: [DayConditions]
    
    struct DayConditions: Decodable {
      let day: DayWeather
      let hour: [HourlyForecast]
      
      struct DayWeather: Decodable {
        let condition: Conditions
        let maxtemp_c: Double
        let maxtemp_f: Double
        let mintemp_c: Double
        let mintemp_f: Double
        let avgtemp_c: Double
        let avgtemp_f: Double
        let maxwind_mph: Double
        let maxwind_kph: Double
        let totalprecip_mm: Double
        let totalprecip_in: Double
        let avgvis_km: Double
        let avgvis_miles: Double
        let avghumidity: Double
        let daily_will_it_rain: Double
        let daily_chance_of_rain: Double
        let daily_will_it_snow: Double
        let daily_chance_of_snow: Double
        
        struct Conditions: Decodable {
          let text: String
          let icon: URL
        }
      }
      
      struct HourlyForecast: Decodable {
        let time: String
        let temp_c: Double
        let temp_f: Double
        let wind_mph: Double
        let wind_kph: Double
        let wind_degree: Double
        let pressure_mb: Double
        let pressure_in: Double
        let precip_mm: Double
        let precip_in: Double
        let humidity: Double
        let cloud: Double
        let feelslike_c: Double
        let feelslike_f: Double
        let windchill_c: Double
        let windchill_f: Double
        let heatindex_c: Double
        let heatindex_f: Double
        let dewpoint_c: Double
        let dewpoint_f: Double
        let will_it_rain: Double
        let chance_of_rain: Double
        let will_it_snow: Double
        let chance_of_snow: Double
        let vis_km: Double
        let vis_miles: Double
        let gust_mph: Double
        let gust_kph: Double
        let uv: Double
        let condition: HourlyCondition
        
        struct HourlyCondition: Decodable {
          let text: String
          let icon: URL
        }
        
      }
      
    }
    
  }
  
}

struct AirQuality: Decodable {
  let co: Double
  let no2: Double
  let o3: Double
  let so2: Double
  let pm2_5: Double
  let pm10: Double
}
