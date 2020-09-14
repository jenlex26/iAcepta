//
//  ErrorInfoLoginModel.swift
//  iAcepta
//
//  Created by QUALITY on 6/12/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import SwiftyJSON

class ErrorInfoLoginModel: NSCoding {
    
    public var type: String?
    public var userInfo: String?
    public var domain: String?
    public var code: String?
    public var description: String?
    
    private class ErrorInfoRequestModelKeys : NSObject {
        static let type : String = "__type"
        static let userInfo : String = "UserInfo"
        static let domain : String = "Domain"
        static let code : String = "Code"
        static let description : String = "Description"
    }
    
    public required init(json: [String:Any]) {
        type = json[ErrorInfoRequestModelKeys.type] as? String
        userInfo = json[ErrorInfoRequestModelKeys.userInfo] as? String
        domain = json[ErrorInfoRequestModelKeys.domain] as? String
        code = json[ErrorInfoRequestModelKeys.code] as? String
        description = json[ErrorInfoRequestModelKeys.description] as? String
    }
    
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = type { dictionary[ErrorInfoRequestModelKeys.type] = value }
        if let value = userInfo { dictionary[ErrorInfoRequestModelKeys.userInfo] = value }
        if let value = domain { dictionary[ErrorInfoRequestModelKeys.domain] = value }
        if let value = code { dictionary[ErrorInfoRequestModelKeys.code] = value }
        if let value = description { dictionary[ErrorInfoRequestModelKeys.description] = value }
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.type = aDecoder.decodeObject(forKey: ErrorInfoRequestModelKeys.type) as? String
        self.userInfo = aDecoder.decodeObject(forKey: ErrorInfoRequestModelKeys.userInfo) as? String
        self.domain = aDecoder.decodeObject(forKey: ErrorInfoRequestModelKeys.domain) as? String
        self.code = aDecoder.decodeObject(forKey: ErrorInfoRequestModelKeys.code) as? String
        self.description = aDecoder.decodeObject(forKey: ErrorInfoRequestModelKeys.description) as? String
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(type, forKey: ErrorInfoRequestModelKeys.type)
        aCoder.encode(userInfo, forKey: ErrorInfoRequestModelKeys.userInfo)
        aCoder.encode(domain, forKey: ErrorInfoRequestModelKeys.domain)
        aCoder.encode(code, forKey: ErrorInfoRequestModelKeys.code)
        aCoder.encode(description, forKey: ErrorInfoRequestModelKeys.description)
    }
    
}
