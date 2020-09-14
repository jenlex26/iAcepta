//
//  WisePadReaderManager.swift
//  iAcepta
//
//  Created by QUALITY on 9/13/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import SwiftyJSON

enum StatusWisepad {
    case FirstState_Types
    case AmountState_Types
    case TimeState_Types
    case SelectAppState_Types
    case FinalConfirmState_Types
    case OnlineProcessState_Types
    case ConfirmControllerState_Types
    case PayControllerState_Types
    case DeviceNotRespond
    case Disconnect
    case Reconnect
    case Denied
    case CancelTransaction
}

protocol sdkWisePadResponse: AnyObject {
    func onWaitingViewWisePad(deviceConnected:Bool,cardIn:Bool)
    func deviceErrorTypeWisePad(errorType:BBDeviceErrorType?, errorMensaje:String, ultimoEstado:StatusWisepad?,deviceConnected:Bool)
    func onReturnCardResultWisePad(result:BBDeviceCheckCardResult, ultimoEstado:StatusWisepad, cardData:[AnyHashable : Any]!)
    func onReturnTransactionResultWisePad(result: BBDeviceTransactionResult, ultimoEstado: StatusWisepad)
    func setValueFromModelWisePad(cardModel:CardWalkerModel?, isChipBanda:String?)
    func onBTReturnScanResults(deviceArray:NSMutableArray)
    func onBTDisconnectedWisePad()
    func onReturnAmountConfirmResultWisePad(_ isConfirmed:Bool)
    func batteryStatusWisePad(isBaterryStatus:BBDeviceBatteryStatus)
    func onRequestDisplayText(result:BBDeviceDisplayText)
}
class WisePadReaderManager: UIViewController {
    
    var wisePad2 = BBDeviceController();
    var cardWalkerModelTlv : CardWalkerModelTlv?
    var ultimoEstado:StatusWisepad = StatusWisepad.FirstState_Types
    var deviceConnected:Bool = false
    var cardIn:Bool = false
    weak var delegate: sdkWisePadResponse?
    var cardWise:CardWalkerModel?
    var arrayReconect = NSObject()
    var setDismiss:Bool?
    var setDisconec:Bool = false
    var helperExt = HelperExtensions()
    
    func starScan(){
        wisePad2.isDebugLogEnabled = true
        print("starScan ------------------")
        if(wisePad2.getConnectionMode() == BBDeviceConnectionMode.bluetooth){
            wisePad2.disconnectBT()
        }
        
        if(wisePad2.getConnectionMode() == BBDeviceConnectionMode.audio){
            wisePad2.stopAudio()
        }
        
        if wisePad2.delegate == nil{
            wisePad2.delegate = self
        }
        wisePad2.startBTScan(nil, scanTimeout: 30)
    }
    
    func connectBTFromList(array:NSObject){
        print("connectBTFromList ------------------")
        arrayReconect = array
        wisePad2.stopBTScan()
        wisePad2.connectBT(array)
    }
    
    func disconect(setDimiss:Bool?){
        print("disconect ------------------")
        setDismiss = setDimiss ?? true
        setDisconec = true
        ultimoEstado = .Disconnect
        cancelTransaction()
        wisePad2.disconnectBT()
    }
    
    func reconnect(){
        print("---- --------- > a Reconnectar")
        ultimoEstado = .Reconnect
        wisePad2.disconnectBT()
    }
    
    func checkCardAgainAfterBadSwipe(){
        wisePad2.checkCard([:])
    }
    
    func cancelTransaction(){
        print("---- --------- > Cancelado")
        wisePad2.sendOnlineProcessResult(nil)
    }
    
    func checkCard(){
        //BBDeviceEmvOption_Start
        let getNumCheckCard:Int = Int(BBDeviceCheckCardMode.swipeOrInsertOrTap.rawValue)
        let numCheckCardMode = NSNumber.init(value: getNumCheckCard)
        let getNumEmvOption:Int = Int(BBDeviceEmvOption.start.rawValue)
        let numEmvOption = NSNumber.init(value: getNumEmvOption)
        let dict:NSDictionary = ["checkCardMode":numCheckCardMode,"checkCardTimeout":60,"emvOption":numEmvOption]
        wisePad2.checkCard(dict as? [AnyHashable : Any])
    }
    
