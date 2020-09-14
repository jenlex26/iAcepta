//
//  voucherCodiViewController.swift
//  iAcepta
//
//  Created by Javier Hernandez on 08/07/20.
//  Copyright © 2020 Quality & Knowledge. All rights reserved.
//

import Foundation
import UIKit

class voucherCodiViewController: MasterViewController {
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var adress: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var referenceTitle: UILabel!
    @IBOutlet weak var reference: UILabel!
    @IBOutlet weak var nameUserTitle: UILabel!
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var destinationAccountTitle: UILabel!
    @IBOutlet weak var destinationAccount: UILabel!
    @IBOutlet weak var autorizacionTitle: UILabel!
    @IBOutlet weak var autorizacion: UILabel!
    @IBOutlet weak var aceptBtn: UIButton!{didSet{aceptBtn.setRoundedLayout(button: aceptBtn)}}
    
    @IBOutlet weak var header: headeriAcepta!
    var amountService = ""
    var referenceService = ""
    var alertService = ""
    var emailService = ""
    var voucherService = [""]
    var txrSession:SessionIAcepta?
    override func viewDidLoad() {
        super.viewDidLoad()
        txrSession = sessionGlob.Static.sessionIAcepta
        viewBack.layer.cornerRadius = 27.5
        name.text   = (txrSession?.comerceName == nil) ? "" : txrSession?.comerceName
        adress.text = (txrSession?.comerAddres == nil) ? "" : txrSession?.comerAddres
        amount.text = amountService.currency()!
        reference.text = referenceService

        header.delegate = self
        header.lblTitle.text = "Comprobante CoDi"
        header.constraintCenter.constant = 0
        header.btnHome.isHidden = true
        header.btnInfo.isHidden = true
        
        if voucherService.count > 1 {
        nameUserTitle.text      = voucherService[0].isEmpty ? "" : voucherService[0]
        nameUser.text           = voucherService[1].isEmpty ? "" : voucherService[1]
        destinationAccount.text = voucherService[2].isEmpty ? "" : voucherService[2]
        destinationAccount.text = voucherService[3].isEmpty ? "" : voucherService[3]
        autorizacionTitle.text  = voucherService[4].isEmpty ? "" : voucherService[4]
        autorizacion.text       = voucherService[5].isEmpty ? "" : voucherService[5]
            
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if alertService != "" {
            alert(alertTitle: "iAcepta", message: alertService, alertBtnFirst: "Aceptar") {
                self.dismiss(animated: true) {
                    self.printDev(object: "mandar servicio de baytec")
                }
            }
        }
    }
    
    
    @IBAction func aceptAction(_ sender: Any) {
        let amountVoucher = self.amountService.currency()!.replacingOccurrences(of: "$", with: "")
        var cardIssuerVoucher    = "NO DISPONIBLE"
        var cardNumberVoucher    = "NO DISPONIBLE"
        var authorizationVoucher = "NO_DISPONIBLE"
        let sequence = String(HelperExtensions().random(digits: 10))
        let emailClient = emailService

        
        if voucherService.count > 1 {
            cardIssuerVoucher    = self.voucherService[1].isEmpty ? "" : voucherService[1]
            cardNumberVoucher    = self.voucherService[3].isEmpty ? "" : voucherService[3]
            authorizationVoucher = self.voucherService[5].isEmpty ? "" : voucherService[5]
        }
        self.present(self.vc, animated: true) {
            CodiPresenter.sendVoucher(amountVoucher, cardIssuerVoucher, cardNumberVoucher, authorizationVoucher,sequence, emailClient) { (result) in
                self.vc.dismiss(animated: true) {
                    switch result {
                    case .success( _):
                        self.performSegue(withIdentifier: "unwindToStar", sender: self)
                        break
                    case .failure(let fail):
                        self.alertServicesLogin(alertTitle: "titleAlertiAcepta".localized, message: fail.content.reason, alertBtnFirst: "titleBtnAlert_Accept".localized, completion: {
                            self.dismiss(animated: true) {
                                let data: [String: Any] = [
                                    "date": Date.toDayStringFormat(),
                                    "cardIssuer": cardIssuerVoucher,
                                    "cardNumber": cardNumberVoucher,
                                    "aplLabel": "",
                                    "prefName" : "",
                                    "aid": "",
                                    "arqc": "",
                                    "authorization": authorizationVoucher,
                                    "trxAmount": amountVoucher,
                                    "trxTip": "0.00",
                                    "trxTotal": amountVoucher,
                                    "trxMonths": "",
                                    "cardholder": "",
                                    "trxSequence": sequence,
                                    "emailClient": "",
                                    "cardType": "",
                                    "dateName": "",
                                    "chip": "",
                                    "cardEntryMode": "",
                                    "hasNIP": "",
                                    "showMap": ""
                                ]
                                let archivedFriends = NSKeyedArchiver.archivedData(withRootObject: data)
                                var dataGral = NSData()
                                
                                dataGral = RNCryptor.encrypt(data: archivedFriends, withPaswd: "&QsCxZdEwArTfCgYuHb%$op=lKjnMbHy") as NSData
                                
                                let voucher = SaveVoucher()
                                voucher.voucherIAcepta = DBManagerVoucher.sharedInstance.getDataFromDB().count
                                voucher.dateVoucher = dataGral as Data
                                voucher.idUserVoucher = (self.txrSession?.userID == nil) ? "" : self.txrSession!.userID
                                voucher.userNameVoucher = (self.txrSession?.userNameTxt == nil) ? "" : (self.txrSession?.userNameTxt)!
                                voucher.hasNip = modelGlob.Static.txrModel?.authorizationByNIP ?? false
                                voucher.codi = true
                                DBManagerVoucher.sharedInstance.addDataSafe(object: voucher){
                                    self.performSegue(withIdentifier: "unwindToStar", sender: self)
                                }
                            }
                        })
                        break
                    }
                }
            }
        }
    }
}

extension voucherCodiViewController:headerActoionDelegate{
    func btnHome() {
        printDev(object: "")
    }
    func btnInfo() {
        printDev(object: "")
    }
}
