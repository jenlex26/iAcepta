//
//  WalkerReaderManager.swift
//  iAcepta
//
//  Created by QUALITY on 6/21/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import SwiftyJSON

enum EstadosWalkers {
    case FirstState_Types
    case AmountState_Types
    case TimeState_Types
    case SelectAppState_Types
    case FinalConfirmState_Types
    case OnlineProcessState_Types
    case ConfirmControllerState_Types
    case PayControllerState_Types
    case DeviceNotRespond
}

protocol sdkResponseDelegate: AnyObject {
    func onWaitingView(deviceConnected:Bool,cardIn:Bool)
    func deviceErrorType(errorType:BBDeviceErrorType?, errorMensaje:String, ultimoEstado:EstadosWalkers?,deviceConnected:Bool)
    func devicePlugged(deviceConnected:Bool,cardIn:Bool)
    func deviceUnplugged()
    func deviceDetected()
    func onReturnCardResult(result:BBDeviceCheckCardResult, ultimoEstado:EstadosWalkers, cardData:[AnyHashable : Any]!)
    func onReturnTransactionResult(result: BBDeviceTransactionResult, ultimoEstado: EstadosWalkers)
    func batteryStatus(isBaterryStatus:BBDeviceBatteryStatus)
    func setValueFromModel(cardModel:CardWalkerModel?, isChipBanda:String?)
    func onRequestDisplayText(result:BBDeviceDisplayText)
}
class WalkerReaderManager: UIViewController{
    
    var walker2 = BBDeviceController();
    var cardWalkerModelTlv : CardWalkerModelTlv?
    var ultimoEstado:EstadosWalkers = EstadosWalkers.FirstState_Types
    var deviceConnected:Bool = false
    var cardIn:Bool = false
    weak var delegate: sdkResponseDelegate?
    var cardReaderModel:CardWalkerModel?
    var helperExt = HelperExtensions()
    
    
    
    func startWalker(){
        walker2.isDebugLogEnabled = true
        walker2.delegate = self
        if walker2.getConnectionMode() == BBDeviceConnectionMode.bluetooth {
            walker2.disconnectBT()
        }
        
        
        walker2.startAudio()
        self.startConnectionWithReader()
        walker2.getDeviceInfo()
        walker2.isDetectAudioDevicePlugged = true
        walker2.checkCard([:])
    }
    
    func startConnectionWithReader(){
        if (walker2.isAudioDevicePlugged()){
            deviceConnected = true
        }
    }
    
    func starWithData(){
        let inputData:NSMutableDictionary = NSMutableDictionary()
        inputData.setObject(NSNumber(value: 30), forKey: "checkCardTimeout" as NSCopying)
        inputData.setObject(NSNumber(value: 1), forKey: "emvOption" as NSCopying)
        inputData.setObject(NSNumber(value: 30), forKey: "finalConfirmTimeout" as NSCopying)
        inputData.setObject(NSNumber(value: 30), forKey: "onlineProcessTimeout" as NSCopying)
        inputData.setObject(NSNumber(value: 30), forKey: "pinEntryTimeout" as NSCopying)
        inputData.setObject(NSNumber(value: 30), forKey: "selectApplicationTimeout" as NSCopying)
        inputData.setObject(NSNumber(value: 30), forKey: "setAmountTimeout" as NSCopying)
        
        inputData.setObject("123456", forKey: "orderID" as NSCopying)
        
        var terminalTime:String = ""
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "YYMMddHHmmss"
        dateFormatterGet.locale =  NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        terminalTime = dateFormatterGet.string(from: Date())
        
        inputData.setObject("\(terminalTime)", forKey: "terminalTime" as NSCopying)
        let getNumCheckCard:Int = Int(BBDeviceCheckCardMode.swipeOrInsertOrTap.rawValue)
        let numCheckCard = NSNumber.init(value: getNumCheckCard)
        let bar = NSNumber(value: false)
        inputData.setObject(numCheckCard, forKey: "checkCardMode" as NSCopying)
        inputData.setObject(bar, forKey: "disableQuickChip" as NSCopying)
        
        let userData = inputData as NSDictionary? as? [AnyHashable: Any] ?? [:]
        walker2.startEmv(withData: userData) /// --- > Primero
    }
    
    func checkCardAgainAfterBadSwipe(){
        walker2.checkCard([:])
    }
    
