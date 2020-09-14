//
//  TypePaymentsRejectedModel.swift
//  iAcepta
//
//  Created by QUALITY on 7/2/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import SwiftyJSON

class TypePaymentsRejectedModel:NSObject, NSCoding {
    
    var switchCommand: String
    var processingCode: String
    var amount: String
    var time: String
    var merchantId: String
    var posEntryMode: String
    var track2Data: String?
    var retreivalReference: String
    var terminalId: String
    var location: String
    var usrId: String
    var nodId: String
    var type: String
    var idDevice: String?
    var typeCard: String?
    var media: String
    var monthPromotion: String?
    var namePromotion: String?
    var solution: String?
    var authoResponse: String?
    var affiliate: String
    
    
    var responseCode: String?
    var scope: String?
    var timestamp: String?
    var secureToken: String?
    var chapterX: String?
    var dateAndTime: String?
    
    var cardHolder: String?
    var tipAmount: String?
    var tipPercentage: String?
    var track1Data: String?
    var date: String?
    var reference: String?
    var email:String?
    var ksn:String?
    var traceAudit:String?
    var networkInfo:String?
    var walker:String? = nil
    var chip:String?
    var dateAndHours:String?
 
    init(switchCommand:String, processingCode:String, amount:String, time:String, merchantId:String, posEntryMode:String, retreivalReference:String, terminalId:String, location:String, usrId:String, nodId:String, type:String, media:String, affiliate:String) {
        self.switchCommand = switchCommand
        self.processingCode = processingCode
        self.amount = amount
        self.time = time
        self.merchantId = merchantId
        self.posEntryMode = posEntryMode
        self.retreivalReference = retreivalReference
        self.terminalId = terminalId
        self.location = location
        self.usrId = usrId
        self.nodId = nodId
        self.type = type
        self.media = media
        self.affiliate = affiliate
        
    }
    
    required init(coder aDecoder: NSCoder) {
        self.switchCommand = aDecoder.decodeObject(forKey: "switchCommand")  as? String ?? ""
        self.processingCode = aDecoder.decodeObject(forKey: "processingCode")  as? String ?? ""
        self.amount = aDecoder.decodeObject(forKey: "amount")  as? String ?? ""
        self.time = aDecoder.decodeObject(forKey: "time")  as? String ?? ""
        self.merchantId = aDecoder.decodeObject(forKey: "merchantId")  as? String ?? ""
        self.posEntryMode = aDecoder.decodeObject(forKey: "posEntryMode")  as? String ?? ""
        self.track2Data = aDecoder.decodeObject(forKey: "track2Data")  as? String ?? ""
        self.retreivalReference = aDecoder.decodeObject(forKey: "retreivalReference")  as? String ?? ""
        self.terminalId = aDecoder.decodeObject(forKey: "terminalId")  as? String ?? ""
        self.location = aDecoder.decodeObject(forKey: "location")  as? String ?? ""
        self.usrId = aDecoder.decodeObject(forKey: "usrId")  as? String ?? ""
        self.nodId = aDecoder.decodeObject(forKey: "nodId")  as? String ?? ""
        self.type = aDecoder.decodeObject(forKey: "type")  as? String ?? ""
        self.idDevice = aDecoder.decodeObject(forKey: "idDevice")  as? String ?? ""
        self.typeCard = aDecoder.decodeObject(forKey: "typeCard")  as? String ?? ""
        self.media = aDecoder.decodeObject(forKey: "media")  as? String ?? ""
        self.monthPromotion = aDecoder.decodeObject(forKey: "monthPromotion")  as? String ?? ""
        self.namePromotion = aDecoder.decodeObject(forKey: "namePromotion")  as? String ?? ""
        self.solution = aDecoder.decodeObject(forKey: "solution")  as? String ?? ""
        self.authoResponse = aDecoder.decodeObject(forKey: "authoResponse")  as? String ?? ""
        self.affiliate = aDecoder.decodeObject(forKey: "affiliate")  as? String ?? ""
        
        self.date = aDecoder.decodeObject(forKey: "date")  as? String ?? ""
        self.track1Data = aDecoder.decodeObject(forKey: "track1Data")  as? String ?? ""
        self.tipPercentage = aDecoder.decodeObject(forKey: "tipPercentage")  as? String ?? ""
        self.tipAmount = aDecoder.decodeObject(forKey: "tipAmount")  as? String ?? ""
        self.cardHolder = aDecoder.decodeObject(forKey: "cardHolder")  as? String ?? ""
        self.reference = aDecoder.decodeObject(forKey: "reference") as? String ?? ""
        self.email = aDecoder.decodeObject(forKey: "email") as? String ?? ""
        self.ksn = aDecoder.decodeObject(forKey: "ksn") as? String ?? ""
        self.traceAudit = aDecoder.decodeObject(forKey: "traceAudit") as? String ?? ""
        self.networkInfo = aDecoder.decodeObject(forKey: "networkInfo") as? String ?? ""
        self.walker = aDecoder.decodeObject(forKey: "walker") as? String ?? ""
        self.chip = aDecoder.decodeObject(forKey: "chip") as? String ?? ""
        self.dateAndHours = aDecoder.decodeObject(forKey: "dateAndHours") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.switchCommand, forKey: "switchCommand")
        aCoder.encode(self.processingCode, forKey: "processingCode")
        aCoder.encode(self.amount, forKey: "amount")
        aCoder.encode(self.time, forKey: "time")
        aCoder.encode(self.merchantId, forKey: "merchantId")
        aCoder.encode(self.posEntryMode, forKey: "posEntryMode")
        aCoder.encode(self.track2Data, forKey: "track2Data")
        aCoder.encode(self.retreivalReference, forKey: "retreivalReference")
        aCoder.encode(self.terminalId, forKey: "terminalId")
        aCoder.encode(self.location, forKey: "location")
        aCoder.encode(self.usrId, forKey: "usrId")
        aCoder.encode(self.nodId, forKey: "nodId")
        aCoder.encode(self.type, forKey: "type")
        aCoder.encode(self.idDevice, forKey: "idDevice")
        aCoder.encode(self.typeCard, forKey: "typeCard")
        aCoder.encode(self.media, forKey: "media")
        aCoder.encode(self.monthPromotion, forKey: "monthPromotion")
        aCoder.encode(self.namePromotion, forKey: "namePromotion")
        aCoder.encode(self.solution, forKey: "solution")
        aCoder.encode(self.authoResponse, forKey: "authoResponse")
        aCoder.encode(self.affiliate, forKey: "affiliate")
        
        aCoder.encode(self.date, forKey: "date")
        aCoder.encode(self.track1Data, forKey: "track1Data")
        aCoder.encode(self.tipPercentage, forKey: "tipPercentage")
        aCoder.encode(self.tipAmount, forKey: "tipAmount")
        aCoder.encode(self.cardHolder, forKey: "cardHolder")
        aCoder.encode(self.reference, forKey: "reference")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.ksn, forKey: "ksn")
        aCoder.encode(self.traceAudit, forKey: "traceAudit")
        aCoder.encode(self.networkInfo, forKey: "networkInfo")
        aCoder.encode(self.walker, forKey: "walker")
        aCoder.encode(self.chip, forKey: "chip")
        aCoder.encode(self.dateAndHours, forKey: "dateAndHours")
    }
    
}
