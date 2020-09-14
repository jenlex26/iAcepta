//
//  AlertViewController.swift
//  iAcepta
//
//  Created by QUALITY on 5/24/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import UIKit

class AlertViewController: UIViewController {
    
    @IBOutlet weak var titleAlert: UILabel!
    @IBOutlet weak var bodyAlert: UILabel!
    @IBOutlet weak var btnTitleAlert: UIButton!{didSet{btnTitleAlert.setRoundedLayout(button: btnTitleAlert)}}
    
    @IBOutlet weak var viewAlert: UIView!
    
    var alertTitle = String()
    var alertBody = String()
    var alertBtnTitle = String()
    var typeActionBnt = String()
    var btnActionAcept : (()->Void)?
    
    @IBOutlet weak var constraint: NSLayoutConstraint!
    @IBOutlet weak var constraintWidth: NSLayoutConstraint!
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleAlert.text = alertTitle
        bodyAlert.text = alertBody
        bodyAlert.adjustsFontSizeToFitWidth = true
        bodyAlert.sizeToFit()
        btnTitleAlert.setTitle(alertBtnTitle, for: .normal)
        viewAlert.layer.cornerRadius = 30
        if (UIDevice.current.userInterfaceIdiom == .pad){
            isiPad()
        }
    }
    
    func isiPad(){
        DispatchQueue.main.async {
            self.constraint.constant = 100
            self.constraintHeight.constant = 200
            self.constraintWidth.constant = 300
            self.titleAlert.font = self.titleAlert.font.withSize(24)
            self.bodyAlert.font = self.bodyAlert.font.withSize(22)
            self.btnTitleAlert.titleLabel?.font =
                self.btnTitleAlert.titleLabel?.font.withSize(28)
            self.viewAlert.layoutIfNeeded()
        }
    }
    
    @IBAction func btnAcept(_ sender: Any) {
        btnActionAcept?()
    }
    
}
