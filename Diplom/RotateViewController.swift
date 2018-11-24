//
//  RotateViewController.swift
//  tableViewTesting
//
//  Created by Admin on 11/16/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import UIKit


class RotateViewController: UIViewController {
    
    @IBOutlet weak var rotatedView: UIView!
    @IBOutlet weak var rotateButton: UIButton!
    
    var isRotate: Bool = false {
        didSet{
            if isRotate {
                rotateButton.setTitle("Stop", for: .normal)
            } else {
                rotateButton.setTitle("Start", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func rotateButtonPressed(_ sender: UIButton) {
        if isRotate {
            rotatedView.layer.removeAllAnimations()
            rotatedView.transform = CGAffineTransform.identity
            isRotate = false
        } else {
            UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .curveLinear], animations: {
                
                self.rotatedView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                
            }, completion: nil )
            isRotate = true
        }
    }
    
}
