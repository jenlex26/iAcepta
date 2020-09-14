//
//  ViewController.swift
//  iAcepta
//
//  Created by iOS_Dev on 2/1/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import UIKit
import Reachability
import Crashlytics
import Firebase
import GoogleUtilities
import RealmSwift

protocol masterDelegate: AnyObject {
    func changeValues()
}


class MasterViewController: UIViewController, CircleMenuDelegate {
    
    @IBOutlet weak var actionTitle: UILabel!
    
    var menuCircle: [(icon: String, color: UIColor)] = []
    var viewControllerSelected : Int?
    var viewSelectedBefore : Int = 0
    weak var delegate: masterDelegate?
    var succesPayment : SuccessfulPaymentModel?
    var succesPaymentCapX : SuccessfulPaymentModelVerifone?
    var typeTransfers:String = ""
    var viewSelect : UIView?
    var externo:Bool = false
    let realm = try! Realm()
    
    let vc = UIStoryboard.overFullScreen(type: .spinner) as! loaderViewController
    
    var typeReader:String = UserDefaults.standard.string(forKey: "TYPEREADER") ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeValueView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func printDev(object: Any) {
        Swift.print(object)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
    func rotateToLandsScapeDevice(orientation:UIInterfaceOrientation, orientationMask:UIInterfaceOrientationMask){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myOrientation = orientationMask
        UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
        UIView.setAnimationsEnabled(true)
    }
    
    func alertServicesLogin(alertTitle:String, message:String, alertBtnFirst:String, completion: @escaping() -> Void){
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier:"AlertVC") as! AlertViewController
        alertVC.alertTitle = alertTitle
        alertVC.alertBody = message
        alertVC.alertBtnTitle = alertBtnFirst
        alertVC.btnActionAcept = completion
        present(alertVC, animated: true, completion: nil)
    }
    
