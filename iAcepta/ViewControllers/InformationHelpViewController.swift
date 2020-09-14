//
//  InformationHelpViewController.swift
//  iAcepta
//
//  Created by QUALITY on 7/16/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import UIKit

class InformationHelpViewController: MasterViewController {
    
    var selectViewInfo:Bool?
    
    @IBOutlet weak var viewHelp: UIView!
    @IBOutlet weak var constUpdate: NSLayoutConstraint!
    @IBOutlet weak var versionLbl: UILabel!
    
    
    var fullString = NSMutableAttributedString()
    let xib = InformationViewController()
    var contentName:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var viewInf = UIView()
        if contentName == "Main"{
            viewInf = xib.instanceFromNibView6(size: view.frame.width)!
            constUpdate.constant = (viewInf.frame.size.height)
            viewHelp.addSubview(viewInf)
        }else if contentName == "TransactionData"{
            viewInf = xib.instanceFromNibView3(size: view.frame.width)!
            constUpdate.constant = (viewInf.frame.size.height)
            viewHelp.addSubview(viewInf)
        }else if contentName == "Cacellation"{
            viewInf = xib.instanceFromNib(size: view.frame.width)!
            constUpdate.constant = (viewInf.frame.size.height)
            viewHelp.addSubview(viewInf)
        } else if contentName == "Return"{
            viewInf = xib.instanceFromNibView4(size: view.frame.width)!
            constUpdate.constant = (viewInf.frame.size.height)
            viewHelp.addSubview(viewInf)
        } else if contentName == "InfoWisepad"{
                   viewInf = xib.instanceFromNibView7(size: view.frame.width)!
                   constUpdate.constant = (viewInf.frame.size.height)
                   viewHelp.addSubview(viewInf)
        } else if contentName == "InfoVoucher"{
                          viewInf = xib.instanceFromNibView5(size: view.frame.width)!
                          constUpdate.constant = (viewInf.frame.size.height)
                          viewHelp.addSubview(viewInf)
               }
        else{
            viewInf = xib.instanceFromNibView2(size: view.frame.width)!
            constUpdate.constant = (viewInf.frame.size.height)
            viewHelp.addSubview(viewInf)
        }
        versionLbl.text = "Versión: \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "")"
         
    }
    


    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    @IBAction func btnCall(_ sender: Any) {if let url = NSURL(string: "tel://\(8003008888)"), UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    @IBAction func btnCallInterCDMX(_ sender: Any) {
        if let url = NSURL(string: "tel://\(83109100)"), UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.openURL(url as URL)
        }
    }
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
