//
//  Constants.swift
//  iAcepta
//
//  Created by Air on 5/22/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation

open class Constants {
    //Production
   // static let URL_Login = "https://www.iaceptamx.com:2107/PosMobileAuthentication.svc/"
    
    static let showChangepaswd = "showChangepaswd"
    static let showEnterUP = "showEnterUser_Password"
    static let showEnterSign = "showEnterUser_Signature"
    static let tip = "propina"
    static let mounthsWithoutInterest = "meses"
    static let showRoot = "showRoot"
    static let returPrevious = "returPrevious"
    static let delegate = UIApplication.shared.delegate as! AppDelegate
    static let ServerURL = Bundle.main.object(forInfoDictionaryKey: "ServerURL") as! String
    static let prod = ServerURL.bool
    static let urlheader = prod! ? "https://iaceptamx.com:8446" : "http://152.151.41.71:8444"
    static let urlheaderVoucher = prod! ? "https://www.iacepta.com:2207" : "http://ns.bayteq.com:23077"
//    static let urlheader = "https://iaceptamx.com:8446"
//    static let urlheader = "http://152.151.41.71:8444"
    static let urls = true
    //(txrModel?.aid == nil) ? "" : txrModel?.aid
    //Develop
    static let URL_Login         = (urls) ? "http://ns.bayteq.com:2005/PosMobileAuthentication.svc/" : ""
    static let URL_Cancelation   = (urls) ? "\(urlheader)/WS_Banamex_Services/resources/Pago": ""
    static let URL_PaymentWalker = (urls) ? "\(urlheader)/WS_Banamex_Walker/resources/PagoWalker" : ""
    static let URL_Verifone      = (urls) ? "\(urlheader)/WS_EvoPayments_CapX/resources/PagoCapituloX" : ""
    static let URL_Voucher       = (urls) ? "\(urlheaderVoucher)/PosMobileService.svc/SendVoucher" : ""
    static let URL_CapX          = (urls) ? "\(urlheader)/WS_EvoPayments_CapX/resources/PagoCapituloX" : ""
    
    static let URL_Codi          = (urls) ? "\(urlheader)/iAcepta_WS_CODI/services" : ""
//    "http://152.151.41.71:8444/iAcepta_WS_CODI/services"
    
    //https://www.iaceptamx.com:8446/WS_Banamex_Walker/resources/PagoWalker //PROD
    static let POSENTRYMODE_VERIFONE = "051"
    static let POSENTRYMODE_VERIFONE_SWIPE = "901"
    static let POSENTRYMODE_VERIFONE_FALLBACK = "801"
    static let POSENTRYMODE_VERIFONE_CONTACTLESS = "071"
    
    static let authorizedVerifone = 0
    static let declineVerifone = 1
    static let netErrorVerifone = 2
}
