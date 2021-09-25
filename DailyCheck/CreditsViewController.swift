//
//  CreditsViewController.swift
//  DailyCheck
//
//  Created by Rahul Sharma on 10/05/20.
//  Copyright © 2020 Rahul Sharma. All rights reserved.
//

import Foundation
import UIKit

class CreditsViewController: UIViewController {
    
    // @IBOutlet weak var feepickLabel: UILabel!
    
    @IBOutlet weak var freepikTextView: UITextView!
    @IBOutlet weak var pixelTextView: UITextView!
    @IBOutlet weak var phatplusTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar = self.navigationController?.navigationBar
        if (navBar != nil) {
            // navBar?.barTintColor = UIColor.black
            navBar?.barTintColor = #colorLiteral(red: 0.07843137255, green: 0.1568627451, blue: 0.3137254902, alpha: 1)
            navBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
        updateAllTextViews()
    }
    
    func updateAllTextViews() {
        updateFreepikTextView()
        updatePixelTextView()
        updatePhatplusTextView()
    }
    
    func updateFreepikTextView() {
        let path1 = "https://www.flaticon.com/authors/freepik"
        let path2 = "https://www.flaticon.com"
        let text = freepikTextView.text ?? ""
        let attributedString = NSAttributedString.makeHyperLink(for: path1, for: path2, in: text, as: "Freepik", as: "www.flaticon.com")
        let font = freepikTextView.font
        let textColor = freepikTextView.textColor
        freepikTextView.attributedText = attributedString
        freepikTextView.font = font
        freepikTextView.textColor = textColor
    }
    
    func updatePixelTextView() {
        let path1 = "https://www.flaticon.com/authors/pixel-perfect"
        let path2 = "https://www.flaticon.com"
        let text = pixelTextView.text ?? ""
        let attributedString = NSAttributedString.makeHyperLink(for: path1, for: path2, in: text, as: "Pixel perfect", as: "www.flaticon.com")
        let font = pixelTextView.font
        let textColor = pixelTextView.textColor
        pixelTextView.attributedText = attributedString
        pixelTextView.font = font
        pixelTextView.textColor = textColor
    }
    
    func updatePhatplusTextView() {
        let path1 = "https://www.flaticon.com/authors/phatplus"
        let path2 = "https://www.flaticon.com"
        let text = phatplusTextView.text ?? ""
        let attributedString = NSAttributedString.makeHyperLink(for: path1, for: path2, in: text, as: "phatplus", as: "www.flaticon.com")
        let font = phatplusTextView.font
        let textColor = phatplusTextView.textColor
        phatplusTextView.attributedText = attributedString
        phatplusTextView.font = font
        phatplusTextView.textColor = textColor
    }
}

extension NSAttributedString {
    
    static func makeHyperLink(for path: String, in string: String, as subString: String) -> NSAttributedString {
        let nsString = NSString(string: string)
        let substringRange = nsString.range(of: subString)
        let attributedstring = NSMutableAttributedString(string: string)
        attributedstring.addAttribute(.link, value: path, range: substringRange)
        return attributedstring
    }
    
    static func makeHyperLink(for path1: String, for path2: String, in string: String, as subString1: String, as subString2: String) -> NSAttributedString {
        let nsString = NSString(string: string)
        let substringRange1 = nsString.range(of: subString1)
        let substringRange2 = nsString.range(of: subString2)
        
        let attributedstring = NSMutableAttributedString(string: string)
        attributedstring.addAttribute(.link, value: path1, range: substringRange1)
        attributedstring.addAttribute(.link, value: path2, range: substringRange2)
        return attributedstring
    }
}
