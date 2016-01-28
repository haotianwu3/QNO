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
    
    override func viewDidLoad() {
        self.isLoginPage = true
        super.viewDidLoad()
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
    
}
