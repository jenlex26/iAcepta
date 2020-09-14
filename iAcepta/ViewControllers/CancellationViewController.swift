//
//  CancellationViewController.swift
//  iAcepta
//
//  Created by QUALITY on 5/23/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift

class CancellationViewController: MasterViewController, UITextFieldDelegate {
    
    @IBOutlet weak var cardField: UITextField!{didSet{cardField.setLayoutFromTextField(textField: cardField, type: .inputValue, imageType: .disabled)}}
//    @IBOutlet weak var expField: UITextField!{didSet{expField.setLayoutFromTextField(textField: expField, type: .inputValue, imageType: .disabled)}}
    @IBOutlet weak var autField: UITextField!{didSet{autField.setLayoutFromTextField(textField: autField, type: .inputValue, imageType: .disabled)}}
    @IBOutlet weak var amountField: UITextField!{didSet{amountField.setLayoutFromTextField(textField: amountField, type: .inputValue, imageType: .disabled)}}
    @IBOutlet weak var titleBtn: UIButton!{didSet{titleBtn.setRoundedLayout(button: titleBtn)}}
    @IBOutlet weak var emailField: UITextField!{didSet{emailField.setLayoutFromTextField(textField: emailField, type: .inputValue, imageType: .disabled)}}
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var fondoOpacity: UIImageView!
    @IBOutlet weak var headerIAcepta: headeriAcepta!
    @IBOutlet weak var btnCircle: CircleMenu!
    var helperExt = HelperExtensions()
    var txrModel:TransactionModel?
    var txrCard:CardWalkerModel?
    let verifone:Bool = false
    var isCancelOrReturn:Bool = false
    var setValues:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeValuesBtn()
        setText()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(tap)
        self.delegate = self
        headerIAcepta.delegate = self
        setHeader()
        amountField.delegate = self
        cardField.delegate = self
        emailField.delegate = self
        viewSelect = fondoOpacity
        autField.autocorrectionType = .no
        emailField.autocorrectionType = .no
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        printDev(object: "viewWillAppear ..... CancellationViewController")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
         return true
    }
    
    func setHeader(){
        if setValues{
            headerIAcepta.btnHome.isHidden = true
            headerIAcepta.btnInfo.isHidden = true
            btnCircle.isHidden = true
            setValuesTextfield()
        }else{
            headerIAcepta.btnHome.isHidden = false
            headerIAcepta.btnInfo.isHidden = false
            btnCircle.isHidden = false
            IQKeyboardManager.shared.enable = true
            IQKeyboardManager.shared.enableAutoToolbar = true
            IQKeyboardManager.shared.toolbarPreviousBarButtonItemText = "Anterior"
            IQKeyboardManager.shared.toolbarNextBarButtonItemText = "Continuar"
            IQKeyboardManager.shared.toolbarDoneBarButtonItemText = ""
        }
    }
    
    func setValuesTextfield(){
        IQKeyboardManager.shared.enableAutoToolbar = false
        emailField.text = modelGlob.Static.txrModel?.email ?? ""
//        emailField.isUserInteractionEnabled = false
//        autField.text = modelGlob.Static.txrModel?.reference ?? ""
//        autField.isUserInteractionEnabled = false
//        let getFinalTotal = finalTotal(amountText: modelGlob.Static.txrModel?.amount?.replacingOccurrences(of: ",", with: "") ?? "", tipText: modelGlob.Static.txrModel?.tip?.replacingOccurrences(of: ",", with: "") ?? "")
        amountField.text = modelGlob.Static.txrModel?.amount//helperExt.formatCurrency(format: String(getFinalTotal))
        amountField.isUserInteractionEnabled = false
    }
    
    func finalTotal(amountText:String, tipText:String) -> Double{
        var total:Double = 0.00
        let amountString = amountText.replacingOccurrences(of: ",", with: "")
        let doubleAmount = (amountString == "") ? (0.00) : (Double(amountString))
        let tipString = tipText.replacingOccurrences(of: ",", with: "")
        let doubleTip = (tipString == "") ? (0.00) : (Double(tipString))
        total = (doubleTip! + doubleAmount!)
        return total
    }
    
    func setText(){
        cardField.attributedPlaceholder = HelperExtensions().setFontText(string: "numberCard_cancellationText", color: "#003C64", nameFont: "Roboto", sizeFont: 20.0)
//        expField.attributedPlaceholder = HelperExtensions().setFontText(string: "cardExpiration_cancellationText", color: "#003C64", nameFont: "Roboto", sizeFont: 20.0)
        autField.attributedPlaceholder = HelperExtensions().setFontText(string: "authorizationOfSale_cancellationText", color: "#003C64", nameFont: "Roboto", sizeFont: 20.0)
        amountField.attributedPlaceholder = HelperExtensions().setFontText(string: "saleAmount_cancellationText", color: "#003C64", nameFont: "Roboto", sizeFont: 20.0)
        emailField.attributedPlaceholder = HelperExtensions().setFontText(string: "email_cancellationText", color: "#003C64", nameFont: "Roboto", sizeFont: 20.0)
    }
    
    func changeValuesBtn() {
        cleanTextfield()
        switch viewControllerSelected {
        case 2: // cancelacion
            viewControllerSelected = 2
            isCancelOrReturn = true
            sessionGlob.Static.sessionIAcepta?.setCancellationHeader = true
            titleBtn.setAttributedTitle(HelperExtensions().setFontText(string: "titleBtnCancellation", color: "#ffffff", nameFont: "Roboto", sizeFont: 20.0), for: .normal)
            headerIAcepta.lblTitle.text = "titleHeaderCancellation".localized
            actionTitle.isHidden = true
        case 3: // devolucion
        viewControllerSelected = 3
        isCancelOrReturn = false
        sessionGlob.Static.sessionIAcepta?.setCancellationHeader = false
        titleBtn.setAttributedTitle(HelperExtensions().setFontText(string: "titleBtnReturn", color: "#ffffff", nameFont: "Roboto", sizeFont: 20.0), for: .normal)
        headerIAcepta.lblTitle.text = "titleHeaderReturn".localized
        actionTitle.isHidden = true
        default:
            break
        }
//        if (viewControllerSelected == 2){
//            viewControllerSelected = 2
//            isCancelOrReturn = true
//            sessionGlob.Static.sessionIAcepta?.hasCancellation = true
//            titleBtn.setAttributedTitle(HelperExtensions().setFontText(string: "titleBtnCancellation", color: "#ffffff", nameFont: "Roboto", sizeFont: 20.0), for: .normal)
//            headerIAcepta.lblTitle.text = "titleHeaderCancellation".localized
//            actionTitle.isHidden = true
//
//        }else if (viewControllerSelected == 3){
//            viewControllerSelected = 3
//            isCancelOrReturn = false
//            sessionGlob.Static.sessionIAcepta?.setCancellationHeader = false
//            titleBtn.setAttributedTitle(HelperExtensions().setFontText(string: "titleBtnReturn", color: "#ffffff", nameFont: "Roboto", sizeFont: 20.0), for: .normal)
//            headerIAcepta.lblTitle.text = "titleHeaderReturn".localized
//            actionTitle.isHidden = true
//        }
    }
    
    func cleanTextfield(){
        cardField.text = ""
//        expField.text = ""
        autField.text = ""
        amountField.text = ""
        emailField.text = ""
        fondoOpacity.isHidden = true
    }
    
    func setNotEnabled(){
        cardField.isEnabled = false
//        expField.isEnabled = false
        autField.isEnabled = false
        amountField.isEnabled = false
        emailField.isEnabled = false
        titleBtn.isEnabled = false
    }
    func setEnabled(){
        cardField.isEnabled = true
//        expField.isEnabled = true
        autField.isEnabled = true
        amountField.isEnabled = true
        emailField.isEnabled = true
        titleBtn.isEnabled = true
    }
    
    func validateText(email:String,autField:String,amountField:String,cardField:String/*,expField:String*/) -> Bool{
        var textValidate:String = ""
        var isError:Int = 0
        if cardField.isEmpty{
            textValidate = String(format: "%@%@", textValidate, "error_enter_card_cancellation".localized)
            isError = 1
        }
        if (email.isEmpty){
            textValidate = String(format: "%@\n%@", textValidate, "validate_email_transactions".localized)
            isError = 1
        }
        if (autField.isEmpty){
            textValidate = String(format: "%@\n%@", textValidate, "error_enter_numAutorization_cancellation".localized)
            isError = 1
        }
        if (amountField.isEmpty){
            textValidate = String(format: "%@\n%@", textValidate, "error_enter_amount_cancellation".localized)
            isError = 1
        }
        if let amountDouble = Double(amountField){
            if (amountDouble < 0){
                textValidate = String(format: "%@\n%@", textValidate, "error_amount_less_zero".localized)
                isError = 1
            }
        }
        if isError == 1{
            alert(alertTitle: "title_alert_incomplete_data_transactions".localized, message: textValidate, alertBtnFirst: "btn_continue".localized, completion: {
                self.dismiss(animated: true, completion: nil)
            })
            return false
        }
        if !helperExt.isValidateEmail(email: emailField.text!){
            alert(alertTitle: "titleAlertiAcepta".localized, message: "validate_invalid_email_transactions".localized, alertBtnFirst: "btn_continue".localized, completion: {
                self.dismiss(animated: true, completion: nil)
            })
            return false
        }
        return true
    }
    
    //Function:Mark TextField
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if(textField == cardField){
            if string == "."{
                return false
            }
        }
