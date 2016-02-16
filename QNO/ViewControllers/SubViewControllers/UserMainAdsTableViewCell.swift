//
//  UserMainAdsTableViewCell.swift
//  QNO
//
//  Created by Randolph on 12/1/2016.
//  Copyright © 2016年 September. All rights reserved.
//

import UIKit

class UserMainAdsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var AdsImageView: UIImageView!
    @IBOutlet weak var houseImageView: UIImageView!
    @IBOutlet weak var houseNAmeTextLabel: UILabel!
    @IBOutlet weak var AdsDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        houseImageView.layer.cornerRadius = houseImageView.frame.size.height / 2
        houseImageView.layer.masksToBounds = true
        houseImageView.layer.borderWidth = 5
        houseImageView.layer.borderColor = UIColor.whiteColor().CGColor
        houseImageView.layer.shadowColor = UIColor.grayColor().CGColor
        houseImageView.layer.shadowRadius = 2.0
        houseImageView.layer.shadowOpacity = 0.6
        
        
        houseNAmeTextLabel.layer.shadowColor = UIColor.blackColor().CGColor
        houseNAmeTextLabel.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        houseNAmeTextLabel.layer.shadowRadius = 0.8
        houseNAmeTextLabel.layer.shadowOpacity = 0.8
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}