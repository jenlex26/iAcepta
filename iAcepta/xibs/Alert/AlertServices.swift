//
//  AlertServices.swift
//  iAcepta
//
//  Created by QUALITY on 5/24/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import UIKit

class AlertServices{
    func alertMonths(title:String, body:String, titleBtn:String, txtSelect:String) -> AlertSelectMonths {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier:"AlertSelectMonths") as! AlertSelectMonths
        alertVC.alertTitle = title
        alertVC.alertBody = body
        alertVC.alertBtnTitle = titleBtn
        alertVC.typeActionBnt = txtSelect
        return alertVC
    }
    func alert(alertTitle:String, message:String, alertBtnFirst:String, completion: @escaping() -> Void) -> AlertViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier:"AlertVC") as! AlertViewController
        alertVC.alertTitle = alertTitle
        alertVC.alertBody = message
        alertVC.alertBtnTitle = alertBtnFirst
        alertVC.btnActionAcept = completion
        return alertVC
    }
}
