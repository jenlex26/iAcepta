//
//  cancelCodiRequest.swift
//  iAcepta
//
//  Created by Javier Hernandez on 16/07/20.
//  Copyright © 2020 Quality & Knowledge. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class cancelCodiRequest: Object, Decodable {
    
    @objc dynamic var cancelResponse            : serResponse?
    
    private enum CodingKeys: String, CodingKey {

        case cancelResponse          = "cancelResponse"

    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cancelResponse = try container.decodeIfPresent(serResponse.self,      forKey: .cancelResponse)

    }
}

class serResponse: Object, Decodable {
    
    @objc dynamic var answerKey                  : String = ""
    @objc dynamic var responseActions            : String = ""
    @objc dynamic var codiResponseCode           : String = ""
    @objc dynamic var responseMessage            : String = ""

    
    private enum CodingKeys: String, CodingKey {
        
        case answerKey                  = "answerKey"
        case responseActions            = "responseActions"
        case codiResponseCode           = "codiResponseCode"
        case responseMessage            = "responseMessage"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        answerKey = try container.decodeIfPresent(String.self,      forKey: .answerKey) ?? ""
        responseActions = try container.decodeIfPresent(String.self,      forKey: .responseActions) ?? ""
        codiResponseCode = try container.decodeIfPresent(String.self,      forKey: .codiResponseCode) ?? ""
        responseMessage = try container.decodeIfPresent(String.self,      forKey: .responseMessage) ?? ""
    }
}

