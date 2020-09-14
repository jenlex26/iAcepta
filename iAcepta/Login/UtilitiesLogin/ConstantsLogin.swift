//
//  ConstantsLogin.swift
//  iAcepta
//
//  Created by QUALITY on 6/10/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
open class ConstantsLogin {
    //Production
    let serverUrl = Bundle.main.object(forInfoDictionaryKey: "ServerURL") as! String
    static let delegate = UIApplication.shared.delegate as! AppDelegate
//    static let prod = delegate.setProd
    static let ServerURL = Bundle.main.object(forInfoDictionaryKey: "ServerURL") as! String
    static let prod = ServerURL.bool

    //static let URL_Login = //"http://ns.bayteq.com:2005/PosMobileAuthentication.svc/authenticate"
    static let URL_Login = prod! ? "https://www.iacepta.com:2107/PosMobileAuthentication.svc/authenticate" : "http://ns.bayteq.com:2005/PosMobileAuthentication.svc/authenticate"
//    "http://ns.bayteq.com:2005/PosMobileAuthentication.svc/authenticate" //DES
//    "https://www.iacepta.com:2107/PosMobileAuthentication.svc/authenticate" //PROD
    
    static let URL_paswd = prod! ? "https://www.iacepta.com:2107/PosMobileAuthentication.svc/changePassword" : "http://ns.bayteq.com:2005/PosMobileAuthentication.svc/changePassword"
//    static let URL_paswd = "http://ns.bayteq.com:2005/PosMobileAuthentication.svc/changePassword" // DES
    static let oauth_consumer_key = "oauth_consumer_key"
    static let oauth_nonce = "oauth_nonce"
    static let oauth_signature = "oauth_signature"
    static let oauth_signature_method = "oauth_signature_method=HMAC-SHA1&"
    static let oauth_timestamp = "oauth_timestamp"
    static let oauth_version = "oauth_version"
    static let oauth_value_version = "1.0"
    static let oauth_header = "oauth_header"
    static let oauth_real = "OAuth realm"
    static let consumer_new_paswd = "consumer_new_password"
    static let oauth_header_new_paswd = "oauthHeader"
    //Develop
    //    static let URL_Login = "http://ns.bayteq.com:2005/PosMobileAuthentication.svc/"
    static let url_upDate = "https://apps.apple.com/mx/app/iacepta-3-0/id821023544"
}
