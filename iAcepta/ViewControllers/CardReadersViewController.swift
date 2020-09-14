//
//  CardReadersViewController.swift
//  iAcepta
//
//  Created by QUALITY on 5/30/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto

protocol verifoneSDKDelegate:AnyObject {
    func responseSDK(_ responseType: String)
}

@IBDesignable class CardReadesViewController: MasterViewController {
    
    @IBOutlet weak var headeriAcept: headeriAcepta!
    @IBOutlet weak var viewCardReaders: UIView!
    @IBOutlet weak var card: UIImageView!
    @IBOutlet weak var btnAccept: UIButton!{didSet{btnAccept.setRoundedLayout(button: btnAccept)}}
    @IBOutlet weak var titleInsertLbl: UILabel!
    @IBOutlet weak var progressView: UIProgressView!{didSet{progressView.setAdjustProgress(progress: progressView, colorImg: "color_progressview", cornerRadious: heightConstraint.constant)}}
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var brandImg: UIImageView!
    @IBOutlet weak var holloImg: UIImageView!
    @IBOutlet weak var expDateLabel: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    var removeAnimation = "iAcepta.animationRemove"
    var animationLoader = "iAcepta.animationLoader"
    var animationHide = "iAcepta.animationHide"
    var animationVerifone = "iAcepta.animationVerifone"
    var verifoneResponse = "iAcepta.verifoneResponse"
    var alertResponse = "iAcpeta.alertResponse"
    var serviceReverse = "iAcepta.reverse"
    var animationWisePad = "iAcepta.animationWisePad"
    
    let walker = WalkerReaderManager()
    let verifone = VerifoneReaderManager()
    let wisepad = WisePadReaderManager()
    let delegateTest = CardReadersWalkerViewController()
    let helpExt = HelperExtensions()
    var cardReaderModel:CardWalkerModel?
    var cardVerifone : CapXModel?
    
    var isViewWillAppear:Bool = false
    var allowBand:Bool = false
    
    // MARK:- Delegate
    weak var delegateNew: verifoneSDKDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headeriAcept.lblTitle.text = "titleHeaderPayment".localized
        headeriAcept.btnHome.isHidden = true
        headeriAcept.btnInfo.isHidden = true

        btnAccept.setTitle("btn_continue".localized, for: .normal)
        titleInsertLbl.text = "titleApproximeInsertSlideCard".localized
        progressView.trackTintColor = UIColor.white
        
        if typeReader == "VERIFONE"{
            verifone.delegate = self
        }else if typeReader == "WALKER"{
            viewCardReaderWalker()
            walker.delegate = self
            modelGlob.Static.txrModel?.track2 = "9988776655443322=1100"
            allowBand = false
        }else if typeReader == "WISEPAD"{
            wisepad.delegate = self
        }
        
