//
//  MyCurrentQueuesViewController.swift
//  QNO
//
//  Created by Randolph on 14/1/2016.
//  Copyright © 2016年 September. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class MyCurrentQueuesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var DataSource: UITableView!
    
    var expectetNumberCache = [Int: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.DataSource.dataSource = self
        self.DataSource.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Defaults[customerQueueKey].count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("customer_queue") as! CustomerTicketTableCell
        
        let queueStr = Defaults[customerQueueKey][indexPath.row]
        let tokens = queueStr.componentsSeparatedByString("&")
        let houseName = tokens[0]
        let queueName = tokens[1]
        let ticketNumber = tokens[2]
        
        cell.houseNameLabel.text = houseName
        cell.queueNameLabel.text = queueName
        cell.myTicketNumber.text = ticketNumber
        cell.expectedNumberLabel.text = "loading"
        
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
                
                let tokens = responseStr!.componentsSeparatedByString("next ticket number is : ")
                
                
                if tokens.count == 2 {
                    NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
                        let _cell = tableView.cellForRowAtIndexPath(indexPath) as! CustomerTicketTableCell
                        _cell.expectedNumberLabel.text = "\(tokens[1])"
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
        
        return cell
    }
}
