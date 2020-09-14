//
//  Enum.swift
//  iAcepta
//
//  Created by QUALITY on 18/02/20.
//  Copyright © 2020 Quality & Knowledge. All rights reserved.
//

import Foundation


enum typeTransaction:String {
    case SELL         = "sell"
    case REVERSAL     = "reversal"
    case CANCELLATION = "cacellation"
    case REFUND       = "refund"
    
    var stringValue: String {
        return self.rawValue
    }
}