    func sdkResponseDevice(_ successCardTlv: CardWalkerModelTlv?, _ error: Error?, _ successCardBand: CardWalkerBand?) {
        var cardPan = ""
        if error != nil{
            print(error as Any)
        }else if successCardTlv != nil{
            var nameValue:String = ""
            if let nameHex = successCardTlv?.cardHolder?.hexadecimal{
                nameValue = String(decoding: nameHex, as: UTF8.self)
            }
            cardPan = successCardTlv!.pan!
            
            cardWise = CardWalkerModel(cardHolder: nameValue, aid: successCardTlv!.aid!, expDate: successCardTlv!.expDate!, pan: cardPan)
            cardWise?.isNipValidation = successCardTlv?.isAuthorizationPin ?? false
            cardWise?.walker = successCardTlv?.walker
            delegate?.setValueFromModelWisePad(cardModel: cardWise, isChipBanda: "C")
            if let maskedPAN = successCardTlv?.pan{
                let typeCard:String = helperExt.typeCardLogo(typeCard: maskedPAN)
                cardWise!.typeCard = typeCard
            }
        }else if successCardBand != nil{
            cardWise = CardWalkerModel(cardHolder: successCardBand!.cardholderName!, aid: "", expDate: successCardBand!.expiryDate!, pan: successCardBand!.maskedPAN!)
            cardWise?.track2 = successCardBand?.encTrack2
            cardWise?.track1 = successCardBand?.encTrack1
            cardWise?.ksn = successCardBand?.ksn
            cardWise?.chip = "Banda"
            cardWise?.serviceCode = Int(successCardBand!.serviceCode!)
            if let maskedPAN = successCardBand?.maskedPAN{
                let typeCard:String = helperExt.typeCardLogo(typeCard: maskedPAN)
                cardWise!.typeCard = typeCard
            }
            delegate?.setValueFromModelWisePad(cardModel: cardWise, isChipBanda: "S")
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
        wisePad2.startEmv(withData: userData) /// --- > Primero
    }
    
    func aDecimal(strHex:String) -> Int{
        let scanner = Scanner(string: strHex)
        var result : UInt32 = 0
        if scanner.scanHexInt32(&result) {
            return Int(result)
        }
        return Int(result)
    }
    
    func sendProcessResultWisePad(tlv:String){
        wisePad2.sendOnlineProcessResult(tlv)
    }
}
extension WisePadReaderManager:BBDeviceControllerDelegate{
    /// --->> Segundo onRequestTerminalTime
    func onRequestTerminalTime() {
        var terminalTime:String = ""
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "YYMMddHHmmss"
        dateFormatterGet.timeZone =  NSTimeZone.local
        dateFormatterGet.locale =  NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        terminalTime = dateFormatterGet.string(from: Date())
        wisePad2.sendTerminalTime(terminalTime)
    }
    
    /// --->> Segundo onRequestTerminalTime
    func onRequestSetAmount() {
        print("Comprobando  -- onRequestSetAmount")
        ultimoEstado = StatusWisepad.AmountState_Types
        wisePad2.setAmount(modelGlob.Static.txrModel?.total?.replacingOccurrences(of: ",", with: ""), cashbackAmount: "0", currencyCode: "484", transactionType: BBDeviceTransactionType.goods, currencyCharacters: [])
    }
    
    /// --->> Tercero onRequestTerminalTime
    func onReturnAmountConfirmResult(_ isConfirmed: Bool) {
        if (isConfirmed){
            print("onReturnAmountConfirmResult - isConfirmed: YES")
            delegate?.onReturnAmountConfirmResultWisePad(true)
        }else{
            delegate?.onReturnAmountConfirmResultWisePad(false)
            print("onReturnAmountConfirmResult - isConfirmed: NO")
        }
    }
    
    /// --->> Cuarto onWaiting
    func onWaiting(forCard checkCardMode: BBDeviceCheckCardMode) {
        //cardIn = false
        print("onWaiting ------------------")
        delegate?.onWaitingViewWisePad(deviceConnected: deviceConnected, cardIn: cardIn)
    }
    
    /// --->> Cuarto onRequestSelectApplication
    func onRequestSelectApplication(_ applicationArray: [Any]!) {
        print("onRequestSelectApplication ------------------")
        ultimoEstado = StatusWisepad.SelectAppState_Types
        print("onRequestSelectApplication - applicationArray:", applicationArray as Any)
        wisePad2.selectApplication(0)
        return;
    }
    