//        if (textField == expField){
//            let result = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
//            if string == "."{
//                return false
//            }
//
//            let rs = result.replacingOccurrences(of: "-", with: "")
//            if rs.count > 4{
//                return false
//            }else{
//                if rs.count > 3{
//                    let first = String(rs.prefix(2))
//                    let last = String(rs.suffix(2))
//                    textField.text = first+"-"+last
//                    return false
//                }
//            }
//
//        }
        if(textField == amountField){
            let newString = string.replacingOccurrences(of: ",", with: ".")
            let result = NSString(string: textField.text!).replacingCharacters(in: range, with: newString)
            let texBool:Bool = textField.calculateExt(range: range, string: newString)
            if texBool{
                if !result.contains(".") && result.count>10{
                    return false
                }
                if newString == "."{
                    return true
                }
                if result.contains("."){
                    return true
                }
                textField.text = ""
                textField.text  = helperExt.new(format: result.replacingOccurrences(of: ",", with: ""))
                return false
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
        if(textField == autField){
            if string == ""{
                return true
            }
            let textBool:Bool = textField.calculeNumbersLettersNoPoint(range: range, string: string)
            return textBool
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == amountField){
            let amountString = amountField.text!.replacingOccurrences(of: ",", with: "")
            let resultAmount = helperExt.formatCurrency(format: String(amountString))
            if (resultAmount == ".00"){
                amountField.text = ""
            }else{
                amountField.text = resultAmount
            }
        }
        if (textField == emailField){
            self.scrollView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == emailField){
            let scrollPoint : CGPoint = CGPoint.init(x:0, y:50)
            self.scrollView.setContentOffset(scrollPoint, animated: true)
        }
    }
    
    //Mark Buttons
    @IBAction func btnContinueAction(_ sender: Any) {
        if validateText(email: emailField.text!, autField: autField.text!, amountField: amountField.text!, cardField: cardField.text!/*, expField: expField.text!*/){
            if headerIAcepta.lblTitle.text == "titleHeaderReturn".localized{recordStartTransaction(title: "transaction",type: typeTransaction.REVERSAL.stringValue)}else{recordStartTransaction(title: "transaction",type: typeTransaction.CANCELLATION.stringValue)}
            recordStartTransaction(title: "transaction",type: typeTransaction.CANCELLATION.stringValue)
            modelGlob.Static.txrModel = TransactionModel.init(total: amountField.text!)
            performSegue(withIdentifier: "toCancellationProcess", sender: self)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        amountField.text = amountField.text?.replacingOccurrences(of: ",", with: ".")
    }
    
    //Mark:Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCancellationProcess"{
            if let destinationVC = segue.destination as? LoaderAnimationProcess {
                let date = NSDate()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd MMM, yy HH:mm:ss"
                destinationVC.setHeader = viewControllerSelected!
                destinationVC.payProcess = false
                destinationVC.sendTxtModel = modelData(isCancelOrReturn)
                destinationVC.cardNumber = cardField.text!
                modelGlob.Static.txrModel?.dateName  = destinationVC.sendTxtModel?.type
                modelGlob.Static.cardReaderModel = CardWalkerModel.init(pan:cardField.text!)
                modelGlob.Static.cardReaderModel?.cardEntryMode = "M"
                modelGlob.Static.txrModel!.date = formatter.string(from: date as Date)
                modelGlob.Static.txrModel?.tracing = destinationVC.sendTxtModel?.retreivalReference
                modelGlob.Static.txrModel?.email = emailField.text
            }
        }
        if segue.identifier == "toHistoryWeb"{
            if let destination = segue.destination as? HistoryWebViewController{
                destination.viewControllerSelected = 4
            }
        }
        if segue.identifier == "toPayments"{
            if let destinationVC = segue.destination as? TransactionDataViewController {
                destinationVC.viewControllerSelected = 1
                destinationVC.setValues = false
            }
        }
    }
    
    //MArk:Model Data
    func modelData(_ isCancel:Bool) -> TypePaymentsRejectedModel?{
        
        var tprModel : TypePaymentsRejectedModel?
        
        var random:Int = Int(arc4random())
        if random<0{
            random = random * -1
        }
        let amount:String = (amountField.text!.replacingOccurrences(of: ",", with: "")).replacingOccurrences(of: ".", with: "")
        let amountEnd:String = amount.withCString { String(format: "%12s", $0)}.replacingOccurrences(of: " ", with: "0")
        var terminalId:String = ""
        if let terminal = sessionGlob.Static.sessionIAcepta?.userPhoneNumber{
            terminalId = terminal
            while terminalId.count < 16 {
                terminalId = String(format: "%@0",terminalId)
            }
        }
        var location:String = ""
        if let loc = sessionGlob.Static.sessionIAcepta?.comerceName{
            location = loc
            while(location.count < 40){
                location = String(format: "%@ ",location)
            }
        }
//        if location.count > 35{
//            let locationNSString = location as NSString
//            location = locationNSString.substring(with: NSRange(location: 0, length: 35))
//        }else{
//            location = String(format: "%@MX MX",location)
//        }
        var usrId:String = ""
        if let usr = sessionGlob.Static.sessionIAcepta?.userID{
            usrId = usr
        }
        var nodId:String = ""
        if let nod = sessionGlob.Static.sessionIAcepta?.userInfo?.nodeId{
            nodId = nod
        }
        let retreivalReference = String(format: "%ld", random)
//        let expiration:String = expField.text!.replacingOccurrences(of: "-", with: "")
        var track2:String = ""
        
        if viewControllerSelected == 2{
            track2 = String(format: "%@=%@", cardField.text!.replacingOccurrences(of: "-", with: ""),"0000")
        }else{
            let getDates = getDate()
            track2 = String(format: "%@=%@", cardField.text!.replacingOccurrences(of: "-", with: ""),getDates)
        }
        
        var authCode:String = autField.text!.uppercased()
        while authCode.count < 6 {
            authCode = String(format: "0%@",authCode)
        }
        
        tprModel = TypePaymentsRejectedModel(switchCommand: (sessionGlob.Static.sessionIAcepta!.setCancellationHeader!) ? "0420" : "0200", processingCode: (sessionGlob.Static.sessionIAcepta!.setCancellationHeader!) ? "000000" : "200000", amount: amountEnd, time: helperExt.dateInFormat(stringFormat: "%H%M%S"), merchantId: "4900", posEntryMode: "052", retreivalReference: retreivalReference, terminalId: terminalId, location: location, usrId: usrId, nodId: nodId, type: helperExt.dateInFormat(stringFormat: "%y%m%d%H%M%S"), media: "iAcepta", affiliate: (sessionGlob.Static.sessionIAcepta?.userInfo!.commerceMemberShipNumber)!)
        tprModel?.track1Data    = ""
        tprModel?.tipPercentage = ""
        tprModel?.typeCard      = "0"
        tprModel?.tipAmount     = ""
        tprModel?.cardHolder    = ""
        tprModel?.monthPromotion = "0"
        tprModel?.namePromotion  = "Sin Promocion"
        tprModel?.solution       = "iAcepta"
        tprModel?.reference      = ""
        tprModel?.idDevice       = "Dispositivo 1"
        tprModel?.authoResponse  = authCode
        tprModel?.track2Data     = track2
        tprModel?.date = helperExt.dateInFormat(stringFormat: "%m%d")
        tprModel?.secureToken = sessionGlob.Static.sessionIAcepta?.authToken
       
        
        return tprModel
    }
    
    //Funciton Date
    func getDate() -> String{
        let today = Date()
        let nextDate = Calendar.current.date(byAdding: .day, value: 30, to: today)
        
        let format = DateFormatter()
        format.dateFormat = "yyMM"
        let stringDate = format.string(from: nextDate!)
        return stringDate
    }
    
    //Mark: Segue Return
    @IBAction func unwindToCancellationOrReturn(segue:UIStoryboardSegue) { }
    
}
extension CancellationViewController: masterDelegate {
    func changeValues() {
        if (viewControllerSelected == 2){
            changeValuesBtn()
        }else if (viewControllerSelected == 3){
            changeValuesBtn()
        }
    }
}
extension CancellationViewController:ServicesIAceptaLogicDelegate{
    func reverseResponse(_ responseType: ServicesResponseType, resultResponse: SuccessfulPaymentModel?) {
        
    }
    
    func servicesResponse(_ responseType: ServicesResponseType, resultResponse: SuccessfulPaymentModel?, resultResponseCapX: SuccessfulPaymentModelVerifone?) {
        
    }
}
extension CancellationViewController:headerActoionDelegate{
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
        if (viewControllerSelected == 2){
            alertVC.contentName = "Cacellation"
        }else{
            alertVC.contentName = "Return"
        }
        
        present(alertVC, animated: true, completion: nil)
    }
}
