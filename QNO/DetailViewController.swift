//
//  DetailViewController.swift
//  QNO
//
//  Created by Randolph on 13/1/2016.
//  Copyright © 2016年 September. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


/* detail scene view controller
@IBOutlet weak var distance: UINavigationItem!
@IBOutlet weak var distance: UINavigationItem!
displays its item (the selected master list row) */
class DetailViewController: MasterViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var shopName: String?
    var shopLatitude: Double = 0.0
    var shopLongitude: Double = 0.0
    var shopAddress: String?
    
    let locationManager = CLLocationManager()
    
    // model to display
    //@IBOutlet weak var MapView: MKMapView!
    //@IBOutlet weak var distance: UINavigationItem!
    @IBOutlet weak var MapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //display user's current location
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.MapView.showsUserLocation = true
        
        
        // display the shop on map
        let shopLocation = CLLocationCoordinate2DMake(shopLatitude, shopLongitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = shopLocation
        annotation.title = self.shopName
        annotation.subtitle = self.shopAddress
        MapView.addAnnotation(annotation)
        MapView.selectAnnotation(annotation, animated: true)
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let houseCenter = CLLocationCoordinate2D(latitude: shopLatitude, longitude: shopLongitude)
        let userRegion = MKCoordinateRegion(center: houseCenter, span: MKCoordinateSpanMake(0.006, 0.006))
        self.MapView.setRegion(userRegion, animated: true)
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Errors: " + error.localizedDescription)
    }
    
    
}
