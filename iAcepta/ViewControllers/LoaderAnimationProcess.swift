//
//  LoaderAnimation.swift
//  iAcepta
//
//  Created by QUALITY on 7/8/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//RNCryptor.h

import Foundation
import UIKit
import MapKit
import CoreLocation

class LoaderAnimationProcess: MasterViewController {
    
    @IBOutlet weak var headerIAcepta: headeriAcepta!
    @IBOutlet weak var loaderImg: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var imgArray:[UIImage] = []
    let helpExt = HelperExtensions()
    let servicesLogic = ServicesIAceptaLogic()
    var txtModel:TransactionModel?
    var txtCard:CardWalkerModel?
    var txtSession:SessionIAcepta?
    var sendTxtModel:TypePaymentsRejectedModel?
    var currentVoucher:SaveVoucher?
    var resultResponseType: ServicesResponseType?
    var sdkVerifone: CardReadesViewController?
    let wisepad = WisePadReaderManager()
    
    var imageData:Data? = nil
    var payProcess:Bool  = false
    var isLocation:Bool  = false
    var isSuccess:Bool   = false
    var isMapLoad:Bool   = false
    var isViewWillApp:Bool = false
    var timerPetition: Timer?
    var cardNumber: String = ""
    var setHeader: Int = 0
    
    var locationManager = CLLocationManager()
    
    var verifoneResponse = "iAcepta.verifoneResponse"
    var serviceReverse = "iAcepta.reverse"
    var alertResponse = "iAcpeta.alertResponse"
    
    var reasonForRejection = ""
    var typeApproved = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtModel = modelGlob.Static.txrModel
        txtCard = modelGlob.Static.cardReaderModel
        txtSession = sessionGlob.Static.sessionIAcepta
        self.loader()
        self.setLabels()
        self.setTxrPayment()
        