    func alertTwoOp(alertTitle:String, message:String, alertBtnFirst:String, alertBtnSecond:String, completion: @escaping() -> Void, completion2: @escaping() -> Void){
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier:"AlertTwo") as! AlertTwoOptions
        alertVC.alertTitle = alertTitle
        alertVC.alertBody = message
        alertVC.titleBtnFirst = alertBtnFirst
        alertVC.titleBtnSecond = alertBtnSecond
        alertVC.btnActionAcept = completion
        alertVC.btnActionCancel = completion2
        present(alertVC, animated: true, completion: nil)
    }
    
    func alert(alertTitle:String, message:String, alertBtnFirst:String, completion: @escaping() -> Void){
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier:"AlertVC") as! AlertViewController
        alertVC.alertTitle = alertTitle
        alertVC.alertBody = message
        alertVC.alertBtnTitle = alertBtnFirst
        alertVC.btnActionAcept = completion
        present(alertVC, animated: true, completion: nil)
    }
    
    func reachable() -> Bool {
        let reachability =  try! Reachability()
        do{
            try reachability.startNotifier()
        }catch{
            print("Unable to start notifier")
        }
        if reachability.connection != .none{
            return true
        }else{
            return false
        }
    }
    
    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
    //MARK: FunctionEventFirebase
    func loginEvent(title:String,content:String){
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
        AnalyticsParameterItemID: "iAcepta-\(title)" as NSObject,
        AnalyticsParameterItemName: title as NSObject,
        AnalyticsParameterContentType: content as NSObject
        ])
        
    }
    
    func recordStartTransaction(title:String,type:String){
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
        AnalyticsParameterItemID: "iAcepta-\(title)" as NSObject,
        AnalyticsParameterItemName: title as NSObject,
        AnalyticsParameterContentType: type as NSObject
        ])
        
    }
    
    func recordEndCardReader(brand_card:String,entry_mode:String,type_reader:String){
        
        Analytics.logEvent("end_card_reader", parameters: [
        "brand_card": brand_card as NSObject,
        "entry_mode": entry_mode as NSObject,
        "type_reader": type_reader as NSObject
        ])
    }
    
    func recordTransactionResult(type_transaction:String,transaction_result:String){
        
        Analytics.logEvent("transaction_result", parameters: [
        "type_transaction": type_transaction as NSObject,
        "transaction_result": transaction_result as NSObject
        ])
    }
    
    func recordSendVoucher(type_transaction:String,process:String){
        
        Analytics.logEvent("card_reader", parameters: [
        "type_transaction": type_transaction as NSObject,
        "process": process as NSObject
        ])
    }
    
    
    
    //MARK: FunctionCircleMenu
    func circleMenu(_: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        button.backgroundColor = menuCircle[atIndex].color
        
        button.setImage(UIImage(named: menuCircle[atIndex].icon), for: .normal)
        
        // set highlited image
        let highlightedImage = UIImage(named: menuCircle[atIndex].icon)?.withRenderingMode(.alwaysTemplate)
        button.setImage(highlightedImage, for: .highlighted)
        button.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        button.isEnabled = true
        if (atIndex == 1 && sessionGlob.Static.sessionIAcepta?.hasPayment != true){
            button.alpha = 0.5
            button.isEnabled = false
        }else if (atIndex == 2 && sessionGlob.Static.sessionIAcepta?.hasCancellation != true){
            button.alpha = 0.5
            button.isEnabled = false
        }else if (atIndex == 3 && sessionGlob.Static.sessionIAcepta?.hasRefund != true){
            button.alpha = 0.5
            button.isEnabled = false
        }else if (atIndex == 0 && sessionGlob.Static.sessionIAcepta?.hascodi != true){
            button.alpha = 0.5
            button.isEnabled = false
        }
        
        
    }
    
    func circleMenu(_: CircleMenu, buttonWillSelected button: UIButton, atIndex: Int) {
        printDev(object: "Otra vez")
        
        
        guard actionTitle == nil else {
            actionTitle.isHidden = false
            switch atIndex {
            case 0:
                actionTitle.text = "Pago CoDi"
                break
            case 1:
                actionTitle.text = "Pagos"
                break
            case 2:
                actionTitle.text = "Cancelación"
                break
            case 3:
                actionTitle.text = "Devolución"
                break
            case 4:
                actionTitle.text = "Historial"
                break
            case 5:
                actionTitle.text = ""
                break
            default:
                break
            }
            return
        }
        
    }
    
    
    func circleMenu(_ circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int) {

        viewSelect?.isHidden = true
        if (viewControllerSelected != atIndex){
            viewControllerSelected = atIndex
            if (atIndex == 1){
                self.performSegue(withIdentifier: "toPayments", sender: atIndex)
            }else if (atIndex == 2 || atIndex == 3){
                if (viewSelectedBefore == 2 || viewSelectedBefore == 3){
                    changeValueView()
                    viewSelectedBefore = atIndex
                    delegate?.changeValues()
                    return
                }else{
                    viewSelectedBefore = atIndex
                    self.performSegue(withIdentifier: "toCancellation", sender: atIndex)
                }
            }else if (atIndex == 4){
                self.performSegue(withIdentifier: "toHistoryWeb", sender: atIndex)
            }else if (atIndex == 5){
                closeSession()
            }else if (atIndex == 0){
                // si quitas esto recuerda revisar el numero de transactionIdentification para el envio de transaccion
                let a = realm.objects(codiWalletResquest.self)
                if a.count > 0 {
                    alert(alertTitle: "iAcepta", message: "tienes una transaccion pendiente", alertBtnFirst: "terminar transaccion") {
                        self.dismiss(animated: true) {
                            let storyboard = UIStoryboard(name: "Codi", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "generateCodeQR") as? generateCodeQR
                            self.present(vc!, animated: true) {}
                        }
                    }
                }else{
                    self.performSegue(withIdentifier: "toTutorial", sender: atIndex)
                }
                
            }
        }else if (viewControllerSelected == 2 || viewControllerSelected == 3){
            viewControllerSelected = atIndex
            delegate?.changeValues()
        }
        guard actionTitle == nil else {
            actionTitle.text = ""
            actionTitle.isHidden = true
            return
        }
        
    }
    
    func menuOpened(_ circleMenu: CircleMenu) {
        viewSelect?.isHidden = false
    }
    
    func menuCollapsed(_ circleMenu: CircleMenu) {
        viewSelect?.isHidden = true
    }
    //FuncPressBtnChange
    func changeValueView(){
        if viewControllerSelected == nil{
            menuCircle = [
                ("menu_codi", UIColor(white: 1, alpha: 0.5)),
                ("menu_pagos", UIColor(white: 1, alpha: 0.5)),
                ("menu_cancelacion", UIColor(white: 1, alpha: 0.9)),
                ("menu_devolucion", UIColor(white: 1, alpha: 0.1)),
                ("menu_historial", UIColor(white: 1, alpha: 0.5)),
                ("menu_salir", UIColor(white: 1, alpha: 0.5))
            ]
        }else if (viewControllerSelected == 0){
            menuCircle = [
                ("menu_codi_Select", UIColor(white: 1, alpha: 0.5)),
                ("menu_pagos", UIColor(white: 1, alpha: 0.5)),
                ("menu_cancelacion", UIColor(white: 1, alpha: 0.5)),
                ("menu_devolucion", UIColor(white: 1, alpha: 0.5)),
                ("menu_historial", UIColor(white: 1, alpha: 0.5)),
                ("menu_salir", UIColor(white: 1, alpha: 0.5))
            ]
        }else if (viewControllerSelected == 1){
            menuCircle = [
                ("menu_codi", UIColor(white: 1, alpha: 0.5)),
                ("menu_refund_select", UIColor(white: 1, alpha: 0.5)),
                ("menu_cancelacion", UIColor(white: 1, alpha: 0.5)),
                ("menu_devolucion", UIColor(white: 1, alpha: 0.5)),
                ("menu_historial", UIColor(white: 1, alpha: 0.5)),
                ("menu_salir", UIColor(white: 1, alpha: 0.5))
            ]
        }else if (viewControllerSelected == 2){
            menuCircle = [
                ("menu_codi", UIColor(white: 1, alpha: 0.5)),
                ("menu_pagos", UIColor(white: 1, alpha: 0.5)),
                ("menu_cancellation_select", UIColor(white: 1, alpha: 0.5)),
                ("menu_devolucion", UIColor(white: 1, alpha: 0.5)),
                ("menu_historial", UIColor(white: 1, alpha: 0.5)),
                ("menu_salir", UIColor(white: 1, alpha: 0.5))
            ]
            
            delegate?.changeValues()
        }else if (viewControllerSelected == 3){
            menuCircle = [
//                ("menu_demo", UIColor(white: 1, alpha: 0.5)),
                ("menu_codi", UIColor(white: 1, alpha: 0.5)),
                ("menu_pagos", UIColor(white: 1, alpha: 0.5)),
                ("menu_cancelacion", UIColor(white: 1, alpha: 0.5)),
                ("menu_return_select", UIColor(white: 1, alpha: 0.5)),
                ("menu_historial", UIColor(white: 1, alpha: 0.5)),
                ("menu_salir", UIColor(white: 1, alpha: 0.5))
            ]
            delegate?.changeValues()
        }else if (viewControllerSelected == 4){
            menuCircle = [
//                ("menu_demo", UIColor(white: 1, alpha: 0.5)),
                ("menu_codi", UIColor(white: 1, alpha: 0.5)),
                ("menu_pagos", UIColor(white: 1, alpha: 0.5)),
                ("menu_cancelacion", UIColor(white: 1, alpha: 0.5)),
                ("menu_devolucion", UIColor(white: 1, alpha: 0.5)),
                ("menu_history_select", UIColor(white: 1, alpha: 0.5)),
                ("menu_salir", UIColor(white: 1, alpha: 0.5))
            ]
            delegate?.changeValues()
        }
    }
    @objc func DismissKeyboard(){
        view.endEditing(true)
    }
    
    func setVoucherData() -> Bool{
        if (DBManagerVoucher.sharedInstance.getDataFromDB().count > 0){
            let result = DBManagerVoucher.sharedInstance.getDataFromDB()
            let idUser = result[result.count-1].idUserVoucher;
            let user = result[result.count-1].userNameVoucher;
            let dataVoucher = result[result.count-1].dateVoucher;
            
            do{
                let decryp = try RNCryptor.decrypt(data: dataVoucher!, withPaswd: "&QsCxZdEwArTfCgYuHb%$op=lKjnMbHy")
                if let objects = NSKeyedUnarchiver.unarchiveObject(with: decryp) as? NSDictionary {
                    let txrModel = TransactionModel.init(amount:(objects.value(forKey: "trxAmount") as! String),email:(objects.value(forKey: "emailClient") as! String))
                    txrModel.total = (objects.value(forKey: "trxTotal") as! String)
                    txrModel.dateName = objects.value(forKey: "dateName") as? String
                    txrModel.arqc = objects.value(forKey: "arqc") as? String
                    txrModel.tip = objects.value(forKey: "trxTip") as? String
                    txrModel.date = objects.value(forKey: "date") as? String
                    txrModel.authorization = objects.value(forKey: "authorization") as? String
                    txrModel.mwi = objects.value(forKey: "trxMonths") as? String
                    txrModel.F037 = objects.value(forKey: "trxSequence") as? String
                    txrModel.showMap = objects.value(forKey: "showMap") as? Data
                    modelGlob.Static.txrModel = txrModel
                    modelGlob.Static.txrModel?.authorizationByNIP  = (objects.value(forKey: "hasNIP") as? Bool)!
                    
                    if typeReader == "VERIFONE"{
                        let txtCard = CapXModel(aid:objects.value(forKey: "aid") as? String, cardHolder:objects.value(forKey: "cardholder") as? String, pan:objects.value(forKey: "cardNumber") as? String)
                        txtCard.isEntryModeReader = objects.value(forKey: "chip") as? String
                        txtCard.cardEntryMode = objects.value(forKey: "cardEntryMode") as? String
                        txtCard.cardType = objects.value(forKey: "cardIssuer") as? String
                        modelGlob.Static.cardCapituloX = txtCard
                    }else{
                        let txrCard = CardWalkerModel(cardHolder:objects.value(forKey: "cardholder") as? String, aid:objects.value(forKey: "aid") as? String, pan:objects.value(forKey: "cardNumber") as? String)
                        //txrCard.isNipValidation = objects.value(forKey: "hasNIP") as? Bool
                        txrCard.chip = objects.value(forKey: "chip") as? String
                        txrCard.appName = objects.value(forKey: "aplLabel") as? String
                        txrCard.prefName = objects.value(forKey: "prefName") as? String
                        txrCard.cardEntryMode = objects.value(forKey: "cardEntryMode") as? String
                        txrCard.typeCard = objects.value(forKey: "cardIssuer") as? String
                        modelGlob.Static.cardReaderModel = txrCard
                    }
                } else {
                    printDev(object: "Error")
                }
                
            } catch let error {
                printDev(object: "Error: \(error)")
            }
        }
        return true
    }
    
    func setVoucherCodiData(){
        
        let processedData = DBManagerVoucher.sharedInstance.getDataFromDB()
        let dispatchGroup = DispatchGroup()
        for voucher in processedData{
            dispatchGroup.enter()
            print("aqui empieza")
            
            var amountRealm        = ""
            var cardNumberRealm    = ""
            var cardIssuerRealm    = ""
            var authorizationRealm = ""
            var sequenceRealm      = ""
            var emailRealm         = ""
            
            do {
                let decryp = try RNCryptor.decrypt(data: voucher.dateVoucher!, withPaswd: "&QsCxZdEwArTfCgYuHb%$op=lKjnMbHy")
                if let objects = NSKeyedUnarchiver.unarchiveObject(with: decryp) as? NSDictionary {
                    let txrModel = TransactionModel.init(amount:(objects.value(forKey: "trxAmount") as! String),email:(objects.value(forKey: "emailClient") as! String))
                    
                    amountRealm        = (objects.value(forKey: "trxTotal") as! String)
                    cardNumberRealm    = (objects.value(forKey: "cardNumber") as! String)
                    cardIssuerRealm    = (objects.value(forKey: "cardIssuer") as! String)
                    authorizationRealm = (objects.value(forKey: "authorization") as! String)
                    sequenceRealm      = (objects.value(forKey: "trxSequence") as! String)
                    emailRealm         = (objects.value(forKey: "emailClient") as! String)
                    
                    
                } else {
                    printDev(object: "Error")
                }
                
            } catch let error {
                printDev(object: "Error: \(error)")
            }
  
            CodiPresenter.sendVoucher(amountRealm, cardIssuerRealm, cardNumberRealm, authorizationRealm, sequenceRealm, emailRealm) { (result) in
                print("aqui manda el servicio")
                switch result {
                case .success( _):
                    self.printDev(object: "Servicio de vaucher enviado")
                    DBManagerVoucher.sharedInstance.deleteFromDb(object: voucher)
                    break
                case .failure( _):
                    self.printDev(object: "Servicio de vaucher fallido")
                    break
                }
                print("aqui termina el task")
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            print("aqui termino")
        }

    }
    

    
    
    //Func MARK: CounterEz
    func setCounterEz(counter:Int, restart:Bool){
        if (restart){
            UserDefaults.standard.set(0, forKey: "counterEZ")
        }else{
            UserDefaults.standard.set(counter, forKey: "counterEZ")
        }
    }
    
    func getCounterEz() -> Int{
        return UserDefaults.standard.integer(forKey: "counterEZ")
    }
    
    //Func MARK:returnOpenURL
    func returnOpenURL(urlBack:String){
        let outApplication = UIApplication.shared
        if let url = URL(string: urlBack){
            outApplication.open(url, options: [:], completionHandler: { (success) in
                if success{
                    print("Open URL")
                }
            })
        }
    }
    
    //Func MARK: CloseSession
    func closeSession(){
        alertTwoOp(alertTitle: "title_alert_closeSession".localized, message: "body_alert_closeSession".localized, alertBtnFirst: "firtsBtn_alert_closeSession".localized, alertBtnSecond: "secondBtn_alert_closeSession".localized, completion: {
            self.dismiss(animated: true, completion: {
//                UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
//                UserDefaults.standard.synchronize()
                
                if (sessionGlob.Static.sessionIAcepta != nil){
                    sessionGlob.Static.sessionIAcepta = nil
                }
                if (modelGlob.Static.cardCapituloX != nil){
                    modelGlob.Static.cardCapituloX = nil
                }
                if (modelGlob.Static.cardReaderModel != nil){
                    modelGlob.Static.cardReaderModel = nil
                }
                if modelGlob.Static.txrModel != nil{
                    modelGlob.Static.txrModel = nil
                }
                if (modelGlob.Static.verifoneSDK != nil){
                    modelGlob.Static.verifoneSDK = nil
                }
                if (modelGlob.Static.walkerSDK != nil){
                    modelGlob.Static.walkerSDK = nil
                }
                
                self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
            })
        }, completion2: {
            self.viewControllerSelected = nil
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func isUpdateAvailable(completion: @escaping (Bool?, Error?) -> Void) throws -> URLSessionDataTask {
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                throw VersionError.invalidBundleInfo
        }
        printDev(object: "\(identifier)------\(currentVersion)--------\(url)")
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { throw VersionError.invalidResponse }
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
                guard let result = (json?["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String else {
                    throw VersionError.invalidResponse
                }
                self.printDev(object: "\(version) < \(currentVersion)")
                completion(version < currentVersion, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
        return task
    }
    
    enum VersionError: Error {
        case invalidResponse, invalidBundleInfo
    }
    
}
