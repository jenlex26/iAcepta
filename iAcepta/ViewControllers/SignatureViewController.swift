//
//  SignatureViewController.swift
//  iAcepta
//
//  Created by QUALITY on 7/5/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import UIKit
import Realm

class SignatureViewController: MasterViewController {
    
    @IBOutlet weak var headerIAcepta: headeriAcepta!
    @IBOutlet weak var lblReceiptSig: UILabel!
    @IBOutlet weak var btnClear: UIButton!{didSet{btnClear.setRoundedLayout(button: btnClear)}}
    @IBOutlet weak var btnContinue: UIButton!{didSet{btnContinue.setRoundedLayout(button: btnContinue)}}
    @IBOutlet weak var drawingView: DrawingSignature!
    @IBOutlet weak var imgCheck: UIImageView!
    
    @IBOutlet weak var lblApproved: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblAuthorization: UILabel!
    
    @IBOutlet weak var lblSetTotal: UILabel!
    @IBOutlet weak var lblSetAuthorization: UILabel!
    
    var helpExt = HelperExtensions()
    var alert = AlertServices()
    var txrInfo:TransactionModel?
    var cardInfo:CardWalkerModel?
    
    var payProcess:Bool = false
    var cardNumber:String = ""
    
    var typeApproved = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txrInfo = modelGlob.Static.txrModel
        cardInfo = modelGlob.Static.cardReaderModel
        
        setTextLabels()
        setInfoLabels()
        header()
        self.rotateToLandsScapeDevice(orientation: .landscapeRight, orientationMask: .landscapeRight)
        
        self.drawingView.layer.cornerRadius = 8;
        self.drawingView.layer.masksToBounds = true;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLoaderVoucher"{
            if let destinationVC = segue.destination as? LoaderAnimationVoucher {
                destinationVC.cardNumber = cardNumber
                destinationVC.payProcess = payProcess
            }
        }
        
    }
    
    
    //Func Mark:
    func setTextLabels(){
        imgCheck.isHidden = false
        btnClear.isHidden = false
        btnContinue.isHidden = false
        lblReceiptSig.text = "\((typeApproved == "") ? "¡Operación realizada con éxito!" : typeApproved) \("receipt_signature".localized)"
        btnContinue.setTitle("btn_continue_sig".localized, for: .normal)
        btnClear.setTitle("btn_clean_sig".localized, for: .normal)
        lblApproved.text = "lbl_approved_sig".localized
        lblTotal.text = "lbl_total_sig".localized
        lblAuthorization.text = "lbl_authorization_sig".localized
    }
    
    func setInfoLabels(){
        lblSetTotal.text = (txrInfo?.total != nil) ? String(format: "$ %@", txrInfo!.total!) : ""
        lblSetAuthorization.text = (txrInfo?.authorization != nil) ? txrInfo?.authorization : ""
    }
    
    func header(){
        headerIAcepta.btnHome.isHidden = true
        headerIAcepta.btnInfo.isHidden = false
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
    

    
    //Buttons Action
    @IBAction func clearAction(_ sender: Any) {
        drawingView.clear()
    }
    
    @IBAction func continueAction(_ sender: Any) {
        if (drawingView.isUserHasDrawn()){
            drawingView.backgroundColor = UIColor.clear
            let file = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("Voucher2.png")
            
            let img = helpExt.imageRepresentation(view: drawingView)
            let imgSize = resizeImage(image: img, targetSize: CGSize(width: drawingView.bounds.width, height: drawingView.bounds.height))
            let imageData = imgSize.pngData()
            if payProcess{
                DBManagerVoucher.sharedInstance.updateValue(value: DBManagerVoucher.sharedInstance.getDataFromDB().last?.voucherIAcepta ?? 0, sign: imgSize.pngData()!)
            }
            do{
                try imageData?.write(to: file, options: .atomic)
            }catch{
                printDev(object: error)
            }
            
            
            let base64 = helpExt.convertImageToBase64String(image: imgSize)
            if base64 != ""{
                rotateToLandsScapeDevice(orientation: .portrait, orientationMask: .portrait)
                performSegue(withIdentifier: "showLoaderVoucher", sender: self)
            }
        }else{
            alert(alertTitle: "iAcepta", message: "Debes firmar primero.", alertBtnFirst: "Ok", completion: {
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
}
