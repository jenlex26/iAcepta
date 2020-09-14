//
//  LoaderAnimationIntegrator.swift
//  iAcepta
//
//  Created by QUALITY on 8/13/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import UIKit
class LoaderAnimationIntegrator: MasterViewController {
    
    @IBOutlet weak var loaderImg: UIImageView!
    @IBOutlet weak var headerIAcepta: headeriAcepta!

    
    var integratorModel:IntegratorModel?
    let loginLogic = LoginLogic()
    var imgArray:[UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        integratorModel = modelGlob.Static.integratorModel
        loginLogic.delegate = self
        setHeader()
        loader()
        login()

    }
    
    //Function MARK: Header
    func setHeader(){
        headerIAcepta.btnInfo.isHidden = true
        headerIAcepta.btnHome.isHidden = true
        if integratorModel?.typeTransfers == "Pago"{
            headerIAcepta.lblTitle.text = "lbl_title_payment_loaderIntegrator".localized
        }else if integratorModel?.typeTransfers == "Cancelacion"{
            headerIAcepta.lblTitle.text = "lbl_title_cancel_loaderIntegrator".localized
        }else if integratorModel?.typeTransfers == "Devolucion"{
            headerIAcepta.lblTitle.text = "lbl_title_refund_loaderIntegrator".localized
        }
    }
    
    //Function MARK: Loader
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
    
    //Function MARK: Login
    func login(){
        loginLogic.loginRequest(modelGlob.Static.integratorModel?.name ?? "", modelGlob.Static.integratorModel?.password ?? "")
    }
}
extension LoaderAnimationIntegrator:LoginLogicDelegate{
    func loginResponse(_ responseType: LoginResponseType) {
        loaderImg.stopAnimating()
        imgArray = []
        typeTransfers = modelGlob.Static.integratorModel?.typeTransfers ?? ""
        //modelGlob.Static.integratorModel = IntegratorModel()
//        alert(alertTitle: "test", message: "\(integratorModel?.name ?? ""),\(integratorModel?.password ?? ""),\(integratorModel?.typeTransfers ?? ""), \(integratorModel?.stringReverse ?? "") , \( integratorModel?.infoExtra ?? "") , \(integratorModel?.externo ?? true)" , alertBtnFirst: "aceptar") {
//
//        }
        switch responseType {
        case .LOGINWASSUCCESS:
            if integratorModel?.typeTransfers == "Pago"{
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "setValuesToPay", sender: self)
                }
            }else if integratorModel?.typeTransfers == "Cancelacion"{
                let cancellation = sessionGlob.Static.sessionIAcepta?.hasCancellation ?? false
                if cancellation{
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "setValuesToCancellation", sender: self)
                    }
                }else{
                    let outPath = String(format: "%@://?Invalido&98", integratorModel?.stringReverse ?? "")
                    self.returnOpenURL(urlBack: outPath)
                }
            }else if integratorModel?.typeTransfers == "Devolucion"{
                let refund = sessionGlob.Static.sessionIAcepta?.hasRefund ?? false
                if refund{
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "setValuesToCancellation", sender: self)
                    }
                }else{
                    let outPath = String(format: "%@://?Invalido&98", integratorModel?.stringReverse ?? "")
                    self.returnOpenURL(urlBack: outPath)
                }
            }else{
                let outPath = String(format: "%%@://?Invalido&98", integratorModel?.stringReverse ?? "")
                self.returnOpenURL(urlBack: outPath)
            }
            break
        default:
            let outPath = String(format: "%@://?Error_Login&99", integratorModel?.stringReverse ?? "")
            self.returnOpenURL(urlBack: outPath)
            break
        }
    }
}
