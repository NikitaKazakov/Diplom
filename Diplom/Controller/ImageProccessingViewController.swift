//
//  ImageProccessingViewController.swift
//  Diplom
//
//  Created by Nikita Kazakov on 12/11/18.
//  Copyright © 2018 Nikita Kazakov. All rights reserved.
//

import Foundation
import UIKit

class ImageProccessingViewController: UIViewController {
    
    class func instantiate(image: UIImage) -> ImageProccessingViewController {
        let storyboard = UIStoryboard(name: "ImageProccessingViewController", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! ImageProccessingViewController
        vc.image = image
        return vc
    }
    
    @IBOutlet weak var originalButton: UIButton!
    @IBOutlet weak var grayscaleButton: UIButton!
    @IBOutlet weak var binaryButton: UIButton!
    @IBOutlet weak var bordersButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalButton.layer.cornerRadius = 8
        grayscaleButton.layer.cornerRadius = 8
        binaryButton.layer.cornerRadius = 8
        bordersButton.layer.cornerRadius = 8
        imageView.layer.cornerRadius = 12
        imageView.image = image
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        originalButton.backgroundColor = UIColor.white
    }
    
    @IBAction func originalButtonPressed(_ sender: UIButton) {
        originalButton.backgroundColor = UIColor.white
        grayscaleButton.backgroundColor = UIColor.pink
        binaryButton.backgroundColor = UIColor.pink
        bordersButton.backgroundColor = UIColor.pink
        imageView.image = image
    }
    
    @IBAction func grayscaleButtonPressed(_ sender: UIButton) {
        originalButton.backgroundColor = UIColor.pink
        grayscaleButton.backgroundColor = UIColor.white
        binaryButton.backgroundColor = UIColor.pink
        bordersButton.backgroundColor = UIColor.pink
        imageView.image = Filter().processPixels(in: image) { pixelBuffer, offset,_,_ in
            let avgColor = pixelBuffer[offset].redComponent/3 + pixelBuffer[offset].greenComponent/3 + pixelBuffer[offset].blueComponent/3
            pixelBuffer[offset] = Filter.RGBA32(red: avgColor, green: avgColor, blue: avgColor, alpha: 255)
        }
    }
    
    @IBAction func binaryButtonPressed(_ sender: UIButton) {
        originalButton.backgroundColor = UIColor.pink
        grayscaleButton.backgroundColor = UIColor.pink
        binaryButton.backgroundColor = UIColor.white
        bordersButton.backgroundColor = UIColor.pink
        imageView.image = Filter().processPixels(in: image) { pixelBuffer, offset,_,_ in
            if pixelBuffer[offset].color > UInt32.max/3*2 {
                pixelBuffer[offset] = Filter.RGBA32.white
            } else {
                pixelBuffer[offset] = Filter.RGBA32.black
            }
        }
    }
    
    @IBAction func bordersButton(_ sender: UIButton) {
        originalButton.backgroundColor = UIColor.pink
        grayscaleButton.backgroundColor = UIColor.pink
        binaryButton.backgroundColor = UIColor.pink
        bordersButton.backgroundColor = UIColor.white
        imageView.image = Filter().borders(in: image)
    }
    
    @IBAction func funcbackButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}


extension UIColor {
    static let pink = UIColor(red: 224/255.0, green: 177/255.0, blue: 255255/0, alpha: 1)
}
