//
//  UserInfoLoginModel.swift
//  iAcepta
//
//  Created by QUALITY on 6/12/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserInfoLoginModel: NSCoding {
    
    public var userName: String?
    public var commerceAddress: String?
    public var commerceName: String?
    public var nodeId: String?
    public var commerceMemberShipNumber: String?
    public var userId: String?
    public var userPhoneNumber: String?
    public var daysForExpiration: String?
    public var expirationDatePassword: String?
    
    private class ContentRequestModelKeys : NSObject {
        static let userName : String = "UserName"
        static let commerceAddress : String = "CommerceAddress"
        static let commerceName : String = "CommerceName"
        static let nodeId : String = "NodeId"
        static let commerceMemberShipNumber : String = "CommerceMemberShipNumber"
        static let userId : String = "UserId"
        static let userPhoneNumber : String = "UserPhoneNumber"
        static let daysForExpiration : String = "DaysForExpiration"
        static let expirationDatePassword : String = "ExpirationDatePassword"
    }
    
    public required init(json: [String:Any]) {
        userName = json[ContentRequestModelKeys.userName] as? String
        commerceAddress = json[ContentRequestModelKeys.commerceAddress] as? String
        commerceName = json[ContentRequestModelKeys.commerceName] as? String
        nodeId = json[ContentRequestModelKeys.nodeId] as? String
        commerceMemberShipNumber = json[ContentRequestModelKeys.commerceMemberShipNumber] as? String
        userId = json[ContentRequestModelKeys.userId] as? String
        userPhoneNumber = json[ContentRequestModelKeys.userPhoneNumber] as? String
        daysForExpiration = json[ContentRequestModelKeys.daysForExpiration] as? String
        expirationDatePassword = json[ContentRequestModelKeys.expirationDatePassword] as? String
    }
    
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = userName { dictionary[ContentRequestModelKeys.userName] = value }
        if let value = commerceAddress { dictionary[ContentRequestModelKeys.commerceAddress] = value }
        if let value = commerceName { dictionary[ContentRequestModelKeys.commerceName] = value }
        if let value = nodeId { dictionary[ContentRequestModelKeys.nodeId] = value }
        if let value = commerceMemberShipNumber { dictionary[ContentRequestModelKeys.commerceMemberShipNumber] = value }
        if let value = userId { dictionary[ContentRequestModelKeys.userId] = value }
        if let value = userPhoneNumber { dictionary[ContentRequestModelKeys.userPhoneNumber] = value }
        if let value = daysForExpiration { dictionary[ContentRequestModelKeys.daysForExpiration] = value }
        if let value = expirationDatePassword { dictionary[ContentRequestModelKeys.expirationDatePassword] = value }
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
//        self.userName = aDecoder.decodeObject(forKey: ContentRequestModelKeys.userName) as? String
//        self.commerceAddress = aDecoder.decodeObject(forKey: ContentRequestModelKeys.commerceAddress) as? String
//        self.commerceName = aDecoder.decodeObject(forKey: ContentRequestModelKeys.commerceName) as? String
//        self.nodeId = aDecoder.decodeObject(forKey: ContentRequestModelKeys.nodeId) as? String
//        self.commerceMemberShipNumber = aDecoder.decodeObject(forKey: ContentRequestModelKeys.commerceMemberShipNumber) as? String
//        self.userId = aDecoder.decodeObject(forKey: ContentRequestModelKeys.userId) as? String
//        self.userPhoneNumber = aDecoder.decodeObject(forKey: ContentRequestModelKeys.userPhoneNumber) as? String
//        self.daysForExpiration = aDecoder.decodeObject(forKey: ContentRequestModelKeys.daysForExpiration) as? String
//        self.expirationDatePassword = aDecoder.decodeObject(forKey: ContentRequestModelKeys.expirationDatePassword) as? String
    }
    
    public func encode(with aCoder: NSCoder) {
//        aCoder.encode(userName, forKey: ContentRequestModelKeys.userName)
//        aCoder.encode(commerceAddress, forKey: ContentRequestModelKeys.commerceAddress)
//        aCoder.encode(commerceName, forKey: ContentRequestModelKeys.commerceName)
//
//        aCoder.encode(nodeId, forKey: ContentRequestModelKeys.nodeId)
//        aCoder.encode(commerceMemberShipNumber, forKey: ContentRequestModelKeys.commerceMemberShipNumber)
//        aCoder.encode(userId, forKey: ContentRequestModelKeys.userId)
//
//        aCoder.encode(userPhoneNumber, forKey: ContentRequestModelKeys.userPhoneNumber)
//        aCoder.encode(daysForExpiration, forKey: ContentRequestModelKeys.daysForExpiration)
//        aCoder.encode(expirationDatePassword, forKey: ContentRequestModelKeys.expirationDatePassword)
    }
    
}
