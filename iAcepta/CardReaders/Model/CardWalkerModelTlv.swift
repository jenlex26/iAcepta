//
//  CardWalkerModelTlv.swift
//  iAcepta
//
//  Created by QUALITY on 6/21/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import UIKit

class CardWalkerModelTlv:NSObject, NSCoding{
    
    public var cardHolder: String?
    public var aid: String?
    public var expDate: String?
    public var pan: String?
    public var walker: String?
    public var c0: String?
    public var c2: String?
    public var isAuthorizationPin: Bool = false

    
    public required init(json: [String:Any]) {
        cardHolder = json["5F20"] as? String
        aid        = json["4F"] as? String
        expDate    = json["5F24"] as? String
        if let numberCard = json["C4"] as? String{
            pan = numberCard.dropLastWhileLetter()
        }

        if let tagPin = json["9F34"] as? String {
            if tagPin.hasPrefix("41") ||
               tagPin.hasPrefix("01") ||
               tagPin.hasPrefix("04") ||
               tagPin.hasPrefix("44") ||
               tagPin.hasPrefix("02") ||
               tagPin.hasPrefix("42") {
                    isAuthorizationPin = tagPin.last == "2"
            }
        }
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
