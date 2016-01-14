//
//  QRCodeGenerator.swift
//  QNO
//
//  Created by Randolph on 14/1/2016.
//  Copyright © 2016年 September. All rights reserved.
//

import UIKit

class QRCodeGenerator: UIViewController {
    @IBOutlet weak var ShopLinkVariable: UILabel!

    @IBOutlet weak var QRCodeDisplayArea: UIImageView!
    
    @IBOutlet weak var QRCodeSizeSlider: UISlider!
    
    
    var qrcodeImage: CIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateQRCode()
        displayQRCodeImage()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func generateQRCode(){
        if qrcodeImage == nil {
            if ShopLinkVariable.text == "" {
                return
            }
            let data = ShopLinkVariable.text!.dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: false)
            
            let filter = CIFilter(name: "CIQRCodeGenerator")
            
            filter!.setValue(data, forKey: "inputMessage")
            filter!.setValue("H", forKey: "inputCorrectionLevel")
            
            qrcodeImage = filter!.outputImage
            
            QRCodeDisplayArea.image = UIImage(CIImage: qrcodeImage)
            
            ShopLinkVariable.resignFirstResponder()
        }
    
    }
    
    func displayQRCodeImage() {
        let scaleX = QRCodeDisplayArea.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = QRCodeDisplayArea.frame.size.height / qrcodeImage.extent.size.height
        
        let transformedImage = qrcodeImage.imageByApplyingTransform(CGAffineTransformMakeScale(scaleX, scaleY))
        
        QRCodeDisplayArea.image = UIImage(CIImage: transformedImage)
        
        
    }
    
    @IBAction func changeImageViewScale(sender: AnyObject) {
        QRCodeDisplayArea.transform = CGAffineTransformMakeScale(CGFloat(QRCodeSizeSlider.value), CGFloat(QRCodeSizeSlider.value))
        
    }
    
    
    //func here is for the scene before this scene
    //func here is for the scene before this scene
    //func here is for the scene before this scene
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let item = sender as! UINavigationItem
        
        let detail = segue.destinationViewController as! QRCodeGenerator
        //uncomment code below & change the "shopName" to the variable of the current shop name
        //detail.ShopLinkVariable = item.shopName
        
    }
    
}
