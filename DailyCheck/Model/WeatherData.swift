//
//  WeatherData.swift
//  DailyCheck
//
//  Created by Rahul Sharma on 27/04/20.
//  Copyright © 2020 Rahul Sharma. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}
