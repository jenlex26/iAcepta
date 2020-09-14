//
//  ConfirmationWisepadButton.swift
//  iAcepta
//
//  Created by QUALITY on 10/3/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import UIKit

class ConfirmationWisepadButton: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var wisepadButton: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        startLoaderWisepad(image: wisepadButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("ConfirmationWisepadButton", owner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func startLoaderWisepad(image: UIImageView){
        var imgArray:[UIImage] = []
        if let nameImg = UIImage(named: "wisepadConfirmAmountTwo"){
            imgArray.append(nameImg)
        }
        if let nameImg2 = UIImage(named: "wisepad_off"){
            imgArray.append(nameImg2)
        }
        
        image.animationImages = imgArray
        image.animationDuration = 0.75
        image.startAnimating()
    }
    
}
