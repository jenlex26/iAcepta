//
//  VoucherViewController.swift
//  iAcepta
//
//  Created by QUALITY on 6/6/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import UIKit

class VoucherViewController: MasterViewController {
    
    @IBOutlet weak var scrollDetailVoucher: UIScrollView!
    @IBOutlet weak var viewDetailVoucher: UIView!
    @IBOutlet weak var btnAccept: UIButton!{didSet{btnAccept.setRoundedLayout(button: btnAccept)}}
    @IBOutlet weak var lblTerms: UILabel!
    @IBOutlet weak var constraintButtom: NSLayoutConstraint!
    
    
    @IBOutlet weak var comNameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var mwiLbl: UILabel!
    @IBOutlet weak var signTypeLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var tipLbl: UILabel!
    @IBOutlet weak var membershipLbl: UILabel!
    @IBOutlet weak var aidLbl: UILabel!
    @IBOutlet weak var arqcLbl: UILabel!
    @IBOutlet weak var cardLbl: UILabel!
    @IBOutlet weak var cardTypeLbl: UILabel!
    @IBOutlet weak var terminalLbl: UILabel!
    @IBOutlet weak var authorizationLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var hourLbl: UILabel!
    @IBOutlet weak var setDateAuthorizationLbl: UILabel!
    @IBOutlet weak var setSignature: UIImageView!
    @IBOutlet weak var cardHolderLbl: UILabel!
    
    
    @IBOutlet weak var totalTextLbl: UILabel!
    @IBOutlet weak var amountTextLbl: UILabel!
    @IBOutlet weak var tipTextLbl: UILabel!
    @IBOutlet weak var dealTextLbl: UILabel!
    @IBOutlet weak var onlineSaleTextLbl: UILabel!
    @IBOutlet weak var arqcTextLbl: UILabel!
    @IBOutlet weak var cardTextLbl: UILabel!
    @IBOutlet weak var terminalTextLbl: UILabel!
    @IBOutlet weak var authorizationTextLbl: UILabel!
    
    @IBOutlet weak var headerIAcepta: headeriAcepta!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var showConstraints : Bool = false
    var once:Bool = true
    var payProcess:Bool = false
    var isSuccessVoucher:Bool = false
    
    var txrSession:SessionIAcepta?
    var txrModel: TransactionModel?
    var txrCard: CardWalkerModel?
    var txrCardCapX: CapXModel?
    var helperExt = HelperExtensions()
    var cardNumber:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rotateToLandsScapeDevice(orientation: .portrait, orientationMask: .portrait)
        txrSession = sessionGlob.Static.sessionIAcepta
        txrModel = modelGlob.Static.txrModel
        externo = modelGlob.Static.integratorModel?.externo ?? false
        if typeReader == "VERIFONE"{
            txrCardCapX = modelGlob.Static.cardCapituloX
        }else{
            txrCard = modelGlob.Static.cardReaderModel
        }
        header()
        setText()
        setLabels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showConstrain()
        if !isSuccessVoucher {
            isSuccessVoucher = true
            alertTwoOp(alertTitle: "alert_title_voucher".localized, message: "alert_msg_voucher".localized, alertBtnFirst: "alert_retry_btn_voucher".localized, alertBtnSecond: "alert_later_btn_voucher".localized, completion: {
                self.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "retryVoucher", sender: self)
            }, completion2: {
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    //Func MARK:Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "retryVoucher"{
            if let destinationVC = segue.destination as? LoaderAnimationVoucher {
                destinationVC.payProcess = payProcess
            }
        }
        if segue.identifier == "unwindToStar"{
            if let destinationVC = segue.destination as? MainMenuViewController {
                if (DBManagerVoucher.sharedInstance.getDataFromDB().count > 0){
                 destinationVC.showVouchers = true
                }
            }
        }
    }
    
