//
//  MasterViewController.swift
//  QNO
//
//  Created by Xinhong LIU on 15/1/2016.
//  Copyright © 2016 September. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {

    var isLoginPage = false
    
    override func viewDidLoad() {
        var imageName = "page_background"
        if isLoginPage {
            imageName = "login_background"
        }
        let bgImage = UIImage(named: imageName)
        let bgImageView = UIImageView(image: bgImage)
        bgImageView.contentMode = .ScaleAspectFill
        let constraints = [NSLayoutConstraint(item: bgImageView, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1.0, constant: 0.0), NSLayoutConstraint(item: bgImageView, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1.0, constant: 0.0), NSLayoutConstraint(item: bgImageView, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 1.0, constant: 0.0), NSLayoutConstraint(item: bgImageView, attribute: .Height, relatedBy: .Equal, toItem: self.view, attribute: .Height, multiplier: 1.0, constant: 0.0)]
        self.view.addSubview(bgImageView)
        self.view.addConstraints(constraints)
        self.view.sendSubviewToBack(bgImageView)
    }
    
}
