//
//  LoginViewController.swift
//  iAcepta
//
//  Created by iOS_Dev on 2/1/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class LoginViewController: MasterViewController, UITextFieldDelegate {
    
    @IBOutlet weak var backView: UIImageView!
    @IBOutlet weak var spiner: UIImageView!

    @IBOutlet var usernameTextField: UITextField!{didSet{
        usernameTextField.setLayoutFromTextField(textField: usernameTextField, type: .login, imageType: .username)
        }}
    @IBOutlet var passwordTextField: UITextField!{didSet{
        passwordTextField.setLayoutFromTextField(textField: passwordTextField, type: .login, imageType: .password)
        }}
    @IBOutlet var loginButton: UIButton!{didSet{loginButton.setRoundedLayout(button: loginButton)}}
    @IBOutlet var waitIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollLogin: UIScrollView!
    @IBOutlet weak var btnCheck: UIButton!

    var loginPresenter: LoginPresenter?
    let loginLogic = LoginLogic()
    var update:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.enableAutoToolbar = false
        loginLogic.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        loginPresenter = LoginPresenter(view: self)
        loginPresenter?.getUser(button: btnCheck, textField: usernameTextField)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(tap)
//        spiner.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if !update{
//            loginPresenter?.setAnimationsViews(textfieldUser: usernameTextField, textfieldPass: passwordTextField, button: loginButton,view: view)
//            let alert = UIAlertController(title: "title_alert_update".localized, message: "body_alert_update".localized, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Btn_update".localized, style: .default, handler: { (action) in
//                UIApplication.shared.open(NSURL(string: ConstantsLogin.url_upDate)! as URL)
//            }))
//            
//            self.present(alert, animated: true) {}
//        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //FUNC MARK: Deletegate TextField
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let scrollPoint : CGPoint = CGPoint.init(x:0, y:50)
        self.scrollLogin.setContentOffset(scrollPoint, animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.scrollLogin.setContentOffset(CGPoint.zero, animated: true)
    }
    
    //FUNC MARK: Btn Actions
    @IBAction func loginTaped(_ sender: UIButton) {
        
        #if DEBUG
            usernameTextField.text = "asalazar" 
            passwordTextField.text = "Pruebas04"
        
        #endif
        
        if (usernameTextField.text!.count>0 && passwordTextField.text!.count>0){
            present(vc, animated: true) {
                if self.reachable(){
                    if (self.btnCheck.isSelected){
                        UserDefaults.standard.set(self.usernameTextField.text, forKey: "user")
                    }
                    self.loginLogic.loginRequest(self.usernameTextField.text!, self.passwordTextField.text!)
                }else{
                    self.vc.dismiss(animated: true) {
                        self.loginResponse(LoginResponseType.NO_CONNECTION)
                    }
                }
            }
        }else{
            self.alertServicesLogin(alertTitle: "titleAlertiAcepta".localized, message: "bodyAlertiAcepta".localized, alertBtnFirst: "titleBtnAlert_Accept".localized, completion: {
                self.dismiss(animated: true, completion: nil)
            })
            
        }
    }

    
    //Function MARK: UIIButons
    @IBAction func btnActionInfo(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier:"infoHelp") as! InformationHelpViewController
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func actionSetUser(_ sender: UIButton) {
        loginPresenter?.buttonSet(sender)
    }
}
extension LoginViewController:LoginLogicDelegate{
    func loginResponse(_ responseType: LoginResponseType) {
        let interactor = LoginLogic()
        vc.dismiss(animated: true) {
            switch responseType {
            case .LOGINWASSUCCESS:
                self.loginEvent(title: "login", content: "SUCCESS")
                sessionGlob.Static.sessionIAcepta?.userNameTxt = self.usernameTextField.text!
                self.performSegue(withIdentifier: "menu", sender: self)
                break
            case .UNAUTHORIZED:
                self.alertServicesLogin(alertTitle: "titleAlertiAcepta".localized, message: (interactor.getMessageFromResponseType(responseType)), alertBtnFirst: "titleBtnAlert_Accept".localized, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
                
                break
            case .UNAUTHORIZED_TEMPORAL_PASSWORD:
                let defaults = UserDefaults.standard
                defaults.set(self.usernameTextField.text, forKey: "user")
                self.alertServicesLogin(alertTitle: "titleAlertTemporalPassword".localized, message: (interactor.getMessageFromResponseType(responseType)), alertBtnFirst: "titleBtnAlert_Accept".localized, completion: {
                    self.dismiss(animated: true, completion: {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "ChangePasswordVC")
                        self.present(controller, animated: true, completion:nil)
                    })
                })
                break
            case .NO_CONNECTION:
                self.alertServicesLogin(alertTitle: "titleAlertWithoutConnection".localized, message: "bodyAlertWithoutConnection".localized, alertBtnFirst: "titleBtnAlert_Accept".localized, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
                
                break
            default:
                break
            }
        }
        
    }
}

extension LoginViewController: LoginView {    
    func showProgress() {
        
    }
    
    func hideProgress() {
        
    }

}
