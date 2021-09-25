//
//  AirModel.swift
//  DailyCheck
//
//  Created by Rahul Sharma on 03/05/20.
//  Copyright © 2020 Rahul Sharma. All rights reserved.
//

import Foundation

struct AirModel {
    let airValue: Int
    let place: String
    let quality: String
    let color: String
    
    var airValueStr: String {
        return String(airValue)
    }
}
