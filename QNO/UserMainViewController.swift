//
//  UserMainViewController.swift
//  QNO
//
//  Created by Randolph on 12/1/2016.
//  Copyright © 2016年 September. All rights reserved.
//

import UIKit

class UserMainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var Ads = [UserMainAds]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        loadSampleAds()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadSampleAds() {
        let photo1 = UIImage(named: "img_1")!
        let Ads1 = UserMainAds(description: "Caprese Salad", photo: photo1)!
        
        let photo2 = UIImage(named: "img_2")!
        let Ads2 = UserMainAds(description: "Chicken and Potatoes", photo: photo2)!
        
        let photo3 = UIImage(named: "img_3")!
        let Ads3 = UserMainAds(description: "Pasta with Meatballs", photo: photo3)!
        
        Ads += [Ads1, Ads2, Ads3]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "UserMainAdsTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UserMainAdsTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let Ad = Ads[indexPath.row]
        
        cell.AdsDescription.text = Ad.description
        cell.AdsImage.image = Ad.photo
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Ads.count
    }
    

    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
