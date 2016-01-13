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


class nearbyShopsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    //@IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableView: UITableView!
    
    var shops = [Shop]()
    
    var shopCellLatitude: Double?
    var shopCellLongitude: Double?
    var distanceCell: String?
    var cellLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.cellLocationManager.delegate = self
        self.cellLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.cellLocationManager.requestWhenInUseAuthorization()
        self.cellLocationManager.startUpdatingLocation()
        
        
        loadSampleShops()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadSampleShops(){
        let shop1 = Shop(name: "CK", logoName: "img_1.png", descirption: "this is a description", address: "Festival Walk, 3/F", latitude: 22.30088, longitude: 114.17208200000005)!
        let shop2 = Shop(name: "LogOn", logoName: "img_2.png", descirption: "this is a description", address: "Festival Walk, 4/F",latitude: 22.2966911, longitude: 114.17192449999993)!
        let shop3 = Shop(name: "Nike", logoName: "img_3.png", descirption: "this is a description", address: "Festival Walk, 5/F",latitude: 22.2819496, longitude: 114.18574409999997)!
        
        shops += [shop1, shop2, shop3]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "shopCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ShopTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let shop = shops[indexPath.row]
        
        cell.ShopTitle.text = shop.Name
        cell.ShopDecription.text = shop.ShopDescription
        cell.ShopLogo.image = UIImage(named: shop.ShopLogoName)
        
        shopCellLatitude = shop.ShopLatitude
        shopCellLongitude = shop.ShopLongitude
        
        cell.DistanceFromUser.text = self.distanceCell
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shops.count
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
        detail.shopLongitude = item.ShopLongitude
        detail.shopLatitude = item.ShopLatitude
        detail.shopAddress = item.ShopAddress
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation = locations.last
        
        let shopCLLocation: CLLocation = CLLocation(latitude: shopCellLatitude!, longitude: shopCellLongitude!)
        let distanceBetween: CLLocationDistance = (userLocation?.distanceFromLocation(shopCLLocation))!
        self.distanceCell = String(format: "%.2f m", distanceBetween)
        
        self.cellLocationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Errors: " + error.localizedDescription)
    }


}


