//
//  CustomerLoginViewController.swift
//  QNO
//
//  Created by Xinhong LIU on 12/1/2016.
//  Copyright © 2016 September. All rights reserved.
//

import UIKit

class CustomerLoginViewController: UIViewController {
    
    @IBAction func login(sender: AnyObject) {
        self.performSegueWithIdentifier("customer_login", sender: self)
    }
}
