//
//  loaderViewController.swift
//  iAcepta
//
//  Created by QUALITY on 26/02/20.
//  Copyright © 2020 Quality & Knowledge. All rights reserved.
//

import UIKit
import Lottie

class loaderViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        star()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        image.stopAnimating()
    }

    func star(){
            var imgArray:[UIImage] = []
            if let nameImg = UIImage(named: "loader_ft1"){
                imgArray.append(nameImg)
            }
            if let nameImg2 = UIImage(named: "loader_ft2"){
                imgArray.append(nameImg2)
            }
            if let nameImg3 = UIImage(named: "loader_ft3"){
                imgArray.append(nameImg3)
            }
            if let nameImg4 = UIImage(named: "loader_ft4"){
                imgArray.append(nameImg4)
            }
            if let nameImg5 = UIImage(named: "loader_ft5"){
                imgArray.append(nameImg5)
            }
            if let nameImg6 = UIImage(named: "loader_ft6"){
                imgArray.append(nameImg6)
            }
            if let nameImg7 = UIImage(named: "loader_ft7"){
                imgArray.append(nameImg7)
            }
            image.animationImages = imgArray
            image.animationDuration = 0.75
            image.startAnimating()
        
         }
}