    //Func MARK: SETText
    func header(){
        headerIAcepta.btnHome.isHidden = true
        headerIAcepta.btnInfo.isHidden = false
        headerIAcepta.delegate = self
        if payProcess{
            headerIAcepta.lblTitle.text = "title_header_payProcess_signature".localized
        }else{
            if sessionGlob.Static.sessionIAcepta!.setCancellationHeader!{
                headerIAcepta.lblTitle.text = "title_header_cancellation_signature".localized
            }else{
                headerIAcepta.lblTitle.text = "title_header_rejected_signature".localized
            }
        }
    }
    
    func setText(){
        amountTextLbl.text = "text_amount_voucher".localized
        tipTextLbl.text = "text_tip_voucher".localized
        dealTextLbl.text = "text_deal_voucher".localized
        arqcTextLbl.text = "text_arqc_voucher".localized
        cardTextLbl.text = "text_card_voucher".localized
        terminalTextLbl.text = "text_terminal_voucher".localized
        authorizationTextLbl.text = "text_authorization_voucher".localized
        viewDetailVoucher.layer.cornerRadius = 27.5
        scrollDetailVoucher.layer.cornerRadius = 27.5
        if payProcess{
            totalTextLbl.text = "text_total_voucher".localized
            onlineSaleTextLbl.text = "text_online_sale_voucher".localized
            lblTerms.text = "text_terms_voucher".localized
            lblTerms.textAlignment = .justified
            lblTerms.sizeToFit()
            lblTerms.adjustsFontSizeToFitWidth = true
        }else{
            if !(sessionGlob.Static.sessionIAcepta!.setCancellationHeader!){
                onlineSaleTextLbl.text = "text_return_sale_voucher".localized
                totalTextLbl.text = "text_total_voucher_isReturn".localized
            }else{
                onlineSaleTextLbl.text = "text_cancel_sale_voucher".localized
                totalTextLbl.text = "text_total_voucher_isCancell".localized
            }
        }
    }
    
    func setLabels(){
        comNameLbl.text = (txrSession?.comerceName == nil) ? "" : txrSession?.comerceName
        addressLbl.text = (txrSession?.comerAddres == nil) ? "" : txrSession?.comerAddres
        aidLbl.text = (txrModel?.aid == nil) ? "" : txrModel?.aid
        arqcLbl.text = (txrModel?.arqc == nil) ? "" : txrModel?.arqc
        membershipLbl.text = (txrSession?.userInfo?.commerceMemberShipNumber == nil) ? "" : txrSession?.userInfo?.commerceMemberShipNumber
        terminalLbl.text = (txrSession?.userPhoneNumber == nil) ? "" : txrSession?.userPhoneNumber
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if txrModel?.authorizationByNIP ?? false {
            signTypeLbl.text = "Autorizado con Firma Electrónica."
        }else{
            signTypeLbl.text = "Firma Digitalizada"
        }
        
        if typeReader == "VERIFONE"{
            setVerifoneLbls()
        }else{
            setWalkerLbls()
        }
        
        if txrModel?.tip != nil && !(txrModel?.tip == "") {
            amountTextLbl.isHidden = false
            tipTextLbl.isHidden = false
            tipLbl.isHidden = false
            amountLbl.isHidden
                = false
            
            amountLbl.text = "$ \(txrModel?.amount ?? "0.00")"//String(format: "$ %@", (txrModel?.amount?.replacingOccurrences(of: ",", with: ""))!)
            tipLbl.text    = "$ \(txrModel?.tip ?? "0.00")"//String(format: "$ %@", (txrModel?.tip?.replacingOccurrences(of: ",", with: ""))!)
        }
        
        if txrModel?.mwi != nil && txrModel?.mwi != "0" && txrModel?.mwi != "-" {
            mwiLbl.isEnabled = false
            mwiLbl.text = String(format: "A %@ Meses sin Intereses", txrModel!.mwi!)
        }else{
            txrModel?.mwi = "0"
            mwiLbl.isEnabled = true
            mwiLbl.isHidden = true
        }
        
        var authorizationId:String = ""
        if let authorization = txrModel?.authorization{
            authorizationId = authorization
            while authorization.count < 6 {
                authorizationId = String(format: "%@0",authorization)
            }
        }
        authorizationLbl.text = authorizationId
        let item = txrModel?.date?.split(separator: " ")
        if item != nil{
            dateTimeLbl.text = String(format: "%@ %@, '%@", item![1].replacingOccurrences(of: ",", with: ""),String(format: "%@", item![0].replacingOccurrences(of: ",", with: "")),String(item![2]))
            hourLbl.text = String(item!.last!)
        }else{
            dateTimeLbl.text = ""
            hourLbl.text = ""
        }
        
        if payProcess{
            totalLbl.text = String(format: "$ %@", txrModel?.total ?? "")
            if !(txrModel?.authorizationByNIP ?? false) {
                let image = helperExt.loadImage(name: "Voucher2")
                
                let imageData = image!.pngData()
                   let bytes = imageData!.count
                   if bytes > 5000{
                       setSignature.contentMode = .scaleAspectFit
                   }else{
                    setSignature.contentMode = .center
                }
                setSignature.image = image
            }
        }else{
            totalLbl.text = String(format: "- $ %@", txrModel!.total!)
        }
        setDateAuthorizationLbl.text = setTextDate()
        
    }
    
