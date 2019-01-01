//
//  ViewController.swift
//  tableViewTesting
//
//  Created by Admin on 11/14/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var choosePhotoFromGalleryButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    
    var images = [UIImage?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculateImages()
        choosePhotoFromGalleryButton.layer.cornerRadius = 8
        takePhotoButton.layer.cornerRadius = 8
        navigationController?.navigationBar.isHidden = true
    }
    
    func calculateImages() {
        images.append(Filter().processPixels(in: #imageLiteral(resourceName: "CR3_GettyImages-159018836")) { pixelBuffer, offset,_,_ in
            if pixelBuffer[offset].color > UInt32.max/3*2 {
                pixelBuffer[offset] = Filter.RGBA32.white
            } else {
                pixelBuffer[offset] = Filter.RGBA32.black
            }
        })
        images.append(Filter().processPixels(in: #imageLiteral(resourceName: "CR3_GettyImages-159018836")) { pixelBuffer, offset,_,_ in
            let avgColor = pixelBuffer[offset].redComponent/3 + pixelBuffer[offset].greenComponent/3 + pixelBuffer[offset].blueComponent/3
            pixelBuffer[offset] = Filter.RGBA32(red: avgColor, green: avgColor, blue: avgColor, alpha: 255)
        })
        images.append(Filter().processPixels(in: #imageLiteral(resourceName: "CR3_GettyImages-159018836")) { pixelBuffer, offset,row,column in
            let n: UInt32 = 20
            var E: UInt32 = 0
            for i in 0..<n/2 {
                for j in 0..<n/2 {
                    E += pixelBuffer[offset].color/n/n
                }
            }
            pixelBuffer[offset] = Filter.RGBA32(red: UInt8(0.2126*Double(pixelBuffer[offset].redComponent)), green: UInt8(0.7152*Double(pixelBuffer[offset].greenComponent)),   blue: UInt8(0.0722*Double(pixelBuffer[offset].blueComponent)), alpha: 255)
        })
    }
    @IBAction func choosePhotoFromGalleryButtonPressed(_ sender: UIButton) {
        let vc = ImagePickerViewController()
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func takePhotoButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Camera", bundle: nil)
        guard let vc = storyboard.instantiateInitialViewController() as? CameraViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
}
