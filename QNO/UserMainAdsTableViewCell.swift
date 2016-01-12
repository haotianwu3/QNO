//
//  UserMainAdsTableViewCell.swift
//  QNO
//
//  Created by Randolph on 12/1/2016.
//  Copyright © 2016年 September. All rights reserved.
//

import UIKit

class UserMainAdsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var AdsImage: UIImageView!
    @IBOutlet weak var AdsDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}