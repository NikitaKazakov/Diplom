//
//  ImageController.swift
//  tableViewTesting
//
//  Created by Admin on 11/20/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import UIKit

class ImageController: UIViewController {
    
    
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image.image = Filter().processPixels(in: #imageLiteral(resourceName: "flamingo")) { pixelBuffer, offset,_,_  in
            if pixelBuffer[offset].color > UInt32.max/3*2 {
                pixelBuffer[offset] = Filter.RGBA32.white
            } else {
                pixelBuffer[offset] = Filter.RGBA32.black
            }
        }
    }
    
    
}
