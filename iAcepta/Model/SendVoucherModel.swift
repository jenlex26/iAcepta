//
//  SendVoucherModel.swift
//  iAcepta
//
//  Created by QUALITY on 7/16/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import SwiftyJSON

class SendVoucherModel:NSObject, NSCoding {
    
    
    var userId: String?
    var nodeId:String?
    var scope:String?
    var expiration:String?
    var secureToken:String?
    var address:String?
    var commerceName:String?
    var memberShip:String?
    var terminal:String?
    var date:String?
    var cardIssuer:String?
    var cardNumber:String?
    var aplLabel:String?
    var prefName:String?
    var aid:String?
    var arqc:String?
    var authorization:String?
    var trxAmount:String?
    var trxTip:String?
    var trxTotal:String?
    var trxMonths:String?
    var cardHolder:String?
    var sign:String?
    var location:String?
    var latitud:String?
    var longitud:String?
    var trxSequence:String?
    var trxTracing:String?
    var trxType:String?
    var emailClient:String?
    var cardType:String?
    var cardEntryMode:String?
    var VoucherType:String?
    var isNipValidation:Bool?
    
    init(userId: String? = nil, nodeId: String? = nil, scope: String? = nil, expiration: String? = nil, secureToken: String? = nil, address: String? = nil, commerceName: String? = nil, memberShip: String? = nil, terminal: String? = nil, date: String? = nil, cardIssuer: String? = nil, cardNumber: String? = nil, aplLabel: String? = nil, prefName: String? = nil, aid: String? = nil, arqc: String? = nil, authorization: String? = nil, trxAmount: String? = nil, trxTip: String? = nil, trxTotal: String? = nil, trxMonths: String? = nil, cardHolder: String? = nil, sign: String? = nil, location: String? = nil, latitude: String? = nil, longitude: String? = nil, trxSequence: String? = nil, trxTracing: String? = nil, trxType: String? = nil, emailClient: String? = nil, cardType: String? = nil, cardEntryMode: String? = nil, VoucherType: String? = nil){
        self.userId = userId
        self.nodeId = nodeId
        self.scope = scope
        self.expiration = expiration
        self.secureToken = secureToken
        self.address = address
        self.commerceName = commerceName
        self.memberShip = memberShip
        self.terminal = terminal
        self.date = date
        self.cardIssuer = cardIssuer
        self.cardNumber = cardNumber
        self.aplLabel = aplLabel
        self.prefName = prefName
        self.aid = aid
        self.arqc = arqc
        self.authorization = authorization
        self.trxAmount = trxAmount
        self.trxTip = trxTip
        self.trxTotal = trxTotal
        self.trxMonths = trxMonths
        self.cardHolder = cardHolder
        self.sign = sign
        self.location = location
        self.latitud = latitude
        self.longitud = longitude
        self.trxSequence = trxSequence
        self.trxTracing = trxTracing
        self.trxType = trxType
        self.emailClient = emailClient
        self.cardType = cardType
        self.cardEntryMode = cardEntryMode
        self.VoucherType = VoucherType
        
    }
    
    func encode(with aCoder: NSCoder) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
       /* self.userId = aDecoder.decodeObject(forKey: "userId")  as? String ?? ""
        self.nodeId = aDecoder.decodeObject(forKey: "nodeId")  as? String ?? ""
        self.scope = aDecoder.decodeObject(forKey: "scope")  as? String ?? ""
        self.expiration = aDecoder.decodeObject(forKey: "expiration")  as? String ?? ""
        self.secureToken = aDecoder.decodeObject(forKey: "secureToken")  as? String ?? ""
        self.address = aDecoder.decodeObject(forKey: "address")  as? String ?? ""
        self.commerceName = aDecoder.decodeObject(forKey: "commerceName")  as? String ?? ""
        self.memberShip = aDecoder.decodeObject(forKey: "memberShip")  as? String ?? ""
        self.terminal = aDecoder.decodeObject(forKey: "terminal")  as? String ?? ""
        self.date = aDecoder.decodeObject(forKey: "date")  as? String ?? ""
        self.cardIssuer = aDecoder.decodeObject(forKey: "cardIssuer")  as? String ?? ""
        self.cardNumber = aDecoder.decodeObject(forKey: "cardNumber")  as? String ?? ""
        self.aplLabel = aDecoder.decodeObject(forKey: "aplLabel")  as? String ?? ""
        self.prefName = aDecoder.decodeObject(forKey: "prefName")  as? String ?? ""
        self.aid = aDecoder.decodeObject(forKey: "aid")  as? String ?? ""
        self.arqc = aDecoder.decodeObject(forKey: "arqc")  as? String ?? ""
        self.authorization = aDecoder.decodeObject(forKey: "authorization")  as? String ?? ""
        self.trxAmount = aDecoder.decodeObject(forKey: "trxAmount")  as? String ?? ""
        self.trxTip = aDecoder.decodeObject(forKey: "trxTip")  as? String ?? ""
        self.trxTotal = aDecoder.decodeObject(forKey: "trxTotal")  as? String ?? ""
        self.trxMonths = aDecoder.decodeObject(forKey: "trxMonths")  as? String ?? ""
        self.cardHolder = aDecoder.decodeObject(forKey: "cardHolder")  as? String ?? ""
        self.sign = aDecoder.decodeObject(forKey: "sign")  as? String ?? ""
        self.location = aDecoder.decodeObject(forKey: "location")  as? String ?? ""
        self.latitude = aDecoder.decodeObject(forKey: "latitude")  as? String ?? ""
        self.longitude = aDecoder.decodeObject(forKey: "longitude")  as? String ?? ""
        self.trxSequence = aDecoder.decodeObject(forKey: "trxSequence")  as? String ?? ""
        self.trxTracing = aDecoder.decodeObject(forKey: "trxTracing")  as? String ?? ""
        self.trxType = aDecoder.decodeObject(forKey: "trxType")  as? String ?? ""
        self.emailClient = aDecoder.decodeObject(forKey: "emailClient")  as? String ?? ""
        self.cardType = aDecoder.decodeObject(forKey: "cardType")  as? String ?? ""
        self.cardEntryMode = aDecoder.decodeObject(forKey: "cardEntryMode")  as? String ?? ""
        self.VoucherType = aDecoder.decodeObject(forKey: "VoucherType")  as? String ?? ""*/
    }
    
}
