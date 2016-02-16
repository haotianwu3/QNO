//
//  PageItemController.swift
//  QNO
//
//  Created by Randolph on 11/1/2016.
//  Copyright © 2016年 September. All rights reserved.
//

import UIKit

class CustomerDemoPageItemController: UIViewController {
    
    var itemIndex: Int = 0
    var imageName: String = "" {
        didSet {
            if let imageView = MainPageItemImageView {
                imageView.image = UIImage(named: imageName)
            }
        }
    }

    @IBOutlet weak var MainPageItemImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MainPageItemImageView!.image = UIImage(named: imageName)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
