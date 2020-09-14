//
//  CodiPresenter.swift
//  iAcepta
//
//  Created by Javier Hernandez on 18/06/20.
//  Copyright © 2020 Quality & Knowledge. All rights reserved.
//

import Foundation

class CodiPresenter{

    static func wallet(_ result: @escaping (Result<codiWallet?,codiError>)->Void){
        if Connectivity.isConnectedToInternet() {
            ServicesManager.walletCodi{ (response) in
                guard response == nil else {
                    do {
                        let object = try JSONDecoder().decode(codiWallet.self, from: (response?.data!)!)
                        debugPrint(object)
                        if (object.walletsResponse?.responseAction.contains("OK"))! && !(object.walletsResponse?.wallets.isEmpty)!{
                            result(.success(object))
                        }else{
                            result(.failure(codiError.genericException("Error de conexión, intenta de nuevo en unos minutos", 400)))
                        }
                    } catch {
                        result(.failure(codiError.genericException("LoginString.genericError.val", 402)))
                    }
                    return
                }
            }
        }else{
            result(.failure(codiError.genericException("Revisa tu conexión a internet", 404)))
        }
        
    }
    
    static func walletRequest(_ typeService:WalletRequestType,_ walletIdentification:String,_ requestKey:String,_ amount:String,_ email:String,_ reference:String,result: @escaping (Result<codiWalletResquest?,codiError>)->Void){
        if Connectivity.isConnectedToInternet() {
            ServicesManager.walletRequestCodi(typeService, walletIdentification, requestKey, amount, email, reference) { (response) in
                guard response == nil else {
                    do {
                        let object = try JSONDecoder().decode(codiWalletResquest.self, from: (response?.data!)!)
                        debugPrint(object)
                        if (object.walletsRequest?.responseActions.contains("OK"))! && !(object.walletsRequest?.retryTime.isEmpty)!{
                            result(.success(object))
                        }else{
                            if typeService == .retry {
                                if (object.walletsRequest?.responseActions.contains("Refuse"))!{
                                    var reason = "Rechazada"
                                    if (object.walletsRequest?.responseActions.contains("Display"))!{
                                        reason = object.walletsRequest!.displayResponseMessage
                                    }
                                    result(.failure(codiError.genericException(reason, 404)))
                                }else{
                                    var stringDataFilter : [String] = []
                                    let filterData = object.walletsRequest?.tickets.filter{ $0.TypeService.contains("Merchant") }
                                    filterData!.forEach {
                                        let items = $0.LayoutList
                                        let a = Array(items)
                                        stringDataFilter = a
                                    }
                                    
                                    result(.failure(codiError.doubleException(object.walletsRequest?.displayResponseMessage ?? "", stringDataFilter , 200)))
                                    //                                    result(.failure(codiError.genericException(object.walletsRequest?.displayResponseMessage ?? "", 200)))
                                }
                            }else{
                                if (object.walletsRequest?.responseActions.isEmpty)!{
                                    result(.failure(codiError.genericException("Error\nIntenta mas tarde", 401)))
                                }else{
                                    let resultValue = (object.walletsRequest?.responseMessage.isEmpty)! ? "Error\nIntenta mas tarde" :  object.walletsRequest?.responseMessage //"Campos vacios"
                                    result(.failure(codiError.genericException(resultValue!, 400)))
                                }
                            }
                        }
                    } catch {
                        result(.failure(codiError.genericException("Error\nIntenta mas tarde", 600)))
                    }
                    return
                }
            }
        }else{
            result(.failure(codiError.genericException("Revisa tu conexión a internet", 404)))
        }
        
    }
    
    static func cancelWallet(_ requestKey:String,_ amount:String,_ email:String,_ reference:String,_ result: @escaping (Result<cancelCodiRequest?,codiError>)->Void){
        if Connectivity.isConnectedToInternet() {
            ServicesManager.cancelCodi(requestKey, amount,email,reference){ (response) in
                guard response == nil else {
                    do {
                        let object = try JSONDecoder().decode(cancelCodiRequest.self, from: (response?.data!)!)
                        debugPrint(object)
                        if (object.cancelResponse?.responseActions.contains("OK"))!{
                            result(.success(object))
                        }else{
                            result(.failure(codiError.genericException(object.cancelResponse!.responseMessage, 402)))
                        }
                    } catch {
                        result(.failure(codiError.genericException("LoginString.genericError.val", 400)))
                    }
                    return
                }
            }
        }else{
            result(.failure(codiError.genericException("Revisa tu conexión a internet", 404)))
        }
        
    }
    
    static func sendVoucher(_ amount:String,_ cardIssuer:String,_ cardNumber:String,_ authorization:String,_ sequence:String,_ email:String,_ result: @escaping (Result<SuccessVoucherCodi?,codiError>)->Void){
        if Connectivity.isConnectedToInternet() {
            ServicesManager.sendVoucherCodi(amount,cardIssuer,cardNumber,authorization,sequence,email){ (response) in
                guard response == nil else {
                    do {
                        let object = try JSONDecoder().decode(SuccessVoucherCodi.self, from: (response?.data!)!)
                        debugPrint(object)
                        if object.content?.code == "0"{
                            result(.success(object))
                        }else{
                            result(.failure(codiError.genericException(object.content?.description ?? "", 402)))
                        }
                    } catch {
                        result(.failure(codiError.genericException("Intenta mas tarde", 400)))
                    }
                    return
                }
            }
        }else{
            result(.failure(codiError.genericException("Revisa tu conexión a internet", 404)))
        }
        
    }
}
