//
//  HouseManageViewController.swift
//  QNO
//
//  Created by Xinhong LIU on 12/1/2016.
//  Copyright © 2016 September. All rights reserved.
//

import UIKit
import PKHUD
import MGSwipeTableCell

class QueueManageViewController: MasterTableViewController {
    
    var houseName: String!
    
    var queues = [String]()
    var expectedNs = [Int]()
    var tickNs = [Int]()
    
    var linkToBeGeneratedToQRCode: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        houseName = QNOStorage.getHouseName()!
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "update", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl!)
    }
    
    override func viewDidAppear(animated: Bool) {
        update()
    }
    
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("queue_cell") as! QueueTableViewCell
        cell.queueNameLabel.text = queues[indexPath.row]
        cell.expectedNumberLabel.text = "\(expectedNs[indexPath.row])"
        cell.ticketNumberLabel.text = "\(tickNs[indexPath.row])"
        
        cell.leftButtons = [MGSwipeButton(title: "Expected+", backgroundColor: UIColor(red: (255/255.0), green: (106/255.0), blue: (106/255.0), alpha: 1.0), callback: { (_cell) -> Bool in
            let index = self.tableView.indexPathForCell(_cell)!.row
            
            PKHUD.sharedHUD.contentView = PKHUDProgressView()
            PKHUD.sharedHUD.show()
            
            let api = QNOAPI()
            do {
                try api.updateQueue(self.houseName, queueName: self.queues[index], expectedNumber: self.expectedNs[index] + 1, ticketNumber: self.tickNs[index], callback: { (errorMessage) -> Void in
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        PKHUD.sharedHUD.hide()
                    })
                    if errorMessage == nil {
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.update()
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
                return false
            } catch {
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    PKHUD.sharedHUD.hide()
                })
                print("Unknown error")
            }
            
            return true
        }), MGSwipeButton(title: "Ticket+", backgroundColor: UIColor(red: (0/255.0), green: (192/255.0), blue: (255/255.0), alpha: 1.0), callback: { (_cell) -> Bool in
            let index = self.tableView.indexPathForCell(_cell)!.row
            
            PKHUD.sharedHUD.contentView = PKHUDProgressView()
            PKHUD.sharedHUD.show()
            
            let api = QNOAPI()
            do {
                try api.updateQueue(self.houseName, queueName: self.queues[index], expectedNumber: self.expectedNs[index], ticketNumber: self.tickNs[index] + 1, callback: { (errorMessage) -> Void in
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        PKHUD.sharedHUD.hide()
                    })
                    if errorMessage == nil {
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.update()
                            self.linkToBeGeneratedToQRCode = "qno://name=\(self.houseName!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!)&queue=\(self.queues[index].stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!)&ticket=\(self.tickNs[index])"
                            self.performSegueWithIdentifier("show_qr", sender: self)
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
                return false
            } catch {
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    PKHUD.sharedHUD.hide()
                })
                print("Unknown error")
            }
            
            return true
        })]
        cell.leftSwipeSettings.transition = .Drag
        cell.rightButtons = [MGSwipeButton(title: "Delete", backgroundColor: UIColor.redColor(), callback: { (_) -> Bool in
            return true
        })]
        cell.rightSwipeSettings.transition = .Drag
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queues.count
    }
    
    @IBAction func addQueue(sender: AnyObject) {
        let alertController = UIAlertController(title: "Create a Queue", message: "Queue Name: ", preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "2 People Table"
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (alertAction) -> Void in
            let queueName = alertController.textFields![0].text
            guard queueName != nil
                else {
                let _alertController = UIAlertController(title: "Error", message: "Do not leave it blank", preferredStyle: .Alert)
                _alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(_alertController, animated: true, completion: nil)
                return
            }
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                PKHUD.sharedHUD.contentView = PKHUDProgressView()
                PKHUD.sharedHUD.show()
            })
            
            
            let api = QNOAPI()
            do {
                try api.addQueue(self.houseName, queueName: queueName!, expectedNumber: 0, ticketNumber: 0, callback: { (errorMessage) -> Void in
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        PKHUD.sharedHUD.hide()
                    })
                    if errorMessage == nil {
                        let _alertController = UIAlertController(title: "Queue has been created", message: "Queue name: \(queueName!)", preferredStyle: .Alert)
                        _alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (UIAlertAction) -> Void in
                            self.update()
                        }))
                        self.presentViewController(_alertController, animated: true, completion: nil)
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
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func update() {
        let api = QNOAPI()
        
        do {
            try
                api.requestAllQueues(self.houseName) { (errorMessage, response) -> Void in
                    guard errorMessage == nil && response != nil else {
                        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .Alert)
                        alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                        return
                    }
                    
                    do {
                        let queues = try NSJSONSerialization.JSONObjectWithData(response!, options: .AllowFragments) as! [AnyObject]
                        self.queues.removeAll()
                        self.expectedNs.removeAll()
                        self.tickNs.removeAll()
                        for queue in queues {
                            let obj = queue as! [String: AnyObject]
                            self.queues.append(obj["name"] as! String)
                            self.expectedNs.append(obj["expectedNumber"] as! Int)
                            self.tickNs.append(obj["ticketNumber"] as! Int)
                        }
                    } catch {
                        let alertController = UIAlertController(title: "Error", message: "Invalid response", preferredStyle: .Alert)
                        alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                        return
                    }
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
                        self.refreshControl?.endRefreshing()
                        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
                    }
            }
        } catch QNOAPIRuntimeError.InvalidOperation {
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.refreshControl?.endRefreshing()
            })
            let alertController = UIAlertController(title: "Invalid operation", message: "The operation is not permitted.", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        } catch {
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.refreshControl?.endRefreshing()
            })
            print("Unknown error")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "update_queue" {
            let dest = segue.destinationViewController as! QueueUpdateViewController
            dest.houseName = self.houseName
            let index = self.tableView.indexPathForSelectedRow?.row
            dest.queueName = queues[index!]
            dest.expectedNumber = expectedNs[index!]
            dest.ticketNumber = tickNs[index!]
        } else if segue.identifier == "show_qr" {
            let nav = segue.destinationViewController as! UINavigationController
            let dest = nav.viewControllers[0] as! QRCodeGeneratorViewController
            dest.link = self.linkToBeGeneratedToQRCode
        }
    }
}
