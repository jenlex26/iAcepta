//
//  ContentLoginModel.swift
//  iAcepta
//
//  Created by QUALITY on 6/11/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import SwiftyJSON

class ContentLoginModel: NSCoding {
    
    public var definedConds: String?
    public var tokenExpiration: String?
    public var type: String?
    public var allowedOps: String?
    public var authToken: String?
    public var condParameters : [CondParametersLoginModel]?
    public var userInfo : UserInfoLoginModel?
    
    private class ContentRequestModelKeys : NSObject {
        static let definedConds : String = "DefinedConds"
        static let tokenExpiration : String = "TokenExpiration"
        static let type : String = "__type"
        static let allowedOps : String = "AllowedOps"
        static let authToken : String = "AuthToken"
        static let condParameters : String = "CondParameters"
        static let userInfo : String = "UserInfo"
    }
    
    
    public required init(json: [String:Any]) {
        definedConds = json[ContentRequestModelKeys.definedConds] as? String
        tokenExpiration = json[ContentRequestModelKeys.tokenExpiration] as? String
        type = json[ContentRequestModelKeys.type] as? String
        allowedOps = json[ContentRequestModelKeys.allowedOps] as? String
        authToken = json[ContentRequestModelKeys.authToken] as? String
        if let items = json[ContentRequestModelKeys.condParameters] as? [[String:Any]] { condParameters = items.map { CondParametersLoginModel(json: $0) } }
        if let userInfoJson = json[ContentRequestModelKeys.userInfo] as? [String:Any] {
            userInfo = UserInfoLoginModel(json: userInfoJson)
        }
    }
    
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = definedConds { dictionary[ContentRequestModelKeys.definedConds] = value }
        if let value = tokenExpiration { dictionary[ContentRequestModelKeys.tokenExpiration] = value }
        if let value = type { dictionary[ContentRequestModelKeys.type] = value }
        if let value = allowedOps { dictionary[ContentRequestModelKeys.allowedOps] = value }
        if let value = authToken { dictionary[ContentRequestModelKeys.authToken] = value }
        if let value = condParameters { dictionary[ContentRequestModelKeys.condParameters] = value.map { $0.dictionaryRepresentation() } }
        if let value = userInfo { dictionary[ContentRequestModelKeys.userInfo] = value.dictionaryRepresentation() }
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
//        self.definedConds = aDecoder.decodeObject(forKey:ContentRequestModelKeys.definedConds) as? String
//        self.tokenExpiration = aDecoder.decodeObject(forKey: ContentRequestModelKeys.tokenExpiration) as? String
//        self.type = aDecoder.decodeObject(forKey:ContentRequestModelKeys.type) as? String
//        self.allowedOps = aDecoder.decodeObject(forKey: ContentRequestModelKeys.allowedOps) as? String
//        self.authToken = aDecoder.decodeObject(forKey:ContentRequestModelKeys.authToken) as? String
//        self.condParameters = aDecoder.decodeObject(forKey: ContentRequestModelKeys.condParameters) as? [CondParametersLoginModel]
//        self.userInfo = aDecoder.decodeObject(forKey: ContentRequestModelKeys.userInfo) as? UserInfoLoginModel
    }
    
    public func encode(with aCoder: NSCoder) {
//        aCoder.encode(definedConds, forKey: ContentRequestModelKeys.definedConds)
//        aCoder.encode(tokenExpiration, forKey: ContentRequestModelKeys.tokenExpiration)
//        aCoder.encode(type, forKey: ContentRequestModelKeys.type)
//        aCoder.encode(allowedOps, forKey: ContentRequestModelKeys.allowedOps)
//        aCoder.encode(authToken, forKey: ContentRequestModelKeys.authToken)
//        aCoder.encode(condParameters, forKey: ContentRequestModelKeys.condParameters)
//        aCoder.encode(userInfo, forKey: ContentRequestModelKeys.userInfo)
    }
    
}
