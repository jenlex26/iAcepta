//
//  MainMenuViewController.swift
//  iAcepta
//
//  Created by iOS_Dev on 2/11/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import UIKit

class MainMenuViewController: MasterViewController {

    @IBOutlet weak var test: UIImageView!
    @IBOutlet weak var headerIAcepta: headeriAcepta!
    @IBOutlet weak var btnVerifone: UIButton!
    @IBOutlet weak var btnWalker: UIButton!
    @IBOutlet weak var btnWisePad: UIButton!
    
    let alertVC = AlertViewController()
    let servicesLogic = ServicesIAceptaLogic()
    var helperExt = HelperExtensions()
    var typeReaderValue:String = ""
    var showVouchers:Bool = false
    var isWisePad:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        typeReaderValue = "VERIFONE"
        headerIAcepta.lblTitle.text = ""
        headerIAcepta.delegate = self
        headerIAcepta.btnHome.isHidden = true
        showVouchers = true
        isWisePad = false
        if UserDefaults.standard.string(forKey: "TYPEREADER") == "VERIFONE"{
            setVerifone()
        }else if UserDefaults.standard.string(forKey: "TYPEREADER") == "WISEPAD"{
            setWisePad()
        }else{
            setWalker()
        }
        
    }
    
    func showArcMenuBackground(){


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.string(forKey: "posIdentificationUser") == nil {
            let data = sessionGlob.Static.sessionIAcepta!.userID
            let number = Int.random(in: 0..<1000)
            let userPostNumber = data + String(number)
            UserDefaults.standard.set(userPostNumber, forKey: "posIdentificationUser")
        }
        if showVouchers{
            showVouchers = false
           checkVoucher()
        }
    }
    func checkVoucher(){
        let result = DBManagerVoucher.sharedInstance.getDataFromDB()
        if result.count > 0{
            if result.last?.codi == true{
            self.setVoucherCodiData()
                self.printDev(object: "Enviando Voucher Codi -------")
            }else{
                if result.last?.hasNip == false && result.last?.signature == nil{
                    printDev(object: "Necesita Firma")
                    if result.last?.dateVoucher != nil{
                        sessionGlob.Static.sessionIAcepta?.hasMultiPayment = false
                        if result.last?.userNameVoucher == sessionGlob.Static.sessionIAcepta?.userNameTxt && result.last!.signature == nil && !result.last!.hasNip {
                            alertFisrt()
                        }else{
                            alert(alertTitle: "", message: String(format: "alert_message_incompleteProcess_mainMenu",result.last?.userNameVoucher ?? "").localized, alertBtnFirst: "Salir", completion: {
                                self.dismiss(animated: true, completion: {
                                    if self.setVoucherData(){
                                        self.performSegue(withIdentifier: "toSignFromLogin", sender: self)
                                    }
                                    
                                })
                            })
                        }
                        printDev(object: "Tiene info")
                    }
                }else if (result.last?.signature != nil && result.last?.hasNip == false){
                    if self.setVoucherData(){
                        let imgSign = UIImage(data: result.last!.signature!, scale: 1.0)
                        //DispatchQueue.global().async {}
                        DispatchQueue.main.async {
                            self.printDev(object: "Enviando Firma ------- sin nip")
                            self.servicesLogic.servicesVoucherDelegate = self
                            self.servicesLogic.voucherConnec(self.sendTxn(signature: imgSign))
                        }
                    }
                }else if result.last?.hasNip == true{
                    if self.setVoucherData(){
                        DispatchQueue.main.async {
                            self.printDev(object: "Enviando Firma ------- con nip")
                            self.servicesLogic.servicesVoucherDelegate = self
                            self.servicesLogic.voucherConnec(self.sendTxn(signature: nil))
                        }
                    }
                }
                
            }
        }
    }
    func alertFisrt(){
        alertTwoOp(alertTitle: "alert_title_iAcepta_mainMenu".localized, message: "alert_message_iAcepta_mainMenu".localized, alertBtnFirst: "alert_btnTitle_sign_mainMenu".localized, alertBtnSecond: "alert_btnTitle_unsigned_mainMenu".localized, completion: {
            self.dismiss(animated: true, completion: {
                if self.setVoucherData(){
                    if modelGlob.Static.txrModel?.authorizationByNIP ?? false{
                        self.performSegue(withIdentifier: "toPayProcessFromLogin", sender: self)
                    }else{
                        self.performSegue(withIdentifier: "toSignFromLogin", sender: self)
                    }
                }
            })
        }, completion2: {
            self.dismiss(animated: true, completion: {
                self.alertTwoOp(alertTitle: "iAcepta", message: "alert_message_voucherMustBeSigned_mainMenu".localized, alertBtnFirst: "Continuar", alertBtnSecond: "Cancelar", completion: {
                    self.dismiss(animated: true, completion: {
                        let result = DBManagerVoucher.sharedInstance.getDataFromDB()
                        DBManagerVoucher.sharedInstance.deleteFromDb(object: result[result.count-1])
                    })
                }, completion2: {
                    self.dismiss(animated: true, completion: {
                        self.checkVoucher()
                        //self.alertFisrt()
                    })
                })
            })
        })
    }
    //MARK: Segue Push
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPayments"{
            if let destinationVC = segue.destination as? TransactionDataViewController {
                destinationVC.viewControllerSelected = 1
            }
        }
        if segue.identifier == "toSignFromLogin"{
            if let destinationVC = segue.destination as? SignatureViewController {
                destinationVC.payProcess = true
            }
        }
        if segue.identifier == "toPayProcessFromLogin"{
            if let destinationVC = segue.destination as? PayProcessViewController{
                destinationVC.payProcess = true
            }
        }
        if segue.identifier == "toCancellation"{
            if let destinationVC = segue.destination as? CancellationViewController {
                destinationVC.viewControllerSelected = Int(truncating: sender as! NSNumber)
                destinationVC.viewSelectedBefore = viewSelectedBefore
            }
        }
        if segue.identifier == "toHistoryWeb"{
            if let destinationVC = segue.destination as? HistoryWebViewController {
                destinationVC.viewControllerSelected = 4
            }
        }
        if segue.identifier == "toTutorial"{
            if let destinationVC = segue.destination as? splashCodiViewController {
                destinationVC.viewControllerSelected = 0
            }
        }
    }
    
    //Mark: Segue Return
    @IBAction func unwindToStar(segue:UIStoryboardSegue) {
        if isWisePad{
            UserDefaults.standard.set("WISEPAD", forKey: "TYPEREADER")
            setWisePad()
        }
        viewControllerSelected = nil
        viewSelectedBefore = 0
    }
    
    //MARK Buttons:
    @IBAction func actionVerifone(_ sender: Any) {
        setVerifone()
    }
    
    @IBAction func actionWalker(_ sender: Any) {
        setWalker()
    }
    
    @IBAction func actionWisePad(_ sender: Any) {
        self.performSegue(withIdentifier: "goToWisePad", sender: self)
    }
    
    //MARK Functions:Verifone&Walker
    func setVerifone(){
        isWisePad = false
        typeReaderValue = "VERIFONE"
        btnVerifone.setImage(UIImage(named: "verifoneSelect.png"), for: .normal)
        btnWalker.setImage(UIImage(named: "walker_unselected.png"), for: .normal)
        btnWisePad.setImage(UIImage(named: "wisepad_off.png"), for: .normal)
        UserDefaults.standard.set(typeReaderValue, forKey: "TYPEREADER")
    }
    
    func setWalker(){
        isWisePad = false
        typeReaderValue = "WALKER"
        btnVerifone.setImage(UIImage(named: "verifone_unselected.png"), for: .normal)
        btnWalker.setImage(UIImage(named: "walker_selected.png"), for: .normal)
        btnWisePad.setImage(UIImage(named: "wisepad_off.png"), for: .normal)
        UserDefaults.standard.set(typeReaderValue, forKey: "TYPEREADER")
    }
    
    func setWisePad() {
        typeReaderValue = "WISEPAD"
        btnVerifone.setImage(UIImage(named: "verifone_unselected.png"), for: .normal)
        btnWalker.setImage(UIImage(named: "walker_unselected.png"), for: .normal)
        btnWisePad.setImage(UIImage(named: "wisepad_on.png"), for: .normal)
    }
    
    //Func MARK:
    func sendTxn(signature:UIImage?) -> SendVoucherModel?{
        let txtCard = modelGlob.Static.cardReaderModel
        let txtModel = modelGlob.Static.txrModel
        let txtSession = sessionGlob.Static.sessionIAcepta
        var txrSendVoucher : SendVoucherModel?
        
        var ref:String = "0"
        var panTemp:String = ""
        
        var aplLabelValue:String = ""
        var cardIssuerValue:String = ""
        var prefNameValue:String = ""
        var cardHolderValue:String = ""
        var cardEntryModeValue:String = ""
        var cardTypeValue:String = ""
        
        if typeReader == "VERIFONE"{
            if (modelGlob.Static.cardCapituloX?.cardType?.uppercased() == "VISA"){
                ref = "1"
            }else if (modelGlob.Static.cardCapituloX?.cardType?.uppercased() == "AMEX"){
                ref = "2"
            }
            panTemp = modelGlob.Static.cardCapituloX?.pan?.replacingOccurrences(of: "F", with: "") ?? ""
            cardIssuerValue = modelGlob.Static.cardCapituloX?.cardType ?? ""
            cardHolderValue = modelGlob.Static.cardCapituloX?.cardHolder ?? ""
            cardEntryModeValue = modelGlob.Static.cardCapituloX?.cardEntryMode ?? ""
            cardTypeValue = modelGlob.Static.cardCapituloX?.isCreditDebit ?? ""
        }else{
            if (txtCard?.typeCard?.uppercased() == "VISA"){
                ref = "1"
            }else if (txtCard?.typeCard?.uppercased() == "AMEX"){
                ref = "2"
            }
            panTemp = txtCard?.pan!.replacingOccurrences(of: "F", with: "") ?? ""
            cardIssuerValue = txtCard?.typeCard ?? ""
            aplLabelValue = txtCard?.appName ?? ""
            prefNameValue = txtCard?.prefName ?? ""
            cardHolderValue = txtCard?.cardHolder ?? ""
            cardEntryModeValue = txtCard?.cardEntryMode ?? ""
            cardTypeValue = txtCard?.isCreditDebit ?? ""
        }
        
        let idd = String((txtModel?.dateName?.suffix(10))!)
        while (txtModel?.authorization!.count)! < 6 {
            txtModel?.authorization = String(format: "0%@", txtModel!.authorization!)
        }
        
        var location:String = ""
        if let loc = txtSession?.comerceName{
            location = loc
            while(location.count < 35){
                location = String(format: "%@ ",location)
            }
        }
        txtSession?.comerceName = location
        
        var trimmedString = (txtSession?.comerceName as NSString?)!.trimmingCharacters(in: .whitespacesAndNewlines)
        trimmedString = String(trimmedString.prefix(trimmedString.count-5))
//        let pan = String(format: "************%@", (panTemp.suffix(4)))
        let lastNumberCard = helperExt.CardNumberFormat(string: panTemp)
        let tip = txtModel?.tip
        printDev(object: "<<<<\(tip ?? "")>>>>>")
        ref = String(format: "%@%@%@", ref,txtModel!.authorization!,idd)
        
        var mesesText:String = ""
        if (txtModel?.mwi != nil && txtModel?.mwi == "" && txtModel?.mwi == "0"){
            mesesText = String(format: "%@ Meses sin Intereses", txtModel!.mwi!)
        }
        var terminalId:String = ""
        if let terminal = sessionGlob.Static.sessionIAcepta?.userPhoneNumber{
            terminalId = terminal
            while terminalId.count < 16 {
                terminalId = String(format: "%@0",terminalId)
            }
        }
        
        let dateVoucher = txtModel?.dateService ?? txtModel?.date

        
        txrSendVoucher = SendVoucherModel(userId: txtSession?.userID, nodeId: txtSession?.userInfo?.nodeId, scope: txtSession?.scope, expiration: txtSession?.tokenExpiration, secureToken: txtSession?.authToken, address: txtSession?.comerAddres, commerceName: trimmedString, memberShip: txtSession?.userInfo?.commerceMemberShipNumber, terminal: terminalId, date: dateVoucher, cardIssuer: cardIssuerValue, cardNumber: lastNumberCard, aplLabel: aplLabelValue, prefName: prefNameValue, aid: txtModel?.aid, arqc: txtModel?.arqc, authorization: txtModel?.authorization, trxAmount: txtModel?.amount, trxTip: tip, trxMonths: mesesText, cardHolder: cardHolderValue, trxSequence: ref, trxTracing: "", trxType: "0", emailClient: txtModel?.email, cardEntryMode: cardEntryModeValue)
        
//        let stringEscabe = NSCharacterSet(charactersIn: "!*'();:@&=+$,/?%#[]")
        var stringImgSign : String = ""
        
        if signature != nil{
            let signBase64 = helperExt.convertToBase64(image: signature!)
            stringImgSign = signBase64.addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed)!
        }
        if modelGlob.Static.txrModel?.authorizationByNIP ?? false{
            txrSendVoucher?.sign = ""
        }else{
            txrSendVoucher?.sign = String(stringImgSign)
        }
        var stringEnd : String = ""
        if (txtModel?.showMap != nil){
            if let imgMap = UIImage(data: txtModel!.showMap!, scale: 1.0){
                let base64Map = helperExt.convertToBase64(image: imgMap)
                stringEnd = base64Map.addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed)!
            }
        }
        txrSendVoucher?.cardType = cardTypeValue
            if modelGlob.Static.txrModel?.authorizationByNIP ?? false{
                txrSendVoucher?.VoucherType = "2"
            }else{
                txrSendVoucher?.VoucherType = "0"
            }
        txrSendVoucher?.trxTip = "0"
        txrSendVoucher?.trxTotal = txtModel?.total
        txrSendVoucher?.latitud =  (txtModel?.latitud == nil) ? "" : txtModel?.latitud
        txrSendVoucher?.longitud =  (txtModel?.longitud == nil) ? "" : txtModel?.longitud
        txrSendVoucher?.location = String(stringEnd)
        
        return txrSendVoucher
    }
}
extension MainMenuViewController:ServicesIAceptaVoucherDelegate{
    func servicesVoucherResponse(_ responseType: ServicesResponseType, resultResponse: SuccessVoucherModel?) {
        if responseType == .SERVICESSUCCESS{
            if resultResponse?.content?.code == "0" || resultResponse?.content?.code == "902"{
                let result = DBManagerVoucher.sharedInstance.getDataFromDB()
                DBManagerVoucher.sharedInstance.deleteFromDb(object: result[result.last?.voucherIAcepta ?? 0])
            }
        }else{
            printDev(object: "Sigue si cancelar Voucher")
        }
    }
}
extension MainMenuViewController:headerActoionDelegate{
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
        alertVC.contentName = "Main"
        present(alertVC, animated: true, completion: nil)
    }
}
extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
