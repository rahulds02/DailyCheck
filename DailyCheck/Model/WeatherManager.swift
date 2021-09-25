//
//  WeatherManager.swift
//  DailyCheck
//
//  Created by Rahul Sharma on 27/04/20.
//  Copyright © 2020 Rahul Sharma. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid="
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let weatherKey = valueForAPIKey(named: "Key_Weather")
        let urlString = weatherURL + weatherKey + "&units=metric" + "&lat=\(latitude)&lon=\(longitude)"
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
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let min = decodedData.main.temp_min
            let max = decodedData.main.temp_max
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, minTemp: min, maxTemp: max)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}


