//
//  LoaderSetupVerifoneViewController.swift
//  iAcepta
//
//  Created by QUALITY on 8/19/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import UIKit

class LoaderSetupVerifoneViewController: MasterViewController {
    
    @IBOutlet weak var headerIAcepta: headeriAcepta!
    @IBOutlet weak var loaderImg: UIImageView!
    
    var verifone = VerifoneReaderManager()
    let helpExt = HelperExtensions()
    let servicesLogic = ServicesIAceptaLogic()
    var statusKeyVerifone:statusKeysVerifone?
    var valueFinished:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        verifone = modelGlob.Static.verifoneSDK!
        verifone.delegate = self
        verifone.validateSucces()
        setHeader()
        loader()
        servicesLogic.servicesIAceptaLoadKeysDelegate = self
    }
    
    //Function MARK: Header
    func setHeader(){
        headerIAcepta.btnHome.isHidden = true
        headerIAcepta.lblTitle.text = "Pagos"
    }
    
    func encryptionInitializedWithSuccess(success:Bool, tokenEW:String, tokenES:String){
        if (success){
            servicesLogic.loadKeysVerifone(sendTxn(tokenEW: tokenEW, tokenES: tokenES))
        }
    }
    
    func hexStringWithData(datag:NSData) -> String{
        let dataBuffer = [UInt8](datag as Data)
        let dataLenght = datag.length
        let hexString = NSMutableString(capacity: datag.count*2)
        for index in 0..<dataLenght{
            hexString.appendFormat("%02lx", dataBuffer[index])
        }
        return hexString as String
    }
    
    func sendTxn(tokenEW:String, tokenES:String) -> TypePaymentsRejectedModel?{
        var tprModel : TypePaymentsRejectedModel?
        let random = arc4random()
        let theRandom = String(format: "%u",random)
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
            while(location.count < 35){
                location = String(format: "%@ ",location)
            }
        }
        if location.count > 35{
            let locationNSString = location as NSString
            location = locationNSString.substring(with: NSRange(location: 0, length: 35))
        }else{
            location = String(format: "%@MX MX",location)
        }
        let F007_2 = helpExt.dateInFormat(stringFormat: "%H%M%S")
        let F037 = String(format: "%@%@",helpExt.dateInFormat(stringFormat: "%H%M%S"),String(theRandom.suffix(6)))
        let type = helpExt.dateInFormat(stringFormat: "%y%m%d%H%M%S")
        let verifone = String(format: "%@%@", tokenES,tokenEW)
        let idDevice = "Dispositivo 2"
        let F007_1:String = helpExt.dateInFormat(stringFormat: "%m%d")
        let dateHour = String(format: "%@%@", F007_1, F007_2)
        tprModel = TypePaymentsRejectedModel(switchCommand: "0200", processingCode: "000000", amount: "000000000000", time: F007_2, merchantId: "4900", posEntryMode: "010", retreivalReference: F037, terminalId: terminalId, location: location, usrId: sessionGlob.Static.sessionIAcepta?.userID ?? "", nodId: sessionGlob.Static.sessionIAcepta?.userInfo?.nodeId ?? "", type: type, media: "iAcepta", affiliate: sessionGlob.Static.sessionIAcepta?.userInfo?.commerceMemberShipNumber ?? "")
        tprModel?.track2Data = "1111111111111111=1234"
        tprModel?.idDevice = idDevice
        tprModel?.dateAndHours = dateHour
        tprModel?.walker = verifone
        tprModel?.secureToken = sessionGlob.Static.sessionIAcepta?.authToken ?? ""
        tprModel?.timestamp = sessionGlob.Static.sessionIAcepta?.tokenExpiration ?? ""
        tprModel?.scope = sessionGlob.Static.sessionIAcepta?.scope ?? ""
        tprModel?.email = "Inicializacion de llaves"
        tprModel?.reference = dateHour
        tprModel?.tipPercentage = "0"
        tprModel?.tipAmount = ""
        tprModel?.cardHolder = ""
        tprModel?.monthPromotion = "0"
        tprModel?.namePromotion = "Sin Promocion"
        return tprModel
    }
}
extension LoaderSetupVerifoneViewController:verifoneResponseDelegate{
    func isConnect(success: Bool) {
        verifone.initLoadKeys()
    }
    
    func evotTxrStarted(_ success: Bool, error: String!, code: String!, tokenB2: Data!, tokenB3: Data!, tokenB4: Data!, tokenQ8: Data!, tokenQ9: Data!, tokenEY: Data!, tokenEZ: Data!, tokenES: Data!, tokenC0: Data!, tokenQE: Data!, tokenCZ: Data!) {
        
    }
    
    func evoApiTransactionEnded(_ success: Bool, error: String!, code: String!, cryptogramType: CryptogramType, authResponse: String!) {
        
    }
    func evoApiEncryptionInitialized(_ success: Bool, error: String!, code: String!, tokenEW: Data!, tokenES: Data!) {
        if (success){
            let utilitiesInfo = UtilitiesVerifone()
            let data_tokenEW = (tokenEW != nil) ? utilitiesInfo.string(fromHexString: hexStringWithData(datag: tokenEW as NSData)) : ""
            let data_tokenES = (tokenEW != nil) ? utilitiesInfo.string(fromHexString: hexStringWithData(datag: tokenES as NSData)) : ""
            self.encryptionInitializedWithSuccess(success: success, tokenEW: data_tokenEW ?? "", tokenES: data_tokenES ?? "")
        }else{
            
        }
    }
    
    func getResponseTokens(dataTokens:String) -> NSDictionary{
        let dicTokensResponse:NSMutableDictionary = NSMutableDictionary()
        if dataTokens != ""{
            let tokens = dataTokens.components(separatedBy: "!")
            for i in 0 ..< tokens.count{
                let token = String(format: "!%@", tokens[i])
                let key = (token as NSString? ?? "").substring(with: NSMakeRange(2, 2))
                dicTokensResponse.setValue(token, forKey: key)
            }
        }
        return dicTokensResponse
    }
    
    //Mark:Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goSetupVerifone"{
            if let destinationVC = segue.destination as? SetupVerifoneViewController {
                destinationVC.statusKeyVerifone = statusKeyVerifone
                destinationVC.isFinished = valueFinished
            }
        }
    }
    
    //Function MARK: Loader
    func loader(){
        var imgArray:[UIImage] = []
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
}
extension LoaderSetupVerifoneViewController:ServicesIAceptaLoadKeysDelegate{
    func serviceResponseLoadKeys(_ responseType: ServicesResponseType, resultResponse: SuccessfulPaymentModelVerifone?) {
        loaderImg.stopAnimating()
        if responseType == .SERVICESSUCCESS{
            let tokens = getResponseTokens(dataTokens: resultResponse?.capituloX ?? "")
            if (tokens != [:]){
                let tokenEX = (tokens.object(forKey: "EX") == nil) ? "" : tokens.object(forKey: "EX") as! String
                if (tokenEX != ""){
                    verifone.endLoadKeysWithToken(tokenEX: Data(tokenEX.utf8))
                    valueFinished = true
                }else{
                    valueFinished = false
                    self.performSegue(withIdentifier: "goSetupVerifone", sender: nil)
                }
            }else{
                valueFinished = false
                self.performSegue(withIdentifier: "goSetupVerifone", sender: nil)
            }
        }else{
            valueFinished = false
            self.performSegue(withIdentifier: "goSetupVerifone", sender: nil)
        }
    }
}
