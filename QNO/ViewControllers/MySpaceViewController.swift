//
//  MySpaceViewController.swift
//  QNO
//
//  Created by Xinhong LIU on 15/1/2016.
//  Copyright © 2016 September. All rights reserved.
//

import UIKit
import PKHUD
import SDWebImage

class MySpaceViewController: MasterViewController {

    @IBAction func cleanImageCache(sender: AnyObject) {
        SDImageCache.sharedImageCache().clearMemory()
        SDImageCache.sharedImageCache().clearDiskOnCompletion { () -> Void in
            PKHUD.sharedHUD.contentView = PKHUDSuccessView()
            PKHUD.sharedHUD.show()
            PKHUD.sharedHUD.hide(afterDelay: 1.0)
        }
    }
}