    /// --->> Cuarto onRequestFinalConfirm
    func onRequestFinalConfirm() {
        print("onRequestFinalConfirm")
        ultimoEstado = StatusWisepad.FinalConfirmState_Types
        wisePad2.sendFinalConfirmResult(true)
        return;
    }
    /// ----> 5ta onRequestOnlineProcess
    func onRequestOnlineProcess(_ tlv: String!) {
        print("onRequestOnlineProcess",tlv)
        ultimoEstado = StatusWisepad.OnlineProcessState_Types
        
        if let dicSdk = wisePad2.decodeTlv(tlv){
            let responseSDK:CardWalkerModelTlv = CardWalkerModelTlv(json: dicSdk as! [String : Any])
            
            let num = SGTLVDecode.decode(with: tlv)
            let c0:NSDictionary = num?["C0"] as! NSDictionary
            let c0Value:String = String(describing: c0["value"] ?? "");
            let finalC0 = String(format: "C00A%@", c0Value)
            
            let c2:NSDictionary = num?["C2"] as! NSDictionary
            let c2length:String = String(describing: c2["length"] ?? "");
            let c2Value:String = String(describing: c2["value"] ?? "");
            
            let value = Int(c2length) ?? 0
            let lengthStr = setInitialC2Value(val: value)
            
            let finalC2 = String(format: "%@%@", lengthStr, c2Value)
            
            responseSDK.walker = String(format: "%@%@", finalC0, finalC2 )
            
            sdkResponseDevice(responseSDK, nil, nil)
            UserDefaults.standard.set(false, forKey: "isValidateNip")
        }else{
            sdkResponseDevice(nil, nil, nil)
        }
    }
    
    func onRequest(_ result: BBDeviceDisplayText){
        print("----displayText----",result)
        delegate?.onRequestDisplayText(result: result)
    }
    
    func onBatteryLow(_ batteryStatus: BBDeviceBatteryStatus) {
        print("Bateria .....", batteryStatus)
        delegate?.batteryStatusWisePad(isBaterryStatus:batteryStatus)
    }
    
    //Func Mark:WisePad
    func onBTReturnScanResults(_ devices: [Any]?){
        print("onBTReturnScanResults <<<<------------------")
        if devices != nil{
            delegate?.onBTReturnScanResults(deviceArray: NSMutableArray(array: devices ?? []))
        }
    }
    
    func onBTScanStopped(){
        print("onBTScanStopped <<<<------------------")
    }
    
    func onBTConnected(_ connectedDevice: NSObject){
        print("onBTConnected <<<<------------------")
        var deviceName:String = ""
        if (connectedDevice is EAAccessory){
            deviceName = connectedDevice.value(forKey: "serialNumber") as? String ?? ""
            if (deviceName.count > 0){
                modelGlob.Static.kLastConnectedBTDeviceName = deviceName
            }else{
                modelGlob.Static.kLastConnectedBTDeviceUUID = ""
            }
        }else if (connectedDevice is CBPeripheral){
            deviceName = connectedDevice.value(forKey: "name") as? String ?? ""
            if (deviceName.count > 0){
                modelGlob.Static.kLastConnectedBTDeviceName = deviceName
            }else{
                let valuePherical = self.wisePad2.getPeripheralUUID(connectedDevice as? CBPeripheral)
                modelGlob.Static.kLastConnectedBTDeviceUUID = valuePherical ?? ""
            }
        }
        if (wisePad2.delegate != nil){
            starWithData()
        }
    }
    
    func onBTDisconnected(){
        print("onBTDisconnected <<<< ------------------")
        if (ultimoEstado == .Reconnect){
            ultimoEstado = .FirstState_Types
            wisePad2.startBTScan(nil, scanTimeout: 30)
        }else if (ultimoEstado == .Disconnect){
            if setDismiss ?? true{
                delegate?.onBTDisconnectedWisePad()
                wisePad2.delegate = nil
            }else{
                wisePad2.delegate = nil
                modelGlob.Static.wisePadSDK?.delegate = nil
            }
        }else if (ultimoEstado == .Denied){
            wisePad2.delegate = nil
            modelGlob.Static.wisePadSDK?.delegate = nil
        }else{
            delegate?.onBTDisconnectedWisePad()
            wisePad2.delegate = nil
            modelGlob.Static.wisePadSDK?.delegate = nil
        }
    }
    

    func onError(_ errorType: BBDeviceErrorType, errorMessage: String!) {
        print("BBDeviceErrorType --------")
        delegate?.deviceErrorTypeWisePad(errorType: errorType, errorMensaje: errorMessage, ultimoEstado: ultimoEstado, deviceConnected: deviceConnected)
    }
    
    func onReturn(_ result: BBDeviceCheckCardResult, cardData: [AnyHashable : Any]!) {
        delegate?.onReturnCardResultWisePad(result: result, ultimoEstado: ultimoEstado, cardData: cardData)
    }
    func onReturn(_ result: BBDeviceTransactionResult) {
        delegate?.onReturnTransactionResultWisePad(result: result, ultimoEstado: ultimoEstado)
        print("BBDeviceTransactionResult", result)
    }
    
    func setInitialC2Value(val:NSInteger) -> String{
        let final  = String(format: "C2820%lX", val)
        return final
    }
    
}
