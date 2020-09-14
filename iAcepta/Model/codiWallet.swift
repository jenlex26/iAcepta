//
//  codiWallet.swift
//  iAcepta
//
//  Created by Javier Hernandez on 18/06/20.
//  Copyright © 2020 Quality & Knowledge. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class codiWallet: Object, Decodable {
    
    @objc dynamic var walletsResponse            : serviceResponse?
    
    private enum CodingKeys: String, CodingKey {

        case walletsResponse          = "walletsResponse"

    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        walletsResponse = try container.decodeIfPresent(serviceResponse.self,      forKey: .walletsResponse)

    }
}

class serviceResponse: Object, Decodable {
    
    @objc dynamic var amountRequired             : String = ""
    @objc dynamic var answerKey                  : String = ""
    @objc dynamic var autoConfirm                : String = ""
    @objc dynamic var defaultRetryTime           : String = ""
    @objc dynamic var responseAction             : String = ""
    @objc dynamic var codiResponseCode           : String = ""
    @objc dynamic var responseMessage            : String = ""
    @objc dynamic var supportRequestCancel       : String = ""
    @objc dynamic var tokenType                  : String = ""
    @objc dynamic var transmitionDateTime        : String = ""
    @objc dynamic var transactionDateTime        : String = ""
//    @objc dynamic var wallets                    : String = ""
                  var wallets                    = List<WalletsService>()
    @objc dynamic var walletUseInVoidTransaction : String = ""


    
    private enum CodingKeys: String, CodingKey {
        
        case amountRequired             = "amountRequired"
        case answerKey                  = "answerKey"
        case autoConfirm                = "autoConfirm"
        case defaultRetryTime           = "defaultRetryTime"
        case responseAction             = "responseActions"
        case codiResponseCode           = "codiResponseCode"
        case responseMessage            = "responseMessage"
        case supportRequestCancel       = "supportRequestCancel"
        case tokenType                  = "tokenType"
        case transmitionDateTime        = "transmitionDateTime"
        case transactionDateTime        = "transactionDateTime"
        case wallets                    = "wallets"
        case walletUseInVoidTransaction = "walletUseInVoidTransaction"

    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        amountRequired = try container.decodeIfPresent(String.self,      forKey: .amountRequired) ?? ""
        answerKey = try container.decodeIfPresent(String.self,      forKey: .answerKey) ?? ""
        autoConfirm = try container.decodeIfPresent(String.self,      forKey: .autoConfirm) ?? ""
        defaultRetryTime = try container.decodeIfPresent(String.self,      forKey: .defaultRetryTime) ?? ""
        responseAction = try container.decodeIfPresent(String.self,      forKey: .responseAction) ?? ""
        codiResponseCode = try container.decodeIfPresent(String.self,      forKey: .codiResponseCode) ?? ""
        responseMessage = try container.decodeIfPresent(String.self,      forKey: .responseMessage) ?? ""
        supportRequestCancel = try container.decodeIfPresent(String.self,      forKey: .supportRequestCancel) ?? ""
        tokenType = try container.decodeIfPresent(String.self,      forKey: .tokenType) ?? ""
        transmitionDateTime = try container.decodeIfPresent(String.self,      forKey: .transmitionDateTime) ?? ""
        transmitionDateTime = try container.decodeIfPresent(String.self,      forKey: .transmitionDateTime) ?? ""
        let stringData = try container.decodeIfPresent(String.self,      forKey: .wallets) ?? ""
        let data = stringData.data(using: .utf8)
        do {
            let object = try JSONDecoder().decode([WalletsService].self, from: (data!))
            let listWallet = List<WalletsService>()
            object.forEach { (wallet) in
                listWallet.append(wallet)
            }
            wallets = listWallet
        } catch  {
            print("ERROR")
        }
        walletUseInVoidTransaction = try container.decodeIfPresent(String.self,      forKey: .walletUseInVoidTransaction) ?? ""
        

    }
}

class WalletsService: Object, Decodable {
    
    @objc dynamic var AutoConfirm                 : String = ""//Bool = false
    @objc dynamic var DefaultRetryTime            : String = ""//Int = 0
    @objc dynamic var TokenType                   : String = ""
    @objc dynamic var SupportRequestCancel        : String = ""//Bool = false
    @objc dynamic var AmountRequired              : String = ""//Bool = false
    @objc dynamic var Label                       : String = ""//String = ""
    @objc dynamic var WalletUseInVoidTransaction  : String = ""//Bool = false
    @objc dynamic var Identification              : String = ""//Int = 0
    @objc dynamic var Image                       : String = ""
    @objc dynamic var Name                        : String = ""



    
    private enum CodingKeys: String, CodingKey {
        
        case AutoConfirm                = "AutoConfirm"
        case DefaultRetryTime           = "DefaultRetryTime"
        case TokenType                  = "TokenType"
        case SupportRequestCancel       = "SupportRequestCancel"
        case AmountRequired             = "AmountRequired"
        case Label                      = "Label"
        case WalletUseInVoidTransaction = "WalletUseInVoidTransaction"
        case Identification             = "Identification"
        case Image                      = "Image"
        case Name                       = "Name"
        


    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        AutoConfirm = try container.decodeIfPresent(String.self,      forKey: .AutoConfirm) ?? "false"
        DefaultRetryTime = try container.decodeIfPresent(String.self,      forKey: .DefaultRetryTime) ?? "0"
        TokenType = try container.decodeIfPresent(String.self,      forKey: .TokenType) ?? ""
        SupportRequestCancel = try container.decodeIfPresent(String.self,      forKey: .SupportRequestCancel) ?? "false"
        AmountRequired = try container.decodeIfPresent(String.self,      forKey: .AmountRequired) ?? "false"
        Label = try container.decodeIfPresent(String.self,      forKey: .Label) ?? ""
        WalletUseInVoidTransaction = try container.decodeIfPresent(String.self,      forKey: .WalletUseInVoidTransaction) ?? "false"
        Identification = try container.decodeIfPresent(String.self,      forKey: .Identification) ?? "0"
        Image = try container.decodeIfPresent(String.self,      forKey: .Image) ?? ""
        Name = try container.decodeIfPresent(String.self,      forKey: .Name) ?? ""
    
    }
}
