//
//  SelectRoleViewController.swift
//  QNO
//
//  Created by Xinhong LIU on 12/1/2016.
//  Copyright © 2016 September. All rights reserved.
//

import UIKit

class SelectRoleViewController: MasterViewController {
    
    var jumped = false
    
    override func viewDidLoad() {
        self.isLoginPage = true
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        if jumped {
            return
        }
        
        jumped = true
        if QNOStorage.getCustomerId() != nil {
            self.performSegueWithIdentifier("customer_login", sender: nil)
        } else if QNOStorage.getHouseName() != nil {
            self.performSegueWithIdentifier("restaurant_login", sender: nil)
        }
    }
}