    func setVerifoneLbls(){
        switch txrCardCapX?.pan!.first {
        case "3":
            cardTypeLbl.text = "AMEX"
        case "4":
            cardTypeLbl.text = "VISA"
        default:
            cardTypeLbl.text = "MASTERCARD"
        }
        let lastNumberCard = helperExt.CardNumberFormat(string: txrCardCapX?.pan ?? cardNumber)
        cardLbl.text = lastNumberCard
        if payProcess{
            cardHolderLbl.text = txrCardCapX?.cardHolder ?? ""
        }
    }
    
    func setWalkerLbls(){
        switch txrCard?.pan!.first {
        case "3":
            cardTypeLbl.text = "AMEX"
        case "4":
            cardTypeLbl.text = "VISA"
        default:
            cardTypeLbl.text = "MASTERCARD"
        }
        cardLbl.text = helperExt.CardNumberFormat(string: txrCard?.pan!.dropLastWhileLetter() ?? cardNumber)
        if payProcess{
            cardHolderLbl.text = txrCard?.cardHolder ?? ""
        }
    }
    
    func setTextDate() -> String{
        let string = NSMutableString()
        string.append(String(format: "%@ %@", txrModel?.authorization ?? "", txrModel?.date ?? ""))
        string.append(String(format: "\n%@ %@", txrModel?.date ?? "", txrModel?.authorization ?? ""))
        string.append(String(format: "\n%@ %@", txrModel?.authorization ?? "", txrModel?.date ?? ""))
        string.append(String(format: "\n%@ %@", txrModel?.date ?? "", txrModel?.authorization ?? ""))
        string.append(String(format: "\n%@ %@", txrModel?.authorization ?? "", txrModel?.date ?? ""))
        string.append(String(format: "\n%@ %@", txrModel?.date ?? "", txrModel?.authorization ?? ""))
        return String(string)
    }
//    func loadImage(name:String) -> UIImage{
//        var image = UIImage()
//        let file = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(name)
//        image = UIImage(contentsOfFile: file.path)!
//        return image
//    }
    
    //Func MARK: Constrain
    func showConstrain() {
        if (!showConstraints) {
            let screenSize = UIScreen.main.bounds
            let screenHeight = screenSize.height
            if !(screenHeight <= 600){
                constraintButtom.constant = 32
            }
            showConstraints = true
        }
    }
    
