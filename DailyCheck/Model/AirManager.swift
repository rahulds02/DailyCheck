//
//  AirManager.swift
//  DailyCheck
//
//  Created by Rahul Sharma on 03/05/20.
//  Copyright © 2020 Rahul Sharma. All rights reserved.
//

import Foundation
import CoreLocation

protocol AirManagerDelegate {
    func didUpdateAir(_ airManager: AirManager, air: AirModel)
    func didFailWithError(error: Error)
}

struct AirManager {
    let airURL = "http://api.airpollutionapi.com/1.0/aqi?APPID="
    var delegate: AirManagerDelegate?
    
    func fetchAirQuality(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let airKey = valueForAPIKey(named: "Key_Air")
        let urlString = airURL + airKey + "&lat=\(latitude)&lon=\(longitude)"
        print("air url is \(urlString)")
        performRequest(with: urlString)
    }
    
    func valueForAPIKey(named keyname:String) -> String {
         let filePath = Bundle.main.path(forResource: "API_Keys", ofType: "plist")
         let plist = NSDictionary(contentsOfFile:filePath!)
         let value = plist?.object(forKey: keyname) as! String
         return value
       }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let air = self.parseJSON(safeData) {
                        self.delegate?.didUpdateAir(self, air: air)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ airData: Data) -> AirModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(AirData.self, from: airData)
            let placeName = decodedData.data.source.name
            let value = decodedData.data.value
            let qualityText = decodedData.data.text
            let bgColor = decodedData.data.color
            let air = AirModel(airValue: value, place: placeName, quality: qualityText, color: bgColor)
           
            return air
            
        } catch {
            print("error is \(error)")
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
}


