//
//  LoginPresenter.swift
//  iAcepta
//
//  Created by QUALITY on 10/1/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation



protocol LoginView {
    func showProgress()
    func hideProgress()
}

class LoginPresenter {
    
    var showAnimation : Bool = false
    var view: LoginView
    
    init(view: LoginView) {
        self.view = view
        
    }
    
    func getUser(button: UIButton,textField:UITextField){
        let valueUser = UserDefaults.standard.string(forKey: "user")
        if (valueUser != "")&&(valueUser != nil){
            button.isSelected = true
            textField.text = valueUser ?? ""
            button.setImage(UIImage(named: "check_On"), for: .normal)
        }else{
            button.isSelected = false
            textField.text = ""
            button.setImage(UIImage(named: "check_Off"), for: .normal)
        }
    }
    
    func setAnimationsViews(textfieldUser: UITextField, textfieldPass:UITextField,button:UIButton,view:UIView){
        if (!showAnimation) {
            HelperExtensions().setAnimation(textfiel: textfieldUser, view: view, timeDuration: 0.4)
            HelperExtensions().setAnimation(textfiel: textfieldPass, view: view, timeDuration: 0.6)
            HelperExtensions().setAnimation(button: button, view: view, timeDuration: 0.8)
            
            showAnimation = true;
        }
    }
    
    func buttonSet(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
        if (sender.isSelected){
            sender.setImage(UIImage(named: "check_On"), for: .normal)
        }else{
            sender.setImage(UIImage(named: "check_Off"), for: .normal)
            UserDefaults.standard.set("", forKey: "user")
        }
    }

    func performLogin(mail: String, password: String) {

    }
    
    func performForgotPassword(mail: String) {

    }
    
    
}

