//
//  ShopTableViewCell.swift
//  QNO
//
//  Created by Randolph on 13/1/2016.
//  Copyright © 2016年 September. All rights reserved.
//

import UIKit

class ShopTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ShopLogo: UIImageView!
    @IBOutlet weak var ShopTitle: UILabel!
    @IBOutlet weak var ShopDecription: UILabel!
    @IBOutlet weak var DistanceFromUser: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
