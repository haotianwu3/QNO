//
//  UserMainViewController.swift
//  QNO
//
//  Created by Randolph on 12/1/2016.
//  Copyright © 2016年 September. All rights reserved.
//

import UIKit
import PKHUD
import SDWebImage

class UserMainViewController: MasterViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabBar: UIToolbar!
    
    var refreshControl: UIRefreshControl?
    
    let placeholderImage = UIImage(named: "no-propertyfound")
    
    var Ads = [UserMainAds]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.backgroundColor = UIColor(patternImage: UIImage(named: "page_background")!)
        
        self.navigationController
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        loadOnlineAds()
        
        self.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "loadOnlineAds", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadOnlineAds() {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        let api = QNOAPI()
        do {
            try api.requestAllAds({ (errorMessage, ads) -> Void in
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    PKHUD.sharedHUD.hide()
                    self.refreshControl?.endRefreshing()
                })
                if errorMessage == nil {
                    self.Ads.removeAll()
                    for ad in ads! {
                        let adDict = ad as! [String: AnyObject]
                        let houseName = adDict["houseName"] as! String
                        let description = adDict["description"] as! String
                        let adId = adDict["id"] as! Int
                        let adObj = UserMainAds(houseName: houseName, description: description, adId: adId)
                        self.Ads.append(adObj)
                    }
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
                    })
                } else {
                    let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            })
        } catch QNOAPIRuntimeError.InvalidOperation {
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                PKHUD.sharedHUD.hide()
                self.refreshControl?.endRefreshing()
            })
            let alertController = UIAlertController(title: "Invalid operation", message: "The operation is not permitted.", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        } catch {
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                PKHUD.sharedHUD.hide()
                self.refreshControl?.endRefreshing()
            })
            print("Unknown error")
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "UserMainAdsTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UserMainAdsTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let Ad = Ads[indexPath.row]
        
        cell.houseNAmeTextLabel.text = Ad.houseName
        cell.AdsDescription.text = Ad.description
        
        let imageURL = "http://144.214.121.58:8080/JOS/ad/adImage?adId=\(Ad.adId)"
        let houseImageURL = "http://144.214.121.58:8080/JOS/house/houseLogoImage?houseName=\(Ad.houseName.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!)"
        cell.AdsImageView.sd_setImageWithURL(NSURL(string: imageURL), placeholderImage: placeholderImage)
        cell.houseImageView.sd_setImageWithURL(NSURL(string: houseImageURL), placeholderImage: placeholderImage)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Ads.count
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200.0
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
