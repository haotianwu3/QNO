//
//  MyCurrentQueuesViewController.swift
//  QNO
//
//  Created by Randolph on 14/1/2016.
//  Copyright © 2016年 September. All rights reserved.
//

import UIKit


class MyCurrentQueuesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var DataSource: UITableView!
    
    var categories = ["Restaurants"]
    
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return categories.count
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section]
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! CategoryRow
        return cell
    }
    
}