    //Func MARK: ButtonAction
    @IBAction func continueAction(_ sender: Any) {
//        UIImageWriteToSavedPhotosAlbum(scrollDetailVoucher.screenshot()!, nil, nil, nil)
        if externo{
            if payProcess{
                goExternoVoucherPayProcess()
            }else{
                goExternoVoucerCancellation()
            }
        }else{
            let prefs = UserDefaults.standard
            prefs.removeObject(forKey:String(format: "B%@_lt", txrModel?.date ?? ""))
            prefs.removeObject(forKey:String(format: "Voucher2", txrModel?.date ?? ""))
            performSegue(withIdentifier: "returnDashboard", sender: self)
            modelGlob.Static.txrModel = nil
            modelGlob.Static.cardCapituloX = nil
            modelGlob.Static.cardReaderModel = nil
            
        }
    }
    
    //func MARK: Externo
    func goExternoVoucherPayProcess(){
//        let alert = UIAlertController(title: "Operación", message: "Respuesta:\("Aprobado")\nCodigo:\("00")\nNúmero de Autorizacion:\(txrModel?.authorization ?? "")\nReferecia:\(txrModel?.reference ?? "")\nMeses sin Intereses :\(txrModel?.mwi ?? "")\nBanco emisor:\(txrCardCapX?.issuingBank ?? "")\nTarjeta:\(txrCardCapX?.isCreditDebit ?? "")", preferredStyle: .alert)
//
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//
//
//        self.present(alert, animated: true)

        if typeReader == "VERIFONE"{
            let outPath = String(format: "%@://?Aprobado&00&%@&%@&%@&%@&%@",modelGlob.Static.integratorModel?.stringReverse ?? "",txrModel?.authorization ?? "",txrModel?.reference ?? "", txrModel?.mwi ?? "", txrCardCapX?.issuingBank ?? "", txrCardCapX?.isCreditDebit ?? "")
            self.returnOpenURL(urlBack: outPath)
        }else{
            let outPath = String(format: "%@://?Aprobado&00&%@&%@&%@&%@&%@",modelGlob.Static.integratorModel?.stringReverse ?? "",txrModel?.authorization ?? "",txrModel?.reference ?? "", txrModel?.mwi ?? "", txrCard?.issuingBank ?? "", txrCard?.isCreditDebit ?? "")
            self.returnOpenURL(urlBack: outPath)
        }
    }
    
    func goExternoVoucerCancellation(){
        let outPath = String(format: "%@://?Aprobado&00",modelGlob.Static.integratorModel?.stringReverse ?? "")
        self.returnOpenURL(urlBack: outPath)
    }
}

extension VoucherViewController:headerActoionDelegate{
    func btnHome() {
        print("")
    }

    func btnInfo() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier:"infoHelp") as! InformationHelpViewController
        alertVC.contentName = "InfoVoucher"
        present(alertVC, animated: true, completion: nil)
    }
}

fileprivate extension UIScrollView {
    func screenshot() -> UIImage? {
        let savedContentOffset = contentOffset
        let savedFrame = frame

        UIGraphicsBeginImageContextWithOptions(contentSize, false, 0.0)
//        UIGraphicsBeginImageContext(contentSize)

        contentOffset = .zero
        frame = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)

        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();

        contentOffset = savedContentOffset
        frame = savedFrame

        return image
    }
}

extension UIImage {

    func aspectFitImage(inRect rect: CGRect) -> UIImage? {
        let width = self.size.width
        let height = self.size.height
        let aspectWidth = rect.width / width
        let aspectHeight = rect.height / height
        let scaleFactor = aspectWidth > aspectHeight ? rect.size.height / height : rect.size.width / width

        UIGraphicsBeginImageContextWithOptions(CGSize(width: width * scaleFactor, height: height * scaleFactor), false, 0.0)
        self.draw(in: CGRect(x: 0.0, y: 0.0, width: width * scaleFactor, height: height * scaleFactor))

        defer {
            UIGraphicsEndImageContext()
        }

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
