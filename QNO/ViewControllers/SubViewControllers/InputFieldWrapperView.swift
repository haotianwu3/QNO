//
//  InputFieldWrapperView.swift
//  QNO
//
//  Created by Xinhong LIU on 28/1/2016.
//  Copyright © 2016 September. All rights reserved.
//

import UIKit

class InputFieldWrapperView: UIView {

    override func awakeFromNib() {
        let bottomBorderImage = UIImage(named: "bottom_bar")
        self.backgroundColor = UIColor(patternImage: bottomBorderImage!)
    }

}