        if payProcess{
            locationManager.requestWhenInUseAuthorization()
        }else{
            mapView.delegate = nil
            mapView = nil
        }
        servicesLogic.servicesDelegate = self
        isViewWillApp = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isViewWillApp{
            isViewWillApp = false
            if payProcess{
                setLocationMapsTranssaction()
            }
        }
    }
    
    //Func MARK: SetText&Labels
    func setTxrPayment(){
        if payProcess{
            lblTitle.text = "title_payProcess_loaderAnimationProcess".localized
            headerIAcepta.lblTitle.text = "title_header_payProcess_loaderAnimationProcess".localized
            //servicesLogic.payment(sendTxn())
        }else{
            lblTitle.text = "title_cancellation_loaderAnimationProcess".localized
            if sessionGlob.Static.sessionIAcepta!.setCancellationHeader!{
                headerIAcepta.lblTitle.text = "title_header_cancellation_loaderAnimationProcess".localized
            }else{
                lblTitle.text = "title_rejected_loaderAnimationProcess".localized
                headerIAcepta.lblTitle.text = "title_header_rejected_loaderAnimationProcess".localized
            }
            servicesLogic.typePaymentsRejected(sendTxtModel)
        }
        
    }
    
    func setLabels(){
        headerIAcepta.lblTitle.text = "title_header_loaderAnimation".localized
        headerIAcepta.btnHome.isHidden = true
        headerIAcepta.btnInfo.isHidden = true
        lblTitle.text = "lbl_msj_loaderAnimation".localized
    }
    
    //Func MARK:Map&Location
    func setLocationMapsTranssaction(){
        mapView.delegate = self
        mapView.showsUserLocation = true
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            switch (CLLocationManager.authorizationStatus()){
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                isMapLoad = true
                isLocation = true
                printDev(object: "authorizedAlways and authorizedWhenInUse")
            default:
                isMapLoad = false
                servicesLogic.payment(sendTxn())
                printDev(object: "no denied")
            }
        }
    }
    
    func saveMap(){
        guard let map = mapView else {return}
        
        UIGraphicsBeginImageContext(map.frame.size)
        map.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let file = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(String(format: "B%@_lt.png", txtModel!.dateName!))
        imageData = image!.pngData()
        do{
            try imageData?.write(to: file, options: .atomic)
        }catch{
            printDev(object: error)
        }
        printDev(object: image as Any)
    }
    
    func removeMap(){
        locationManager.stopUpdatingLocation()
        guard let map = mapView else {return}
        map.delegate = nil
        map.removeFromSuperview()
        locationManager.delegate = nil
    }
    
    //Function MARK: SpinnerImage
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
    
    //Func MARK: Services
    func sendTxn() -> TypePaymentsRejectedModel?{
        var tprModel : TypePaymentsRejectedModel?
        let date = NSDate()
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "es_MX_POSIX") as Locale
        formatter.dateFormat = "HHmmss"
        let time = formatter.string(from: date as Date)
        var amount:String = ""
        if let getAmount = txtModel?.total{
            amount = (getAmount.replacingOccurrences(of: ",", with: "")).replacingOccurrences(of: ".", with: "");
        }
        let amountEnd:String = amount.withCString { String(format: "%12s", $0)}.replacingOccurrences(of: " ", with: "0")
        var namePromotion:String = "Meses sin Intereses"
        if let mwiNamePromotion = txtModel?.mwi{
            if (mwiNamePromotion == "-")||(mwiNamePromotion == "0"){
                namePromotion = "Sin Promocion"
            }
        }
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
        
        let tipEnd = modelGlob.Static.txrModel?.tip ?? ""
        
        if modelGlob.Static.cardReaderModel?.track2 == nil{
            modelGlob.Static.cardReaderModel?.track2 = ""
        }
        if txtModel?.posEntryMode == nil{
            modelGlob.Static.txrModel?.posEntryMode = ""
        }
        
        tprModel = TypePaymentsRejectedModel(switchCommand: "0200", processingCode: "000000", amount: amountEnd, time: time, merchantId: "4900", posEntryMode: txtModel!.posEntryMode!, retreivalReference: txtModel!.F037!, terminalId: terminalId, location: location, usrId: sessionGlob.Static.sessionIAcepta!.userID, nodId: (sessionGlob.Static.sessionIAcepta?.userInfo!.nodeId)!, type: txtModel!.dateName!, media: "iAcepta", affiliate: (sessionGlob.Static.sessionIAcepta?.userInfo!.commerceMemberShipNumber)!)
        tprModel?.tipPercentage = modelGlob.Static.txrModel?.tipPercentage?.replacingOccurrences(of: ".", with: "") ?? ""//"(null)"//
        
        tprModel?.tipAmount = (tipEnd.replacingOccurrences(of: ",", with: "")).replacingOccurrences(of: ".", with: "");
        tprModel?.monthPromotion = txtModel?.mwi
        tprModel?.secureToken = sessionGlob.Static.sessionIAcepta?.authToken
        tprModel?.timestamp = sessionGlob.Static.sessionIAcepta?.tokenExpiration
        tprModel?.scope = sessionGlob.Static.sessionIAcepta?.scope
        tprModel?.namePromotion = namePromotion
        tprModel?.reference = txtModel?.reference
        tprModel!.traceAudit = "(null)"
        tprModel!.networkInfo = "(null)"
        tprModel?.email = (txtModel?.email == nil) ? "(null)" : txtModel?.email
        
        if typeReader == "VERIFONE"{
//            let nameReader = UserDefaults.standard.string(forKey: "VerifoneID") ?? ""
            tprModel?.dateAndTime = helpExt.dateInFormat(stringFormat: "%e %b, %y  %T")
            txtModel?.F007_1 = helpExt.dateInFormat(stringFormat: "%m%d")
            txtModel?.F007_2 = helpExt.dateInFormat(stringFormat: "%H%M%S")
            let dateAndHours = String(format: "%@%@",txtModel?.F007_1 ?? "",txtModel?.F007_2 ?? "")
            tprModel?.idDevice = "Dispositivo 2"
            tprModel?.dateAndHours = dateAndHours
            tprModel?.walker = modelGlob.Static.cardCapituloX?.tokens ?? ""
            tprModel?.track2Data = modelGlob.Static.cardCapituloX?.track2 ?? ""
            tprModel?.chip = modelGlob.Static.cardCapituloX?.isEntryModeReader ?? ""
        }else if (typeReader == "WALKER") || (typeReader == "WISEPAD"){
            
            tprModel?.dateAndTime = time
            tprModel?.idDevice = (typeReader == "WALKER") ? "Dispositivo 1" : "Dispositivo 3"
            tprModel?.walker = (modelGlob.Static.cardReaderModel?.walker == nil) ? "(null)" : modelGlob.Static.cardReaderModel?.walker
            tprModel?.chip = (modelGlob.Static.cardReaderModel?.chip == nil) ? "(null)" : modelGlob.Static.cardReaderModel?.chip
            tprModel?.track1Data = (modelGlob.Static.cardReaderModel?.track1 == nil) ? "(null)" : modelGlob.Static.cardReaderModel?.track1
            tprModel?.ksn = (modelGlob.Static.cardReaderModel?.ksn == nil) ? "(null)" : modelGlob.Static.cardReaderModel?.ksn
            tprModel?.track2Data = (modelGlob.Static.cardReaderModel?.track2 == nil) ? "(null)" : modelGlob.Static.cardReaderModel?.track2
        }
        
        return tprModel
    }
    
    func reverse2() -> TypePaymentsRejectedModel?{
            var tprModel : TypePaymentsRejectedModel?
            let date = NSDate()
            let formatter = DateFormatter()
            formatter.locale = NSLocale(localeIdentifier: "es_MX_POSIX") as Locale
            formatter.dateFormat = "HHmmss"
            let time = formatter.string(from: date as Date)
            var amount:String = ""
            if let getAmount = txtModel?.total{
                amount = (getAmount.replacingOccurrences(of: ",", with: "")).replacingOccurrences(of: ".", with: "");
            }
            let amountEnd:String = amount.withCString { String(format: "%12s", $0)}.replacingOccurrences(of: " ", with: "0")
            var namePromotion:String = "Meses sin Intereses"
            if let mwiNamePromotion = txtModel?.mwi{
                if (mwiNamePromotion == "-")||(mwiNamePromotion == "0"){
                    namePromotion = "Sin Promocion"
                }
            }
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
            
            let tipEnd = modelGlob.Static.txrModel?.tip ?? ""
            
            if modelGlob.Static.cardReaderModel?.track2 == nil{
                modelGlob.Static.cardReaderModel?.track2 = ""
            }
            if txtModel?.posEntryMode == nil{
                modelGlob.Static.txrModel?.posEntryMode = ""
            }
            
            tprModel = TypePaymentsRejectedModel(switchCommand: "0420", processingCode: "000000", amount: "000000000000", time: txtModel?.F007_2 ?? "", merchantId: "4900", posEntryMode: txtModel!.posEntryMode!, retreivalReference: txtModel!.F037!, terminalId: terminalId, location: location, usrId: sessionGlob.Static.sessionIAcepta!.userID, nodId: (sessionGlob.Static.sessionIAcepta?.userInfo!.nodeId)!, type: "", media: "iAcepta", affiliate: (sessionGlob.Static.sessionIAcepta?.userInfo!.commerceMemberShipNumber)!)
            tprModel?.tipPercentage = modelGlob.Static.txrModel?.tipPercentage?.replacingOccurrences(of: ".", with: "") ?? ""
            
            tprModel?.authoResponse = txtModel?.authorization ?? ""
            tprModel?.tipAmount = (tipEnd.replacingOccurrences(of: ",", with: "")).replacingOccurrences(of: ".", with: "");
            tprModel?.monthPromotion = txtModel?.mwi
            tprModel?.secureToken = sessionGlob.Static.sessionIAcepta?.authToken
            tprModel?.timestamp = sessionGlob.Static.sessionIAcepta?.tokenExpiration
            tprModel?.scope = sessionGlob.Static.sessionIAcepta?.scope
            tprModel?.namePromotion = namePromotion
            tprModel?.reference = txtModel?.reference
            tprModel!.traceAudit = "(null)"
            tprModel!.networkInfo = "(null)"
            tprModel?.email = (txtModel?.email == nil) ? "(null)" : txtModel?.email
            
            if typeReader == "VERIFONE"{
    //            let nameReader = UserDefaults.standard.string(forKey: "VerifoneID") ?? ""
                tprModel?.dateAndTime = helpExt.dateInFormat(stringFormat: "%e %b, %y  %T")
                txtModel?.F007_1 = helpExt.dateInFormat(stringFormat: "%m%d")
                txtModel?.F007_2 = helpExt.dateInFormat(stringFormat: "%H%M%S")
                let dateAndHours = String(format: "%@%@",txtModel?.F007_1 ?? "",txtModel?.F007_2 ?? "")
                tprModel?.idDevice = "Dispositivo 2"
                tprModel?.dateAndHours = dateAndHours
                tprModel?.walker = modelGlob.Static.cardCapituloX?.tokens ?? ""
                tprModel?.track2Data = modelGlob.Static.cardCapituloX?.track2 ?? ""
                tprModel?.chip = modelGlob.Static.cardCapituloX?.isEntryModeReader ?? ""
            }else if (typeReader == "WALKER") || (typeReader == "WISEPAD"){
                
                tprModel?.dateAndTime = time
                tprModel?.idDevice = (typeReader == "WALKER") ? "Dispositivo 1" : "Dispositivo 3"
                tprModel?.walker = (modelGlob.Static.cardReaderModel?.walker == nil) ? "(null)" : modelGlob.Static.cardReaderModel?.walker
                tprModel?.chip = (modelGlob.Static.cardReaderModel?.chip == nil) ? "(null)" : modelGlob.Static.cardReaderModel?.chip
                tprModel?.track1Data = (modelGlob.Static.cardReaderModel?.track1 == nil) ? "(null)" : modelGlob.Static.cardReaderModel?.track1
                tprModel?.ksn = (modelGlob.Static.cardReaderModel?.ksn == nil) ? "(null)" : modelGlob.Static.cardReaderModel?.ksn
                tprModel?.track2Data = (modelGlob.Static.cardReaderModel?.track2 == nil) ? "(null)" : modelGlob.Static.cardReaderModel?.track2
            }
            
            return tprModel
        }
    
    
    
    
    
    func reverso() -> TypePaymentsRejectedModel?{
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
        
        var namePromotion:String = "Meses sin Intereses"
        if let mwiNamePromotion = txtModel?.mwi{
            if (mwiNamePromotion == "-")||(mwiNamePromotion == "0"){
                namePromotion = "Sin Promocion"
            }
        }
        
        let nameReader = UserDefaults.standard.string(forKey: "VerifoneID") ?? ""
        let tipEnd = modelGlob.Static.txrModel?.tip ?? ""
        
        txtModel?.F007_2 = helpExt.dateInFormat(stringFormat: "%H%M%S")
        txtModel?.F037 = String(format: "%@%@",helpExt.dateInFormat(stringFormat: "%H%M%S"),String(theRandom.suffix(6)))
        
        tprModel = TypePaymentsRejectedModel(switchCommand: "0420", processingCode: "000000", amount: "000000000000", time: txtModel?.F007_2 ?? "", merchantId: "4900", posEntryMode: "010", retreivalReference: txtModel?.F037 ?? "", terminalId: terminalId, location: location, usrId: sessionGlob.Static.sessionIAcepta?.userID ?? "", nodId: sessionGlob.Static.sessionIAcepta?.userInfo?.nodeId ?? "", type: "", media: "iAcepta", affiliate: sessionGlob.Static.sessionIAcepta?.userInfo?.commerceMemberShipNumber ?? "")
        tprModel?.track2Data = "1111111111111111=1234"
        tprModel?.authoResponse = txtModel?.authorization ?? "" //numero de autorización
        tprModel?.idDevice = (nameReader != "") ? nameReader : "Dispositivo 2"
        tprModel?.tipPercentage = modelGlob.Static.txrModel?.tipPercentage?.replacingOccurrences(of: ".", with: "") ?? "0"
        tprModel?.tipAmount = (tipEnd.replacingOccurrences(of: ",", with: "")).replacingOccurrences(of: ".", with: "");
        tprModel?.monthPromotion = txtModel?.mwi // lo mismo que tipAmount
        tprModel?.namePromotion = namePromotion
        tprModel?.reference = txtModel?.reference ?? ""
        tprModel?.dateAndTime = helpExt.dateInFormat(stringFormat: "%m%d%H%M%S")
        tprModel?.secureToken = sessionGlob.Static.sessionIAcepta?.authToken ?? ""
        tprModel?.timestamp = sessionGlob.Static.sessionIAcepta?.tokenExpiration ?? ""
        tprModel?.scope = sessionGlob.Static.sessionIAcepta?.scope ?? ""
        
        return tprModel
    }
    
    //cambio
    func chip(result:SuccessfulPaymentModel){
        let dates = result.allDates
        var resultDates = dates!.components(separatedBy: "|")
        txtModel?.arqc = resultDates[2]
        txtModel?.aid = resultDates[3]
        if resultDates[4] == "null"{
            txtCard?.appName = resultDates[4]
        }
        if resultDates[5] == "null"{
            txtCard?.prefName = resultDates[5]
        }
//        txtCard?.pan = resultDates[6]
        txtModel?.legend = resultDates[8]
        if !(resultDates[9].prefix(2) == "C0"){
            txtCard?.issuingBank = resultDates[9]
        }else{
            txtCard?.issuingBank = ""
        }
        if !(resultDates[10].prefix(2) == "C0"){
            txtCard?.isCreditDebit = resultDates[10]
        }else{
            txtCard?.isCreditDebit = ""
        }
        if result.responseCode! == "00"{
            saveVoucherForPayment("Chip")
        }
        
    }
    //cambio
    func isEntryModeCapX(result:SuccessfulPaymentModelVerifone, entryMode:String){
        let dates = result.allDates
        let dataCard = dates!.components(separatedBy: "|")
        modelGlob.Static.txrModel?.legend = dataCard[14]
        modelGlob.Static.cardCapituloX?.issuingBank = dataCard[15]
        modelGlob.Static.cardCapituloX?.isCreditDebit = dataCard[16]
        let date = result.date
        if date == nil || helpExt.containsOnlyLetters(input: date!){
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .medium
           modelGlob.Static.txrModel?.dateService = dateFormatter.string(from: date)
        }else{
            modelGlob.Static.txrModel?.dateService = helpExt.toDate(string: date!)
        }
        if result.responseCode! == "00"{
            saveVoucherForPayment(entryMode)
        }
    }
    
    func banda(resultDates:[String]){
    
        if (resultDates[10] == "null") || !(resultDates[10] == ""){
            txtCard?.isCreditDebit = resultDates[10]
        }
        if (resultDates[9] == "null") || !(resultDates[9] == ""){
            txtCard?.issuingBank = resultDates[9]
        }
//        txtCard?.pan = resultDates[6]
        saveVoucherForPayment("Banda")
//        if result.responseCode! == "00"{
//            saveVoucherForPayment("Banda")
//        }
    }
    
    func disconnected() {
        modelGlob.Static.wisePadSDK?.ultimoEstado = .Disconnect
        modelGlob.Static.wisePadSDK?.wisePad2.cancelCheckCard()
        modelGlob.Static.wisePadSDK?.disconect(setDimiss: false)
    }
    
    func saveVoucherForPayment(_ isChipBanda:String){
        if txtModel?.reference == nil || txtModel?.reference == "-"{
            txtModel?.reference = ""
        }
        var mwi:String = "Meses sin Intereses"
        if (txtModel?.mwi == "" || txtModel?.mwi == "0" || txtModel?.mwi == nil){
            mwi = "Sin Promocion"
        }
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //let pan = String(format: "************%@", String(txtCard!.pan!.suffix(4)))
        var pan:String = ""
        var cardIssuer:String = ""
        var aplLabel:String = ""
        var prefName:String = ""
        var cardholder:String = ""
        var cardType:String = ""
        var cardEntryMode:String = ""
        var tip:String = "0.00"
        //(txtCard?.appName == nil) ? "" : txtCard?.appName as Any
        if typeReader == "VERIFONE"{
            pan = helpExt.CardNumberFormat(string: modelGlob.Static.cardCapituloX?.pan ?? cardNumber)
//            pan = String(format: "************%@", String(modelGlob.Static.cardCapituloX?.pan?.suffix(4) ?? ""))
            cardIssuer = modelGlob.Static.cardCapituloX?.cardType ?? ""
            cardholder = modelGlob.Static.cardCapituloX?.cardHolder ?? ""
            cardType = modelGlob.Static.cardCapituloX?.isCreditDebit ?? ""
            cardEntryMode = modelGlob.Static.cardCapituloX?.cardEntryMode ?? ""
            tip = txtModel?.tip ?? "0.00"
        }else{
            tip = txtModel?.tip ?? "0.00"
            pan = helpExt.CardNumberFormat(string: txtCard!.pan ?? cardNumber)
//            pan = String(format: "************%@", String(txtCard!.pan!.suffix(4)))
            cardIssuer = txtCard?.typeCard ?? ""
            aplLabel = txtCard?.appName ?? ""
            prefName = txtCard?.prefName ?? ""
            cardholder = txtCard?.cardHolder ?? ""
            cardType = txtCard?.isCreditDebit ?? ""
            cardEntryMode = txtCard?.cardEntryMode ?? ""
        }
        
        let data: [String: Any] = [
            "date": txtModel?.date as Any,
            "cardIssuer": cardIssuer,
            "cardNumber": pan,
            "aplLabel": aplLabel,
            "prefName" : prefName,
            "aid": (txtModel?.aid == nil) ? "" : txtModel?.aid as Any,
            "arqc": (txtModel?.arqc == nil) ? "" : txtModel?.arqc as Any,
            "authorization": txtModel?.authorization as Any,
            "trxAmount": txtModel?.amount as Any,
            "trxTip": tip,
//            "trxTip": (txtModel?.tip == nil) ? "0.00" : txtModel?.tip as Any,
            "trxTotal": txtModel?.total as Any,
            "trxMonths": mwi,
            "cardholder": cardholder,
            "trxSequence": txtModel?.F037 as Any,
            "emailClient": txtModel?.email as Any,
            "cardType": cardType,
            "dateName": txtModel?.dateName as Any,
            "chip": isChipBanda,
            "cardEntryMode": cardEntryMode,
            "hasNIP": modelGlob.Static.txrModel?.authorizationByNIP ?? false as Any,
            "showMap": imageData as Any
        ]
        let archivedFriends = NSKeyedArchiver.archivedData(withRootObject: data)
        var dataGral = NSData()
        
        dataGral = RNCryptor.encrypt(data: archivedFriends, withPaswd: "&QsCxZdEwArTfCgYuHb%$op=lKjnMbHy") as NSData
        
        let voucher = SaveVoucher()
        voucher.voucherIAcepta = DBManagerVoucher.sharedInstance.getDataFromDB().count
        voucher.dateVoucher = dataGral as Data
        voucher.idUserVoucher = (txtSession?.userID == nil) ? "" : txtSession!.userID
        voucher.userNameVoucher = (txtSession?.userNameTxt == nil) ? "" : (txtSession?.userNameTxt)!
        voucher.hasNip = modelGlob.Static.txrModel?.authorizationByNIP ?? false
        DBManagerVoucher.sharedInstance.addData(object: voucher)
        
        if payProcess{
            if modelGlob.Static.txrModel?.authorizationByNIP ?? false{
                performSegue(withIdentifier: "showSucces", sender: self)
            }else{
             performSegue(withIdentifier: "showSignature", sender: self)
            }
        }else{
            performSegue(withIdentifier: "showSucces", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if isLocation{
            printDev(object: "Entro a guarda mapa y eliminar delegate .........")
            saveMap()
            removeMap()
        }
        if segue.identifier == "showRejected"{
            printDev(object: "Fue un rechazo .........")
            disconnected()
            wisepad.cancelTransaction()
            if let destinationVC = segue.destination as? CancellationProcessViewController {
                destinationVC.reasonForRejection = reasonForRejection
                destinationVC.payProcess = payProcess
                destinationVC.resultResponseType = resultResponseType
            }
        }else if segue.identifier == "showSucces"{
            disconnected()
            if let destinationVC = segue.destination as? PayProcessViewController {
                    printDev(object: "Se va a la siguiente pantalla .........")
                    destinationVC.payProcess = payProcess
                    destinationVC.cardNumber = cardNumber
                destinationVC.typeApproved = reasonForRejection
                    //destinationVC.info = succesPayment
            }
        }else if segue.identifier == "showSignature"{
            disconnected()
            if let destinationVC = segue.destination as? SignatureViewController{
                destinationVC.cardNumber = cardNumber
                destinationVC.payProcess = payProcess
                destinationVC.typeApproved = reasonForRejection
            }
        }else if segue.identifier == "goToLoadKeys"{
            if let destinationVC = segue.destination as? LoaderSetupVerifoneViewController{
                destinationVC.statusKeyVerifone = .sendPayment
            }
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
    
    @objc func validateResponseCode(){
        if UserDefaults.standard.string(forKey: "TYPEREADER") == "VERIFONE"{
            let verifoneNot = Notification.Name(self.verifoneResponse)
            NotificationCenter.default.removeObserver(self, name: verifoneNot, object: nil)
            loaderImg.stopAnimating()
            //aqui cae verifone
            let codeVerifone = txtModel?.responseCode
            let authorizationVerifone = txtModel?.authorization
            let datesVerifone = succesPaymentCapX?.allDates
            let resultDatesVerifone = datesVerifone!.components(separatedBy: "|")
            
            if codeVerifone == "00" && resultDatesVerifone.count > 1 && authorizationVerifone?.count == 6 && authorizationVerifone != "000000"  {
                txtModel?.arqc = modelGlob.Static.cardCapituloX?.arqc ?? ""
                if (modelGlob.Static.cardCapituloX?.isEntryModeReader == "Chip"){
                    isEntryModeCapX(result: succesPaymentCapX!, entryMode: "Chip")
                }else{
                    isEntryModeCapX(result: succesPaymentCapX!, entryMode: "Banda")
                }
            }else if !(txtModel?.responseCode == "71"){
        modelGlob.Static.verifoneSDK?.endTransactionWithResponse(response: Constants.declineVerifone, tokenB5: nil, tokenB6: nil)
                let datesVerifone = succesPaymentCapX?.allDates
                let resultDatesVerifone = datesVerifone!.components(separatedBy: "|")
                reasonForRejection = resultDatesVerifone[14]
                performSegue(withIdentifier: "showRejected", sender: self)
            }
            else if (txtModel?.responseCode == "03"){
                let datesVerifone = succesPaymentCapX?.allDates
                let resultDatesVerifone = datesVerifone!.components(separatedBy: "|")
                reasonForRejection = resultDatesVerifone[14]
                    performSegue(withIdentifier: "showRejected", sender: self)
                }
        }
        else{
            if txtModel?.responseCode == "00"{
                chip(result: succesPayment!)
            }
        }
    }
    
    @objc func sendReverse(){
        if UserDefaults.standard.string(forKey: "TYPEREADER") == "VERIFONE"{
            txtModel?.attemptsReverse = (txtModel?.attemptsReverse != nil) ? txtModel!.attemptsReverse! + 1 : 1
            servicesLogic.reverse(reverso())
        }else{
            print("alert")
            servicesLogic.reverse(reverse2())
            reasonForRejection = "rechazo por icc"
        }
    }
    @objc func alertView(){
        alert(alertTitle: "iAcepta", message: "Necesita cargar llaves.", alertBtnFirst: "Aceptar", completion: {
            self.dismiss(animated: true, completion: {
                self.performSegue(withIdentifier: "goToLoadKeys", sender: nil)
            })
        })
    }
}

extension LoaderAnimationProcess:ServicesIAceptaLogicDelegate{
    func reverseResponse(_ responseType: ServicesResponseType, resultResponse: SuccessfulPaymentModel?) {
        resultResponseType = responseType
        if responseType == .DENIED{
            if txtModel?.attemptsReverse ?? 0 <= 3{
                self.sendReverse()
            } else{
                performSegue(withIdentifier: "showRejected", sender: self)
            }
        }else if responseType == .UNAUTHORIZED{
            
        }else if responseType == .SERVICESSUCCESS{
            performSegue(withIdentifier: "showRejected", sender: self)
        }
    }
    
    func servicesResponse(_ responseType: ServicesResponseType, resultResponse: SuccessfulPaymentModel?, resultResponseCapX: SuccessfulPaymentModelVerifone?) {
//        loaderImg.stopAnimating()
        resultResponseType = responseType
        
        if responseType == .UNAUTHORIZED{
            recordTransactionResult(type_transaction: typeTransaction.SELL.stringValue, transaction_result:"UNAUTHORIZED")
            if (mapView != nil){
                removeMap()
            }
            if UserDefaults.standard.string(forKey: "TYPEREADER") == "VERIFONE"{
                if payProcess{
                 modelGlob.Static.verifoneSDK?.cancelTransaction()
                }
            }
            performSegue(withIdentifier: "showRejected", sender: self)
        }else if responseType == .SERVICESSUCCESS{
            recordTransactionResult(type_transaction: typeTransaction.SELL.stringValue, transaction_result:"SERVICESSUCCESS")
            if UserDefaults.standard.string(forKey: "TYPEREADER") == "VERIFONE"{
                if payProcess{
                    modelGlob.Static.txrModel?.responseCode = resultResponseCapX?.responseCode
                    modelGlob.Static.txrModel?.authorization = resultResponseCapX?.authorization
                    succesPaymentCapX = resultResponseCapX
                    
                    NotificationCenter.default.addObserver(self, selector: #selector(self.validateResponseCode), name: Notification.Name(verifoneResponse), object: nil)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.sendReverse), name: Notification.Name(serviceReverse), object: nil)
                    
                    if resultResponseCapX?.responseCode == "00"{
                        self.setCounterEz(counter: 0, restart: true)
                        let tokens = getResponseTokens(dataTokens: resultResponseCapX?.capituloX ?? "")
                        let tokenB5 = (tokens.object(forKey: "B5") == nil) ? nil : tokens.object(forKey: "B5") as? String ?? ""
                        let tokenB6 = (tokens.object(forKey: "B6") == nil) ? nil : tokens.object(forKey: "B6") as? String ?? ""
                        if tokenB5 != nil || tokenB6 != nil{
                            modelGlob.Static.verifoneSDK?.endTransactionWithResponse(response: Constants.authorizedVerifone, tokenB5: tokenB5?.data(using: .utf8) as NSData?, tokenB6: tokenB6?.data(using: .utf8) as NSData?)
                        }else{
                            modelGlob.Static.verifoneSDK?.endTransactionWithResponse(response: Constants.authorizedVerifone, tokenB5: nil, tokenB6: nil)
                        }
                    }else{
                        if resultResponseCapX?.responseCode == "70"{
                            let aux = self.getCounterEz()
                            self.setCounterEz(counter: aux+1, restart: false)
                            modelGlob.Static.verifoneSDK?.endTransactionWithResponse(response: Constants.declineVerifone, tokenB5: nil, tokenB6: nil)
                        }else if resultResponseCapX?.responseCode == "71"{
                            alert(alertTitle: "iAcepta", message: "Necesita cargar llaves.", alertBtnFirst: "Aceptar", completion: {
                                self.dismiss(animated: true, completion: {
                                    self.performSegue(withIdentifier: "goToLoadKeys", sender: nil)
                                })
                            })
                        }else{
                            modelGlob.Static.verifoneSDK?.endTransactionWithResponse(response: Constants.declineVerifone, tokenB5: nil, tokenB6: nil)
                        }
                    }
                }else{
                    if resultResponse?.responseCode == "00"{
                        modelGlob.Static.txrModel?.authorization = resultResponse!.authorization
                        succesPayment = resultResponse
                        performSegue(withIdentifier: "showSucces", sender: self)
                    }else{
                        performSegue(withIdentifier: "showRejected", sender: self)
                    }
                }
            }else{
                if payProcess{
                    
                    NotificationCenter.default.addObserver(self, selector: #selector(self.validateResponseCode), name: Notification.Name(verifoneResponse), object: nil)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.sendReverse), name: Notification.Name(serviceReverse), object: nil)
                    
                    modelGlob.Static.txrModel?.authorization = resultResponse!.authorization
                    modelGlob.Static.txrModel?.responseCode = resultResponse!.responseCode
                    modelGlob.Static.txrModel?.legend = resultResponse!.allDates
                    succesPayment = resultResponse
                    
                    let date = resultResponse?.date
                    if date == nil || helpExt.containsOnlyLetters(input: date!){
                        let date = Date()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateStyle = .medium
                        dateFormatter.timeStyle = .medium

                       modelGlob.Static.txrModel?.dateService = dateFormatter.string(from: date)
                    }else{
                        modelGlob.Static.txrModel?.dateService = helpExt.toDate(string: date!)
                    }
                    //aqui cambio
                    guard let dates = resultResponse?.allDates else {
                        performSegue(withIdentifier: "showRejected", sender: self)
                        return
                    }
                    let authorization = resultResponse?.authorization
                    
                    if dates.isEmpty {
                        performSegue(withIdentifier: "showRejected", sender: self)
//                        return
                    }
                     
                    let resultDates = dates.components(separatedBy: "|")
 
                    if resultResponse?.responseCode == "00" &&  resultDates.count > 1
                    && authorization?.count == 6 && authorization != "000000" && resultResponse?.code == "0210" {
                        if txtCard?.chip == "Banda"{
                            banda(resultDates: resultDates)
                        }else{
                            let dates = resultResponse?.allDates
                            var resultDates = dates!.components(separatedBy: "|")
                            let tlv = resultDates[7]
                            if let tlvPosition = tlv.index(tlv.startIndex, offsetBy: 6, limitedBy: tlv.endIndex){
                                let endTlv = String(tlv[tlvPosition..<tlv.endIndex])
//                                modelGlob.Static.walkerSDK?.sendProcessResult(tlv: endTlv)
                                modelGlob.Static.wisePadSDK?.sendProcessResultWisePad(tlv: endTlv)
//                                validateResponseCode()
                            }
                        }
                    }else{
                        if dates != "Aprobada" && resultResponse?.code != "0430"{
                          let resultDates = dates.components(separatedBy: "|")
                            reasonForRejection = resultDates[8]
                            performSegue(withIdentifier: "showRejected", sender: self)
                        }else{
                            reasonForRejection = "Rechazada por ICC"
                            performSegue(withIdentifier: "showRejected", sender: self)
                        }
                        

                        
                    }
                    
                }else{
                    if resultResponse?.responseCode == "00"{
                        modelGlob.Static.txrModel?.authorization = resultResponse!.authorization
                        succesPayment = resultResponse
                        performSegue(withIdentifier: "showSucces", sender: self)
                    }else{
                        performSegue(withIdentifier: "showRejected", sender: self)
                    }
                }
            }
            
        }else if responseType == .NO_CONNECTION{
            recordTransactionResult(type_transaction: typeTransaction.SELL.stringValue, transaction_result:"NO_CONNECTION")
            alert(alertTitle: "titleAlertWithoutConnection".localized, message: "bodyAlertWithoutConnection".localized, alertBtnFirst: "titleBtnAlert_Accept".localized, completion: {
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    @objc func validates(){
        if payProcess{
            timerPetition?.invalidate()
            timerPetition = nil
            servicesLogic.payment(sendTxn())
        }
    }
}
extension LoaderAnimationProcess:MKMapViewDelegate, CLLocationManagerDelegate{
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region:MKCoordinateRegion = MKCoordinateRegion.init(center: userLocation.coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
        mapView.setRegion(region, animated: true)
        let lastRecordedLocation: MKUserLocation? = userLocation
        if (lastRecordedLocation != nil){
            print("Entra a cooordenadas .....................................")
            modelGlob.Static.txrModel?.latitud = String(format: "%.8f", userLocation.coordinate.latitude)
            modelGlob.Static.txrModel?.longitud = String(format: "%.8f", userLocation.coordinate.longitude)
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc = locations.last
        print(loc as Any)
        locationManager.stopUpdatingLocation()
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        
        if fullyRendered && !isSuccess && isMapLoad{
            isSuccess = true
            self.timerPetition = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.validates), userInfo: nil, repeats: false)
        }
    }
}
