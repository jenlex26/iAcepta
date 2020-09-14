//
//  ServiceResultLoginModel.swift
//  iAcepta
//
//  Created by QUALITY on 6/11/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class ServiceResultLoginModel: NSCoding {
    
    public var responseType: String?
    public var content: [String:Any]?
    public var version: String?
    
    private class ContentRequestModelKeys : NSObject {
        static let responseType : String = "ResponseType"
        static let content : String = "Content"
        static let version : String = "Version"
    }
    
    public convenience init(object: Any) {
        self.init(json: JSON(object))
    }
    
    public required init(json: JSON) {
        responseType = json[ContentRequestModelKeys.responseType].string
        content = json[ContentRequestModelKeys.content].dictionaryObject
        version = json[ContentRequestModelKeys.version].string
    }
    
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = responseType { dictionary[ContentRequestModelKeys.responseType] = value }
        if let value = content { dictionary[ContentRequestModelKeys.content] = value }
        if let value = version { dictionary[ContentRequestModelKeys.version] = value }
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.responseType = aDecoder.decodeObject(forKey: ContentRequestModelKeys.responseType) as? String
        self.content = aDecoder.decodeObject(forKey: ContentRequestModelKeys.content) as? Dictionary
        self.version = aDecoder.decodeObject(forKey: ContentRequestModelKeys.version) as? String
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(responseType, forKey: ContentRequestModelKeys.responseType)
        aCoder.encode(content, forKey: ContentRequestModelKeys.content)
        aCoder.encode(version, forKey: ContentRequestModelKeys.version)
    }
    
}