    func sendProcessResult(tlv:String){
        walker2.sendOnlineProcessResult(tlv)
    }
    
}
extension WalkerReaderManager:BBDeviceControllerDelegate{

    /// --->> Segundo onRequestTerminalTime
    func onRequestTerminalTime() {
        var terminalTime:String = ""
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "YYMMddHHmmss"
        dateFormatterGet.timeZone =  NSTimeZone.local
        dateFormatterGet.locale =  NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        terminalTime = dateFormatterGet.string(from: Date())
        walker2.sendTerminalTime(terminalTime)
    }
    
    /// --->> Segundo onRequestTerminalTime
    func onRequestSetAmount() {
        
        print("Comprobando  -- onRequestSetAmount")
        ultimoEstado = EstadosWalkers.AmountState_Types
        walker2.setAmount(modelGlob.Static.txrModel?.total?.replacingOccurrences(of: ",", with: ""), cashbackAmount: "0", currencyCode: "484", transactionType: BBDeviceTransactionType.goods, currencyCharacters: [])
    }
    
    /// --->> Tercero onRequestTerminalTime
    func onReturnAmountConfirmResult(_ isConfirmed: Bool) {
        if (isConfirmed){
            print("onReturnAmountConfirmResult - isConfirmed: YES")
        }else{
            print("onReturnAmountConfirmResult - isConfirmed: NO")
        }
    }
    
    /// --->> Cuarto onWaiting
    func onWaiting(forCard checkCardMode: BBDeviceCheckCardMode) {
        //cardIn = false
        delegate?.onWaitingView(deviceConnected: deviceConnected, cardIn: cardIn)
    }
    
    /// --->> Cuarto onRequestSelectApplication
    func onRequestSelectApplication(_ applicationArray: [Any]!) {
        ultimoEstado = EstadosWalkers.SelectAppState_Types
        print("onRequestSelectApplication - applicationArray:", applicationArray as Any)
        walker2.selectApplication(0)
        return;
    }
    
    /// --->> Cuarto onRequestFinalConfirm
    func onRequestFinalConfirm() {
        print("onRequestFinalConfirm")
        ultimoEstado = EstadosWalkers.FinalConfirmState_Types
        walker2.sendFinalConfirmResult(true)
        return;
    }
    
    /// ----> 5ta onRequestOnlineProcess
    func onRequestOnlineProcess(_ tlv: String!) {
        print("onRequestOnlineProcess",tlv)
        ultimoEstado = EstadosWalkers.OnlineProcessState_Types
        if let dicSdk = walker2.decodeTlv(tlv){
            let responseSDK:CardWalkerModelTlv = CardWalkerModelTlv(json: dicSdk as! [String : Any])
            responseSDK.walker = getWalker(tlv: tlv)
            sdkResponseDevice(responseSDK, nil, nil)
            UserDefaults.standard.set(false, forKey: "isValidateNip")
        }else{
            sdkResponseDevice(nil, nil, nil)
        }
    }
    
    func onReturnEnableInputAmountResult(_ isSuccess: Bool) {
        print("onReturnEnableInputAmountResult ",isSuccess)
    }
    
    func onReturnDisableInputAmountResult(_ isSuccess: Bool) {
        print("onReturnDisableInputAmountResult", isSuccess)
    }
    
    func onError(_ errorType: BBDeviceErrorType, errorMessage: String!) {
        print("BBDeviceErrorType --------")
        delegate?.deviceErrorType(errorType: errorType, errorMensaje: errorMessage, ultimoEstado: ultimoEstado, deviceConnected: deviceConnected)
    }
    
    func onRequest(_ result: BBDeviceDisplayText){
        print(result,"displayText")
        delegate?.onRequestDisplayText(result: result)
    }
    
    func onBatteryLow(_ batteryStatus: BBDeviceBatteryStatus) {
        print("Bateria .....", batteryStatus)
        delegate?.batteryStatus(isBaterryStatus:batteryStatus)
    }
    
    func onAudioDevicePlugged() {
        print("onAudioDevicePlugged ------- ")
        delegate?.devicePlugged(deviceConnected:true,cardIn:cardIn)
    }
    
    func onAudioDeviceUnplugged() {
        print("onAudioDeviceUnplugged------------------")
        delegate?.deviceUnplugged()
    }
    
