//
//  CardWalkerBand.swift
//  iAcepta
//
//  Created by QUALITY on 6/27/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
class CardWalkerBand:NSObject, NSCoding{
    
    public var cardholderName: String?
    public var formatID: String?
    public var expiryDate: String?
    public var maskedPAN: String?
    public var serviceCode: String?
    public var typeCard: String?
    public var ksn: String?
    public var encTrack1: String?
    public var encTrack3: String?
    public var encTrack2: String?
    
    
    public required init(json: [String:Any]) {
        cardholderName = json["cardholderName"] as? String
        formatID = json["formatID"] as? String
        expiryDate = json["expiryDate"] as? String
        maskedPAN = json["maskedPAN"] as? String
        serviceCode = json["serviceCode"] as? String
        ksn = json["ksn"] as? String
        encTrack1 = json["encTrack1"] as? String
        encTrack3 = json["encTrack3"] as? String
        encTrack2 = json["encTrack2"] as? String
    }
    
    public func dictionaryRepresentation() -> [String: Any] {
        let dictionary: [String: Any] = [:]
        return dictionary
    }
    
    required init?(coder aDecoder: NSCoder) {

    }
    
    func encode(with aCoder: NSCoder) {
    }
    
    
}
