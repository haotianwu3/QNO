//
//  HouseLoginViewController.swift
//  QNO
//
//  Created by Xinhong LIU on 12/1/2016.
//  Copyright © 2016 September. All rights reserved.
//

import UIKit

class HouseLoginViewController: MasterViewController {

    @IBOutlet weak var houseNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        self.isLoginPage = true
        super.viewDidLoad()
        
        let singleTap = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        singleTap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(singleTap)
        
        houseNameTextField.attributedPlaceholder = NSAttributedString(string: "User Name / Email Address", attributes: [NSForegroundColorAttributeName: UIColor(white: 1.0, alpha: 0.7)])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor(white: 1.0, alpha: 0.7)])
    }
    
    override func viewDidAppear(animated: Bool) {
        if let houseName = QNOStorage.getHouseName() {
            houseNameTextField.text = houseName
        } else {
            houseNameTextField.text = ""
        }
    }
    
    @IBAction func login(sender: AnyObject) {
        
        let houseName = houseNameTextField.text
        
        guard houseName != nil && houseName != "" else {
            let alertController = UIAlertController(title: "Invalid inputs", message: "Please input house name", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        QNOStorage.setHouseName(houseName)
        self.performSegueWithIdentifier("house_login", sender: self)
    }
    
    func hideKeyboard() {
        houseNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
}
