//
//  CustomerLoginViewController.swift
//  QNO
//
//  Created by Xinhong LIU on 12/1/2016.
//  Copyright © 2016 September. All rights reserved.
//

import UIKit

class CustomerLoginViewController: MasterViewController {
    
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        self.isLoginPage = true
        super.viewDidLoad()
        
        let singleTap = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        singleTap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(singleTap)
        
        accountTextField.attributedPlaceholder = NSAttributedString(string: "User Name / Email Address", attributes: [NSForegroundColorAttributeName: UIColor(white: 1.0, alpha: 0.7)])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor(white: 1.0, alpha: 0.7)])
    }
    
    override func viewDidAppear(animated: Bool) {
        if let account = QNOStorage.getCustomerId() {
            accountTextField.text = account
        } else {
            accountTextField.text = ""
        }
    }
    
    @IBAction func login(sender: AnyObject) {
        QNOStorage.setCustomerId(accountTextField.text)
        if QNOStorage.getAndSetNotFirstLogin() {
            self.performSegueWithIdentifier("customer_login", sender: self)
        } else {
            self.performSegueWithIdentifier("customer_demo", sender: self)
        }
    }
    
    func hideKeyboard() {
        accountTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}
