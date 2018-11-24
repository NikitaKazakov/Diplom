//
//  ViewController.swift
//  tableViewTesting
//
//  Created by Admin on 11/14/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var images = [UIImage?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ImageCell", bundle: nil), forCellReuseIdentifier: "ImageCell")
        tableView.separatorStyle = .none
        calculateImages()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            pixelBuffer[offset] = Filter.RGBA32(red: UInt8(0.299*Double(pixelBuffer[offset].redComponent)), green: UInt8(0.7152*Double(pixelBuffer[offset].greenComponent)),   blue: UInt8(0.114*Double(pixelBuffer[offset].blueComponent)), alpha: 255)
        })
        images.append(Filter().processPixels(in: #imageLiteral(resourceName: "CR3_GettyImages-159018836")) { pixelBuffer, offset,_,_ in
            pixelBuffer[offset] = Filter.RGBA32(red: UInt8(0.2126*Double(pixelBuffer[offset].redComponent)), green: UInt8(0.7152*Double(pixelBuffer[offset].greenComponent)),   blue: UInt8(0.0722*Double(pixelBuffer[offset].blueComponent)), alpha: 255)
        })
        images.append(Filter().processPixels(in: #imageLiteral(resourceName: "CR3_GettyImages-159018836")) { pixelBuffer, offset,_,_ in
            pixelBuffer[offset] = Filter.RGBA32(red: UInt8(0.3*Double(pixelBuffer[offset].redComponent)), green: UInt8(0.59*Double(pixelBuffer[offset].greenComponent)),   blue: UInt8(0.11*Double(pixelBuffer[offset].blueComponent)),   alpha: 255)
        })
        images.append(Filter().processPixels(in: #imageLiteral(resourceName: "CR3_GettyImages-159018836")) { pixelBuffer, offset,_,_ in
            pixelBuffer[offset] = Filter.RGBA32(red: UInt8(0.299*Double(pixelBuffer[offset].redComponent)), green: UInt8(0.587*Double(pixelBuffer[offset].greenComponent)),   blue: UInt8(0.114*Double(pixelBuffer[offset].blueComponent)),   alpha: 255)
        })
        images.append(Filter().processPixels(in: #imageLiteral(resourceName: "CR3_GettyImages-159018836")) { pixelBuffer, offset,_,_ in
            pixelBuffer[offset] = Filter.RGBA32(red: UInt8(0.2126*Double(pixelBuffer[offset].redComponent)), green: UInt8(0.7152*Double(pixelBuffer[offset].greenComponent)),   blue: UInt8(0.0722*Double(pixelBuffer[offset].blueComponent)), alpha: 255)
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
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell") as? ImageCell else { return UITableViewCell() }
        cell.flamingoImageView.image = images[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let storyboard = UIStoryboard(name: "RotateViewController", bundle: nil)
        let storyboard = UIStoryboard(name: "ImageController", bundle: nil)
        guard let vc = storyboard.instantiateInitialViewController() else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
}
