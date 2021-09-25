//
//  WeatherModel.swift
//  DailyCheck
//
//  Created by Rahul Sharma on 27/04/20.
//  Copyright © 2020 Rahul Sharma. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    let minTemp: Double
    let maxTemp: Double
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var minTempString: String {
        return String(format: "%.1f", minTemp)
    }
    
    var maxTempString: String {
        return String(format: "%.1f", maxTemp)
    }
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloudBolt"
        case 300...321:
            return "cloudDrizzle"
        case 500...531:
            return "cloudRain"
        case 600...622:
            return "cloudSnow"
        case 701...781:
            return "Haze"
        case 800:
            return "sun"
        case 801...804:
            return "cloudBolt"
        default:
            return "cloud"
        }
    }
    
}
