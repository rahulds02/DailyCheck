//
//  AirData.swift
//  DailyCheck
//
//  Created by Rahul Sharma on 03/05/20.
//  Copyright © 2020 Rahul Sharma. All rights reserved.
//

import Foundation

struct AirData: Codable {
    
    let data: AData
}

struct AData: Codable {
    let text: String
    let value: Int
    let color: String
    let source: AirSource
}

struct AirSource: Codable {
    let name: String
}
