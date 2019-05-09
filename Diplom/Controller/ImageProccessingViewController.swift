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
    @IBOutlet weak var histogramButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage!
    var x: [Int]!
    var y: [YValues]!
    
    private lazy var images: [String : UIImage] = [originalButton.description : image]
    
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
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
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
        if let image = images[sender.description] {
            imageView.image = image
        } else {
            images[sender.description] = Filter().grayscale(image: image)
            imageView.image = images[sender.description]
        }
    }
    
    @IBAction func binaryButtonPressed(_ sender: UIButton) {
        originalButton.backgroundColor = UIColor.pink
        grayscaleButton.backgroundColor = UIColor.pink
        binaryButton.backgroundColor = UIColor.white
        bordersButton.backgroundColor = UIColor.pink
        if let image = images[sender.description] {
            imageView.image = image
        } else {
            images[sender.description] = Filter().binary(image: image)
            imageView.image = images[sender.description]
        }
    }
    
    @IBAction func bordersButton(_ sender: UIButton) {
        originalButton.backgroundColor = UIColor.pink
        grayscaleButton.backgroundColor = UIColor.pink
        binaryButton.backgroundColor = UIColor.pink
        bordersButton.backgroundColor = UIColor.white
        if let image = images[sender.description] {
            imageView.image = image
        } else {
            images[sender.description] = Filter().borders(in: image)
            imageView.image = images[sender.description]
        }
    }
    @IBAction func histogramButtonPressed(_ sender: UIButton) {
        let view = UINib(nibName: "GraphCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! GraphCell
        self.view.addSubview(view)
        view.frame = imageView.frame
        view.isUserInteractionEnabled = true
        if x != nil, y != nil {
            view.graphView.subModel = SubModel(x: x, y: y)
            view.smallGraphView.subModel = SubModel(x: x, y: y)
        } else {
            guard let array = Filter().histogram(image: image) else {
                return
            }
            
            var x = [Int]()
            (0..<256).forEach { x.append($0) }
            let y = YValues(color: "#F34C44", name: "histogram", data: array)
            view.graphView.subModel =  SubModel(x: x, y: [y])
            view.smallGraphView.subModel = SubModel(x: x, y: [y])
            self.x = x
            self.y = [y]
        }
    }
}


extension UIColor {
    static let pink = UIColor(red: 224/255.0, green: 177/255.0, blue: 255/255.0, alpha: 1)
}
