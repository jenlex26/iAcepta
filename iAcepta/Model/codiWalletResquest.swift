//
//  codiWalletResquest.swift
//  iAcepta
//
//  Created by Javier Hernandez on 19/06/20.
//  Copyright © 2020 Quality & Knowledge. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class codiWalletResquest: Object, Decodable {
    
    @objc dynamic var walletsRequest            : walletsRequestResponse?
    @objc dynamic var identidification = ""
    @objc dynamic var amount = ""
    @objc dynamic var email = ""
    @objc dynamic var reference = ""
    
    private enum CodingKeys: String, CodingKey {

        case walletsRequest          = "walletsRequestResponse"

    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        walletsRequest = try container.decodeIfPresent(walletsRequestResponse.self,      forKey: .walletsRequest)

    }
}

class walletsRequestResponse: Object, Decodable {
    
      @objc dynamic var answerKey                          : String = ""
      @objc dynamic var displayCredentialIdentification    : String = ""
      @objc dynamic var foreignPaymentMethodIdentification : String = ""
      @objc dynamic var issuerIdentification               : String = ""
      @objc dynamic var paymentMethodIdentification        : String = ""
      @objc dynamic var requestKey                         : String = ""
      @objc dynamic var responseActions                    : String = ""
      @objc dynamic var codiResponseCode                   : String = ""
      @objc dynamic var responseMessage                    : String = ""
      @objc dynamic var retryTime                          : String = ""
      @objc dynamic var transactionIdentification          : String = ""
      @objc dynamic var transmitionDateTime                : String = ""
      @objc dynamic var transactionDateTime                : String = ""
      @objc dynamic var walletRequestToken                 : String = ""
      @objc dynamic var walletRequestTokenType             : String = ""
      @objc dynamic var identifierForTheResolutor          : String = ""
      @objc dynamic var displayResponseMessage             : String = ""
                    var displayResponseMessageList         = List<String>()
//      @objc dynamic var tickets                            : String = ""
                    var tickets                            = List<ticketService>()
    

    private enum CodingKeys: String, CodingKey {
        
        
        case answerKey                            = "answerKey"
        case displayCredentialIdentification      = "displayCredentialIdentification"
        case foreignPaymentMethodIdentification   = "foreignPaymentMethodIdentification"
        case issuerIdentification                 = "issuerIdentification"
        case paymentMethodIdentification          = "paymentMethodIdentification"
        case requestKey                           = "requestKey"
        case responseActions                      = "responseActions"
        case codiResponseCode                     = "codiResponseCode"
        case responseMessage                      = "responseMessage"
        case retryTime                            = "retryTime"
        case transactionIdentification            = "transactionIdentification"
        case transmitionDateTime                  = "transmitionDateTime"
        case transactionDateTime                  = "transactionDateTime"
        case walletRequestToken                   = "walletRequestToken"
        case walletRequestTokenType               = "walletRequestTokenType"
        case tickets                              = "tickets"
        case identifierForTheResolutor            = "identifierForTheResolutor"
        case displayResponseMessage               = "displayResponseMessage"
        
        
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        answerKey = try container.decodeIfPresent(String.self,      forKey: .answerKey) ?? ""
        displayCredentialIdentification = try container.decodeIfPresent(String.self,      forKey: .displayCredentialIdentification) ?? ""
        foreignPaymentMethodIdentification = try container.decodeIfPresent(String.self,      forKey: .foreignPaymentMethodIdentification) ?? ""
        issuerIdentification = try container.decodeIfPresent(String.self,      forKey: .issuerIdentification) ?? ""
        paymentMethodIdentification = try container.decodeIfPresent(String.self,      forKey: .paymentMethodIdentification) ?? ""
        requestKey = try container.decodeIfPresent(String.self,      forKey: .requestKey) ?? ""
        responseActions = try container.decodeIfPresent(String.self,      forKey: .responseActions) ?? ""
        codiResponseCode = try container.decodeIfPresent(String.self,      forKey: .codiResponseCode) ?? ""
        responseMessage = try container.decodeIfPresent(String.self,      forKey: .responseMessage) ?? ""
        retryTime = try container.decodeIfPresent(String.self,      forKey: .retryTime) ?? ""
        transactionIdentification = try container.decodeIfPresent(String.self,      forKey: .transactionIdentification) ?? ""
        transmitionDateTime = try container.decodeIfPresent(String.self,      forKey: .transmitionDateTime) ?? ""
        transactionDateTime = try container.decodeIfPresent(String.self,      forKey: .transactionDateTime) ?? ""
        walletRequestToken = try container.decodeIfPresent(String.self,      forKey: .walletRequestToken) ?? ""
        walletRequestTokenType = try container.decodeIfPresent(String.self,      forKey: .walletRequestTokenType) ?? ""
        identifierForTheResolutor = try container.decodeIfPresent(String.self,      forKey: .identifierForTheResolutor) ?? ""
//        displayResponseMessage = try container.decodeIfPresent(String.self,      forKey: .displayResponseMessage) ?? ""
        let stringData = try container.decodeIfPresent(String.self,      forKey: .displayResponseMessage) ?? ""
        let data = stringData.data(using: .utf8)
        do {
            let object = try JSONDecoder().decode([String].self, from: (data!))
            let listWallet = List<String>()
            object.forEach { (wallet) in
                listWallet.append(wallet)
            }
            displayResponseMessageList = listWallet
            displayResponseMessage = listWallet.joined(separator: "\n")
            print(displayResponseMessage)
        } catch  {
            print("ERROR")
        }
//        tickets  = try container.decodeIfPresent(String.self,      forKey: .tickets) ?? ""
        let ticketsData = try container.decodeIfPresent(String.self,      forKey: .tickets) ?? ""
        print(ticketsData)
        let data1 = ticketsData.data(using: .utf8)
        do {
             let object = try JSONDecoder().decode([ticketService].self, from: (data1!))
            let listWallet = List<ticketService>()
            object.forEach { (wallet) in
                listWallet.append(wallet)
            }
            tickets = listWallet
            print("<<<<<<<\(tickets)>>>>>>>>>")
        } catch  {
            print("ERROR")
        }
 
    }
}

class ticketService: Object, Decodable {
    
    @objc dynamic var TypeService    : String = ""
                  var LayoutList     = List<String>()
    @objc dynamic var Layout         : String = ""


    private enum CodingKeys: String, CodingKey {
        
        case TypeService     = "Type"
        case Layout          = "Layout"

    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        TypeService = try container.decodeIfPresent(String.self,      forKey: .TypeService) ?? ""
        let tagsArray = try container.decodeIfPresent([String].self,      forKey: .Layout) ?? []
        LayoutList.append(objectsIn: tagsArray)
        Layout = tagsArray.joined(separator: "\n")

    }
}
