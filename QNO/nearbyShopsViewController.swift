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
    var afterFilterShops = [Shop]()
    var tempFilterShops = [Shop]()
    var distanceLimit: Double = 3000 // ***can be changed in setting
    
    var shopCellLatitude: Double?
    var shopCellLongitude: Double?
    var distanceCell: String?
    var cellLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleShops()
        filterShops()
        
        self.cellLocationManager.delegate = self
        self.cellLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.cellLocationManager.requestWhenInUseAuthorization()
        self.cellLocationManager.startUpdatingLocation()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func filterShops(){
        tempFilterShops = shops
        for index1 in 0...(shops.count-1){
            let unfilterShop = shops[index1]
            shopCellLatitude = unfilterShop.ShopLatitude
            shopCellLongitude = unfilterShop.ShopLongitude
            let userLocation = cellLocationManager.location
            let shopCLLocation: CLLocation = CLLocation(latitude: shopCellLatitude!, longitude: shopCellLongitude!)
            let distanceBetween: CLLocationDistance = (userLocation?.distanceFromLocation(shopCLLocation))!
            tempFilterShops[index1].distance = distanceBetween
        }
        tempFilterShops.sortInPlace {(shop1:Shop, shop2:Shop) -> Bool in
            shop1.distance < shop2.distance
        }
        //now tempFilterShops is in asending order
        for index2 in 0...(tempFilterShops.count-1){
            if tempFilterShops[index2].distance <= distanceLimit{
                afterFilterShops += [tempFilterShops[index2]]
            }
        }

        
    }
    
    func loadSampleShops(){
        let shop1 = Shop(name: "CK", logoName: "img_1.png", descirption: "this is a description", address: "Festival Walk, 3/F", latitude: 22.30088, longitude: 114.17208200000005)!
        let shop2 = Shop(name: "LogOn", logoName: "img_2.png", descirption: "this is a description", address: "Festival Walk, 4/F",latitude: 22.2966911, longitude: 114.17192449999993)!
        let shop3 = Shop(name: "Nike", logoName: "img_3.png", descirption: "this is a description", address: "Festival Walk, 5/F",latitude: 22.2819496, longitude: 114.18574409999997)!
        let shop4 = Shop(name: "WangJiaSha", logoName: "img_4.png", descirption: "this is a description", address: "Festival Walk, 6/F",latitude: 22.337305, longitude: 114.174034)!
        let shop5 = Shop(name: "BaYueHua", logoName: "img_1.png", descirption: "this is a description", address: "Festival Walk, 2/F",latitude: 22.337551, longitude: 114.173894)!
        let shop6 = Shop(name: "AC1", logoName: "img_2.png", descirption: "this is a description", address: "CityU AC1",latitude: 22.336863, longitude: 114.172151)!
        shops += [shop1, shop2, shop3, shop4, shop5, shop6]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "shopCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ShopTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let shop = afterFilterShops[indexPath.row]
        
        cell.ShopTitle.text = shop.Name
        cell.ShopDecription.text = shop.ShopDescription
        cell.ShopLogo.image = UIImage(named: shop.ShopLogoName)
        
        
        self.distanceCell = String(format: "%.2f m", shop.distance)
        
        
        cell.DistanceFromUser.text = self.distanceCell
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return afterFilterShops.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // sender is the tapped `UITableViewCell`
        let cell = sender as! UITableViewCell
        let indexPath = self.tableView.indexPathForCell(cell)
        
        // load the selected model
        let item = self.afterFilterShops[indexPath!.row]
        
        let detail = segue.destinationViewController as! DetailViewController
        // set the model to be viewed
        detail.shopName = item.Name
        detail.shopLongitude = item.ShopLongitude
        detail.shopLatitude = item.ShopLatitude
        detail.shopAddress = item.ShopAddress
    }
    
    


}


