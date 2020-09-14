//
//  AlertTwoOptions.swift
//  iAcepta
//
//  Created by QUALITY on 7/23/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import UIKit

class AlertTwoOptions: UIViewController {
    
    @IBOutlet weak var viewAlert: UIView!
    @IBOutlet weak var titleAlert: UILabel!
    @IBOutlet weak var bodyAlert: UILabel!
    @IBOutlet weak var btnCancel: UIButton!{didSet{btnCancel.setRoundedLayout(button: btnCancel)}}
    @IBOutlet weak var btnAcept: UIButton!{didSet{btnAcept.setRoundedLayout(button: btnAcept)}}
    
    @IBOutlet weak var constraintButton: NSLayoutConstraint!
    @IBOutlet weak var constraint: NSLayoutConstraint!

    var btnActionAcept : (()->Void)?
    var btnActionCancel : (()->Void)?
    
    var alertTitle = String()
    var alertBody = String()
    var titleBtnFirst = String()
    var titleBtnSecond = String()
    
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintWidth: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleAlert.text = alertTitle
        bodyAlert.text =  alertBody
        bodyAlert.adjustsFontSizeToFitWidth = true
        bodyAlert.sizeToFit()
        btnAcept.setTitle(titleBtnFirst, for: .normal)
        btnCancel.setTitle(titleBtnSecond, for: .normal)
        viewAlert.layer.cornerRadius = 30
        if (UIDevice.current.userInterfaceIdiom == .pad){
            isiPad()
        }
    }
    
    func isiPad(){
        DispatchQueue.main.async {
            self.constraintButton.constant = 120
            self.constraint.constant = 120
            self.constraintHeight.constant = 250
            self.constraintWidth.constant = 400
            self.titleAlert.font = self.titleAlert.font.withSize(24)
            self.bodyAlert.font = self.bodyAlert.font.withSize(22)
            self.btnAcept.titleLabel?.font =
                self.btnAcept.titleLabel?.font.withSize(28)
            self.btnCancel.titleLabel?.font =
                self.btnCancel.titleLabel?.font.withSize(28)
            self.viewAlert.layoutIfNeeded()
        }
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        btnActionCancel?()
    }
    
    @IBAction func btnAcept(_ sender: Any) {
        btnActionAcept?()
    }
    
}
