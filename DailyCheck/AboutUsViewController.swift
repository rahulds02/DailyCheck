//
//  AboutUsViewController.swift
//  DailyCheck
//
//  Created by Rahul Sharma on 10/05/20.
//  Copyright © 2020 Rahul Sharma. All rights reserved.
//

import Foundation
import UIKit

class AboutUsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar = self.navigationController?.navigationBar
        if (navBar != nil) {
           // navBar?.barTintColor = UIColor.black
            navBar?.barTintColor = #colorLiteral(red: 0.07843137255, green: 0.1568627451, blue: 0.3137254902, alpha: 1)
            navBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
    }
}
