//
//  modelGlob.swift
//  iAcepta
//
//  Created by QUALITY on 6/26/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation

class modelGlob {
    struct Static {
        static var txrModel:TransactionModel?
        static var cardReaderModel:CardWalkerModel?
        static var cardCapituloX:CapXModel?
        static var integratorModel:IntegratorModel?
        static var verifoneSDK:VerifoneReaderManager? = VerifoneReaderManager()
        static var walkerSDK:WalkerReaderManager? = WalkerReaderManager()
        static var wisePadSDK:WisePadReaderManager? = WisePadReaderManager()
        static var kLastConnectedBTDeviceName:String = "kLastConnectedBTDeviceName"
        static var kLastConnectedBTDeviceUUID:String = "kLastConnectedBTDeviceUUID"
    }
}
