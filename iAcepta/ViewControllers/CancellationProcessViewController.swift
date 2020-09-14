//
//  CancellationProcessViewController.swift
//  iAcepta
//
//  Created by QUALITY on 7/11/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import UIKit

class CancellationProcessViewController: MasterViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblRejected: UILabel!
    @IBOutlet weak var btnContinue: UIButton!{didSet{btnContinue.setRoundedLayout(button: btnContinue)}}
    
    @IBOutlet weak var reasonLbl: UILabel!
    @IBOutlet weak var headerIAcepta: headeriAcepta!
    
    var payProcess:Bool = false
    var resultResponseType: ServicesResponseType?
    var resultKeyVerifone: statusKeysVerifone?
    
    var reasonForRejection = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabels()
        reasonLbl.text = reasonForRejection
        externo = modelGlob.Static.integratorModel?.externo ?? false
        if (typeReader == "WISEPAD"){
            print("Entra cancelación en CancellationProcessViewcontroller")
            modelGlob.Static.wisePadSDK?.ultimoEstado = .Disconnect
            modelGlob.Static.wisePadSDK?.wisePad2.cancelCheckCard()
            modelGlob.Static.wisePadSDK?.disconect(setDimiss: false)
        }
    }
    
    //Mark function: labels
    func setLabels(){
        if payProcess{
            lblTitle.text = "title_payProcess_cancellationProcess".localized
            headerIAcepta.lblTitle.text = "title_header_payProcess_cancellationProcess".localized
        }else{
            if sessionGlob.Static.sessionIAcepta!.setCancellationHeader!{
                lblTitle.text = "title_payProcess_cancellationProcess".localized
                headerIAcepta.lblTitle.text = "title_header_cancellation_cancellationProcess".localized
            }else{
                lblTitle.text = "title_payProcess_cancellationProcess".localized
                headerIAcepta.lblTitle.text = "title_header_rejected_cancellationProcess".localized
            }
        }
        headerIAcepta.btnHome.isHidden = true
        headerIAcepta.btnInfo.isHidden = true
        btnContinue.setTitle("btn_continue_cancellationProcess".localized, for: .normal)
        lblRejected.text = "title_rejected_cancellationProcess".localized
    }
    
    //Mark function: Btns
    @IBAction func continueAction(_ sender: Any) {
        switch (resultResponseType){
        case .some(.SERVICESSUCCESS):
            if resultKeyVerifone == .sendPayment{
                performSegue(withIdentifier: "unwindToStar", sender: self)
            }else{
                goSuccess()
            }
            break;
        default:
                failedAnswer()
            break;
        }
    }
    
    //Mark function: Externo
    func goSuccess(){
        if payProcess{
            if externo{
                let outPath = String(format: "%@://?Rechazado&%@",modelGlob.Static.integratorModel?.stringReverse ?? "",modelGlob.Static.txrModel?.responseCode ?? "")
                self.returnOpenURL(urlBack: outPath)
            }else{
                performSegue(withIdentifier: "unwindToStar", sender: self)
            }
        }else{
            if externo{
                let outPath = String(format: "%@://?Rechazado&09",modelGlob.Static.integratorModel?.stringReverse ?? "")
                self.returnOpenURL(urlBack: outPath)
            }else{
                performSegue(withIdentifier: "unwindToCancellationOrReturn", sender: self)
            }
        }
    }
    
    func failedAnswer(){
        if externo{
            let outPath = String(format: "%@://?Error_Timeout&97",modelGlob.Static.integratorModel?.stringReverse ?? "")
            self.returnOpenURL(urlBack: outPath)
        }
        if payProcess{
            performSegue(withIdentifier: "unwindToStar", sender: self)
        }else{
            performSegue(withIdentifier: "unwindToCancellationOrReturn", sender: self)
        }
    }
}