        isViewWillAppear = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isViewWillAppear{
            isViewWillAppear = false
            let percentage  = 80
            let invertedValue = Float(100 - percentage) / 100
            progressView.setProgress(invertedValue, animated: true)
            btnAccept.isHidden = true
            
            if typeReader == "VERIFONE"{
                btnBack.isHidden = true
                view.layoutSubviews()
                viewCardReaderVerifone()
                verifone.startReaderConnection()
            }else if typeReader == "WALKER"{
                if (walker.deviceConnected) {
                    if walker.cardIn{
                        changeProgressView(percentage: 33)
                        changeTitle(text: "titleReadingCard".localized)
                        animationWalker(arrows: false, terminal: false, card: false, arrowsHide: false, terminalHide: true, cardHide: true)
                    }else{
                        changeProgressView(percentage: 66)
                        changeTitle(text: "titleInsertCard".localized)
                        animationWalker(arrows: true, terminal: false, card: true, arrowsHide: true, terminalHide: true, cardHide: true)
                    }
                }else{
                    animationWalker(arrows: true, terminal: true, card: false, arrowsHide: true, terminalHide: true, cardHide: false)
                    changeProgressView(percentage: 100)
                    
                    walker.ultimoEstado = .FirstState_Types
                    walker.startWalker()
                }
            }else if typeReader == "WISEPAD"{
                changeProgressView(percentage: 66)
                changeTitle(text: "titleApproximeInsertSlideCard".localized) //titleApproximeInsertSlideCard
                viewCardReaderWisePad()
                wisepad.starScan()
            }
        }
    }
    
    //Button
    @IBAction func acceptAction(_ sender: Any) {
        if typeReader == "VERIFONE"{
            if dateTxrVerifone(){
                let not = Notification.Name(self.removeAnimation)
                let aniVerifone = Notification.Name(self.animationVerifone)
                NotificationCenter.default.removeObserver(self, name: not, object: nil)
                NotificationCenter.default.removeObserver(self, name: aniVerifone, object: nil)
                modelGlob.Static.verifoneSDK = verifone
//                self.performSegue(withIdentifier: "toConformationPayment", sender: nil)
                self.performSegue(withIdentifier: "toPayProcess", sender: nil)
            }
        }else if typeReader == "WALKER"{
            animateIndicator(animation: false)
            if (dateTxr()){
                modelGlob.Static.walkerSDK = walker
//                self.performSegue(withIdentifier: "toConformationPayment", sender: nil)
                self.performSegue(withIdentifier: "toPayProcess", sender: nil)
            }
        }else if typeReader == "WISEPAD"{
            if (dateTxr()){
                modelGlob.Static.wisePadSDK = wisepad
//                self.performSegue(withIdentifier: "toConformationPayment", sender: nil)
                self.performSegue(withIdentifier: "toPayProcess", sender: nil)
            }
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        if typeReader == "VERIFONE"{
            verifone.cancelTransaction()
            dismiss(animated: true, completion: nil)
        }else if typeReader == "WALKER"{
            walker.walker2.stopAudio()
            dismiss(animated: true, completion: nil)
        }else if (typeReader == "WISEPAD"){
            wisepad.disconect(setDimiss: true)
//            dismiss(animated: true, completion: nil)
        }
    }
    
    //Functions viewCardReaderVerifone
    func changeReaderVerifone(){
        for v in viewCardReaders.subviews{
            v.removeFromSuperview()
        }
        
        let subview :CardReadersVerifoneViewController = CardReadersVerifoneViewController(frame: CGRect(x: 0, y: 0, width: viewCardReaders.frame.width, height: viewCardReaders.frame.height))
        viewCardReaders.addSubview(subview)
    }
    
    func viewCardReaderVerifone(){
        for v in viewCardReaders.subviews{
            v.removeFromSuperview()
        }
        var viewInf = UIView()
        let car = CardReadersVerifoneViewController()
        viewInf = car.loadViewLoadVerifone()!
        car.setLoaders()
        viewCardReaders.addSubview(viewInf)
        changeTitle(text: "titlwInsert".localized)
    }
    
    func viewCardReaderWalker(){
        for v in viewCardReaders.subviews{
            v.removeFromSuperview()
        }
        
        let subview :CardReadersWalkerViewController = CardReadersWalkerViewController(frame: CGRect(x: 0, y: 0, width: viewCardReaders.frame.width, height: viewCardReaders.frame.height))
        viewCardReaders.addSubview(subview)
    }
    
    func viewCardReaderWisePad(){
        for v in viewCardReaders.subviews{
            v.removeFromSuperview()
        }
        var viewInf = UIView()
        let car = CardReadersWisePadViewController()
        viewInf = car.loadViewLoadWisePad()!
        car.setLoaders()
        changeTitle(text: "titlwInsert".localized)
        viewCardReaders.addSubview(viewInf)
    }
    
    func changeReaderWisePad(){
        for v in viewCardReaders.subviews{
            v.removeFromSuperview()
        }
        let subview :CardReadersWisePadViewController = CardReadersWisePadViewController(frame: CGRect(x: 0, y: 0, width: viewCardReaders.frame.width, height: viewCardReaders.frame.height))
        changeTitle(text: "titleApproximeInsertSlideCard".localized)
        viewCardReaders.addSubview(subview)
    }
    
    func changeAceptButtonWisePad(){
        for v in viewCardReaders.subviews{
            v.removeFromSuperview()
        }
        changeTitle(text: "Confirma el monto en el lector")
        
        if (UIDevice.current.userInterfaceIdiom == .pad){
            let subview :ConfirmationWisepadButtoniPad = ConfirmationWisepadButtoniPad(frame: CGRect(x: 0, y: 0, width: viewCardReaders.frame.width, height: viewCardReaders.frame.height))
            viewCardReaders.addSubview(subview)
        }else{
            let subview :ConfirmationWisepadButton = ConfirmationWisepadButton(frame: CGRect(x: 0, y: 0, width: viewCardReaders.frame.width, height: viewCardReaders.frame.height))
            viewCardReaders.addSubview(subview)
        }
        
    }
    
//    func checkLogoImg(aid:String) -> String{
//        var typeCard:String = ""
//        if (aid == "A0000000031010" || aid == "A0000000032010" || aid == "A0000000032020" || aid == "A0000000038010"){
//            typeCard = "Visa"
//            brandImg.image = UIImage(named: "doveHoll.png")
//            holloImg.image = UIImage(named: "logo_visa")
//        }else if (aid == "A0000000041010" || aid == "A0000000049999" || aid == "A0000000043060" || aid == "A0000000046000"){
//            typeCard = "Mastercard"
//            brandImg.image = UIImage(named: "logo_mcholl.png")
//            holloImg.image = UIImage(named: "master_card")
//        }else if (aid == "A00000002501" || aid == "A000000025010801"){
//            brandImg.image = nil
//            holloImg.image = UIImage(named: "amex_logo.png")
//            validateAMEX()
//        }else{
//
//        }
//        return typeCard
//    }

    
    func dateTxr()-> Bool{
        let random = arc4random()
        let theRandom = String(format: "%u",random)
        let date = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, yy HH:mm:ss"
        modelGlob.Static.txrModel!.date = formatter.string(from: date as Date)
        modelGlob.Static.txrModel?.F007_1 = helpExt.dateInFormat(stringFormat: "%m%d")
        modelGlob.Static.txrModel?.F007_2 = helpExt.dateInFormat(stringFormat: "%H%M%S")
        modelGlob.Static.txrModel?.F037 = String(format: "%@%@",helpExt.dateInFormat(stringFormat: "%H%M%S"),String(theRandom.suffix(6)))
        modelGlob.Static.txrModel?.dateName = helpExt.dateInFormat(stringFormat: "%y%m%d%H%M%S")
        return true
    }
    
    func dateTxrVerifone()-> Bool{
        let random = arc4random()
        let theRandom = String(format: "%u",random)
        let date = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, yy HH:mm:ss"
        modelGlob.Static.txrModel!.date = formatter.string(from: date as Date)
        modelGlob.Static.txrModel?.F037 = String(format: "%@%@",helpExt.dateInFormat(stringFormat: "%H%M%S"),String(theRandom.suffix(6)))
        let dataAll = cardVerifone?.resultData
        let posEntryModeToken = dataAll?.object(forKey: "posEntryMode") as? String ?? ""
        let dataEntrymode = helpExt.isEntryMode(string: posEntryModeToken)
        modelGlob.Static.txrModel?.posEntryMode = dataEntrymode.value(forKey: "postEntryMode") as? String ?? ""
        cardVerifone?.isEntryModeReader = dataEntrymode.value(forKey: "isEntryModeReader") as? String ?? ""
        cardVerifone?.track2 = "1111111111111111=1234"
        modelGlob.Static.cardCapituloX = cardVerifone
        modelGlob.Static.txrModel?.dateName = helpExt.dateInFormat(stringFormat: "%y%m%d%H%M%S")
        
        return true
    }
    
    //Mark func: SharedFunc2Readers
    func selectTypeCard(_ typeCard:String){
        if typeCard == "VISA"{
            brandImg.image = UIImage(named: "doveHoll.png")
            holloImg.image = UIImage(named: "logo_visa")
        }else if typeCard == "MASTERCARD"{
            brandImg.image = UIImage(named: "logo_mcholl.png")
            holloImg.image = UIImage(named: "master_card.png")
        }else if typeCard == "AMEX"{
            brandImg.image = nil
            holloImg.image = UIImage(named: "amex_logo.png")
            validateAMEX()
        }
    }
    
    func validateAMEX(){
        if (!sessionGlob.Static.sessionIAcepta!.canAcceptPayAmex!){
            alert(alertTitle: "Tarjeta no permitida", message: "No tiene permisos para realizar cobros con American Express", alertBtnFirst: "Aceptar", completion: {
                self.dismiss(animated: true, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
            })
        }
        if (sessionGlob.Static.sessionIAcepta?.amexFlag == "OPT" && modelGlob.Static.txrModel?.mwi != "0"){
                modelGlob.Static.txrModel?.mwi = "0"
                alert(alertTitle: "Promoción no permitida", message: "Recuerda que las ventas con AMEX no pueden ser procesadas a Meses Sin Intereses, si continuas con la transacción los Meses Sin Intereses no serán aplicados.", alertBtnFirst: "Aceptar", completion: {
                    self.dismiss(animated: true, completion: nil)
                })
            }
    }
    
    //Mark func: VERIFONE
    func getValuesFromToken(tokenQ9:NSString, tokenB3:NSString, tokenQ8:NSString) -> NSDictionary{
        let applicationLabel = tokenQ9.substring(with: NSRange(location: 10, length: 16))
        let track2:NSString = tokenQ9.substring(with: NSRange(location: 79, length: 40)) as NSString
        let cardholderName = tokenQ9.substring(with: NSRange(location: 218, length: 30))
        let cardnumber = track2.substring(with: NSRange(location: 0, length: 16))
        var aid:String = ""
        var posEntryMode:String = ""
        if (tokenB3.length > 0){
            aid = tokenB3.substring(with: NSRange(location: 58, length: 14))
        }
        if (tokenQ8.length > 0){
            posEntryMode = tokenQ8.substring(with: NSRange(location: tokenQ8.length - 3, length: 3))
        }
        let dicTokens:NSMutableDictionary = ["cardholdername":cardholderName, "cardnumber":cardnumber,"cardtype":applicationLabel,"expdate":"","aplicationID":aid,"posEntryMode":posEntryMode]
        return dicTokens
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
    
    func validateTrack2(track2:String) -> Bool{
        let scanner = Scanner(string: track2)
        var result : UInt32 = 0
        if scanner.scanHexInt32(&result) {
            if (result == UInt32(0.0)){
                return false
            }else{
                return true
            }
        }
        return false
    }
    
    //Func Mark: Segue return
    @IBAction func unwindToReadCard(segue:UIStoryboardSegue) {
            isViewWillAppear = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToLoadKeys"{
            if let destinationVC = segue.destination as? LoaderSetupVerifoneViewController{
                destinationVC.statusKeyVerifone = .sendPayment
            }
        }
        if segue.identifier == "toPayProcess"{
            if let destinationVC = segue.destination as? LoaderAnimationProcess {
                destinationVC.payProcess = true
            }
        }
    }
    
}
extension UIImage{
    convenience init(view: UIView) {
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
        
    }
}
extension CardReadesViewController:sdkResponseDelegate{
    func onRequestDisplayText(result: BBDeviceDisplayText) {
        printDev(object: result)
        if result == .NOT_ICC_CARD {
            self.allowBand = true
        }
    }
    
    
    func changeTitle(text:String) {
        titleInsertLbl.text = text
    }
    
    func animationVerifone(arrows:Bool,  card:Bool, arrowsHide:Bool, cardHide:Bool){
        let value:[String: Bool] = ["arrows": arrows, "card":card, "arrowsHide": arrowsHide, "cardHide":cardHide]
        let notificationName = Notification.Name(self.animationVerifone)
        NotificationCenter.default.post(name: notificationName, object: nil,userInfo: value)
        if(arrows && card){
            changeTitle(text: "titleApproximeInsertSlideCard".localized)
        }
    }
    
    func animationWalker(arrows:Bool, terminal:Bool, card:Bool, arrowsHide:Bool, terminalHide:Bool, cardHide:Bool){
        let value:[String: Bool] = ["arrows": arrows, "terminal":terminal, "card":card, "arrowsHide": arrowsHide, "terminalHide": terminalHide, "cardHide":cardHide]
        let notificationName = Notification.Name(self.removeAnimation)
        NotificationCenter.default.post(name: notificationName, object: nil,userInfo: value)
    }
    
    func animationWisePad(arrows:Bool, terminal:Bool, card:Bool, arrowsHide:Bool, terminalHide:Bool, cardHide:Bool){
        let value:[String: Bool] = ["arrows": arrows, "terminal":terminal, "card":card, "arrowsHide": arrowsHide, "terminalHide": terminalHide, "cardHide":cardHide]
        let notificationName = Notification.Name(self.animationWisePad)
        NotificationCenter.default.post(name: notificationName, object: nil,userInfo: value)
    }
    
    func changeProgressView (percentage:Int){
        let invertedValue = Float(100 - percentage) / 100
        progressView.setProgress(invertedValue, animated: true)
    }
    
    func animateIndicator (animation:Bool){
        let value:[String: Bool] = ["animation": animation]
        let notificationName = Notification.Name(self.animationLoader)
        NotificationCenter.default.post(name: notificationName, object: nil,userInfo: value)
    }
    
    func animateHide (animationHide:Bool){
        let value:[String: Bool] = ["animationHide": animationHide]
        let notificationName = Notification.Name(self.animationHide)
        NotificationCenter.default.post(name: notificationName, object: nil,userInfo: value)
    }
    //insertado
    func onWaitingView(deviceConnected:Bool,cardIn:Bool){
        if (deviceConnected) {
            changeProgressView(percentage: 66)
            if(typeReader == "WISEPAD"){
                changeTitle(text: "titleC".localized)
            }else{
                changeTitle(text: "titleInsertCard".localized)
            }
            animateIndicator(animation: false)
            if(cardIn){
                changeProgressView(percentage: 33)
                changeTitle(text: "titleReadingCard".localized)
                animationWalker(arrows: false, terminal: false, card: false, arrowsHide: false, terminalHide: true, cardHide: true)
            }else{
                changeProgressView(percentage: 66)
                animationWalker(arrows: true, terminal: false, card: true, arrowsHide: true, terminalHide: true, cardHide: true)
            }
        }else{
            changeProgressView(percentage: 100)
            changeTitle(text: "titleInsertReader".localized)
            animationWalker(arrows: true, terminal: true, card: false, arrowsHide: true, terminalHide: true, cardHide: false)
        }
    }
    
    func deviceErrorType(errorType: BBDeviceErrorType?, errorMensaje: String, ultimoEstado: EstadosWalkers?, deviceConnected: Bool) {
        if(deviceConnected){
            changeProgressView(percentage: 66)
            animationWalker(arrows: true, terminal: false, card: true, arrowsHide: true, terminalHide: true, cardHide: true)
        }
        
        switch (ultimoEstado) {
        case .AmountState_Types?:
            alert(alertTitle: "Error", message: "El dispositivo no responde, presione resetear para continuar", alertBtnFirst: "Resetear", completion: {
                self.dismiss(animated: true, completion: nil)
            })
            break;
        case .FirstState_Types?:
            break;
        case .TimeState_Types?:
            alert(alertTitle: "Error", message: "El dispositivo no responde, presione resetear para continuar", alertBtnFirst: "Resetear", completion: {
                self.dismiss(animated: true, completion: nil)
            })
            break;
        case .SelectAppState_Types?:
            alert(alertTitle: "Error", message: "El dispositivo no responde, presione resetear para continuar", alertBtnFirst: "Resetear", completion: {
                self.dismiss(animated: true, completion: nil)
            })
            break;
        case .FinalConfirmState_Types?:
            alert(alertTitle: "Error", message: "El dispositivo no responde, presione resetear para continuar", alertBtnFirst: "Resetear", completion: {
                self.dismiss(animated: true, completion: nil)
            })
            break;
        case .OnlineProcessState_Types?:
            break;
        case .ConfirmControllerState_Types?:
            alert(alertTitle: "Error", message: "regresar a card", alertBtnFirst: "*********", completion: {
                self.dismiss(animated: true, completion: nil)
            })
            break;
        case .PayControllerState_Types?:
            alert(alertTitle: "Error", message: "regresar a card", alertBtnFirst: "*********", completion: {
                self.dismiss(animated: true, completion: nil)
            })
            break;
        case .DeviceNotRespond?:
            alert(alertTitle: "Error", message: "El dispositivo no responde, presione resetear para continuar", alertBtnFirst: "Resetear", completion: {
                self.dismiss(animated: true, completion: nil)
            })
            break;
        case .none:
            printDev(object: "No se encuentra")
        }
        
        switch errorType {
        case .audioRecordingPermissionDenied?:
            alert(alertTitle: "iAcepta", message: "Para poder continuar se necesita permisos.\n Ve a configuración de tu dispositivo, busca la aplicación iAcepta y concedele todos los permisos.", alertBtnFirst: "Continuar", completion: {
                self.dismiss(animated: true, completion: nil)
            })
            walker.walker2.stopAudio()
            walker.walker2.delegate = nil
            walker.walker2.resetSession()
            walker.walker2.release()
            break
        case.invalidInput_InvalidDataFormat?:
            alert(alertTitle: "iAcepta", message: "Error de formato", alertBtnFirst: "Aceptar", completion: {
                self.dismiss(animated: true, completion: nil)
            })
        case .commError?:
            alert(alertTitle: "iAcepta", message: "Resetear Walker", alertBtnFirst: "*************", completion: {
                self.dismiss(animated: true, completion: nil)
            })
        default:
            break
        }
    }//detectado
    func devicePlugged(deviceConnected:Bool,cardIn:Bool){
        if (deviceConnected){
            walker.deviceConnected = true
            changeProgressView(percentage: 66)
            changeTitle(text: "titleInsertCard".localized)
            animateIndicator(animation: true)
            if cardIn{
                changeProgressView(percentage: 33)
                changeTitle(text: "titleReadingCard".localized)
                animationWalker(arrows: false, terminal: false, card: false, arrowsHide: false, terminalHide: true, cardHide: true)
            }else{
                changeProgressView(percentage: 66)
                animationWalker(arrows: true, terminal: false, card: true, arrowsHide: true, terminalHide: true, cardHide: true)
            }
            
        }else{
            changeProgressView(percentage: 100)
            changeTitle(text: "titleInsertReader".localized)
            animationWalker(arrows: true, terminal: true, card: false, arrowsHide: true, terminalHide: true, cardHide: false)
        }
        walker.checkCardAgainAfterBadSwipe()
    }
    
    func deviceUnplugged() {
        walker.deviceConnected = false
        walker.cardIn = false
        animationWalker(arrows: true, terminal: true, card: false, arrowsHide: true, terminalHide: true, cardHide: false)
        changeTitle(text: "titleInsertReader".localized)
        animateIndicator(animation: false)
    }
    
    //detecta
    func deviceDetected() {
        changeProgressView(percentage: 100)
        animationWalker(arrows: true, terminal: true, card: false, arrowsHide: true, terminalHide: true, cardHide: false)
        changeTitle(text: "titleInsertReader".localized)
    }
    
    func onReturnCardResult(result: BBDeviceCheckCardResult, ultimoEstado estadoWalkert: EstadosWalkers, cardData:[AnyHashable : Any]!) {
        switch (result) {
            case .insertedCard:
                walker.cardIn = true
                changeProgressView(percentage: 33)
                changeTitle(text: "titleReadingCard".localized)
                walker.starWithData()
                animationWalker(arrows: false, terminal: false, card: false, arrowsHide: false, terminalHide: true, cardHide: true)
                break;
            case .noCard:
                walker.cardIn = false
                walker.checkCardAgainAfterBadSwipe()
                changeProgressView(percentage: 66)
                changeTitle(text: "titleInsertCard".localized)
                break;
            case .badSwipe:
                alert(alertTitle: "title_alert_error_reader_cardReader".localized, message: "Deslice nuevamente la tarjeta", alertBtnFirst: "Entendido", completion: {
                    self.walker.checkCardAgainAfterBadSwipe()
                    self.dismiss(animated: true, completion: nil)
                })
                break;
            case .magHeadFail:
                break;
            case .notIccCard:
                changeProgressView(percentage: 66) // walker
                changeTitle(text: "titleInsertCard".localized)
                allowBand = true
                alert(alertTitle: "title_alert_iccCard".localized, message: "msg_alert_iccCard".localized, alertBtnFirst: "titleBtnAlert_Accept".localized, completion: {
                    self.walker.checkCardAgainAfterBadSwipe()
                    self.dismiss(animated: true, completion: nil)
                })
                break;
            case .swipedCard:
                let aceptBand = sessionGlob.Static.sessionIAcepta?.canAcceptPayToBad ?? false
                if aceptBand == true{
                    alert(alertTitle: "title_alert_bandRestriction_cardReader".localized, message: "msg_alert_bandRestriction_cardReader".localized, alertBtnFirst: "titleBtnAlert_Accept".localized, completion: {
                        self.walker.checkCardAgainAfterBadSwipe()
                        self.dismiss(animated: true, completion: nil)
                    })
                }else{
                    if cardData != nil{
                        let serviceCode = Int(cardData?["serviceCode"] as? String ?? "") ?? 0
                        if ((serviceCode >= 200 && serviceCode < 300) || (serviceCode >= 600 && serviceCode < 700)) && allowBand == false{
                            alert(alertTitle: "title_alert_chip_cardReader".localized, message: "msg_alert_chipCard_cardReader".localized, alertBtnFirst: "titleBtnAlert_Accept".localized, completion: {
                                self.walker.checkCardAgainAfterBadSwipe()
                                self.dismiss(animated: true, completion: nil)
                            })
                        }else{
                            if cardData?["maskedPAN"] == nil{
                                alert(alertTitle: "title_alert_readError_cardReader".localized, message: "msg_alert_noInfoCard_cardReader".localized, alertBtnFirst: "titleBtnAlert_Accept".localized, completion: {
                                    self.walker.checkCardAgainAfterBadSwipe()
                                    self.dismiss(animated: true, completion: nil)
                                })
                            }else if (!validateTrack2(track2: cardData?["encTrack2"] as? String ?? "")){
                                alert(alertTitle:"title_alert_readError_cardReader".localized, message: "msg_alert_noInfoCard_cardReader".localized, alertBtnFirst: "titleBtnAlert_Accept".localized, completion: {
                                    self.walker.checkCardAgainAfterBadSwipe()
                                    self.dismiss(animated: true, completion: nil)
                                })
                            }else{
                                let responseSDK:CardWalkerBand = CardWalkerBand(json: cardData as! [String : Any])
                                walker.sdkResponseDevice(nil, nil, responseSDK)
                                animationWalker(arrows: false, terminal: false, card: false, arrowsHide: false, terminalHide: true, cardHide: true)
                                changeProgressView(percentage: 1)
                            }
                        }
                    }
                }
                break;
            case .useIccCard:
                break;
            default:
                break;
        }
    }
    
    func onReturnTransactionResult(result: BBDeviceTransactionResult, ultimoEstado estadoWalkert: EstadosWalkers) {
        switch result {
        case BBDeviceTransactionResult.approved:
            printDev(object: "BBDeviceTransactionResult")
            let notificationName = Notification.Name(self.verifoneResponse)
            NotificationCenter.default.post(name: notificationName, object: nil)
        case BBDeviceTransactionResult.terminated:
            switch (estadoWalkert) {
            case EstadosWalkers.AmountState_Types:
                break;
            case EstadosWalkers.TimeState_Types:
                break;
            case EstadosWalkers.SelectAppState_Types:
                alert(alertTitle: "title_alert_error_cardReaders".localized, message: "body_alert_invalidaCard_cardReaders".localized, alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
                break;
            case EstadosWalkers.FinalConfirmState_Types:
                alert(alertTitle: "title_alert_error_cardReaders".localized, message: "body_alert_cardReadingError_cardReader".localized, alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
                break;
            case EstadosWalkers.OnlineProcessState_Types:
                alert(alertTitle: "title_exhaustedTime_aler_cardReaders".localized, message: "body_alert_timeOut_cardReader".localized, alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
                break;
            case EstadosWalkers.ConfirmControllerState_Types:
                alert(alertTitle: "title_exhaustedTime_aler_cardReaders".localized, message: "Voy a regresar a ConfirmationViewController", alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
            case EstadosWalkers.PayControllerState_Types:
                alert(alertTitle: "title_exhaustedTime_aler_cardReaders".localized, message: "PayControllerState_Types", alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
            default:
                break
            }
            
        case BBDeviceTransactionResult.declined:
            switch (estadoWalkert) {
            case EstadosWalkers.AmountState_Types:
                alert(alertTitle: "title_alert_error_cardReaders".localized, message: "Error en el monto", alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
                break;
            case EstadosWalkers.TimeState_Types:
                break;
            case EstadosWalkers.SelectAppState_Types:
                alert(alertTitle: "title_alert_error_cardReaders".localized, message: "Aplicación de tarjeta inválida, tarjeta declinada", alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
                break;
            case EstadosWalkers.FinalConfirmState_Types:
                alert(alertTitle: "title_alert_error_cardReaders".localized, message: "Tarjeta declinada", alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
                break;
            case EstadosWalkers.OnlineProcessState_Types:
                alert(alertTitle: "Tiempo Agotado", message: "Se terminó el tiempo de espera, reinicie la transacción", alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
                break;
            case EstadosWalkers.ConfirmControllerState_Types:
                alert(alertTitle: "AlertAlerta", message: "Regresar a Read Card", alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
                break;
            case EstadosWalkers.PayControllerState_Types:
                alert(alertTitle: "AlertAlerta", message: "Ver validacion..", alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
                break;
            default:
                break
            }
            
        case BBDeviceTransactionResult.applicationBlocked:
            alert(alertTitle: "title_alert_error_cardReaders".localized, message: "body_alert_cardReadingError_cardReader".localized, alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                self.dismiss(animated: true, completion: nil)
            })
            break
            
        case BBDeviceTransactionResult.capkFail:
            alert(alertTitle: "title_alert_error_cardReaders".localized, message: "body_alert_cardReadingError_cardReader".localized, alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                self.dismiss(animated: true, completion: nil)
            })
            break
            
        case BBDeviceTransactionResult.notIcc:
            alert(alertTitle: "title_alert_error_cardReaders".localized, message: "body_alert_cardReadingError_cardReader".localized, alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                self.dismiss(animated: true, completion: nil)
            })
            break
            
        case BBDeviceTransactionResult.cardBlocked:
            alert(alertTitle: "title_errorCard_cardReader".localized, message: "body_alert_tryDifferentCard_cardReader".localized, alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                self.dismiss(animated: true, completion: nil)
            })
            break
            
        case BBDeviceTransactionResult.noEmvApps:
            alert(alertTitle: "title_alert_error_chip_cardReader".localized, message: "body_alert_chipDefective_cardReader".localized, alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                self.allowBand = true
                self.dismiss(animated: true, completion: nil)
            })
            break
            
        case BBDeviceTransactionResult.cardNotSupported:
            alert(alertTitle: "title_alert_error_cardReaders".localized, message: "body_alert_cardReadingError_cardReader".localized, alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                self.dismiss(animated: true, completion: nil)
            })
            break
            
        case BBDeviceTransactionResult.canceledOrTimeout:
            alert(alertTitle: "title_alert_error_cardReaders".localized, message: "body_alert_cardReadingError_cardReader".localized, alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                self.dismiss(animated: true, completion: nil)
            })
            break
            
        case BBDeviceTransactionResult.conditionsOfUseNotSatisfied:
            alert(alertTitle: "title_alert_error_cardReaders".localized, message: "body_alert_cardReadingError_cardReader".localized, alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                self.dismiss(animated: true, completion: nil)
            })
            break
            
        case BBDeviceTransactionResult.deviceError:
            alert(alertTitle: "title_alert_error_cardReaders".localized, message: "body_alert_errorDevice_cardReader".localized, alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                self.dismiss(animated: true, completion: nil)
            })
            break
            
        case BBDeviceTransactionResult.invalidIccData:
            alert(alertTitle: "title_alert_error_cardReaders".localized, message: "body_alert_cardReadingError_cardReader".localized, alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                self.dismiss(animated: true, completion: nil)
            })
            break
            
        case BBDeviceTransactionResult.missingMandatoryData:
            alert(alertTitle: "title_alert_error_cardReaders".localized, message: "body_alert_cardReadingError_cardReader".localized, alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                self.dismiss(animated: true, completion: nil)
            })
        default:
            break
        }
    }
    
    func batteryStatus(isBaterryStatus:BBDeviceBatteryStatus) {
        alert(alertTitle: "title_alert_batteryLow_cardReader".localized, message: "body_alert_batteryLow_cardReader".localized, alertBtnFirst: "btn_understood".localized, completion: {
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func setValueFromModel(cardModel:CardWalkerModel?, isChipBanda:String?=""){
        
        changeProgressView(percentage: 1)
        titleInsertLbl.text = "titleFinishedReading".localized
        btnAccept.isHidden = false
        animationWalker(arrows: false, terminal: false, card: false, arrowsHide: false, terminalHide: true, cardHide: true)
        helpExt.setAnimation(button: btnAccept, view: view, timeDuration: 1.4)
        
//        if let pan = cardModel?.pan!.replacingOccurrences(of: "F", with: ""){
//            let lastNumber = pan.suffix(4)
//            cardLabel.text = String(format: "**** **** **** %@", String(lastNumber))
//        }
        let lastNumber = cardModel?.pan!.suffix(4)
        cardLabel.text = String(format: "**** **** **** %@", String(lastNumber!))
        if let name = cardModel?.cardHolder{
            nameLabel.text = name
        }
        if let typeCard = cardModel?.typeCard{
            selectTypeCard(typeCard.uppercased())
        }else{
            let cardLogo = helpExt.typeCardLogo(typeCard: cardModel!.pan!)
            switch cardLogo {
                case "Visa":
                brandImg.image = UIImage(named: "doveHoll.png")
                holloImg.image = UIImage(named: "logo_visa")
                case "MasterCard":
                brandImg.image = UIImage(named: "logo_mcholl.png")
                holloImg.image = UIImage(named: "master_card")
                case "Amex":
                brandImg.image = nil
                holloImg.image = UIImage(named: "amex_logo.png")
                validateAMEX()
                case "Maestro":
                brandImg.image = nil
                holloImg.image = UIImage(named: "amex_logo.png")
                case "Diners":
                brandImg.image = nil
                holloImg.image = UIImage(named: "logo_diners.png")
                case "JBC":
                brandImg.image = nil
                holloImg.image = UIImage(named: "logo_jcb.png")
                case "Discovery":
                brandImg.image = nil
                holloImg.image = UIImage(named: "logo_discovery.png")
            default:
                brandImg.image = nil
                holloImg.image = nil
            }
//            if let checkLogo = cardModel?.aid{
//                if checkLogo != ""{
//                    cardModel?.typeCard = checkLogoImg(aid: checkLogo)
//                }
//            }
        }
        
        if let expDate:NSString = cardModel?.expDate as NSString?{
            let firstBlock = expDate.substring(with: NSRange(location: 2, length: 2))
            let secondBlock = expDate.substring(with: NSRange(location: 0, length: 2))
            expDateLabel.text = String(format: "%@/%@", firstBlock,secondBlock)
        }
        
        modelGlob.Static.cardReaderModel = cardModel
        if cardModel?.walker != "" || cardModel?.walker != nil{
            modelGlob.Static.cardReaderModel?.walker = cardModel?.walker
        }
        if isChipBanda == "S"{
            if let serviceCode = cardModel?.serviceCode{
                if (serviceCode >= 200 && serviceCode<300) || (serviceCode>=600&&serviceCode<700){
                    modelGlob.Static.txrModel?.posEntryMode = "802"
                }else{
                    modelGlob.Static.txrModel?.posEntryMode = "902"
                }
            }
            modelGlob.Static.cardReaderModel?.track2 = cardModel?.track2
            modelGlob.Static.cardReaderModel?.track1 = cardModel?.track1
        }else if isChipBanda == "C"{
            modelGlob.Static.txrModel?.posEntryMode = "052"
            modelGlob.Static.cardReaderModel?.track2 = "9988776655443322=1100"
        }
        modelGlob.Static.cardReaderModel?.cardEntryMode = isChipBanda
        modelGlob.Static.cardReaderModel?.isNipValidation = false
    }
}
extension CardReadesViewController:verifoneResponseDelegate{
    func evoApiEncryptionInitialized(_ success: Bool, error: String!, code: String!, tokenEW: Data!, tokenES: Data!) {
        printDev(object: "evoApiEncryptionInitialized  no debe entrar")
    }
    
    func evoApiTransactionEnded(_ success: Bool, error: String!, code: String!, cryptogramType: CryptogramType, authResponse: String!) {
        if success{
            let postEntryMode = modelGlob.Static.txrModel?.posEntryMode ?? ""
            if postEntryMode == Constants.POSENTRYMODE_VERIFONE{
                if modelGlob.Static.txrModel?.responseCode == "00"{
                    if cryptogramType.rawValue == 1 || cryptogramType.rawValue == 0 || cryptogramType.rawValue == nil {
//                        modelGlob.Static.cardCapituloX?.isEntryModeReader = "Chip"
//                        modelGlob.Static.cardCapituloX?.cardEntryMode = "C"
                        let notificationName = Notification.Name(self.verifoneResponse)
                        NotificationCenter.default.post(name: notificationName, object: nil)
                        UserDefaults.standard.set(0, forKey: "counterEZ")
                    }else{
                        modelGlob.Static.txrModel?.legend = "VENTA CANCELADA EN LÍNEA"
                        modelGlob.Static.txrModel?.responseCode = "01"
                        let notificationName = Notification.Name(self.serviceReverse)
                        NotificationCenter.default.post(name: notificationName, object: nil)
                    }
                }else{
                    let notificationName = Notification.Name(self.verifoneResponse)
                    NotificationCenter.default.post(name: notificationName, object: nil)
                }
            }else{
                if modelGlob.Static.txrModel?.responseCode != nil{
                    if modelGlob.Static.txrModel?.responseCode == "00"{
                        if postEntryMode == Constants.POSENTRYMODE_VERIFONE_SWIPE{
                            modelGlob.Static.cardCapituloX?.isEntryModeReader = "Banda"
                            modelGlob.Static.cardCapituloX?.cardEntryMode = "S"
                        }else if postEntryMode == Constants.POSENTRYMODE_VERIFONE_FALLBACK{
                            modelGlob.Static.cardCapituloX?.isEntryModeReader = "Banda"
                            modelGlob.Static.cardCapituloX?.cardEntryMode = "S"
                        }else if postEntryMode == Constants.POSENTRYMODE_VERIFONE_CONTACTLESS{
                            modelGlob.Static.cardCapituloX?.isEntryModeReader = "Chip"
                            modelGlob.Static.cardCapituloX?.cardEntryMode = "C"
                        }
                        let notificationName = Notification.Name(self.verifoneResponse)
                        NotificationCenter.default.post(name: notificationName, object: nil)
                    }else{
                        let notificationName = Notification.Name(self.verifoneResponse)
                        NotificationCenter.default.post(name: notificationName, object: nil)
                    }
                }
            }
        }else{
            if code == "11"{
                let notificationName = Notification.Name(self.alertResponse)
                NotificationCenter.default.post(name: notificationName, object: nil)
            }
        }
    }
    
    func isConnect(success: Bool) {
        if success{
            changeProgressView(percentage: 50)
            self.changeReaderVerifone()
            let total = modelGlob.Static.txrModel?.total ?? "00"
            if let amount:Double = Double(total.replacingOccurrences(of: ",", with: "")){
                animationVerifone(arrows: true, card: true, arrowsHide: true, cardHide: true)
                verifone.startTransactionWithAmount(withTimeout: 60, txrType: Purchase, amount: amount)
            }
        }else{
            changeProgressView(percentage: 100)
            alert(alertTitle: "iAcepta", message: "Lector no disponible.", alertBtnFirst: "Aceptar", completion: {
                self.dismiss(animated: true, completion: {
                    
                    self.dismiss(animated: true, completion: nil)
                })
            })
            
            animationVerifone(arrows: false, card: false, arrowsHide: false, cardHide: true)
        }
    }
    func evotTxrStarted(_ success: Bool, error: String!, code: String!, tokenB2: Data!, tokenB3: Data!, tokenB4: Data!, tokenQ8: Data!, tokenQ9: Data!, tokenEY: Data!, tokenEZ: Data!, tokenES: Data!, tokenC0: Data!, tokenQE: Data!, tokenCZ: Data!) {
        
        if success{
            btnBack.isHidden = false
            let utilitiesInfo = UtilitiesVerifone()
            let date_tokenB2 = (tokenB2 != nil) ? utilitiesInfo.string(fromHexString: hexStringWithData(datag: tokenB2 as NSData)) : ""
            let date_tokenB3 = (tokenB3 != nil) ? utilitiesInfo.string(fromHexString: hexStringWithData(datag: tokenB3 as NSData)) : ""
            let date_tokenB4 = (tokenB4 != nil) ? utilitiesInfo.string(fromHexString:hexStringWithData(datag: tokenB4 as NSData)) : ""
            let date_tokenQ8 = (tokenQ8 != nil) ? utilitiesInfo.string(fromHexString:hexStringWithData(datag: tokenQ8 as NSData)) : ""
            let date_tokenQ9 = (tokenQ9 != nil) ? utilitiesInfo.string(fromHexString:hexStringWithData(datag: tokenQ9 as NSData)) : ""
            let date_tokenEY = (tokenEY != nil) ? utilitiesInfo.string(fromHexString:hexStringWithData(datag: tokenEY as NSData)) : ""
            var date_tokenEZ = (tokenEZ != nil) ? utilitiesInfo.string(fromHexString:hexStringWithData(datag: tokenEZ as NSData)) : ""
            let date_tokenES = (tokenES != nil) ? utilitiesInfo.string(fromHexString:hexStringWithData(datag: tokenES as NSData)) : ""
            let date_tokenC0 = (tokenC0 != nil) ? utilitiesInfo.string(fromHexString:hexStringWithData(datag: tokenC0 as NSData)) : ""
            let date_tokenQE = (tokenQE != nil) ? utilitiesInfo.string(fromHexString:hexStringWithData(datag: tokenQE as NSData)) : ""
            let date_tokenCZ = (tokenCZ != nil) ? utilitiesInfo.string(fromHexString:hexStringWithData(datag: tokenCZ as NSData)) : ""
            let dataAll:NSDictionary = self.getValuesFromToken(tokenQ9: date_tokenQ9 as NSString? ?? "" , tokenB3: date_tokenB3 as NSString? ?? "", tokenQ8: date_tokenQ8 as NSString? ?? "")
            
            let hasNIP = (date_tokenQ8 as NSString? ?? "").substring(with: NSMakeRange(31, 1))
            if (hasNIP == "1" || (hasNIP == "2")){
                modelGlob.Static.txrModel?.authorizationByNIP  = true
            }
            
            var aid:String = ""
            var arqc:String = ""
            if (date_tokenB3 != nil && date_tokenB3 != ""){
                aid = (date_tokenB3 as NSString? ?? "").substring(with: NSMakeRange(58, 14))
            }
            
            if (date_tokenB2 != nil && date_tokenB2 != ""){
                arqc = (date_tokenB2 as NSString? ?? "").substring(with: NSMakeRange(30, 16))
            }
            
            
            
            let tokenEZCount = String(format: "%02ld", getCounterEz())
            date_tokenEZ = (date_tokenEZ as NSString? ?? "").replacingCharacters(in: NSMakeRange(37, 2), with: tokenEZCount)
            
            let tokens = String(format: "%@%@%@%@%@%@%@%@%@%@%@", date_tokenB2 ?? "",date_tokenB3 ?? "",date_tokenB4 ?? "",date_tokenQ8 ?? "", date_tokenQ9 ?? "", date_tokenEY ?? "", date_tokenEZ ?? "", date_tokenES ?? "", date_tokenC0 ?? "", date_tokenQE ?? "", date_tokenCZ ?? "")
            let cardHolder:String = dataAll.object(forKey: "cardholdername") as? String ?? ""
            let pan:String = dataAll.object(forKey: "cardnumber") as? String ?? ""
            
            let verifoneID = (date_tokenES as NSString? ?? "")?.substring(with: NSMakeRange(31, 20))
            UserDefaults.standard.set(verifoneID, forKey: "VerifoneID")
            
            cardVerifone = CapXModel(resultData: dataAll, tokenB2: date_tokenB2, tokenB3: date_tokenB3, tokenB4: date_tokenB4, tokenQ8: date_tokenQ8, tokenQ9: date_tokenQ9, tokenEY: date_tokenEY, tokenEZ: date_tokenEZ, tokenES: date_tokenES, tokenC0: date_tokenC0, tokenQE: date_tokenQE, tokenCZ: date_tokenCZ, aid: aid, arqc: arqc, tokens: tokens, cardHolder: cardHolder, pan: pan)
            
            let swipeCheck = (date_tokenQ8 as NSString? ?? "").substring(from: (date_tokenQ8!.count) - 3)
            
            btnAccept.isHidden = false
            cardLabel.isHidden = false
            nameLabel.isHidden = false
            holloImg.isHidden = false
            brandImg.isHidden = false
            
            var entry_mode:String = ""

            switch dataAll.object(forKey: "posEntryMode") as? String {
                case "901":
                entry_mode = "MSR"
                case "801":
                entry_mode = "BOTH"
                case "071":
                entry_mode = "CONTACTLESS"
            default:
                entry_mode = "ISC"
            }
            
            recordEndCardReader(brand_card: dataAll.object(forKey: "cardtype") as? String ?? "", entry_mode: entry_mode, type_reader: typeReader)
            
            if (swipeCheck.contains("90")){
                if sessionGlob.Static.sessionIAcepta!.canAcceptPayToBad!{
                    alert(alertTitle: "Restricción de banda", message: "El comercio no tiene permitida la lectura de banda, inserte chip.", alertBtnFirst: "Aceptar", completion: {
                        self.dismiss(animated: true, completion:nil)
                    })
                    btnAccept.isHidden = true
                    btnBack.isHidden = true
                }else{
                    setValueCapXToModel(data: dataAll)
                }
            }else{
                    setValueCapXToModel(data: dataAll)
            }
        }else{
            changeProgressView(percentage: 100)
            var message = error ?? ""
            
            if code == "11"{
                message = "Necesita cargar llaves."
                alert(alertTitle: "iAcepta", message: message, alertBtnFirst: "Aceptar", completion: {
                    self.dismiss(animated: true, completion: {
                        modelGlob.Static.verifoneSDK = self.verifone
                        self.performSegue(withIdentifier: "goToLoadKeys", sender: nil)
                    })
                })
            }else{
                alert(alertTitle: "iAcepta", message: error, alertBtnFirst: "Aceptar", completion: {
                    self.dismiss(animated: true, completion: {
                        self.dismiss(animated: true) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    })
                })
            }
        
        }
        animationVerifone(arrows: false, card: false, arrowsHide: false, cardHide: true)
    }
    
    func setValueCapXToModel(data:NSDictionary){
        let cardNumber = data.object(forKey: "cardnumber") as? String ?? ""
        //let cardtype = cardNumber.typeCard
        let cardtype = cardNumber.typeCardNew(typeReader: .Verifone)
        
        cardVerifone?.cardType = cardtype
        nameLabel.text = data.object(forKey: "cardholdername") as? String ?? ""
        changeTitle(text: "titleFinishedReading".localized)
        
        cardLabel.text = String(format: "**** **** **** %@", (cardNumber as NSString? ?? "").substring(with: NSMakeRange(12, 4)))
        
        selectTypeCard(cardtype.uppercased())
        changeProgressView(percentage: 1)
        helpExt.setAnimation(button: btnAccept, view: view, timeDuration: 1.4)
        
    }
}
extension CardReadesViewController:sdkWisePadResponse{
    func onWaitingViewWisePad(deviceConnected:Bool,cardIn:Bool){
        
    }
    
    func deviceErrorTypeWisePad(errorType:BBDeviceErrorType?, errorMensaje:String, ultimoEstado:StatusWisepad?,deviceConnected:Bool){
       switch errorType {
       
       case.invalidInput_InvalidDataFormat?:
           alert(alertTitle: "iAcepta", message: "Error de formato", alertBtnFirst: "Aceptar", completion: {
               self.dismiss(animated: true, completion: nil)
           })
       default:
           break
       }
    }
    
    func onReturnCardResultWisePad(result:BBDeviceCheckCardResult, ultimoEstado:StatusWisepad, cardData:[AnyHashable : Any]!){
        printDev(object: "onReturn -- \(result)")
        switch (result) {
        case .insertedCard:
            wisepad.cardIn = true
            changeProgressView(percentage: 33)
            changeTitle(text: "titleReadingCard".localized)
            wisepad.starWithData()
            animationWisePad(arrows: false, terminal: false, card: false, arrowsHide: false, terminalHide: true, cardHide: true)
            break;
        case .noCard:
            wisepad.cardIn = false
            wisepad.checkCard()
            changeProgressView(percentage: 66)
            changeTitle(text: "titleInsertCard".localized)
            break;
        case .badSwipe:
            alert(alertTitle: "title_alert_error_reader_cardReader".localized, message: "Deslice nuevamente la tarjeta", alertBtnFirst: "Entendido", completion: {
                self.wisepad.checkCard()
                self.dismiss(animated: true, completion: nil)
            })
            break;
        case .magHeadFail:
            break;
        case .notIccCard:
            changeProgressView(percentage: 66)
            changeTitle(text: "titleInsertCard".localized)
            allowBand = true
            alert(alertTitle: "title_alert_iccCard".localized, message: "msg_alert_iccCard".localized, alertBtnFirst: "titleBtnAlert_Accept".localized, completion: {
                self.wisepad.checkCard()
                self.dismiss(animated: true, completion: nil)
            })
            break;
        case .swipedCard:
            let aceptBand = sessionGlob.Static.sessionIAcepta?.canAcceptPayToBad ?? false
            if aceptBand == true{
                alert(alertTitle: "title_alert_bandRestriction_cardReader".localized, message: "msg_alert_bandRestriction_cardReader".localized, alertBtnFirst: "titleBtnAlert_Accept".localized, completion: {
                    self.wisepad.checkCard()
                    self.dismiss(animated: true, completion: nil)
                })
            }else{
                if cardData != nil{
                    let serviceCode = cardData?["serviceCode"] as? String ?? ""
                    if (serviceCode.hasPrefix("2") || serviceCode.hasPrefix("6")) && !allowBand {
                        alert(alertTitle: "title_alert_chip_cardReader".localized, message: "msg_alert_chipCard_cardReader".localized, alertBtnFirst: "titleBtnAlert_Accept".localized, completion: {
                            self.wisepad.checkCard()
                            self.dismiss(animated: true, completion: nil)
                        })
                    }else{
                        if cardData?["maskedPAN"] == nil{
                            alert(alertTitle: "title_alert_readError_cardReader".localized, message: "msg_alert_noInfoCard_cardReader".localized, alertBtnFirst: "titleBtnAlert_Accept".localized, completion: {
                                self.wisepad.checkCard()
                                self.dismiss(animated: true, completion: nil)
                            })
                        }else if (!validateTrack2(track2: cardData?["encTrack2"] as? String ?? "")){
                            alert(alertTitle:"title_alert_readError_cardReader".localized, message: "msg_alert_noInfoCard_cardReader".localized, alertBtnFirst: "titleBtnAlert_Accept".localized, completion: {
                                self.wisepad.checkCard()
                                self.dismiss(animated: true, completion: nil)
                            })
                        }else{
                            let responseSDK:CardWalkerBand = CardWalkerBand(json: cardData as! [String : Any])
                            wisepad.sdkResponseDevice(nil, nil, responseSDK)
                            animationWisePad(arrows: false, terminal: false, card: false, arrowsHide: false, terminalHide: true, cardHide: true)
                            changeProgressView(percentage: 1)
                        }
                    }
                }
            }
            break;
        case .useIccCard:
            break;
        default:
            break;
        }
    }
    
    func onReturnTransactionResultWisePad(result: BBDeviceTransactionResult, ultimoEstado Wisepad: StatusWisepad){
        switch result {
            case BBDeviceTransactionResult.iccCardRemoved:
                print("tarjeta retirada")
                let notificationName = Notification.Name(self.serviceReverse)
                NotificationCenter.default.post(name: notificationName, object: nil)
            break
        case BBDeviceTransactionResult.approved:
            printDev(object: "BBDeviceTransactionResult")
            let notificationName = Notification.Name(self.verifoneResponse)
            NotificationCenter.default.post(name: notificationName, object: nil)
        case BBDeviceTransactionResult.terminated:
            switch (Wisepad) {
            case StatusWisepad.AmountState_Types:
                break;
            case StatusWisepad.TimeState_Types:
                break;
            case StatusWisepad.SelectAppState_Types:
                alert(alertTitle: "title_alert_error_cardReaders".localized, message: "body_alert_invalidaCard_cardReaders".localized, alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
                break;
            case StatusWisepad.FinalConfirmState_Types:
                alert(alertTitle: "title_alert_error_cardReaders".localized, message: "body_alert_cardReadingError_cardReader".localized, alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
                break;
            case StatusWisepad.OnlineProcessState_Types:
                alert(alertTitle: "title_exhaustedTime_aler_cardReaders".localized, message: "body_alert_timeOut_cardReader".localized, alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
                break;
            case StatusWisepad.ConfirmControllerState_Types:
                alert(alertTitle: "title_exhaustedTime_aler_cardReaders".localized, message: "Voy a regresar a ConfirmationViewController", alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
            case StatusWisepad.PayControllerState_Types:
                alert(alertTitle: "title_exhaustedTime_aler_cardReaders".localized, message: "PayControllerState_Types", alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
            default:
                break
            }
            
        case BBDeviceTransactionResult.declined:
            switch (Wisepad) {
            case StatusWisepad.AmountState_Types:
                alert(alertTitle: "title_alert_error_cardReaders".localized, message: "Error en el monto", alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
                break;
            case StatusWisepad.TimeState_Types:
                break;
            case StatusWisepad.SelectAppState_Types:
                alert(alertTitle: "title_alert_error_cardReaders".localized, message: "Aplicación de tarjeta inválida, tarjeta declinada", alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
                break;
            case StatusWisepad.FinalConfirmState_Types:
                alert(alertTitle: "title_alert_error_cardReaders".localized, message: "Tarjeta declinada", alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
                break;
            case StatusWisepad.OnlineProcessState_Types:
                alert(alertTitle: "Tiempo Agotado", message: "Se terminó el tiempo de espera, reinicie la transacción", alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
                break;
            case StatusWisepad.ConfirmControllerState_Types:
                alert(alertTitle: "AlertAlerta", message: "Regresar a Read Card", alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
                break;
            case StatusWisepad.PayControllerState_Types:
                alert(alertTitle: "AlertAlerta", message: "Ver validacion..", alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
                break;
            default:
                break
            }
            
        case BBDeviceTransactionResult.applicationBlocked:
            alert(alertTitle: "title_alert_error_cardReaders".localized, message: "body_alert_cardReadingError_cardReader".localized, alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                self.dismiss(animated: true, completion: nil)
            })
            break
            
        case BBDeviceTransactionResult.capkFail:
            alert(alertTitle: "title_alert_error_cardReaders".localized, message: "body_alert_cardReadingError_cardReader".localized, alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                self.dismiss(animated: true, completion: nil)
            })
            break
            
        case BBDeviceTransactionResult.notIcc:
            alert(alertTitle: "title_alert_error_cardReaders".localized, message: "body_alert_cardReadingError_cardReader".localized, alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                self.dismiss(animated: true, completion: nil)
            })
            break
            
        case BBDeviceTransactionResult.cardBlocked:
            alert(alertTitle: "title_errorCard_cardReader".localized, message: "body_alert_tryDifferentCard_cardReader".localized, alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                self.dismiss(animated: true, completion: nil)
            })
            break
            
        case BBDeviceTransactionResult.noEmvApps:
            alert(alertTitle: "title_alert_error_chip_cardReader".localized, message: "body_alert_chipDefective_cardReader".localized, alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                self.allowBand = true
                self.dismiss(animated: true, completion: nil)
            })
            break
            
        case BBDeviceTransactionResult.cardNotSupported:
            alert(alertTitle: "title_alert_error_cardReaders".localized, message: "body_alert_cardReadingError_cardReader".localized, alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                self.dismiss(animated: true, completion: nil)
            })
            break
            
        case BBDeviceTransactionResult.canceledOrTimeout:
            alert(alertTitle: "title_alert_error_cardReaders".localized, message: "body_alert_cardReadingError_cardReader".localized, alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                self.dismiss(animated: true, completion: nil)
            })
            break
            
        case BBDeviceTransactionResult.conditionsOfUseNotSatisfied:
            alert(alertTitle: "title_alert_error_cardReaders".localized, message: "body_alert_cardReadingError_cardReader".localized, alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                self.dismiss(animated: true, completion: nil)
            })
            break
            
        case BBDeviceTransactionResult.deviceError:
            alert(alertTitle: "title_alert_error_cardReaders".localized, message: "body_alert_errorDevice_cardReader".localized, alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                self.dismiss(animated: true, completion: nil)
            })
            break
            
        case BBDeviceTransactionResult.invalidIccData:
            alert(alertTitle: "title_alert_error_cardReaders".localized, message: "body_alert_cardReadingError_cardReader".localized, alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                self.dismiss(animated: true, completion: nil)
            })
            break
            
        case BBDeviceTransactionResult.missingMandatoryData:
            alert(alertTitle: "title_alert_error_cardReaders".localized, message: "body_alert_cardReadingError_cardReader".localized, alertBtnFirst: "title_btn_reread_cardReader".localized, completion: {
                self.dismiss(animated: true, completion: nil)
            })
        default:
            break
        }
    }
    
    func setValueFromModelWisePad(cardModel:CardWalkerModel?, isChipBanda:String?){
        changeProgressView(percentage: 1)
        titleInsertLbl.text = "titleFinishedReading".localized
        btnAccept.isHidden = false
        animationWisePad(arrows: false, terminal: false, card: false, arrowsHide: false, terminalHide: true, cardHide: true)
        helpExt.setAnimation(button: btnAccept, view: view, timeDuration: 1.4)
        
        if cardModel!.isNipValidation {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            modelGlob.Static.txrModel?.authorizationByNIP  = true
        }

            let lastNumber = cardModel?.pan!.suffix(4)
        cardLabel.text = String(format: "**** **** **** %@", String(lastNumber!))
        
        if let name = cardModel?.cardHolder{
            nameLabel.text = name
        }
        if let typeCard = cardModel?.typeCard{
            selectTypeCard(typeCard.uppercased())
        }else{
            let cardLogo = helpExt.typeCardLogo(typeCard: cardModel!.pan!)
            switch cardLogo {
                case "Visa":
                brandImg.image = UIImage(named: "doveHoll.png")
                holloImg.image = UIImage(named: "logo_visa")
                case "MasterCard":
                brandImg.image = UIImage(named: "logo_mcholl.png")
                holloImg.image = UIImage(named: "master_card")
                case "Amex":
                brandImg.image = nil
                holloImg.image = UIImage(named: "amex_logo.png")
                validateAMEX()
                case "Maestro":
                brandImg.image = nil
                holloImg.image = UIImage(named: "amex_logo.png")
                case "Diners":
                brandImg.image = nil
                holloImg.image = UIImage(named: "logo_diners.png")
                case "JBC":
                brandImg.image = nil
                holloImg.image = UIImage(named: "logo_jcb.png")
                case "Discovery":
                brandImg.image = nil
                holloImg.image = UIImage(named: "logo_discovery.png")
            default:
                brandImg.image = nil
                holloImg.image = nil
            }
//            if let checkLogo = cardModel?.aid{
//                if checkLogo != ""{
//                    cardModel?.typeCard = checkLogoImg(aid: checkLogo)
//                }
//            }
        }
        
        if let expDate:NSString = cardModel?.expDate as NSString?{
            let firstBlock = expDate.substring(with: NSRange(location: 2, length: 2))
            let secondBlock = expDate.substring(with: NSRange(location: 0, length: 2))
            expDateLabel.text = String(format: "%@/%@", firstBlock,secondBlock)
        }
        
        modelGlob.Static.cardReaderModel = cardModel
        if cardModel?.walker != "" || cardModel?.walker != nil{
            modelGlob.Static.cardReaderModel?.walker = cardModel?.walker
        }
        if isChipBanda == "S"{
            if let serviceCode = cardModel?.serviceCode{
                if (serviceCode >= 200 && serviceCode<300) || (serviceCode>=600&&serviceCode<700){
                    modelGlob.Static.txrModel?.posEntryMode = "802"
                }else{
                    modelGlob.Static.txrModel?.posEntryMode = "902"
                }
            }
            modelGlob.Static.cardReaderModel?.track2 = cardModel?.track2
            modelGlob.Static.cardReaderModel?.track1 = cardModel?.track1
        }else if isChipBanda == "C"{
            modelGlob.Static.txrModel?.posEntryMode = "051"
            modelGlob.Static.cardReaderModel?.track2 = "9988776655443322=1100"
            modelGlob.Static.cardReaderModel?.chip = "Chip"
        }
        modelGlob.Static.cardReaderModel?.cardEntryMode = isChipBanda
        modelGlob.Static.cardReaderModel?.isNipValidation = false
        recordEndCardReader(brand_card: cardModel!.cardHolder!, entry_mode: isChipBanda!, type_reader: typeReader)
    }
    
    func onBTReturnScanResults(deviceArray:NSMutableArray){
        if typeReader == "WISEPAD"{
            if deviceArray.count > 0{
                let nameDevice = UserDefaults.standard.string(forKey: "PREVIOUS_DEVICE") ?? ""
                for array in deviceArray{
                    let obj1: EAAccessory = array as! NSObject as! EAAccessory
                    if (obj1.serialNumber == nameDevice){
                        //aqui pasa algo
//                        changeReaderWisePad()
                        changeAceptButtonWisePad()
                        wisepad.connectBTFromList(array: array as! NSObject)
                    }
                }
            }
        }
    }
    
    func onBTDisconnectedWisePad(){
        dismiss(animated: true, completion: {
            self.wisepad.delegate = nil
        })
    }
    
    func onReturnAmountConfirmResultWisePad(_ isConfirmed:Bool){
        if (!isConfirmed){
            let nameDevice = UserDefaults.standard.string(forKey: "PREVIOUS_DEVICE") ?? ""
            alertTwoOp(alertTitle: "iAcepta", message: "El lector \(nameDevice) fue desconectado.", alertBtnFirst: "Volver a conectar", alertBtnSecond: "Cancelar", completion: {
                self.dismiss(animated: true, completion: {
                    DispatchQueue.main.async {
                        self.wisepad.reconnect()
                        self.printDev(object: "Volver a conectar")
                    }
                })
            }, completion2: {
                self.dismiss(animated: true, completion: {
                    self.wisepad.disconect(setDimiss: true)
                    self.printDev(object: "Cancelar")
                })
            })
        }else { // aqui acepta wisepad transaccion
            changeReaderWisePad()
            
        }
    }
    func batteryStatusWisePad(isBaterryStatus:BBDeviceBatteryStatus){
        alert(alertTitle: "title_alert_batteryLow_cardReader".localized, message: "body_alert_batteryLow_cardReader".localized, alertBtnFirst: "btn_understood".localized, completion: {
            self.dismiss(animated: true, completion: nil)
        })
    }
}