    func onNoAudioDeviceDetected() {
        print("onNoDeviceDetected----------------------")
        delegate?.deviceDetected()
    }
    
    func onReturnDeviceInfo(_ deviceInfo: [AnyHashable : Any]!) {
        print(deviceInfo,"onReturnDeviceInfo")
    }
    
    func onReturn(_ result: BBDeviceCheckCardResult, cardData: [AnyHashable : Any]!) {
        delegate?.onReturnCardResult(result: result, ultimoEstado: ultimoEstado, cardData: cardData)
    }
    
    func onReturn(_ result: BBDeviceTransactionResult) {
        delegate?.onReturnTransactionResult(result: result, ultimoEstado: ultimoEstado)
    }
    
    
    // Func: MARK
    func sdkResponseDevice(_ successCardTlv: CardWalkerModelTlv?, _ error: Error?, _ successCardBand: CardWalkerBand?) {
        if error != nil{
            print(error as Any)
        }else if successCardTlv != nil{
            var nameValue:String = ""
            if let nameHex = successCardTlv?.cardHolder?.hexadecimal{
                nameValue = String(decoding: nameHex, as: UTF8.self)
            }
            cardReaderModel = CardWalkerModel(cardHolder: nameValue, aid: successCardTlv!.aid!, expDate: successCardTlv!.expDate!, pan: successCardTlv!.pan!)
            cardReaderModel?.walker = successCardTlv?.walker
            delegate?.setValueFromModel(cardModel: cardReaderModel, isChipBanda: "C")
            if let maskedPAN = successCardTlv?.pan{
                let typeCard:String = helperExt.typeCardLogo(typeCard: maskedPAN)
                cardReaderModel!.typeCard = typeCard
            }
        }else if successCardBand != nil{
            cardReaderModel = CardWalkerModel(cardHolder: successCardBand!.cardholderName!, aid: "", expDate: successCardBand!.expiryDate!, pan: successCardBand!.maskedPAN!)
            cardReaderModel?.track2 = successCardBand?.encTrack2
            cardReaderModel?.track1 = successCardBand?.encTrack1
            cardReaderModel?.ksn = successCardBand?.ksn
            cardReaderModel?.chip = "Banda"
            cardReaderModel?.serviceCode = Int(successCardBand!.serviceCode!)
            if let maskedPAN = successCardBand?.maskedPAN{
                let typeCard:String = helperExt.typeCardLogo(typeCard: maskedPAN)
                cardReaderModel!.typeCard = typeCard
            }
            delegate?.setValueFromModel(cardModel: cardReaderModel, isChipBanda: "S")
        }
    }
    
    func getWalker(tlv:String) -> String{
        var walkerTemp = tlv
        let etiquetas:NSMutableArray = ["9F1A","9C","9F27","9F26","9F1C","9F12","9B","95","5F20","4F","5F24","9F16","9F21","9A","9F02","9F03","C4"]
        var finish:Bool = false
        var i:Int = 0
        
        while (!finish){
            let walker: NSString = walkerTemp as NSString
            let range:NSRange = walker.range(of: etiquetas[i] as! String, options: .caseInsensitive, range: NSMakeRange(0, (etiquetas[i] as AnyObject).description!.count), locale: nil)
            
            if (range.location != NSNotFound){
                
                let indexStartOfText = walkerTemp.index(walkerTemp.startIndex, offsetBy: range.location + (etiquetas[i] as AnyObject).description!.count)
                var substring = walkerTemp[indexStartOfText...] as NSString
                
                
                let lon:Int = 2 * aDecimal(strHex: substring.substring(with: NSRange(location: 0, length: 2)))
                substring = substring.substring(with: NSMakeRange(2, lon)) as NSString
                
                let idxStart = walkerTemp.index(walkerTemp.startIndex, offsetBy: (etiquetas[i] as AnyObject).description!.count + 2 + lon)
                walkerTemp = String(walkerTemp[idxStart...])
                if (walkerTemp as NSString).substring(to: 2) == "C0"{
                    finish = true
                }else{
                    etiquetas.removeObject(at: i)
                    i = 0
                }
            }else{
                i += 1
            }
        }
        return walkerTemp
    }
    
    func aDecimal(strHex:String) -> Int{
        let scanner = Scanner(string: strHex)
        var result : UInt32 = 0
        if scanner.scanHexInt32(&result) {
            return Int(result)
        }
        return Int(result)
    }
}
