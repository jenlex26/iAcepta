//
//  tutorialViewController.swift
//  iAcepta
//
//  Created by QUALITY on 10/18/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import UIKit

class tutorialViewController: UIViewController {

    @IBOutlet weak var gif: UIImageView!
    
    var viewControllerSelected : Int?
    var setValues:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let jeremyGif = UIImage.gifImageWithName("tutorial")
        gif.image = jeremyGif
    }

    @IBAction func dismissButton(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToStar", sender: self)
    }
}
