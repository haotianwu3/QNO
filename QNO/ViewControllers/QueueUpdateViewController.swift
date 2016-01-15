//
//  QueueUpdateViewController.swift
//  QNO
//
//  Created by Xinhong LIU on 14/1/2016.
//  Copyright © 2016 September. All rights reserved.
//

import UIKit
import PKHUD

class QueueUpdateViewController: MasterViewController {
    var houseName: String!
    var queueName: String!
    var expectedNumber: Int!
    var ticketNumber: Int!
    
    @IBOutlet weak var expectedNumberLabel: UILabel!
    @IBOutlet weak var ticketNumberLabel: UILabel!
    
    @IBOutlet weak var eNStepper: UIStepper!
    @IBOutlet weak var tNStepper: UIStepper!
    
    @IBAction func eNvalueChanged(sender: AnyObject) {
        let picker = sender as! UIStepper
        expectedNumber = Int(picker.value)
        expectedNumberLabel.text = "Expected: \(expectedNumber)"
    }
    
    @IBAction func tNValueChanged(sender: AnyObject) {
        let picker = sender as! UIStepper
        ticketNumber = Int(picker.value)
        ticketNumberLabel.text = "Ticket: \(ticketNumber)"
    }
    
    override func viewDidLoad() {
        eNStepper.value = Double(expectedNumber)
        tNStepper.value = Double(ticketNumber)
        expectedNumberLabel.text = "Expected: \(expectedNumber)"
        ticketNumberLabel.text = "Ticket: \(ticketNumber)"
    }
    
    @IBAction func update(sender: AnyObject) {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        let api = QNOAPI()
        do {
            try api.updateQueue(houseName, queueName: queueName, expectedNumber: expectedNumber, ticketNumber: ticketNumber, callback: { (errorMessage) -> Void in
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    PKHUD.sharedHUD.hide()
                })
                if errorMessage == nil {
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        PKHUD.sharedHUD.contentView = PKHUDSuccessView()
                        PKHUD.sharedHUD.show()
                        PKHUD.sharedHUD.hide(afterDelay: 1.0);
                    })
                } else {
                    let _alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .Alert)
                    _alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    self.presentViewController(_alertController, animated: true, completion: nil)
                }
            })
        } catch QNOAPIRuntimeError.InvalidOperation {
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                PKHUD.sharedHUD.hide()
            })
            let _alertController = UIAlertController(title: "Invalid operation", message: "The operation is not permitted.", preferredStyle: .Alert)
            _alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(_alertController, animated: true, completion: nil)
            return
        } catch {
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                PKHUD.sharedHUD.hide()
            })
            print("Unknown error")
        }
    }
    
}
