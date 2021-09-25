//
//  SecondViewController.swift
//  DailyCheck
//
//  Created by Rahul Sharma on 24/04/20.
//  Copyright © 2020 Rahul Sharma. All rights reserved.
//

import UIKit
import CoreLocation
import SpinningIndicator

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var bgImageView: UIImageView!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    let settingsLauncher = SettingsLauncher()
    var indicator: SpinningIndicator?
    var appDelegate: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let settingIconImage = UIImage(named: "more24")
        let navBar = self.navigationController?.navigationBar
        if (navBar != nil) {
           // navBar?.barTintColor = UIColor.black
            navBar?.barTintColor = #colorLiteral(red: 0.07843137255, green: 0.1568627451, blue: 0.3137254902, alpha: 1)
            navBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: settingIconImage, style: .plain, target: self, action: #selector(settingTapped))
        }
        
        self.bgImageView.backgroundColor = #colorLiteral(red: 0.1529411765, green: 0.2862745098, blue: 0.4274509804, alpha: 1)
        
        weatherManager.delegate = self
        settingsLauncher.settingDelegate = self
      
        let lat = self.appDelegate?.appLat
        let lon = self.appDelegate?.appLon
        
        cityLabel.isHidden = true
        minTempLabel.isHidden = true
        maxTempLabel.isHidden = true
        tempLabel.isHidden = true
        
        if Reachability.isInternetAvailable() {
            self.indicator = SpinningIndicator(frame: UIScreen.main.bounds)
            if self.indicator != nil {
                view.addSubview(self.indicator!)
                self.indicator!.addCircle(lineColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), lineWidth: 2, radius: 16, angle: 0)
                self.indicator!.beginAnimating()
            }
            if lat != nil && lon != nil {
                weatherManager.fetchWeather(latitude: lat!, longitude: lon!)
            }
        } else {
            let noNwView = UIView()
            self.view.addSubview(noNwView)
            let label = UILabel()
            noNwView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            label.widthAnchor.constraint(equalToConstant: 300).isActive = true
            label.heightAnchor.constraint(equalToConstant: 200).isActive = true
            label.text = "No network connection, please connect to network and try again!"
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 20)
            label.numberOfLines = 0
            label.textColor = UIColor.white
            
            noNwView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            noNwView.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.1568627451, blue: 0.3137254902, alpha: 1)
            
            // create the alert
            let alert = UIAlertController(title: "Network Error", message: "No internet connection", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @objc func settingTapped() {
        settingsLauncher.showSettings()
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.cityLabel.isHidden = false
            self.minTempLabel.isHidden = false
            self.maxTempLabel.isHidden = false
            self.tempLabel.isHidden = false
            
            self.tempLabel.text = weather.temperatureString
            print("rahul condition name is \(weather.conditionName)")
            //self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.conditionImageView.image = UIImage(named: weather.conditionName)
            self.cityLabel.text = weather.cityName
            self.minTempLabel.text = "Min: \(weather.minTempString) °C"
            self.maxTempLabel.text = "Max: \(weather.maxTempString) °C"
            
            if self.indicator != nil {
                self.indicator!.endAnimating()
                self.indicator!.removeFromSuperview()
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
        
        DispatchQueue.main.async {
            if self.indicator != nil {
                self.indicator!.endAnimating()
                self.indicator!.removeFromSuperview()
                
                // create the alert
                let alert = UIAlertController(title: "Error!", message: "Error in getting weather news, please try after some time", preferredStyle: UIAlertController.Style.alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        
    }
}

extension WeatherViewController: SettingLauncherDelegate {
    
    func settingItemSelected(item: Int) {
      
        print("in weatherview item selected")
        
        if item == 0 {
            performSegue(withIdentifier: "goToAboutUsFromWeather", sender: self)
        } else if item == 1 {
             performSegue(withIdentifier: "goToCreditsFromWeather", sender: self)
        } else if item == 2 {
             performSegue(withIdentifier: "goToPrivacyFromWeather", sender: self)
        }
        
    }
}
