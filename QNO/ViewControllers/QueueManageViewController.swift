//
//  HouseManageViewController.swift
//  QNO
//
//  Created by Xinhong LIU on 12/1/2016.
//  Copyright © 2016 September. All rights reserved.
//

import UIKit

class QueueManageViewController: UITableViewController {
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("queue_cell") as! QueueTableViewCell
        cell.queueNameLabel.text = "2 People Table"
        cell.expectedNumberLabel.text = "20"
        cell.ticketNumberLabel.text = "25"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}
