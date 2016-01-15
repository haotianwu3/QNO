//
//  CustomerRegisterViewController.swift
//  QNO
//
//  Created by Xinhong LIU on 15/1/2016.
//  Copyright © 2016 September. All rights reserved.
//

import UIKit
import PKHUD

class CustomerRegisterViewController: UIViewController {

    @IBOutlet weak var accountTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var mobileTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    // return error, nil if no error
    func validateForm() -> String? {
        let account = accountTextField.text
        guard account != nil && account != "" else {
            return "Your account cannot be blank"
        }
        return nil
    }
    
    @IBAction func register(sender: AnyObject) {
        let error = validateForm()
        
        let account = accountTextField.text!
        let email = emailTextField.text
        let mobile = mobileTextField.text
        let address = addressTextField.text
        
        guard error == nil else {
            let alertController = UIAlertController(title: "Invalid inputs", message: error, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        let api = QNOAPI()
        do {
            try api.addCustomer(account, email: email, mobile: mobile, address: address, callback: { (errorMessage) -> Void in
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    PKHUD.sharedHUD.hide()
                })
                if errorMessage == nil {
                    let alertController = UIAlertController(title: "Account has been created", message: "You can login now", preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (UIAlertAction) -> Void in
                        QNOStorage.setCustomerId(account)
                    }))
                    self.presentViewController(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            })
        } catch QNOAPIRuntimeError.InvalidOperation {
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                PKHUD.sharedHUD.hide()
            })
            let alertController = UIAlertController(title: "Invalid operation", message: "The operation is not permitted.", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        } catch {
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                PKHUD.sharedHUD.hide()
            })
            print("Unknown error")
        }
    }
}
