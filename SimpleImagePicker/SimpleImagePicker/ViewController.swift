//
//  ViewController.swift
//  SimpleImagePicker
//
//  Created by Eslam Ali  on 17/09/2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func didTapSelectImageButton(_ sender: Any) {
        
        SimpleImagePicker.shared.pickImage(self) { image in
            self.image.image = image
        }
        
    }
}

