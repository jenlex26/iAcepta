//
//  LoaderAnimationVoucher.swift
//  iAcepta
//
//  Created by QUALITY on 7/12/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import UIKit

class LoaderAnimationVoucher: MasterViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var loaderImg: UIImageView!
    @IBOutlet weak var headerIAcepta: headeriAcepta!
    
    var imgArray:[UIImage] = []
    var payProcess:Bool = false
    var isSuccesVoucher:Bool = false
    
    var txtModel:TransactionModel?
    var txtCard:CardWalkerModel?
    var txtSession:SessionIAcepta?
    let servicesLogic = ServicesIAceptaLogic()
    var helperExt = HelperExtensions()
    var cardNumber: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader()
        setText()
        header()
        txtModel = modelGlob.Static.txrModel
        txtCard = modelGlob.Static.cardReaderModel
        txtSession = sessionGlob.Static.sessionIAcepta
        servicesLogic.servicesVoucherDelegate = self
        servicesLogic.voucherConnec(sendTxn())
        self.rotateToLandsScapeDevice(orientation: .portrait, orientationMask: .portrait)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVoucher"{
            if let destinationVC = segue.destination as? VoucherViewController {
                destinationVC.cardNumber = cardNumber
                destinationVC.payProcess = payProcess
                destinationVC.isSuccessVoucher = isSuccesVoucher
            }
        }
    }
    
    //Function MARK: setText
    func setText(){
        lblTitle.text = "lbl_title_loaderAnimationVoucher".localized
    }
    
    func header(){
        headerIAcepta.btnHome.isHidden = true
        headerIAcepta.btnInfo.isHidden = false
        if payProcess{
            headerIAcepta.lblTitle.text = "title_header_payProcess_loaderAnimationVoucher".localized
        }else{
            if sessionGlob.Static.sessionIAcepta!.setCancellationHeader!{
                headerIAcepta.lblTitle.text = "title_header_cancellation_loaderAnimationVoucher".localized
            }else{
                headerIAcepta.lblTitle.text = "title_header_rejected_loaderAnimationVoucher".localized
            }
        }
    }
    
    //Function MARK: Animation
    func loader(){
        if let nameImg = UIImage(named: "loader_ft1"){
            imgArray.append(nameImg)
        }
        if let nameImg2 = UIImage(named: "loader_ft2"){
            imgArray.append(nameImg2)
        }
        if let nameImg3 = UIImage(named: "loader_ft3"){
            imgArray.append(nameImg3)
        }
        if let nameImg4 = UIImage(named: "loader_ft4"){
            imgArray.append(nameImg4)
        }
        if let nameImg5 = UIImage(named: "loader_ft5"){
            imgArray.append(nameImg5)
        }
        if let nameImg6 = UIImage(named: "loader_ft6"){
            imgArray.append(nameImg6)
        }
        if let nameImg7 = UIImage(named: "loader_ft7"){
            imgArray.append(nameImg7)
        }
        loaderImg.animationImages = imgArray
        loaderImg.animationDuration = 1
        loaderImg.isHidden = false
        loaderImg.startAnimating()
    }
    //Function MARK: sendText
    func sendTxn() -> SendVoucherModel?{
        var txrSendVoucher : SendVoucherModel?
        
        var ref:String = "0"
        var panTemp:String = ""
        var lastNumberCard = ""
        
        var aplLabelValue:String = ""
        var cardIssuerValue:String = ""
        var prefNameValue:String = ""
        var cardHolderValue:String = ""
        var cardEntryModeValue:String = ""
        var cardTypeValue:String = ""
        
        if typeReader == "VERIFONE"{
            
            switch modelGlob.Static.cardCapituloX?.pan?.prefix(1) {
                case "4":
                    ref = "1"
                case "3":
                    ref = "2"
                default:
                    ref = "0"
            }
    
            panTemp = modelGlob.Static.cardCapituloX?.pan?.replacingOccurrences(of: "F", with: "") ?? ""
            cardIssuerValue = modelGlob.Static.cardCapituloX?.cardType ?? ""
            cardHolderValue = modelGlob.Static.cardCapituloX?.cardHolder ?? ""
            cardEntryModeValue = modelGlob.Static.cardCapituloX?.cardEntryMode ?? ""
            cardTypeValue = modelGlob.Static.cardCapituloX?.isCreditDebit ?? ""
        }else{
            switch modelGlob.Static.cardReaderModel?.pan?.prefix(1) {
                case "4":
                    ref = "1"
                case "3":
                    ref = "2"
                default:
                    ref = "0"
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
        
        let trimmedString = (txtSession?.comerceName as NSString?)!.trimmingCharacters(in: .whitespacesAndNewlines)
        let tip = txtModel?.tip
        if panTemp.isEmpty{
            lastNumberCard = helperExt.CardNumberFormat(string: cardNumber.dropLastWhileLetter())
        }else{
            lastNumberCard = helperExt.CardNumberFormat(string: panTemp.dropLastWhileLetter())
        }
        ref = String(format: "%@%@%@", ref,txtModel!.authorization!,idd)
        
        var mesesText:String = ""
        if (txtModel?.mwi != nil && txtModel?.mwi != "" && txtModel?.mwi != "0"){
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
        if let imgSign:UIImage = helperExt.loadImage(name: "Voucher2"){
            let signBase64 = helperExt.convertToBase64(image: imgSign)
            stringImgSign = signBase64.addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed)!
        }
        
        if modelGlob.Static.txrModel?.authorizationByNIP ?? false{
            txrSendVoucher?.sign = ""
        }else{
            txrSendVoucher?.sign = String(stringImgSign)
        }
        
        if  payProcess{
            var stringEnd : String = ""
            if let img:UIImage = helperExt.loadImage(name: String(format: "B%@_lt", txtModel!.dateName!)){
                let base64 = helperExt.convertToBase64(image: img)
                stringEnd = base64.addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed)!
            }
            txrSendVoucher?.cardType = cardTypeValue
            if modelGlob.Static.txrModel?.authorizationByNIP ?? false{
                txrSendVoucher?.VoucherType = "2"
            }else{
                txrSendVoucher?.VoucherType = "0"
            }
            txrSendVoucher?.trxTip = txtModel?.tip
            txrSendVoucher?.trxTotal = txtModel?.total
            txrSendVoucher?.latitud  =  (txtModel?.latitud == nil) ? "" : txtModel?.latitud
            txrSendVoucher?.longitud =  (txtModel?.longitud == nil) ? "" : txtModel?.longitud
            txrSendVoucher?.location = String(stringEnd)
        }else{
            txrSendVoucher?.trxTracing = txtModel?.tracing ?? ""
            txrSendVoucher?.trxTotal = String(format: "-%@", txtModel!.total!)
            txrSendVoucher?.latitud =  ""
            txrSendVoucher?.longitud =  ""
            txrSendVoucher?.location = ""
            txrSendVoucher?.sign = ""
            if txtSession!.setCancellationHeader!{
                txrSendVoucher?.trxType = "1"
            }else{
                txrSendVoucher?.trxType = "2"
            }
        }
        
        return txrSendVoucher
    }
    
}
//Function MARK: Extension
extension LoaderAnimationVoucher:ServicesIAceptaVoucherDelegate{
    func servicesVoucherResponse(_ responseType: ServicesResponseType, resultResponse: SuccessVoucherModel?) {
        loaderImg.stopAnimating()
        if responseType == .NO_CONNECTION{
            self.alert(alertTitle: "titleAlertWithoutConnection".localized, message: "bodyAlertWithoutConnection".localized, alertBtnFirst: "titleBtnAlert_Accept".localized, completion: {
                self.dismiss(animated: true, completion: nil)
            })
        }else if responseType == .SERVICESSUCCESS{
            if resultResponse?.content?.code == "0" || resultResponse?.content?.code == "902"{
                isSuccesVoucher = true
                recordSendVoucher(type_transaction: typeTransaction.SELL.stringValue, process: "transaction")
                let result = DBManagerVoucher.sharedInstance.getDataFromDB()
                if result.count > 0{
                    DBManagerVoucher.sharedInstance.deleteFromDb(object: result[result.last?.voucherIAcepta ?? 0])
                }
                performSegue(withIdentifier: "showVoucher", sender: self)
            }else{
                isSuccesVoucher = false
                recordSendVoucher(type_transaction: typeTransaction.SELL.stringValue, process: "backup")
                performSegue(withIdentifier: "showVoucher", sender: self)
            }
        }else{
            isSuccesVoucher = false
            recordSendVoucher(type_transaction: typeTransaction.SELL.stringValue, process: "backup")
            performSegue(withIdentifier: "showVoucher", sender: self)
        }
    }
    
}
