//
//  BaseCell.swift
//  DailyCheck
//
//  Created by Rahul Sharma on 10/05/20.
//  Copyright © 2020 Rahul Sharma. All rights reserved.
//

import Foundation
import UIKit

class BaseCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    func setUpViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SettingsCell: BaseCell {
    
    override var isHighlighted: Bool {
           didSet {
               backgroundColor = isHighlighted ? UIColor.darkGray : UIColor.white
            nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            iconImageView.tintColor = isHighlighted ? UIColor.white : UIColor.darkGray
           }
       }
    
    var setting: Setting? {
        didSet {
            nameLabel.text = setting?.name
            
            if let imageName = setting?.imageName {
                iconImageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
                iconImageView.tintColor = UIColor.darkGray
            }
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Setting"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "settingIcon32")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    func addConstraintWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for(index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    override func setUpViews() {
        super.setUpViews()
        
        addSubview(nameLabel)
        addSubview(iconImageView)
        
        addConstraintWithFormat(format: "H:|-8-[v0(30)]-8-[v1]|", views: iconImageView, nameLabel)
        addConstraintWithFormat(format: "V:|[v0]|", views: nameLabel)
        addConstraintWithFormat(format: "V:[v0(30)]", views: iconImageView)
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        //backgroundColor = UIColor.blue
    }
}
