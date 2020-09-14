//
//  splashCodiViewController.swift
//  iAcepta
//
//  Created by QUALITY on 11/02/20.
//  Copyright © 2020 Quality & Knowledge. All rights reserved.
//

import UIKit

class splashCodiViewController: MasterViewController {
    
    var identificationData = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllerSelected = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.present(self.vc, animated: true) {
                CodiPresenter.wallet({ (result) in
                    self.vc.dismiss(animated: true) {
                        switch result {
                        case .success(let success):
                            self.identificationData = success?.walletsResponse?.wallets[0].Identification ?? ""
                            debugPrint(success?.walletsResponse?.wallets[0].Identification ?? "")
                            self.performSegue(withIdentifier: "toPay", sender: self)
                            break
                        case .failure(let fail):
                            debugPrint(fail)
                            if fail.content.code == 404 || fail.content.code == 400 {
                                self.alertServicesLogin(alertTitle: "titleAlertiAcepta".localized, message: fail.content.reason, alertBtnFirst: "titleBtnAlert_Accept".localized, completion: {
                                    self.dismiss(animated: true) {
                                        self.performSegue(withIdentifier: "unwindToStar", sender: self)
                                    }
                                })
                            }
                            self.performSegue(withIdentifier: "toError", sender: self)
                            break
                        }
                    }
                })
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPay"{
            if let destinationVC = segue.destination as? detailPaymentViewController{
                destinationVC.identificationService = identificationData
                destinationVC.viewControllerSelected = 0
            }
        }
    }
}
