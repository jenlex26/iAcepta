//
//  TransactionDataViewController.swift
//  iAcepta
//
//  Created by iOS_Dev on 2/7/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class TransactionDataViewController: MasterViewController, UITextFieldDelegate {
    
    @IBOutlet var amountTextField: UITextField!
        {didSet{amountTextField.setLayoutFromTextField(textField: amountTextField, type: .inputValue, imageType: .amount)
            amountTextField.addToolbar(textField: amountTextField)
            
        }}
    
    @IBOutlet var tipTextField: UITextField!
        {didSet{tipTextField.setLayoutFromTextField(textField: tipTextField, type: .inputValue, imageType: .amount)}}
    
    @IBOutlet var finalAmountTextField: UITextField!
        {didSet{finalAmountTextField.setLayoutFromTextField(textField: finalAmountTextField, type: .inputValue, imageType: .amount)}}
    
    @IBOutlet var msiTextField: UITextField!
        {didSet{
        msiTextField.setLayoutFromTextField(textField: msiTextField, type: .inputValue, imageType: .disabled)}}
    
    @IBOutlet var referenceTextField: UITextField!
        {didSet{referenceTextField.setLayoutFromTextField(textField: referenceTextField, type: .inputValue, imageType: .disabled)}}
    
    @IBOutlet var emailTextField: UITextField!
        {didSet{emailTextField.setLayoutFromTextField(textField: emailTextField, type: .inputValue, imageType: .disabled)
            emailTextField.addToolbar(textField: emailTextField)
        }}
    
    @IBOutlet var cleanButton: UIButton!{didSet{cleanButton.setRoundedLayout(button: cleanButton)}}
    
    @IBOutlet var readyButton: UIButton!{didSet{readyButton.setRoundedLayout(button: readyButton)}}
    
    @IBOutlet weak var fondoOpacity: UIImageView!
    var txtModel : TransactionModel?


    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var mwiLabel: UILabel!
    @IBOutlet weak var referenceLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var btnCircle: CircleMenu!
    @IBOutlet weak var headerIAcepta: headeriAcepta!
    var service = AlertServices()
    var helperExt = HelperExtensions()
    var showAnimation : Bool = false
    var setValues : Bool = false
    var isViewWillAppear:Bool = false
    var newPercent : Double = 0.0
    var percentage : Double = 0.0
    var mangerBluetooth: CBCentralManager!

    
    @IBOutlet weak var scrollTransaction: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textfieldCustom()
        viewControllerSelected = 1
        setHeader()
        validateTextFields()
        amountTextField.delegate = self
        msiTextField.delegate = self
        tipTextField.delegate = self
        emailTextField.delegate = self
        referenceTextField.delegate = self
        finalAmountTextField.delegate = self
        viewSelect = fondoOpacity
        isViewWillAppear = true
        viewControllerSelected = 1
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(tap)
//        amountTextField.addTarget(self, action: #selector(TransactionDataViewController.textFieldDidChangeEdit(_:)), for: UIControl.Event.editingChanged)
        IQKeyboardManager.shared.enable = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isViewWillAppear{
            isViewWillAppear = false
            setAnimationsViews()
            if setValues{
                setValuesTextField()
            }
        }
