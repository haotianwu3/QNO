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
    
    @IBAction func addEN(sender: AnyObject) {
        expectedNumber = expectedNumber + 1
        expectedNumberLabel.text = "Expected: \(expectedNumber)"
    }
    
    @IBAction func minusEN(sender: AnyObject) {
        expectedNumber = expectedNumber - 1
        if expectedNumber < 0 {
            expectedNumber = 0
        }
        expectedNumberLabel.text = "Expected: \(expectedNumber)"
    }
    
    @IBAction func addTN(sender: AnyObject) {
        ticketNumber = ticketNumber + 1
        ticketNumberLabel.text = "Ticket: \(ticketNumber)"
    }
    
    @IBAction func minusTN(sender: AnyObject) {
        ticketNumber = ticketNumber - 1
        if ticketNumber < 0 {
            ticketNumber = 0
        }
        ticketNumberLabel.text = "Ticket: \(ticketNumber)"
    }
    
    override func viewDidLoad() {
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
