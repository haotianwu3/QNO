//
//  HouseRegistrationViewController.swift
//  QNO
//
//  Created by Xinhong LIU on 12/1/2016.
//  Copyright © 2016 September. All rights reserved.
//

import UIKit
import PKHUD
import SwiftyUserDefaults

class HouseRegistrationViewController: MasterViewController {
    
    @IBOutlet weak var houseNameTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var telTextField: UITextField!
    
    @IBOutlet weak var homepageTextField: UITextField!
    
    
    override func viewDidLoad() {
        self.isLoginPage = true
        super.viewDidLoad()
        
        let singleTap = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        singleTap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(singleTap)
    }
    
    
    // validate form
    // if no error, return nil
    func validateForm() -> String? {
        
        let houseName = houseNameTextField.text
        
        guard houseName != nil && houseName != "" else {
            return "Please fill the house name"
        }
        
        return nil
    }
    
    @IBAction func register(sender: AnyObject) {
        let error = validateForm()
        
        let houseName = houseNameTextField.text!
        let address = addressTextField.text
        let tel = telTextField.text
        let homepage = homepageTextField.text
        
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
            try api.addHouse(houseName, address: address, tel: tel, homepage: homepage) { (errorMessage) -> Void in
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        PKHUD.sharedHUD.hide()
                    })
                    if errorMessage == nil {
                        let alertController = UIAlertController(title: "House has been created", message: "You can login now", preferredStyle: .Alert)
                        alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (UIAlertAction) -> Void in
                            QNOStorage.setHouseName(houseName)
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                self.performSegueWithIdentifier("unwind", sender: self)
                            })
                        }))
                        self.presentViewController(alertController, animated: true, completion: nil)
                    } else {
                        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .Alert)
                        alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                })
            }
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
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
        
    }
    
    func hideKeyboard() {
        houseNameTextField.resignFirstResponder()
        addressTextField.resignFirstResponder()
        telTextField.resignFirstResponder()
        homepageTextField.resignFirstResponder()
    }
}
