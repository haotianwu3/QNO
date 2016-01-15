//
//  nearbyShopsViewController.swift
//  QNO
//
//  Created by Randolph on 13/1/2016.
//  Copyright © 2016年 September. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import PKHUD
import SDWebImage

class nearbyShopsViewController: MasterTableViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var shops = [Shop]()
    var afterFilterShops = [Shop]()
    var tempFilterShops = [Shop]()
    var distanceLimit: Double = 30000 // ***can be changed in setting
    
    var shopCellLatitude: Double?
    var shopCellLongitude: Double?
    var distanceCell: String?
    var cellLocationManager = CLLocationManager()
    
    let placeholderImage = UIImage(named: "no-propertyfound")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cellLocationManager.delegate = self
        self.cellLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.cellLocationManager.requestWhenInUseAuthorization()
        self.cellLocationManager.startUpdatingLocation()
        
        loadOnlineHouses()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "loadOnlineHouses", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl!)
    }
    
    override func viewDidDisappear(animated: Bool) {
        let selectedIndexPath = tableView.indexPathForSelectedRow
        guard selectedIndexPath != nil else {
            return
        }
        tableView.deselectRowAtIndexPath(selectedIndexPath!, animated: true)
    }
    
    func loadOnlineHouses() {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        let api = QNOAPI()
        do {
            try api.requestAllHouses({ (errorMessage, houses) -> Void in
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    PKHUD.sharedHUD.hide()
                    self.refreshControl?.endRefreshing()
                })
                if errorMessage == nil {
                    self.shops.removeAll()
                    for house in houses! {
                        let houseDict = house as! [String: AnyObject]
                        let houseName = houseDict["name"] as! String
                        let hasLogo = houseDict["logoType"] != nil
                        let description = houseDict["description"] as? String
                        let longitude = houseDict["longitude"] as? Double
                        let latitude = houseDict["latitude"] as? Double
                        let address = houseDict["address"] as? String
                        let shop = Shop(name: houseName, hasLogo: hasLogo, description: description, address: address, latitude: latitude, longitude: longitude)
                        // calculate distance
                        if latitude != nil && longitude != nil {
                            let userLocation = self.cellLocationManager.location
                            if userLocation != nil {
                                let shopCLLocation: CLLocation = CLLocation(latitude: latitude!, longitude: longitude!)
                                let distanceBetween: CLLocationDistance = (userLocation?.distanceFromLocation(shopCLLocation))!
                                shop.distance = distanceBetween
                                if shop.distance < self.distanceLimit {
                                    self.shops.append(shop)
                                }
                            } else {
                                let alertController = UIAlertController(title: "Error", message: "Your location is not available", preferredStyle: .Alert)
                                alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                                self.presentViewController(alertController, animated: true, completion: nil)
                            }
                        }
                    }
                    
                    self.shops.sortInPlace {(shop1:Shop, shop2:Shop) -> Bool in
                        shop1.distance < shop2.distance
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
    
    func loadSampleShops(){
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "shopCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ShopTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let shop = shops[indexPath.row]
        
        cell.ShopTitle.text = shop.Name
        cell.ShopDecription.text = shop.ShopDescription
        if shop.hasLogo {
            let imageURL = "http://144.214.121.58:8080/JOS/house/houseLogoImage?houseName=\(shop.Name.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!)"
            cell.ShopLogo.sd_setImageWithURL(NSURL(string: imageURL), placeholderImage: placeholderImage)
        } else {
            cell.ShopLogo.image = placeholderImage
        }
        
        self.distanceCell = String(format: "%.2f m", shop.distance!)
        
        
        cell.DistanceFromUser.text = self.distanceCell
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shops.count
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // sender is the tapped `UITableViewCell`
        let cell = sender as! UITableViewCell
        let indexPath = self.tableView.indexPathForCell(cell)
        
        // load the selected model
        let item = self.shops[indexPath!.row]
        
        let detail = segue.destinationViewController as! DetailViewController
        // set the model to be viewed
        detail.shopName = item.Name
        detail.shopLongitude = item.ShopLongitude!
        detail.shopLatitude = item.ShopLatitude!
        detail.shopAddress = item.ShopAddress
    }

}


