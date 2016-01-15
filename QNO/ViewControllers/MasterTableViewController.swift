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
        let bgImage = UIImage(named: "page_background")
        let bgImageView = UIImageView(image: bgImage)
        self.tableView.backgroundView? = bgImageView
        self.tableView.backgroundView?.contentMode = .ScaleAspectFill
    }
    
}
