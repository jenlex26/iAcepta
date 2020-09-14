//
//  VerifoneReaderManager.swift
//  iAcepta
//
//  Created by QUALITY on 7/26/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import UIKit

protocol verifoneResponseDelegate: AnyObject {
    func isConnect(success:Bool)
    func evotTxrStarted(_ success: Bool, error: String!, code: String!, tokenB2: Data!, tokenB3: Data!, tokenB4: Data!, tokenQ8: Data!, tokenQ9: Data!, tokenEY: Data!, tokenEZ: Data!, tokenES: Data!, tokenC0: Data!, tokenQE: Data!, tokenCZ: Data!)
    func evoApiTransactionEnded(_ success: Bool, error: String!, code: String!, cryptogramType: CryptogramType, authResponse: String!)
    func evoApiEncryptionInitialized(_ success: Bool, error: String!, code: String!, tokenEW: Data!, tokenES: Data!)
}

class VerifoneReaderManager {
    
    var evoApi = EvoApi();
    var isRefund:Bool = false
    var manageBluetooth : CBPeripheralManager?
    var timerVerifone: Timer?
    
    weak var delegate: verifoneResponseDelegate?
    
    static let shared = VerifoneReaderManager()
    
    init() {
    }
    
    func startReaderConnection() {
        evoApi = EvoApi.main()
        evoApi.initialize(self)
        self.timerVerifone = Timer.scheduledTimer(timeInterval: 7, target: self, selector: #selector(self.validateSucces), userInfo: nil, repeats: false)
    }
    
    func startTransactionWithAmount(withTimeout:Int, txrType:TransactionType, amount:Double){
        let datex = NSDate()
        let transaction = Purchase
        let cashback:Double = 0
        let currency:String = "0484"
        let terminalDecision = ForcedOnline
        let flagCCV:Bool = true
        let flagExpDate:Bool = true
        
        evoApi.startTransaction(withTimeout: uint(withTimeout), andDate: datex as Date, andTransactionType: transaction, andAmount: amount, andCashBackAmount: cashback, andCurrencyCode: currency, andTerminalDecision: terminalDecision, andflagCCV: flagCCV, andFlagExpirationDate: flagExpDate)
    }
    
    func finishTransactionWith(response:Int, andTokeB5:Data, andTokenB6:Data){
        evoApi.endTransaction(with: TransactionResponse(rawValue: TransactionResponse.RawValue(response)), andTokenB5: andTokeB5, andTokenB6: andTokenB6)
    }
    
    func cancelTransaction(){
        print("Se cancela Verifone....")
        evoApi.cancelTransaction()
    }
    
    func endTransactionWithResponse(response:Int, tokenB5:NSData?, tokenB6:NSData?) {
        print("Finaliza Verifone....")
        evoApi.endTransaction(with: TransactionResponse(rawValue: TransactionResponse.RawValue(response)), andTokenB5: tokenB5 as Data?, andTokenB6: tokenB6 as Data?)
    }
    
    func probarExiste() {
        print("estao de verifone",evoApi.delegate)
    }
    
    @objc func validateSucces() {
        removeTime()
        delegate?.isConnect(success: evoApi.isConnected()?.success ?? false)
    }
    
    func removeTime(){
        print("Timer Verifone .........")
        timerVerifone?.invalidate()
        timerVerifone = nil
    }
    
    //Function MARK: Load Keys
    func initLoadKeys(){
        print("Inicializa Encriptación ........ ->>>>>")
        evoApi.initEncryption()
    }
    
    func endLoadKeysWithToken(tokenEX:Data?){
        //endEncryptionWithToken
        print("Termina Carga de llaves ........ <<<<< ------")
        evoApi.endEncryption(withToken: tokenEX ?? nil)
    }
    
}
extension VerifoneReaderManager: EvoApiDelegate{
    func evoApiConnectionStateChanged(_ success: Bool, error: String!, code: String!) {
        removeTime()
        delegate?.isConnect(success: success)
    }
    
    func evoApiEncryptionInitialized(_ success: Bool, error: String!, code: String!, tokenEW: Data!, tokenES: Data!) {
        delegate?.evoApiEncryptionInitialized(success, error: error, code: code, tokenEW: tokenEW, tokenES: tokenES )
    }
    
    func evoApiEncryptionEnded(_ success: Bool, error: String!, code: String!) {
        print("evoApiEncryptionEnded")
    }
    
    func evoApiBinTableConfigured(_ success: Bool, error: String!, code: String!) {
        print("evoApiBinTableConfigured")
    }
    
    func evoApiBinTableReceived(_ success: Bool, error: String!, code: String!, binTableId: String!, binTableVersion: String!, binStartN: String!, binEndN: String!) {
        print("evoApiBinTableReceived")
    }
    
    func evoApiAppVersionReceived(_ success: Bool, error: String!, code: String!, tokenES: Data!, tokenQ8: Data!) {
        print("evoApiAppVersionReceived")
    }
    
    func evoApiCardBinReceived(_ success: Bool, error: String!, code: String!, pan: String!) {
        print("evoApiCardBinReceived")
    }
    
    func evoApiTransactionStarted(_ success: Bool, error: String!, code: String!, tokenB2: Data!, tokenB3: Data!, tokenB4: Data!, tokenQ8: Data!, tokenQ9: Data!, tokenEY: Data!, tokenEZ: Data!, tokenES: Data!, tokenC0: Data!, tokenQE: Data!, tokenCZ: Data!) {
        print("evoApiTransactionStarted")
        delegate?.evotTxrStarted(success, error: error, code: code, tokenB2: tokenB2, tokenB3: tokenB3, tokenB4: tokenB4, tokenQ8: tokenQ8, tokenQ9: tokenQ9, tokenEY: tokenEY, tokenEZ: tokenEZ, tokenES: tokenES, tokenC0: tokenC0, tokenQE: tokenQE, tokenCZ: tokenCZ)
        //delegate?.evotTxrStarted(false, error: error, code: "11", tokenB2: tokenB2, tokenB3: tokenB3, tokenB4: tokenB4, tokenQ8: tokenQ8, tokenQ9: tokenQ9, tokenEY: tokenEY, tokenEZ: tokenEZ, tokenES: tokenES, tokenC0: tokenC0, tokenQE: tokenQE, tokenCZ: tokenCZ)
        
    }
    
    func evoApiTransactionEnded(_ success: Bool, error: String!, code: String!, cryptogramType: CryptogramType, cryptogram: String!, authResponse: String!, scriptsProcesed: Int, scriptsResult: [Any]!) {
        if code == "98"{
            delegate?.evoApiTransactionEnded(true, error: error, code: code, cryptogramType: cryptogramType, authResponse: authResponse)
        }else{
            delegate?.evoApiTransactionEnded(success, error: error, code: code, cryptogramType: cryptogramType, authResponse: authResponse)
        }
    }
    
    func evoApiBatteryValueResult(_ success: Bool, error: String!, code: String!, bateryValue: Int) {
        print("evoApiBatteryValueResult ---- ")
    }
    
    func evoApiTransactionCanceled(_ success: Bool, error: String!, code: String!) {
        print("evoApiTransactionCanceled")
    }
    
}
