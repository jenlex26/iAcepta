//
//  CapXModel.swift
//  iAcepta
//
//  Created by QUALITY on 7/31/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
class CapXModel:NSObject, NSCoding{
    //var cardHolder: String?
    var resultData: NSDictionary?
    var tokenB2: String?
    var tokenB3: String?
    var tokenB4: String?
    var tokenQ8: String?
    var tokenQ9: String?
    var tokenEY: String?
    var tokenEZ: String?
    var tokenES: String?
    var tokenC0: String?
    var tokenQE: String?
    var tokenCZ: String?
    
    var aid: String?
    var arqc: String?
    
    var tokens:String?
    var cardHolder:String?
    var pan:String?
    
    var cardType:String?
    var isEntryModeReader:String?
    var track2:String?
    
    var issuingBank:String?
    var isCreditDebit:String?
    var cardEntryMode:String?
    
    init(resultData:NSDictionary? = nil, tokenB2:String? = nil,tokenB3:String? = nil, tokenB4:String? = nil, tokenQ8:String? = nil, tokenQ9:String? = nil, tokenEY:String? = nil, tokenEZ:String? = nil, tokenES:String? = nil, tokenC0:String? = nil, tokenQE:String? = nil, tokenCZ:String? = nil, aid:String? = nil, arqc:String? = nil, tokens:String? = nil, cardHolder:String? = nil, pan:String? = nil, cardType:String? = nil, isEntryModeReader:String? = nil, track2:String? = nil, issuingBank:String? = nil, isCreditDebit:String? = nil, cardEntryMode:String? = nil) {
        self.resultData = resultData
        self.tokenB2 = tokenB2
        self.tokenB3 = tokenB3
        self.tokenB4 = tokenB4
        self.tokenQ8 = tokenQ8
        self.tokenQ9 = tokenQ9
        self.tokenEY = tokenEY
        self.tokenEZ = tokenEZ
        self.tokenES = tokenES
        self.tokenC0 = tokenC0
        self.tokenQE = tokenQE
        self.tokenCZ = tokenCZ
        self.arqc = arqc
        self.tokens = tokens
        self.cardHolder = cardHolder
        self.pan = pan
        self.cardType = cardType
        self.isEntryModeReader = isEntryModeReader
        self.track2 = track2
        self.issuingBank = issuingBank
        self.isCreditDebit = isCreditDebit
        self.cardEntryMode = cardEntryMode
    }
    
    func encode(with aCoder: NSCoder) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
    }
    
}