//        if(txtModel?.mwi == nil){
//            msiTextField.text = nil
//        }
    }
    
    @IBAction func onShowMenu(_ sender: Any) {
        
    }
    
    // Function MARK: Observables
    @IBAction func cleanAction(_ sender: Any) {
        self.clearElements()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        amountTextField.text = amountTextField.text?.replacingOccurrences(of: ",", with: ".")
    }
    
    @objc func textFieldDidChangeEdit(_ textField: UITextField) {
        let amount = String(amountTextField.text ?? "")
        let tips = Double(amount.replacingOccurrences(of: ",", with: "")) ?? 0.0
        let operation:Double = Double((percentage * tips) / 100)
        let total = finalTotal(amountText:textField.text ?? "", tipText:String(operation) ?? "")
        finalAmountTextField.text = helperExt.formatCurrency(format: String(total))
        tipTextField.text = String(operation)
    }

    
    @IBAction func readyAction(_ sender: Any) {
        if validate(amount: amountTextField.text!, email: emailTextField.text!){
            if UserDefaults.standard.string(forKey: "TYPEREADER") == "WISEPAD"{
                mangerBluetooth = CBCentralManager(delegate: self, queue: nil)
            }else{
                nextViewController()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
         return true
    }
    func nextViewController(){
        var txrMwi = msiTextField.text!
        if (txrMwi.isEmpty){
            txrMwi = "0"
        }
        var txrReference = referenceTextField.text!
        if (txrReference.isEmpty){
            txrReference = ""
        }
        
        modelGlob.Static.txrModel = TransactionModel(amount: amountTextField.text!, tip: tipTextField.text!, total: finalAmountTextField.text!, mwi: txrMwi, reference: txrReference, email: emailTextField.text!, tipPercentage: String(newPercent))
        recordStartTransaction(title: "transaction",type: typeTransaction.SELL.stringValue)
        self.performSegue(withIdentifier: "toCardReader", sender: nil)
        
    }
    
    //Functions Mark: Header
    func setHeader(){
        headerIAcepta.lblTitle.text = "titleHeaderPayment".localized
        headerIAcepta.delegate = self
        if setValues{
            headerIAcepta.btnHome.isHidden = true
            headerIAcepta.btnInfo.isHidden = true
            btnCircle.isHidden = true
        }else{
            headerIAcepta.btnHome.isHidden = false
            headerIAcepta.btnInfo.isHidden = false
            btnCircle.isHidden = false
        }
    }
    //Functions Mark:
    func setAnimationsViews(){
        if (!showAnimation) {
            helperExt.setAnimation(textfiel: amountTextField, view: view, timeDuration: 0.4)
            helperExt.setAnimation(textfiel: tipTextField, view: view, timeDuration: 0.6)
            helperExt.setAnimation(textfiel: finalAmountTextField, view: view, timeDuration: 0.8)
            helperExt.setAnimation(textfiel: msiTextField, view: view, timeDuration: 0.4)
            helperExt.setAnimation(textfiel: referenceTextField, view: view, timeDuration: 0.6)
            helperExt.setAnimation(textfiel: emailTextField, view: view, timeDuration: 0.8)
            
            helperExt.setAnimation(label: amountLabel, view: view, timeDuration: 0.8)
            helperExt.setAnimation(label: tipLabel, view: view, timeDuration: 0.8)
            helperExt.setAnimation(label: totalLabel, view: view, timeDuration: 0.8)
            helperExt.setAnimation(label: mwiLabel, view: view, timeDuration: 0.8)
            helperExt.setAnimation(label: referenceLabel, view: view, timeDuration: 0.8)
            helperExt.setAnimation(label: emailLabel, view: view, timeDuration: 0.8)
            
            helperExt.setAnimation(button: readyButton, view: view, timeDuration: 0.8)
            helperExt.setAnimation(button: cleanButton, view: view, timeDuration: 0.8)
            showAnimation = true
        }
    }
    
    func textfieldCustom(){
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 50
        IQKeyboardManager.shared.toolbarPreviousBarButtonItemText = "Anterior"
        IQKeyboardManager.shared.toolbarNextBarButtonItemText = "Continuar"
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = ""
        IQKeyboardManager.shared.toolbarManageBehaviour = .byTag
  
    }
    
    func validateTextFields(){
        let canTip = sessionGlob.Static.sessionIAcepta?.canAcceptTip ?? false
        let canMwi = sessionGlob.Static.sessionIAcepta?.rangeMsi ?? []
        if !canTip{
            tipTextField.alpha = 0.5
            tipTextField.isEnabled = false
        }
        if (canMwi.count <= 0){
            msiTextField.alpha = 0.5
            msiTextField.isEnabled = false
        }
    }
    
    func validate (amount:String, email:String) -> Bool{
        var textValidate:String = ""
        
        if (amount.count <= 0){
            textValidate = String(format: "%@%@", textValidate, "validate_amount_transactions".localized)
        }
        if (amount == "0.00")||(amount == "0.0"){
            textValidate = String(format: "%@\n%@", textValidate, "validate_amount_transactions".localized)
        }
        
        if (email.isEmpty){
            textValidate = String(format: "%@\n%@", textValidate, "validate_email_transactions".localized)
        }
        
        if textValidate.count >= 1{
            alert(alertTitle: "title_alert_incomplete_data_transactions".localized, message: textValidate, alertBtnFirst: "btn_continue".localized, completion: {
                self.dismiss(animated: true, completion: nil)
            })
            return false
        }
        
        if !helperExt.isValidateEmail(email: emailTextField.text!){
            alert(alertTitle: "titleAlertiAcepta".localized, message: "validate_invalid_email_transactions".localized, alertBtnFirst: "btn_continue".localized, completion: {
                self.dismiss(animated: true, completion: nil)
            })
            return false
        }
        
        return true
    }
    
    func clearElements(){
        amountTextField.text = ""
        tipTextField.text = ""
        finalAmountTextField.text = ""
        msiTextField.text = ""
        referenceTextField.text = ""
        emailTextField.text = ""
        newPercent = 0.0
        percentage = 0.0
    }
    
    func setValuesTextField(){
        cleanButton.isEnabled = false
        amountTextField.text = modelGlob.Static.txrModel?.amount ?? ""
        amountTextField.isUserInteractionEnabled = false
        tipTextField.text = modelGlob.Static.txrModel?.tip ?? ""
        tipTextField.isUserInteractionEnabled = false
        msiTextField.text = modelGlob.Static.txrModel?.mwi ?? ""
        msiTextField.isUserInteractionEnabled = false
        referenceTextField.text = modelGlob.Static.txrModel?.reference ?? ""
        referenceTextField.isUserInteractionEnabled = false
        emailTextField.text = modelGlob.Static.txrModel?.email ?? ""
        emailTextField.isUserInteractionEnabled = false
        
        
        let getFinalTotal = finalTotal(amountText: helperExt.new(format: amountTextField.text?.replacingOccurrences(of: ",", with: "") ?? ""), tipText: helperExt.new(format: tipTextField.text?.replacingOccurrences(of: ",", with: "") ?? ""))
        finalAmountTextField.text = helperExt.formatCurrency(format: String(getFinalTotal))
    }
    
    //Func MARK: DelegateTextfield
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == emailTextField){
            let scrollPoint : CGPoint = CGPoint.init(x:0, y:50)
            self.scrollTransaction.setContentOffset(scrollPoint, animated: true)
        }
    }
    //aqui
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == emailTextField){
            self.scrollTransaction.setContentOffset(CGPoint.zero, animated: true)
        }else if (textField == amountTextField){
            let amountString = amountTextField.text!.replacingOccurrences(of: ",", with: "")
            let doubleAmount = (amountString == "") ? (0.00) : (Double(amountString))
            let tipString = tipTextField.text!.replacingOccurrences(of: ",", with: "")
            let doubleTip = (tipString == "") ? (0.00) : (Double(tipString))
            let sumsr = (doubleTip! + doubleAmount!)
                if (sumsr == 0.00){
                    amountTextField.text = ""
                }else{
                    let resultAmount = helperExt.formatCurrency(format: String(amountString))
                    if (resultAmount == ".00"){
                        amountTextField.text = ""
                        finalAmountTextField.text = ""
                    }else{
                        amountTextField.text = resultAmount
                    }
                }
            amountTextField.resignFirstResponder()
        }
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        if(textField == amountTextField){
            if range.location == 0 && (string == ".") {
                return false
            }

            let newString = string.replacingOccurrences(of: ",", with: ".")
            let result = NSString(string: textField.text!).replacingCharacters(in: range, with: newString)
            
            if result == ""{
                finalAmountTextField.text = ""
            }
            
            let texBool:Bool = textField.calculateExt(range: range, string: newString)
            if texBool{
                if !result.contains(".") && result.count>10{
                    return false
                }
                if newString == "."{
                    return true
                }
                textField.text = ""
                textField.text  = result
//                    helperExt.new(format: result.replacingOccurrences(of: ",", with: ""))
                if !(newPercent > 0){
                    if tipTextField.text == ""{
                        tipTextField.text = "0.00"
                    }
                    
                    
                    let getFinalTotal = finalTotal(amountText: result, tipText: tipTextField.text!)
                    finalAmountTextField.text = helperExt.formatCurrency(format: String(getFinalTotal))
                    return false
                }else{
                    if amountTextField.text == ""{
                        tipTextField.text = "0.00"
                    }
                    if let floatAmount = Float(result.replacingOccurrences(of: ",", with: "")){
                        let stringText:NSString = result as NSString
                        let separatorRange : NSRange = stringText.range(of: "(?<=[.])\\d*$", options: .regularExpression)
                        if !(separatorRange.location == NSNotFound){
                            if (range.location > (separatorRange.location + 1)){
                                return false
                            }
                        }
                        let amount = String(amountTextField.text ?? "")
                        let tips = Double(amount.replacingOccurrences(of: ",", with: "")) ?? 0.0
                        let operation:Double = Double((percentage * tips) / 100)
                        let total = finalTotal(amountText:textField.text ?? "", tipText:String(operation) ?? "")
                        finalAmountTextField.text = helperExt.formatCurrency(format: String(total))
                        tipTextField.text = String(operation)
//                        let valueTipTextfield = helperExt.getPercentage(amount: floatAmount, percentage: Float(newPercent))
//                        tipTextField.text = helperExt.formatCurrency(format: String(valueTipTextfield.replacingOccurrences(of: ",", with: "")))
                        let getFinalTotal = finalTotal(amountText: String(floatAmount), tipText: tipTextField.text!)
                        finalAmountTextField.text = helperExt.new(format: String(getFinalTotal))
                    }
                    return false
                }
            }else{
                if (textField.text!.contains(".")){
                    return false
                }
                if newString == "."{
                    let resultTextfield = String(format: "%@%@", textField.text! , newString)
                    textField.text = resultTextfield
                    return false
                }
                return texBool
            }
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == msiTextField){
            let alertVC = service.alertMonths(title: "titleAlertPayments".localized, body: "bodyAlertPayments".localized, titleBtn: "txt_continue".localized, txtSelect: Constants.mounthsWithoutInterest)
            alertVC.delegateMoths = self
            if let percent = Double(msiTextField.text!){
                if percent != 0.0 {
                    alertVC.roudedPercent = percent
                }
            }
            present(alertVC, animated: true, completion: nil)
            return false
        }else if(textField == tipTextField){
            if (amountTextField.text!.count <= 0){
                alert(alertTitle: "title_alert_incomplete_data_transactions".localized, message: "validate_amount_transactions".localized, alertBtnFirst: "btn_continue".localized, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
            }else{
                let alertVC = service.alertMonths(title: "titleAlertTip".localized, body: "bodyAlertTip".localized, titleBtn: "txt_continue".localized, txtSelect: Constants.tip)
                alertVC.amount = amountTextField.text!
                if let percent = Double(tipTextField.text!.replacingOccurrences(of: ",", with: "")){
                    if percent != 0.0{
                        alertVC.roudedPercent = percent
                    }
                }
                alertVC.delegateMoths = self
                present(alertVC, animated: true, completion: nil)
            }
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
    func finalTotal(amountText:String, tipText:String) -> Double{
        var total:Double = 0.00
        if !amountText.hasPrefix("."){
            let amountString = amountText.replacingOccurrences(of: ",", with: "")
            let doubleAmount = (amountString == "") ? (0.00) : (Double(amountString))
            let tipString = tipText.replacingOccurrences(of: ",", with: "")
            let doubleTip = (tipString == "") ? (0.00) : (Double(tipString))
            total = (doubleTip! + doubleAmount!)
        }
        return total
    }
    
    
    
    
    func setEnabled(){
        amountTextField.isEnabled = false
        tipTextField.isEnabled = false
        msiTextField.isEnabled = false
        referenceTextField.isEnabled = false
        emailTextField.isEnabled = false
        cleanButton.isEnabled = false
        readyButton.isEnabled = false
        
    }
    
    func setNotEnabled(){
        amountTextField.isEnabled = true
        referenceTextField.isEnabled = true
        emailTextField.isEnabled = true
        cleanButton.isEnabled = true
        readyButton.isEnabled = true
        tipTextField.isEnabled = true
        msiTextField.isEnabled = true
        validateTextFields()
    }
    
    //Mark: Segue Return
    @IBAction func unwindToTransactionData(segue:UIStoryboardSegue) { }

}

extension TransactionDataViewController: selectMonthsDelegate {
    func changeValues(value: Double, txtSelect: String, calculeTip: Bool, porcent: Double) {
        if (txtSelect == Constants.mounthsWithoutInterest){
            if value == 0{
                msiTextField.text = ""
            }else{
                msiTextField.text = "\(Int(value))"
            }
        }else if (txtSelect == Constants.tip){
            percentage = porcent
            newPercent = Double(value)
            let amountValue = amountTextField.text!.replacingOccurrences(of: ",", with: "")
            if let floatAmount = Float(amountValue){
                if calculeTip == true{
                    tipTextField.text = helperExt.formatCurrency(format: String(value))
                    
                    let total = finalTotal(amountText:String(floatAmount), tipText:tipTextField.text!)
                    finalAmountTextField.text = helperExt.formatCurrency(format: String(total))
                }else{
                    let tipValue = helperExt.getPercentage(amount: floatAmount, percentage: Float(value))
                    tipTextField.text = helperExt.formatCurrency(format: tipValue)
                    let total = floatAmount + Float(tipTextField.text!)!
                    finalAmountTextField.text = helperExt.formatCurrency(format: String(total))
                }
            }
        }
    }
}
extension TransactionDataViewController:headerActoionDelegate{
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
        alertVC.contentName = "TransactionData"
        present(alertVC, animated: true, completion: nil)
    }
}
extension TransactionDataViewController:CBCentralManagerDelegate{
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        mangerBluetooth = nil
        switch (central.state) {
        case .poweredOn:
            self.nextViewController()
        default:
            alert(alertTitle: "iAcepta", message: "Bluetooth apagado.", alertBtnFirst: "Aceptar", completion: {
                self.dismiss(animated: true, completion: nil)
            })
            break;
        }
    }
}
