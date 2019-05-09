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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        choosePhotoFromGalleryButton.layer.cornerRadius = 8
        takePhotoButton.layer.cornerRadius = 8
        navigationController?.navigationBar.isHidden = true
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
