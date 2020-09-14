//
//  SuccessVoucherModel.swift
//  iAcepta
//
//  Created by QUALITY on 7/19/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import RealmSwift

class SuccessVoucherModel: NSObject{
    
    var version         : String?
    var responseType    : String?
    var content         : ContentVoucher?
    
    private class ContentRequestModelKeys : NSObject {
        static let version      : String = "Version"
        static let responseType : String = "ResponseType"
        static let content      : String = "Content"
    }
    
    public required init(json: JSON) {
        version             = json[ContentRequestModelKeys.version].string
        responseType        = json[ContentRequestModelKeys.responseType].string
        if let userInfoJson = json[ContentRequestModelKeys.content].dictionaryObject {
            content         = ContentVoucher(json: userInfoJson)
        }
    }
    
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = version { dictionary[ContentRequestModelKeys.version] = value }
        if let value = responseType { dictionary[ContentRequestModelKeys.responseType] = value }
        if let value = content { dictionary[ContentRequestModelKeys.content] = value }
        return dictionary
    }
    
    required public init(coder aDecoder: NSCoder) {}
    
    public func encode(with aCoder: NSCoder) {}
    
}


class SuccessVoucherCodi: Object, Decodable {
    
    @objc dynamic var version         : String = ""
    @objc dynamic var responseType    : String = ""
    @objc dynamic var content         : contentRequestResponse?


    private enum CodingKeys: String, CodingKey {
        
        case version      = "Version"
        case responseType = "ResponseType"
        case content      = "Content"

    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        version      = try container.decodeIfPresent(String.self,      forKey: .version) ?? ""
        responseType = try container.decodeIfPresent(String.self,      forKey: .responseType) ?? ""
        content      = try container.decodeIfPresent(contentRequestResponse.self,      forKey: .content)


    }
}

class contentRequestResponse: Object, Decodable {
    
    @objc dynamic var type      : String = ""
    @objc dynamic var code      : String = ""
    @objc dynamic var descrip   : String = ""


    private enum CodingKeys: String, CodingKey {
        
        case type     = "__type"
        case code     = "Code"
        case descrip  = "Description"

    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type      = try container.decodeIfPresent(String.self,      forKey: .type) ?? ""
        code      = try container.decodeIfPresent(String.self,      forKey: .code) ?? ""
        descrip   = try container.decodeIfPresent(String.self,      forKey: .descrip) ?? ""
        

    }
}
