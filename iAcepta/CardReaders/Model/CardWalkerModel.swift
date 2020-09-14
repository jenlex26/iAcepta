//
//  CardWalkerModel.swift
//  iAcepta
//
//  Created by QUALITY on 6/28/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
class CardWalkerModel:NSObject, NSCoding{

    var cardHolder: String?
    var aid: String?
    var expDate: String?
    var pan: String?
    
    var typeCard: String?
    var track1: String?
    var track2: String?
    var ksn: String?
    var chip: String?
    var walker:String?
    var cardEntryMode:String?
    
    var appName:String?
    var prefName:String?
    var issuingBank:String?
    var isCreditDebit:String?
    var isNipValidation:Bool = false
    
    var serviceCode:Int?
    
    init(cardHolder:String? = nil, aid:String? = nil,expDate:String? = nil, pan:String? = nil) {
        self.cardHolder = cardHolder
        self.aid = aid
        self.expDate = expDate
        self.pan = pan
    }
    
    required init(coder aDecoder: NSCoder) {
        self.cardHolder = aDecoder.decodeObject(forKey: "cardHolder")  as? String ?? ""
        self.aid = aDecoder.decodeObject(forKey: "aid") as? String ?? ""
        self.expDate = aDecoder.decodeObject(forKey: "expDate")  as? String ?? ""
        self.pan = aDecoder.decodeObject(forKey: "pan")  as? String ?? ""
        self.track1 = aDecoder.decodeObject(forKey: "track1")  as? String ?? ""
        self.track2 = aDecoder.decodeObject(forKey: "track2")  as? String ?? ""
        self.ksn = aDecoder.decodeObject(forKey: "ksn") as? String ?? ""
        self.chip = aDecoder.decodeObject(forKey: "chip") as? String ?? ""
        self.walker = aDecoder.decodeObject(forKey: "walker") as? String ?? ""
        self.appName = aDecoder.decodeObject(forKey: "appName") as? String ?? ""
        self.prefName = aDecoder.decodeObject(forKey: "prefName") as? String ?? ""
        self.issuingBank = aDecoder.decodeObject(forKey: "issuingBank") as? String ?? ""
        self.isCreditDebit = aDecoder.decodeObject(forKey: "isCreditDebit") as? String ?? ""
        self.cardEntryMode = aDecoder.decodeObject(forKey: "cardEntryMode") as? String ?? ""
        self.isNipValidation = (aDecoder.decodeObject(forKey: "isNipValidation") as? Bool)!
        self.serviceCode = aDecoder.decodeObject(forKey: "serviceCode") as? Int ?? 0
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.cardHolder, forKey: "cardHolder")
        aCoder.encode(self.aid, forKey: "aid")
        aCoder.encode(self.expDate, forKey: "expDate")
        aCoder.encode(self.pan, forKey: "pan")
        aCoder.encode(self.track1, forKey: "track1")
        aCoder.encode(self.track2, forKey: "track2")
        aCoder.encode(self.ksn, forKey: "ksn")
        aCoder.encode(self.chip, forKey: "chip")
        aCoder.encode(self.walker, forKey: "walker")
        aCoder.encode(self.appName, forKey: "appName")
        aCoder.encode(self.prefName, forKey: "prefName")
        aCoder.encode(self.issuingBank, forKey: "issuingBank")
        aCoder.encode(self.isCreditDebit, forKey: "isCreditDebit")
        aCoder.encode(self.cardEntryMode, forKey: "cardEntryMode")
        aCoder.encode(self.isNipValidation, forKey: "isNipValidation")
        aCoder.encode(self.serviceCode, forKey: "serviceCode")
    }
    
}
