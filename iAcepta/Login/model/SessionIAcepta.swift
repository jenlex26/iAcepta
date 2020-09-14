//
//  SessionIAcepta.swift
//  iAcepta
//
//  Created by QUALITY on 6/7/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import UIKit

class SessionIAcepta:NSObject, NSCoding{
    
    var authToken: String
    var userID: String
    var userPhoneNumber: String
    var comerceName: String
    var comerAddres : String
    var daysForExpiration : Int
    var tokenExpiration : String
    var amexFlag : String?
    
    var hasPayment : Bool? = false
    var hasCancellation:Bool? = false
    var hasRefund:Bool? = false
    var hasAcceptTip:Bool? = false
    var hasMultiPayment:Bool? = false
    var hascodi:Bool? = false
    
    var setCancellationHeader:Bool? = false
    
    var canAcceptOPT:Bool? = false
    var canAcceptPayAmex:Bool? = false
    var canAcceptPayToBad:Bool? = false
    var canAcceptTip:Bool? = false
    
    var rangeMsi:Array? = []
    var scope:String?
    
    var userInfo : UserInfoLoginModel?
    
    var userNameTxt:String?

    
    init(authToken:String, userID:String,userPhoneNumber:String, comerceName:String, comerAddres:String, daysForExpiration:Int, tokenExpiration:String) {
        self.authToken = authToken
        self.userID = userID
        self.userPhoneNumber = userPhoneNumber
        self.comerceName = comerceName
        self.comerAddres = comerAddres
        self.daysForExpiration = daysForExpiration
        self.tokenExpiration = tokenExpiration
    }
    
    
    required init(coder aDecoder: NSCoder) {
        self.authToken = aDecoder.decodeObject(forKey: "authToken")  as? String ?? ""
        self.userID = aDecoder.decodeObject(forKey: "userID") as? String ?? ""
        self.userPhoneNumber = aDecoder.decodeObject(forKey: "userPhoneNumber")  as? String ?? ""
        self.comerceName = aDecoder.decodeObject(forKey:"comerceName")  as? String ?? ""
        self.comerAddres = aDecoder.decodeObject(forKey: "comerAddres")  as? String ?? ""
        self.daysForExpiration = aDecoder.decodeObject(forKey: "daysForExpiration")  as? Int ?? 0
        self.tokenExpiration = aDecoder.decodeObject(forKey: "tokenExpiration")  as? String ?? ""
        self.hasPayment = aDecoder.decodeObject(forKey: "hasPayment")  as? Bool
        self.hasCancellation = aDecoder.decodeObject(forKey: "hasCancellation")  as? Bool
        self.hasRefund = aDecoder.decodeObject(forKey: "hasRefund")  as? Bool
        self.hasAcceptTip = aDecoder.decodeObject(forKey: "hasAcceptTip")  as? Bool
        self.hasMultiPayment = aDecoder.decodeObject(forKey: "hasMultiPayment")  as? Bool
        self.hascodi = aDecoder.decodeObject(forKey: "hascodi")  as? Bool
        self.rangeMsi = aDecoder.decodeObject(forKey: "rangeMsi")  as? Array
        self.canAcceptOPT = aDecoder.decodeObject(forKey: "canAcceptOPT")  as? Bool
        self.canAcceptPayAmex = aDecoder.decodeObject(forKey: "canAcceptPayAmex")  as? Bool
        self.canAcceptPayToBad = aDecoder.decodeObject(forKey:"canAcceptPayToBad") as? Bool
        self.canAcceptTip = aDecoder.decodeObject(forKey:"canAcceptTip") as? Bool
        self.userInfo = aDecoder.decodeObject(forKey:"userInfo") as? UserInfoLoginModel
        self.scope = aDecoder.decodeObject(forKey:"scope") as? String ?? ""
        self.userNameTxt = aDecoder.decodeObject(forKey:"userNameTxt") as? String ?? ""
        self.amexFlag = aDecoder.decodeObject(forKey:"amexFlag") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.authToken, forKey: "authToken")
        aCoder.encode(self.userID, forKey: "userID")
        aCoder.encode(self.userPhoneNumber, forKey: "userPhoneNumber")
        aCoder.encode(self.comerceName, forKey: "comerceName")
        aCoder.encode(self.comerAddres, forKey: "comerAddres")
        aCoder.encode(self.daysForExpiration, forKey: "daysForExpiration")
        aCoder.encode(self.tokenExpiration, forKey: "tokenExpiration")
        aCoder.encode(self.hasPayment, forKey: "hasPayment")
        aCoder.encode(self.hasCancellation, forKey: "hasCancellation")
        aCoder.encode(self.hasRefund, forKey: "hasRefund")
        aCoder.encode(self.hasAcceptTip, forKey: "hasAcceptTip")
        aCoder.encode(self.hasMultiPayment, forKey: "hasMultiPayment")
        aCoder.encode(self.hascodi, forKey: "hascodi")
        aCoder.encode(self.canAcceptOPT, forKey: "canAcceptOPT")
        aCoder.encode(self.rangeMsi, forKey: "rangeMsi")
        aCoder.encode(self.canAcceptPayAmex, forKey: "canAcceptPayAmex")
        aCoder.encode(self.canAcceptPayToBad, forKey: "canAcceptPayToBad")
        aCoder.encode(self.canAcceptTip, forKey: "canAcceptTip")
        aCoder.encode(userInfo, forKey: "userInfo")
        aCoder.encode(scope, forKey: "scope")
        aCoder.encode(userNameTxt, forKey: "userNameTxt")
        aCoder.encode(self.amexFlag, forKey: "amexFlag")
    }

}
