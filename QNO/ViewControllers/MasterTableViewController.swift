//
//  MasterTableViewController.swift
//  QNO
//
//  Created by Xinhong LIU on 15/1/2016.
//  Copyright © 2016 September. All rights reserved.
//

import UIKit

class MasterTableViewController: UITableViewController {

    override func viewDidLoad() {
        let bgImage = UIImage(named: "page_background_1")
        self.tableView.backgroundColor = UIColor(patternImage: bgImage!)
        
        self.tableView.separatorColor = UIColor.clearColor()
        //let bgImageView = UIImageView(image: bgImage)
        //bgImageView.contentMode = .ScaleAspectFill
        //self.tableView.addSubview(bgImageView)
        
        //let constraints = [NSLayoutConstraint(item: bgImageView, attribute: .CenterX, relatedBy: .Equal, toItem: self.tableView, attribute: .CenterX, multiplier: 1.0, constant: 0.0), NSLayoutConstraint(item: bgImageView, attribute: .CenterY, relatedBy: .Equal, toItem: self.tableView, attribute: .CenterY, multiplier: 1.0, constant: 0.0), NSLayoutConstraint(item: bgImageView, attribute: .Width, relatedBy: .Equal, toItem: self.tableView, attribute: .Width, multiplier: 1.0, constant: 0.0), NSLayoutConstraint(item: bgImageView, attribute: .Height, relatedBy: .Equal, toItem: self.tableView, attribute: .Height, multiplier: 1.0, constant: 0.0)]
        
        //self.tableView.addConstraints(constraints)
        //self.tableView.sendSubviewToBack(bgImageView)
        //self.tableView.backgroundView?.contentMode = .ScaleAspectFill
    }
    
}
