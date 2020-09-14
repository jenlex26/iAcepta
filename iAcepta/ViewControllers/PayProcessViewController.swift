//
//  PayProcessViewController.swift
//  iAcepta
//
//  Created by QUALITY on 6/5/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import UIKit

class PayProcessViewController: MasterViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var authorizationLabel: UILabel!
    @IBOutlet weak var authorizationSignatureLabel: UILabel!
    @IBOutlet weak var btnAccept: UIButton!{didSet{btnAccept.setRoundedLayout(button: btnAccept)}}
    
    @IBOutlet weak var headeriAcepta: headeriAcepta!
    @IBOutlet weak var constraintBottom: NSLayoutConstraint!
    
    var showConstraints : Bool = false
    var payProcess:Bool = false
    
    var multiPagos:Bool = false
    var arregloDatosTrans:NSArray = []
    var regreso:String = ""
    var old:Bool = false
    var useVerifone:Bool = false
    var useIngenico:Bool = false
    var cardNumber:String = ""
    
    var typeApproved = ""
    
    let servicesLogic = ServicesIAceptaLogic()
    var info: SuccessfulPaymentModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setProcess()
        setText()
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showConstrain()
    }
    
    // MARK: Functions
    func showConstrain() {
        if (!showConstraints) {
            let screenSize = UIScreen.main.bounds
            let screenHeight = screenSize.height
            if !(screenHeight <= 600){
                constraintBottom.constant = 30
            }
            showConstraints = true
        }
    }
    
    func setText() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        headeriAcepta.btnHome.isHidden = true
        headeriAcepta.btnInfo.isHidden = true
        titleLabel.text = (typeApproved == "") ? "titlePayProcess".localized : typeApproved
        resultLabel.text = "text_result_PayProcess".localized
        authorizationSignatureLabel.text = "text_authorizationSignature_PayProcess".localized
        btnAccept.setTitle("btn_continue".localized, for: .normal)
    }
    
    func setData(){
        if let total = modelGlob.Static.txrModel?.total{
            totalLabel.text = String(format: "%@%@", "text_total_PayProcess".localized,total)
        }
        if let autorizacion = modelGlob.Static.txrModel?.authorization{
            authorizationLabel.text = String(format: "%@%@", "text_authorization_PayProcess".localized, autorizacion)
        }
        authorizationSignatureLabel.isHidden = !(modelGlob.Static.txrModel?.authorizationByNIP ?? false)
    }
    
    func setProcess(){
        if payProcess{
            headeriAcepta.lblTitle.text = "title_header_sucess_payProcess".localized
        } else{
            if sessionGlob.Static.sessionIAcepta!.setCancellationHeader!{
                headeriAcepta.lblTitle.text = "title_header_cancellation_payProcess".localized
            }else{
                headeriAcepta.lblTitle.text = "title_header_rejected_payProcess".localized
            }
        }
    }
    
    @IBAction func continueAction(_ sender: Any) {
             performSegue(withIdentifier: "showVoucherWithNip", sender: self) 
    }
    
    //Mark:Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVoucherWithNip"{
            if let destinationVC = segue.destination as? LoaderAnimationVoucher {
                destinationVC.cardNumber = cardNumber
                destinationVC.payProcess = payProcess
            }
        }
    }
    
}
