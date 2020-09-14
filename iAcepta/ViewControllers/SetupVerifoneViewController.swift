//
//  SetupVerifoneViewController.swift
//  iAcepta
//
//  Created by QUALITY on 8/19/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import UIKit
enum statusKeysVerifone {
    case start
    case sendPayment
}
class SetupVerifoneViewController: MasterViewController {
    
    @IBOutlet weak var imgVerifone: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnTryAgain: UIButton!{didSet{btnTryAgain.setRoundedLayout(button: btnTryAgain)}}
    @IBOutlet weak var btnCancel: UIButton!{didSet{btnCancel.setRoundedLayout(button: btnCancel)}}
    @IBOutlet weak var btnContinue: UIButton!{didSet{btnContinue.setRoundedLayout(button: btnContinue)}}
    @IBOutlet weak var imgResponse: UIImageView!
    @IBOutlet weak var headerIAcepta: headeriAcepta!
    
    var isFinished:Bool = false
    var status:Bool = false
    var statusKeyVerifone:statusKeysVerifone?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        validateFinished()
        setHeader()
    }
    
    func setHeader(){
        headerIAcepta.btnHome.isHidden = true
        headerIAcepta.lblTitle.text = "Pagos"
    }
    
    func validateFinished(){
        if !(isFinished){
            lblTitle.text = "La configuracion del lector no se ha realizado correctamente."
            btnTryAgain.isHidden = false
            btnCancel.isHidden = false
            imgResponse.image = UIImage(named: "rejected_img")
        }else{
            imgResponse.image = UIImage(named: "check_green")
            lblTitle.text = "Lector configurado correctamente."
            btnContinue.isHidden = false
        }
    }
    
    
    @IBAction func retryAction(_ sender: Any) {
        self.performSegue(withIdentifier: "retrySetupVerifone", sender: self)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        modelGlob.Static.verifoneSDK?.cancelTransaction()
        switch (statusKeyVerifone) {
        case .start?:
            performSegue(withIdentifier: "unwindToTransactionData", sender: self)
            break
        case .sendPayment?:
            performSegue(withIdentifier: "showRejected", sender: self)
            break
        case .none:
            print("")
        }
        
    }
    
    @IBAction func continueAction(_ sender: Any) {
        performSegue(withIdentifier: "unwindToReadCard", sender: self)
    }
    
    //Function MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRejected"{
            if let destinationVC = segue.destination as? CancellationProcessViewController {
                destinationVC.resultResponseType = .SERVICESSUCCESS
                destinationVC.resultKeyVerifone = statusKeyVerifone
            }
        }else if segue.identifier == "retrySetupVerifone"{
            if let destinationVC = segue.destination as? LoaderSetupVerifoneViewController {
                destinationVC.statusKeyVerifone = statusKeyVerifone
            }
        }
    }
}
