//
//  NewsCell.swift
//  DailyCheck
//
//  Created by Rahul Sharma on 28/04/20.
//  Copyright © 2020 Rahul Sharma. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var newsView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
