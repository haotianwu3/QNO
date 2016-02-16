//
//  RadiusCornerView.swift
//  QNO
//
//  Created by Randolph on 16/2/2016.
//  Copyright © 2016年 September. All rights reserved.
//

import UIKit

class RadiusCornerView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
}
