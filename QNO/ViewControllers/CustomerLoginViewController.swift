//
//  CustomerLoginViewController.swift
//  QNO
//
//  Created by Xinhong LIU on 12/1/2016.
//  Copyright © 2016 September. All rights reserved.
//

import UIKit

class CustomerLoginViewController: UIViewController {
    
    @IBOutlet weak var accountTextField: UITextField!
    
    override func viewDidAppear(animated: Bool) {
        if let account = QNOStorage.getCustomerId() {
            accountTextField.text = account
        } else {
            accountTextField.text = ""
        }
    }
    
    @IBAction func login(sender: AnyObject) {
        if QNOStorage.getAndSetNotFirstLogin() {
            self.performSegueWithIdentifier("customer_login", sender: self)
        } else {
            self.performSegueWithIdentifier("customer_demo", sender: self)
        }
    }
}
