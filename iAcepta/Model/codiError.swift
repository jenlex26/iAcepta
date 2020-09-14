//
//  codiError.swift
//  iAcepta
//
//  Created by Javier Hernandez on 18/06/20.
//  Copyright © 2020 Quality & Knowledge. All rights reserved.
//

import Foundation

enum codiError: Error {
    case serviceException(_ reason:String, _ code:Int)
    case genericException(_ reason:String, _ code:Int)
    case doubleException(_ reason:String,_ reason2:[String], _ code:Int)
    
    struct Content {
        var reason: String, reason2:[String], code: Int
    }
    var content: Content {
        switch self {

            case .serviceException(let message, let code):
                return Content(reason: message, reason2: [""], code: code)
            
            case .genericException(let message, let code):
                return Content(reason: message, reason2: [""], code: code)
            
        case .doubleException(let message,let message2, let code):
            return Content(reason: message, reason2: message2, code: code)

        }
    }
}
