//
//  ContentVoucher.swift
//  iAcepta
//
//  Created by QUALITY on 7/19/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import SwiftyJSON

class ContentVoucher: NSObject {
    
    var type         : String?
    var code         : String?
    var descrip      : String?
    
    private class ContentRequestModelKeys : NSObject {
        static let type : String = "__type"
        static let code : String = "Code"
        static let descrip : String = "Description"
    }
    
    public required init(json: [String:Any]) {
        type = json[ContentRequestModelKeys.type] as? String
        code = json[ContentRequestModelKeys.code] as? String
        descrip = json[ContentRequestModelKeys.descrip] as? String
    }
    
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = type { dictionary[ContentRequestModelKeys.type] = value }
        if let value = code { dictionary[ContentRequestModelKeys.code] = value }
        if let value = descrip { dictionary[ContentRequestModelKeys.descrip] = value }
        return dictionary
    }
    
}
