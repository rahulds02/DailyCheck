//
//  PrivacyPolicyViewController.swift
//  DailyCheck
//
//  Created by Rahul Sharma on 10/05/20.
//  Copyright © 2020 Rahul Sharma. All rights reserved.
//

import Foundation
import UIKit

class PrivacyPolicyViewController: UIViewController {
    
    @IBOutlet weak var privacyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        privacyLabel.text = "Your privacy is importatnt to us. AlluringApps Developer as an individual developer build the Dailycheck application. The application uses your phone location to get the news, weather and air quality at your location. \n\n- This application neither shared your location nor stored in the application\n\n-Application uses network connection to get news, weather and air quality\n\n-Application does not send any user data to anyone online/offline."
        
        privacyLabel.textColor = .white
        
        let navBar = self.navigationController?.navigationBar
        if (navBar != nil) {
           // navBar?.barTintColor = UIColor.black
            navBar?.barTintColor = #colorLiteral(red: 0.07843137255, green: 0.1568627451, blue: 0.3137254902, alpha: 1)
            navBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
        
        
    }
}
