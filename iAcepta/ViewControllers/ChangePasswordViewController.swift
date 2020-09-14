//
//  ChangePasswordViewController.swift
//  iAcepta
//
//  Created by QUALITY on 5/27/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import UIKit

class ChangePasswordViewController: MasterViewController {
    @IBOutlet weak var currentPasswordTextfield: UITextField!{didSet{currentPasswordTextfield.setCornerRadious(textfield: currentPasswordTextfield)}}
    @IBOutlet weak var newPasswordTextfield: UITextField!{didSet{newPasswordTextfield.setCornerRadious(textfield: newPasswordTextfield)}}
    @IBOutlet weak var repeatPasswordTextfield: UITextField!{didSet{repeatPasswordTextfield.setCornerRadious(textfield: repeatPasswordTextfield)}}
    @IBOutlet weak var firstDescriptionPassword: UILabel!{didSet{firstDescriptionPassword.labelSize(label: firstDescriptionPassword, lblText: "firstDescriptionPassword", lblSize: 13, nameFont: "Roboto-Light")}}
    @IBOutlet weak var secondDescriptionPassword: UILabel!{didSet{secondDescriptionPassword.labelSize(label: secondDescriptionPassword, lblText: "secondDescriptionPassword", lblSize: 13, nameFont: "Roboto-Light")}}
    @IBOutlet weak var thirdDescriptionPassword: UILabel!{didSet{thirdDescriptionPassword.labelSize(label: thirdDescriptionPassword, lblText: "thirdDescriptionPassword", lblSize: 13, nameFont: "Roboto-Light")}}
    
    @IBOutlet weak var updatePassword: UIButton!{didSet{updatePassword.setRoundedLayout(button: updatePassword)}}
    
    
    @IBOutlet weak var headeriAcepta: headeriAcepta!
    
    let loginLogic = LoginLogic()
    var showAlert : Bool = false
    var user:String = ""
    let color:Double = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headeriAcepta.lblTitle.text = ""
        headeriAcepta.btnHome.isHidden = true;
        headeriAcepta.btnInfo.isHidden = true;
        
        loginLogic.delegateChangePassword = self
        updateLabels()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //alertViewShow()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /*@objc func DismissKeyboard(){
        view.endEditing(true)
    }*/
    
    @IBAction func btnAceptAction(_ sender: Any) {
        let defaults = UserDefaults.standard
        let user = defaults.string(forKey: "user")!
        if  (validateParameters(currentPassword: currentPasswordTextfield.text!, newPassword: newPasswordTextfield.text!, repeatPassword: repeatPasswordTextfield.text!)){
            if reachable(){
                loginLogic.changePasswordRequest(user, currentPasswordTextfield.text!, newPasswordTextfield.text!)
            }else{
                changePasswordResponse(changePasswordResponseType.NO_CONNECTION)
            }
        }
    }
    
    func validateParameters(currentPassword:String, newPassword:String, repeatPassword:String) -> Bool {
        if (currentPassword.isEmpty)||(newPassword.isEmpty)||(repeatPassword.isEmpty){
            changePasswordResponse(changePasswordResponseType.EMPTY_FORMAT)
            return false
        }else if (newPassword != repeatPassword){
            changePasswordResponse(changePasswordResponseType.DIFF_NEW_PASSWORD)
            return false
        }
        return true
    }
    func updateLabels(){
        currentPasswordTextfield.attributedPlaceholder = NSAttributedString(string: "currentPasword".localized, attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: CGFloat(color), green: CGFloat(color), blue: CGFloat(color), alpha: 0.5)])
        newPasswordTextfield.attributedPlaceholder = NSAttributedString(string: "newPassword".localized, attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: CGFloat(color), green: CGFloat(color), blue: CGFloat(color), alpha: 0.5)])
        repeatPasswordTextfield.attributedPlaceholder = NSAttributedString(string: "repeatNewPassword".localized, attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: CGFloat(color), green: CGFloat(color), blue: CGFloat(color), alpha: 0.5)])
        updatePassword.setAttributedTitle(HelperExtensions().setFontText(string: "updatePassword_TitleBtn", color: "#ffffff", nameFont: "Roboto", sizeFont: 20.0), for: .normal)
    }
    
}

extension ChangePasswordViewController:ChangePasswordDelegate{
    func changePasswordResponse(_ responseType: changePasswordResponseType) {
        switch responseType {
        case .UPDATE_PASSWORD:
            alertServicesLogin(alertTitle: "titleAlertiAcepta".localized, message: "body_password_update".localized, alertBtnFirst: "titleBtnAlert_Accept".localized, completion: {
                self.dismiss(animated: true, completion: {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    if let viewControllers = appDelegate.window?.rootViewController?.presentedViewController{
                        viewControllers.dismiss(animated: false, completion: nil)
                    }
                })
            })
            break
        case .NOT_SECURITY_PASSWORD:
            alertServicesLogin(alertTitle: "titleAlertiAcepta".localized, message: "body_password_not_secutiry".localized, alertBtnFirst: "titleBtnAlert_Accept".localized, completion: {
                self.dismiss(animated: true, completion: nil)
            })
            break
        case .VERYFY_PASSWORD:
            alertServicesLogin(alertTitle: "titleAlertTemporalPassword".localized, message: "body_very_password".localized, alertBtnFirst: "titleBtnAlert_Accept".localized, completion: {
                self.dismiss(animated: true, completion: nil)
            })
            break
        case .EMPTY_FORMAT:
            alertServicesLogin(alertTitle: "titleAlertiAcepta".localized, message: "body_empety_form".localized, alertBtnFirst: "titleBtnAlert_Accept".localized, completion: {
                self.dismiss(animated: true, completion: nil)
            })
            break
        case .NO_CONNECTION:
            alertServicesLogin(alertTitle: "titleAlertWithoutConnection".localized, message: "bodyAlertWithoutConnection".localized, alertBtnFirst: "titleBtnAlert_Accept".localized, completion: {
                self.dismiss(animated: true, completion: nil)
            })
            break
        case .DIFF_NEW_PASSWORD:
            alertServicesLogin(alertTitle: "titleAlertiAcepta".localized, message: "body_diff_new_password".localized, alertBtnFirst: "titleBtnAlert_Accept".localized, completion: {
                self.dismiss(animated: true, completion: nil)
            })
            break
        default:
            break
        }
    }
}
