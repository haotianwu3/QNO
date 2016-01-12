//
//  HouseRegistrationViewController.swift
//  QNO
//
//  Created by Xinhong LIU on 12/1/2016.
//  Copyright © 2016 September. All rights reserved.
//

import UIKit
import PKHUD

class HouseRegistrationViewController: UIViewController {
    
    // validate form
    // if no error, return nil
    func validateForm() -> String? {
        // TODO: Read form
        return nil
    }
    
    func register() {
        let error = validateForm()
        
        let houseName = ""
        let address = ""
        let tel = ""
        let homepage = ""
        
        guard error == nil else {
            let alertController = UIAlertController(title: "Invalid inputs", message: error, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        
        let api = QNOAPI()
        do {
            try api.addHouse(houseName, address: address, tel: tel, homepage: homepage) { (errorMessage) -> Void in
                
            }
        } catch QNOAPIRuntimeError.InvalidOperation {
            let alertController = UIAlertController(title: "Invalid operation", message: error, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        } catch {
            print("Unknown error")
        }
        
    }
}
