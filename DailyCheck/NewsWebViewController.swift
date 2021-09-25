//
//  NewsWebViewController.swift
//  DailyCheck
//
//  Created by Rahul Sharma on 28/04/20.
//  Copyright © 2020 Rahul Sharma. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class NewsWebViewController : UIViewController {
    
    @IBOutlet weak var newsWebView: WKWebView!
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("NewsWebView url is \(url)")
        
        if let newsURL = url {
            sendRequest(newsURL: newsURL)
        }
    }
    
    func sendRequest(newsURL: URL) {
        let newsRequest = URLRequest(url: newsURL)
        newsWebView.load(newsRequest)
    }
}
