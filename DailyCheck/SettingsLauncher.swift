//
//  SettingsLauncher.swift
//  DailyCheck
//
//  Created by Rahul Sharma on 09/05/20.
//  Copyright © 2020 Rahul Sharma. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

protocol SettingLauncherDelegate {
    func settingItemSelected(item: Int)
}

class Setting: NSObject {
    let name: String
    let imageName: String
    
    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}

class SettingsLauncher: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var settingDelegate: SettingLauncherDelegate?
    let blackView = UIView()
    let cellId = "cellId"
    let cellHeight: CGFloat = 50
    
    let settings: [Setting] = {
        //let setting = Setting(name: "settings", imageName: "settingIcon32")
        return [Setting(name: "About Us", imageName: "aboutUs"),
               Setting(name: "Credits", imageName: "credits"),
               Setting(name: "Privacy Policy", imageName: "policyIcon"),
               Setting(name: "Version 1.0.0", imageName: "")]
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    override init() {
        super.init()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        collectionView.register(SettingsCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func showSettings() {
        
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
           
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            window.addSubview(collectionView)
            let height: CGFloat = CGFloat(settings.count) * cellHeight
            let y = window.frame.height - height
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }, completion: nil)
        }
        
    }
    
    @objc func handleDismiss() {
         
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        }
    }
}

extension SettingsLauncher {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingsCell
        let setting = settings[indexPath.item]
        cell.setting = setting
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let setting = settings[indexPath.item]
        print(setting.name)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        }) { (completed: Bool) in
            
            self.settingDelegate?.settingItemSelected(item: indexPath.row)
        }
    }
}
