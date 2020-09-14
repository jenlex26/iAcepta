//
//  detailPaymentViewController.swift
//  iAcepta
//
//  Created by QUALITY on 13/02/20.
//  Copyright © 2020 Quality & Knowledge. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
//import Unrealm



//struct parameterServiceQR{
//    var serviceRespose = codiWalletResquest()
//    var identidification = ""
//    var amount = ""
//    var email = ""
//    var reference = ""
//}


class detailPaymentViewController: MasterViewController, UITextFieldDelegate {
    @IBOutlet weak var headeriAcepta: headeriAcepta!
    @IBOutlet weak var labelDisplay: UILabel!
    @IBOutlet weak var amountTextField: UITextField!{didSet{amountTextField.setLayoutFromTextField(textField: amountTextField, type: .inputValue, imageType: .amount)
        }}
    @IBOutlet weak var referenceTextField: UITextField!{didSet{referenceTextField.setLayoutFromTextField(textField: referenceTextField, type: .inputValue, imageType: .disabled)}}
    @IBOutlet weak var emailTextField: UITextField!{didSet{emailTextField.setLayoutFromTextField(textField: emailTextField, type: .inputValue, imageType: .disabled)
        emailTextField.addToolbar(textField: emailTextField)
    }}
    @IBOutlet weak var cleanButton: UIButton!{didSet{cleanButton.setRoundedLayout(button: cleanButton)}}
    @IBOutlet weak var continueButton: UIButton!{didSet{continueButton.setRoundedLayout(button: continueButton)}}
    
    @IBOutlet weak var btnCircle: CircleMenu!
    
    var identificationService: String = ""
    var QRData = ""
    var timeData = ""
    var serviceRespose = codiWalletResquest()
//    var service = parameterServiceQR()
    var setValues:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllerSelected = 0
        amountTextField.delegate = self
        emailTextField.delegate = self
        referenceTextField.delegate = self
        headeriAcepta.delegate = self
        headeriAcepta.lblTitle.text = "CoDi"
        headeriAcepta.constraintCenter.constant = 0
        headeriAcepta.btnHome.isHidden = false
        headeriAcepta.btnInfo.isHidden = true
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 50
        IQKeyboardManager.shared.toolbarPreviousBarButtonItemText = "Anterior"
        IQKeyboardManager.shared.toolbarNextBarButtonItemText = "Continuar"
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = ""
        self.hideKeyboardWhenTappedAround()
    }
    

    //MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toQR"{
            if let destinationVC = segue.destination as? generateCodeQR{
                destinationVC.modelResponse = serviceRespose
            }
        }
        
        if segue.identifier == "menu"{
                    viewControllerSelected = nil
                }
                if segue.identifier == "toCancellation"{
                    if let destinationVC = segue.destination as? CancellationViewController {
                        destinationVC.setValues = false
                        destinationVC.viewControllerSelected = Int(truncating: sender as! NSNumber)
                        destinationVC.viewSelectedBefore = viewSelectedBefore
                    }
                }
                if segue.identifier == "setValuesToCancellation"{
                    if let destinationVC = segue.destination as? CancellationViewController {
                        destinationVC.setValues = true
                        if typeTransfers == "Cancelacion"{
                            destinationVC.viewControllerSelected = 2
                        }else if typeTransfers == "Devolucion"{
                            destinationVC.viewControllerSelected = 3
                        }
                    }
                }
                if segue.identifier == "setValuesToPay"{
                    if let destinationVC = segue.destination as? TransactionDataViewController {
                        destinationVC.setValues = true
                    }
                }
                if segue.identifier == "toPayments"{
                    if let destinationVC = segue.destination as? TransactionDataViewController {
                        destinationVC.viewControllerSelected = 1
                        destinationVC.setValues = false
                    }
                }
                if segue.identifier == "toHistoryWeb"{
                    if let destination = segue.destination as? HistoryWebViewController{
                        destination.viewControllerSelected = 4
                    }
                }
                if segue.identifier == "toTutorial"{
                    if let destinationVC = segue.destination as? splashCodiViewController {
                        destinationVC.viewControllerSelected = 0
        //                destinationVC.setValues = false
                    }
                }
    }
    
    
    @IBAction func continueButton(_ sender: Any) {
        if amountTextField.text!.count>0 {
            let amount = amountTextField.text?.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: "")
            let email  = emailTextField.text ?? ""
            let reference = referenceTextField.text ?? ""
            self.present(self.vc, animated: true) {
                CodiPresenter.walletRequest(.firstAttempt, self.identificationService, "", amount!, email,reference) { (result) in
                    self.vc.dismiss(animated: true) {
                        switch result {
                        case .success(let success):
                            self.labelDisplay.text = success?.walletsRequest?.displayResponseMessage
                            self.serviceRespose = success!
                            self.serviceRespose.reference = reference
                            self.serviceRespose.email = email
                            self.serviceRespose.amount = amount!
                            self.serviceRespose.identidification = self.identificationService
                            DBManagerVoucher.sharedInstance.addDataCodi(object: self.serviceRespose)
                            self.performSegue(withIdentifier: "toQR", sender: self)
                            break
                        case .failure(let fail):
                            debugPrint(fail)
                            self.alertServicesLogin(alertTitle: "titleAlertiAcepta".localized, message: fail.content.reason, alertBtnFirst: "titleBtnAlert_Accept".localized, completion: {
                                self.dismiss(animated: true, completion: nil)
                            })
                            break
                        }
                    }
                }
            }
        }else{
            self.alertServicesLogin(alertTitle: "titleAlertiAcepta".localized, message: "Ingresa un monto", alertBtnFirst: "titleBtnAlert_Accept".localized, completion: {
                self.dismiss(animated: true, completion: nil)
            })
            
        }
        
    }
    
    @IBAction func clearButton(_ sender: Any) {
        amountTextField.text = ""
        referenceTextField.text = ""
        emailTextField.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
            if (textField == amountTextField){
            let amountString = amountTextField.text!.replacingOccurrences(of: ",", with: "")
            let doubleAmount = (amountString == "") ? (0.00) : (Double(amountString))
            
                    let resultAmount = HelperExtensions().formatCurrency(format: String(amountString))
                    if (resultAmount == ".00"){
                        amountTextField.text = ""
                    }else{
                        amountTextField.text = resultAmount
                    }
                }
            amountTextField.resignFirstResponder()
        }
    }


extension detailPaymentViewController:headerActoionDelegate{
    func btnHome() {
        alertTwoOp(alertTitle: "title_alert_returnMenu_closeSession".localized, message: "body_alert_returnMenu_closeSession".localized, alertBtnFirst: "firtsBtn_alert_returnMenu_closeSession".localized, alertBtnSecond: "secondBtn_alert_returnMenu_closeSession".localized, completion: {
            self.dismiss(animated: true, completion: {
                self.performSegue(withIdentifier: "unwindToStar", sender: self)
            })
        }) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    func btnInfo() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier:"infoHelp") as! InformationHelpViewController
        present(alertVC, animated: true, completion: nil)
    }
}
