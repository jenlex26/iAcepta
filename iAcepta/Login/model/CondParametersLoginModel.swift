//
//  CondParametersLoginModel.swift
//  iAcepta
//
//  Created by QUALITY on 6/12/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import SwiftyJSON

class CondParametersLoginModel: NSCoding {
    
    public var condCode: String?
    public var value: String?
    public var name: String?
    
    private class CondRequestModelKeys : NSObject {
        static let condCode : String = "CondCode"
        static let value : String = "Value"
        static let name : String = "Name"
    }
    
    public required init(json: [String:Any]) {
        condCode = json[CondRequestModelKeys.condCode] as? String
        value = json[CondRequestModelKeys.value] as? String
        name = json[CondRequestModelKeys.name] as? String
    }
    
    public func dictionaryRepresentation() -> [String: Any] {
        let dictionary: [String: Any] = [:]
//        if let value = condCode { dictionary[CondRequestModelKeys.condCode] = value }
//        if let value = value { dictionary[CondRequestModelKeys.value] = value }
//        if let value = name { dictionary[CondRequestModelKeys.name] = value }
        return dictionary
    }
    
    required public init(coder aDecoder: NSCoder) {
//        self.condCode = aDecoder.decodeObject(forKey: CondRequestModelKeys.condCode) as? String
//        self.value = aDecoder.decodeObject(forKey: CondRequestModelKeys.value) as? String
//        self.name = aDecoder.decodeObject(forKey: CondRequestModelKeys.name) as? String
    }
    
    public func encode(with aCoder: NSCoder) {
//        aCoder.encode(condCode, forKey: CondRequestModelKeys.condCode)
//        aCoder.encode(value, forKey: CondRequestModelKeys.value)
//        aCoder.encode(name, forKey: CondRequestModelKeys.name)
    }
    
}
