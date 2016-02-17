//
//  MyCurrentQueuesViewController.swift
//  QNO
//
//  Created by Randolph on 14/1/2016.
//  Copyright © 2016年 September. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import MGSwipeTableCell

class CustomerTicketsViewController: MasterTableViewController {
    
    var expectetNumberCache = [Int: Int]()
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Defaults[customerQueueKey].count * 2 - 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row % 2 == 0 {
            return 130
        } else {
            return 10
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(Int(indexPath.row.value) % 2 == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier("customer_queue") as! CustomerTicketTableCell
        
            let queueStr = Defaults[customerQueueKey][indexPath.row / 2]
            let tokens = queueStr.componentsSeparatedByString("&")
            let houseName = tokens[0].stringByReplacingOccurrencesOfString("+", withString: " ").stringByRemovingPercentEncoding!
            let queueName = tokens[1].stringByReplacingOccurrencesOfString("+", withString: " ").stringByRemovingPercentEncoding!
            let ticketNumber = tokens[2]
        
            cell.houseNameLabel.text = houseName
            cell.queueNameLabel.text = queueName
            cell.estimatedTimeLabel.text = "Estimated waiting time: loading"
            cell.myTicketNumber.text = ticketNumber
            cell.expectedNumberLabel.text = "loading"
        
            cell.rightButtons = [MGSwipeButton(title: "Delete", backgroundColor: UIColor.redColor(), callback: { (_cell) -> Bool in
                let iP = self.tableView.indexPathForCell(_cell)!
                Defaults[customerQueueKey].removeAtIndex(iP.row / 2)
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
                })
                return true
            })]
        
            let api = QNOAPI()
            do {
                try api.requestQueue(houseName, queueName: queueName) { (errorMessage, response) -> Void in
                    guard errorMessage == nil && response != nil else {
                        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .Alert)
                        alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                        return
                    }
                
                    let responseStr = String(data: response!, encoding: NSUTF8StringEncoding)
                
                    var tokens = responseStr!.componentsSeparatedByString("Expected next number is: ")
                    tokens = tokens[1].componentsSeparatedByString(", next ticket number is")
                    if tokens.count == 2 {
                        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
                            let _cell = tableView.cellForRowAtIndexPath(indexPath) as! CustomerTicketTableCell
                            _cell.expectedNumberLabel.text = "\(tokens[0])"
                            let expectedN = Int(tokens[0])!
                            let estimatedTime = arc4random_uniform(UInt32(10)) + 10
                            cell.estimatedTimeLabel.text = "Estimated waiting time: \(Int(estimatedTime) * (Int(ticketNumber)! - expectedN)) minutes"
                        }
                    } else {
                        let alertController = UIAlertController(title: "Error", message: "Invalid response", preferredStyle: .Alert)
                        alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            } catch QNOAPIRuntimeError.InvalidOperation {
                let alertController = UIAlertController(title: "Invalid operation", message: "The operation is not permitted.", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            } catch {
                print("Unknown error")
            }
            cell.backgroundColor = UIColor.clearColor()
            return cell
        } else {
            let separatorIdentifier = "shopCellSeparator"
            let separatorCell = tableView.dequeueReusableCellWithIdentifier(separatorIdentifier, forIndexPath: indexPath)
            separatorCell.backgroundColor = UIColor.clearColor()
            return separatorCell
        }
    }
}
