//
//  TransactionModel.swift
//  iAcepta
//
//  Created by QUALITY on 6/18/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import SwiftyJSON

class TransactionModel:NSObject, NSCoding {
    
    var amount: String?
    var tip: String?
    var total: String?
    var mwi: String?
    var reference: String?
    var email: String?
    var tipPercentage: String?
    
    var posEntryMode: String?
    var track2:String?
    var date:String?
    var dateTime:String?
    
    var F007_1: String?
    var F007_2: String?
    var F037: String?
    var q6: String?
    
    var dateName: String?
    var authorization: String?
    var dateService: String?
    
    var responseCode:String?
    var legend:String?
    var arqc:String?
    var aid:String?
    
    var latitud:String?
    var longitud:String?
    
    var tracing:String?
    var attemptsReverse:Int?
    
    var showMap:Data?
    
    var authorizationByNIP = false
    
    
    
    
    init(amount: String? = nil, tip: String? = nil, total: String?=nil, mwi: String? = nil, reference: String? = nil, email: String? = nil, tipPercentage: String? = nil) {
        self.amount = amount
        self.tip = tip
        self.total = total
        self.mwi = mwi
        self.reference = reference
        self.email = email
        self.tipPercentage = tipPercentage
    }
    
    
    required init(coder aDecoder: NSCoder) {
        self.amount = aDecoder.decodeObject(forKey: "amount")  as? String ?? ""
        self.tip = aDecoder.decodeObject(forKey: "tip")  as? String ?? ""
        self.total = aDecoder.decodeObject(forKey: "total")  as? String ?? ""
        self.mwi = aDecoder.decodeObject(forKey: "mwi")  as? String ?? ""
        self.reference = aDecoder.decodeObject(forKey: "reference")  as? String ?? ""
        self.email = aDecoder.decodeObject(forKey: "email")  as? String ?? ""
        self.tipPercentage = aDecoder.decodeObject(forKey: "tipPercentage")  as? String ?? ""
        self.posEntryMode = aDecoder.decodeObject(forKey: "posEntryMode")  as? String ?? ""
        self.track2 = aDecoder.decodeObject(forKey: "track2")  as? String ?? ""
        self.date = aDecoder.decodeObject(forKey: "date") as? String ?? ""
        self.F007_1 = aDecoder.decodeObject(forKey: "F007_1") as? String ?? ""
        self.F007_2 = aDecoder.decodeObject(forKey: "F007_2") as? String ?? ""
        self.F037 = aDecoder.decodeObject(forKey: "F037") as? String ?? ""
        self.dateName = aDecoder.decodeObject(forKey: "dateName") as? String ?? ""
        self.dateService = aDecoder.decodeObject(forKey: "dateService") as? String ?? ""
        self.authorization = aDecoder.decodeObject(forKey: "authorization") as? String ?? ""
        self.responseCode = aDecoder.decodeObject(forKey: "responseCode") as? String ?? ""
        self.legend = aDecoder.decodeObject(forKey: "legend") as? String ?? ""
        self.arqc = aDecoder.decodeObject(forKey: "arqc") as? String ?? ""
        self.aid = aDecoder.decodeObject(forKey: "aid") as? String ?? ""
        self.q6 = aDecoder.decodeObject(forKey: "q6") as? String ?? ""
        self.latitud = aDecoder.decodeObject(forKey: "latitud") as? String ?? ""
        self.longitud = aDecoder.decodeObject(forKey: "longitud") as? String ?? ""
        self.tracing = aDecoder.decodeObject(forKey: "tracing") as? String ?? ""
        self.dateTime = aDecoder.decodeObject(forKey: "dateTime") as? String ?? ""
        self.attemptsReverse = aDecoder.decodeObject(forKey: "attemptsReverse") as? Int ?? 0
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.amount, forKey: "amount")
        aCoder.encode(self.tip, forKey: "tip")
        aCoder.encode(self.total, forKey: "total")
        aCoder.encode(self.mwi, forKey: "mwi")
        aCoder.encode(self.reference, forKey: "reference")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.tipPercentage, forKey: "tipPercentage")
        aCoder.encode(self.posEntryMode, forKey: "posEntryMode")
        aCoder.encode(self.track2, forKey: "track2")
        aCoder.encode(self.date, forKey: "date")
        aCoder.encode(self.F007_1, forKey: "F007_1")
        aCoder.encode(self.F007_2, forKey: "F007_2")
        aCoder.encode(self.F037, forKey: "F037")
        aCoder.encode(self.dateName, forKey: "dateName")
        aCoder.encode(self.dateService, forKey: "dateService")
        aCoder.encode(self.authorization, forKey: "authorization")
        aCoder.encode(self.responseCode, forKey: "responseCode")
        aCoder.encode(self.legend, forKey: "legend")
        aCoder.encode(self.arqc, forKey: "arqc")
        aCoder.encode(self.aid, forKey: "aid")
        aCoder.encode(self.q6, forKey: "aid")
        aCoder.encode(self.latitud, forKey: "latitud")
        aCoder.encode(self.longitud, forKey: "longitud")
        aCoder.encode(self.tracing, forKey: "tracing")
        aCoder.encode(self.dateTime, forKey: "dateTime")
        aCoder.encode(self.attemptsReverse, forKey: "attemptsReverse")
    }
    
}
