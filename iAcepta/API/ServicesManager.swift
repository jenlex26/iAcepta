//
//  ServicesManager.swift
//  iAcepta
//
//  Created by QUALITY on 7/1/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum ResponseWSType:String {
    case Data
    case Url
    case Error
    case HtmlContent
    case Empty
    case UnKnow
    case Denied
}

enum WalletRequestType {
    case firstAttempt
    case retry
}

class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

class ServicesManager: MasterViewController {
    static let ServerURL = Bundle.main.object(forInfoDictionaryKey: "ServerURL") as! String
    static let prod = ServerURL.bool
    
    func paymentsRejacted(_ txrTypePaymentsRejected:TypePaymentsRejectedModel?, _ completion: @escaping(_ response:SuccessfulPaymentModel?, _ failure:ErrorInfoLoginModel?, _ errorServices:ResponseWSType?) ->() ){
        let postOK:String = String(format: "switchCommand=%@&processingCode=%@&amount=%@&time=%@&date=%@&merchantId=%@&posEntryMode=%@&track2Data=%@&retreivalReference=%@&terminalId=%@&location=%@&track1Data=%@&usrId=%@&nodId=%@&tipo=%@&idDispositivo=%@&prctPropina=%@&tipoTja=%@&montoPropina=%@&medio=%@&tjaHabiente=%@&mesesPromocion=%@&nombrePromocion=%@&solucion=%@&Referencia=&ARQC=&TXNCTN=&tokens63=&authoResponse=%@&Afiliacion=%@&SecureToken=%@",txrTypePaymentsRejected!.switchCommand,txrTypePaymentsRejected!.processingCode,txrTypePaymentsRejected!.amount,txrTypePaymentsRejected!.time,txrTypePaymentsRejected!.date!,txrTypePaymentsRejected!.merchantId,txrTypePaymentsRejected!.posEntryMode,txrTypePaymentsRejected!.track2Data!,txrTypePaymentsRejected!.retreivalReference,txrTypePaymentsRejected!.terminalId,txrTypePaymentsRejected!.location,txrTypePaymentsRejected!.track1Data!,txrTypePaymentsRejected!.usrId,txrTypePaymentsRejected!.nodId,txrTypePaymentsRejected!.type,txrTypePaymentsRejected!.idDevice!,(txrTypePaymentsRejected?.tipPercentage!)!,(txrTypePaymentsRejected?.typeCard)!,txrTypePaymentsRejected!.tipAmount!,txrTypePaymentsRejected!.media,txrTypePaymentsRejected!.cardHolder!,txrTypePaymentsRejected!.monthPromotion!,(txrTypePaymentsRejected?.namePromotion)!,txrTypePaymentsRejected!.solution!,txrTypePaymentsRejected!.authoResponse!,txrTypePaymentsRejected!.affiliate,txrTypePaymentsRejected!.secureToken ?? "")
        printDev(object: "cancelacion\(postOK)")
        let postData =  Data(postOK.utf8)
        let url = Constants.URL_Cancelation
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("\(postData.count)", forHTTPHeaderField: "Content-Length")
        request.httpBody = postOK.data(using: .utf8)
        
        Alamofire.request(request)
            .responseJSON { response in
                if case let .failure(error) = response.result {
                    completion(nil,nil,ResponseWSType.UnKnow)
                    self.printDev(object: error)
                }else{
                    if let data = response.data{
                        if let json = try? JSON(data: data) {
                            self.printDev(object: json)
                            let responsePayment:SuccessfulPaymentModel = SuccessfulPaymentModel(json: json)
                            completion(responsePayment,nil,nil)
                        }else{
                            completion(nil,nil,ResponseWSType.UnKnow)
                        }
                    }
                }
        }
    }
    
    func paymentServices(_ txrTPR:TypePaymentsRejectedModel?, _ completion: @escaping(_ response:SuccessfulPaymentModel?, _ responseCapX:SuccessfulPaymentModelVerifone? , _ failure:ErrorInfoLoginModel?, _ errorServices:ResponseWSType?) ->() ){
        
        let postOk = NSMutableString()
        postOk.append(String(format: "switchCommand=%@", txrTPR?.switchCommand ?? ""))
        postOk.append(String(format: "&processingCode=%@", txrTPR?.processingCode ?? ""))
        postOk.append(String(format: "&time=%@", txrTPR?.time ?? ""))
        postOk.append(String(format: "&merchantId=%@", txrTPR?.merchantId ?? ""))
        postOk.append(String(format: "&posEntryMode=%@", txrTPR?.posEntryMode ?? ""))
        postOk.append(String(format: "&track2Data=%@", txrTPR?.track2Data ?? ""))
        postOk.append(String(format: "&retreivalReference=%@", txrTPR?.retreivalReference ?? ""))
        postOk.append(String(format: "&terminalId=%@", txrTPR?.terminalId ?? ""))
        postOk.append(String(format: "&location=%@", txrTPR?.location ?? ""))
        postOk.append(String(format: "&usrId=%@", txrTPR?.usrId ?? ""))
        postOk.append(String(format: "&nodId=%@", txrTPR?.nodId ?? ""))
        postOk.append(String(format: "&idDispositivo=%@", txrTPR?.idDevice ?? ""))
        postOk.append(String(format: "&prctPropina=%@", txrTPR?.tipPercentage ?? ""))
        postOk.append(String(format: "&montoPropina=%@", txrTPR?.tipAmount ?? ""))
        postOk.append(String(format: "&medio=%@", txrTPR?.media ?? ""))
        postOk.append(String(format: "&mesesPromocion=%@", txrTPR?.monthPromotion ?? ""))
        postOk.append(String(format: "&nombrePromocion=%@", txrTPR?.namePromotion ?? ""))
        postOk.append(String(format: "&Referencia=%@", txrTPR?.reference ?? ""))
        postOk.append(String(format: "&Afiliacion=%@", txrTPR?.affiliate ?? ""))
        postOk.append(String(format: "&SecureToken=%@", txrTPR?.secureToken ?? ""))
        postOk.append(String(format: "&Timestamp=%@", txrTPR?.timestamp ?? ""))
        postOk.append(String(format: "&Track1=%@", txrTPR?.track1Data ?? ""))
        postOk.append(String(format: "&Scope=%@", txrTPR?.scope ?? ""))
        postOk.append(String(format: "&KSN=%@", txrTPR?.ksn ?? ""))
        postOk.append(String(format: "&ChipBanda=%@", txrTPR?.chip ?? ""))
        postOk.append(String(format: "&Amount=%@", txrTPR?.amount ?? ""))
        postOk.append(String(format: "&Email=%@", txrTPR?.email ?? ""))
        postOk.append(String(format: "&tipo=%@", txrTPR?.type ?? ""))
        
        
        postOk.append(String(format: "&tipoTja=%@", "0"))
        postOk.append(String(format: "&solucion=%@", "iAcepta"))
        postOk.append(String(format: "&track1Data=%@", ""))
        postOk.append(String(format: "&authoResponse=%@", ""))
        postOk.append(String(format: "&responseCode=%@", ""))
        postOk.append(String(format: "&Cardholder=%@",txrTPR?.cardHolder ?? ""))
        postOk.append(String(format: "&deviceType=%@","IOS"))
        postOk.append(String(format: "&appVersion=%@",Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""))
        
        
        let typeReader = UserDefaults.standard.string(forKey: "TYPEREADER") ?? ""
        var url:URL!
        
        if typeReader == "VERIFONE"{
            postOk.append(String(format: "&capitulox=%@", txrTPR?.walker ?? ""))
            postOk.append(String(format: "&FechaHora=%@", txrTPR?.dateAndTime ?? ""))
            url = URL(string: Constants.URL_Verifone)!
        }else{
            postOk.append(String(format: "&capitulox=%@", ""))
            postOk.append(String(format: "&FechaHora=%@", txrTPR?.dateAndTime ?? ""))
            postOk.append(String(format: "&Walker=%@", txrTPR?.walker ?? ""))
            postOk.append(String(format: "&TraceAudit=%@", txrTPR?.traceAudit ?? ""))
            postOk.append(String(format: "&NetworkInfo=%@", txrTPR?.networkInfo ?? ""))
            url = URL(string: Constants.URL_PaymentWalker)!
        }
        
        
        
        let jsonData = String(postOk).data(using:.ascii, allowLossyConversion: true)!
        printDev(object: "body de pago \(postOk)")
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("\(jsonData.count)", forHTTPHeaderField: "Content-Length")
        request.httpBody = jsonData
        
        Alamofire.request(request).responseString {
            (response) in
            //            self.printDev(object: postOk)
            debugPrint(response.result)
            if case let .failure(error) = response.result {
                completion(nil,nil,nil,ResponseWSType.UnKnow)
            }else{
                if let data = response.data{
                    if typeReader == "VERIFONE"{
                        if let json = try? JSON(data: data) {
                            let responsePayment:SuccessfulPaymentModelVerifone = SuccessfulPaymentModelVerifone(json: json)
                            completion(nil,responsePayment,nil,nil)
                        }else{
                            completion(nil,nil,nil, ResponseWSType.Denied)
                        }
                    }else{
                        if let json = try? JSON(data: data) {
                            let responsePayment:SuccessfulPaymentModel = SuccessfulPaymentModel(json: json)
                            completion(responsePayment,nil,nil,nil)
                            self.printDev(object: json)
                        }else{
                            completion(nil,nil,nil,ResponseWSType.Denied)
                        }
                    }
                }
            }
            
        }
    }
    
    // test
    func reverseServices(_ txrTPR:TypePaymentsRejectedModel?, _ completion: @escaping(_ response:SuccessfulPaymentModel?, _ responseCapX:SuccessfulPaymentModelVerifone? , _ failure:ErrorInfoLoginModel?, _ errorServices:ResponseWSType?) ->() ){
        
        let postOk = NSMutableString()
        postOk.append(String(format: "switchCommand=%@", txrTPR?.switchCommand ?? ""))
        postOk.append(String(format: "&processingCode=%@", txrTPR?.processingCode ?? ""))
        postOk.append(String(format: "&time=%@", txrTPR?.time ?? ""))
        postOk.append(String(format: "&merchantId=%@", txrTPR?.merchantId ?? ""))
        postOk.append(String(format: "&posEntryMode=%@", txrTPR?.posEntryMode ?? ""))
        postOk.append(String(format: "&track2Data=%@", txrTPR?.track2Data ?? ""))
        postOk.append(String(format: "&retreivalReference=%@", txrTPR?.retreivalReference ?? ""))
        postOk.append(String(format: "&terminalId=%@", txrTPR?.terminalId ?? ""))
        postOk.append(String(format: "&location=%@", txrTPR?.location ?? ""))
        postOk.append(String(format: "&usrId=%@", txrTPR?.usrId ?? ""))
        postOk.append(String(format: "&nodId=%@", txrTPR?.nodId ?? ""))
        postOk.append(String(format: "&idDispositivo=%@", txrTPR?.idDevice ?? ""))
        postOk.append(String(format: "&prctPropina=%@", txrTPR?.tipPercentage ?? ""))
        postOk.append(String(format: "&montoPropina=%@", txrTPR?.tipAmount ?? ""))
        postOk.append(String(format: "&medio=%@", txrTPR?.media ?? ""))
        postOk.append(String(format: "&mesesPromocion=%@", txrTPR?.monthPromotion ?? ""))
        postOk.append(String(format: "&nombrePromocion=%@", txrTPR?.namePromotion ?? ""))
        postOk.append(String(format: "&Referencia=%@", txrTPR?.reference ?? ""))
        postOk.append(String(format: "&Afiliacion=%@", txrTPR?.affiliate ?? ""))
        postOk.append(String(format: "&SecureToken=%@", txrTPR?.secureToken ?? ""))
        postOk.append(String(format: "&Timestamp=%@", txrTPR?.timestamp ?? ""))
        postOk.append(String(format: "&Track1=%@", txrTPR?.track1Data ?? ""))
        postOk.append(String(format: "&Scope=%@", txrTPR?.scope ?? ""))
        postOk.append(String(format: "&KSN=%@", txrTPR?.ksn ?? ""))
        postOk.append(String(format: "&ChipBanda=%@", txrTPR?.chip ?? ""))
        postOk.append(String(format: "&Amount=%@", txrTPR?.amount ?? ""))
        postOk.append(String(format: "&Email=%@", txrTPR?.email ?? ""))
        postOk.append(String(format: "&tipo=%@", txrTPR?.type ?? ""))
        
        
        postOk.append(String(format: "&tipoTja=%@", "0"))
        postOk.append(String(format: "&solucion=%@", "iAcepta"))
        postOk.append(String(format: "&track1Data=%@", ""))
        postOk.append(String(format: "&authoResponse=%@", txrTPR?.authoResponse ?? ""))
        postOk.append(String(format: "&responseCode=%@", ""))
        postOk.append(String(format: "&Cardholder=%@",txrTPR?.cardHolder ?? ""))
        postOk.append(String(format: "&deviceType=%@","IOS"))
        postOk.append(String(format: "&appVersion=%@",Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""))
        
        
        let typeReader = UserDefaults.standard.string(forKey: "TYPEREADER") ?? ""
        var url:URL!
        
        if typeReader == "VERIFONE"{
            postOk.append(String(format: "&capitulox=%@", txrTPR?.walker ?? ""))
            postOk.append(String(format: "&FechaHora=%@", txrTPR?.dateAndTime ?? ""))
            url = URL(string: Constants.URL_Verifone)!
        }else{
            postOk.append(String(format: "&capitulox=%@", ""))
            postOk.append(String(format: "&FechaHora=%@", txrTPR?.dateAndTime ?? ""))
            postOk.append(String(format: "&Walker=%@", txrTPR?.walker ?? ""))
            postOk.append(String(format: "&TraceAudit=%@", txrTPR?.traceAudit ?? ""))
            postOk.append(String(format: "&NetworkInfo=%@", txrTPR?.networkInfo ?? ""))
            url = URL(string: Constants.URL_PaymentWalker)!
        }
        
        
        
        let jsonData = String(postOk).data(using:.ascii, allowLossyConversion: true)!
        printDev(object: "body de reverso \(postOk)")
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("\(jsonData.count)", forHTTPHeaderField: "Content-Length")
        request.httpBody = jsonData
        
        Alamofire.request(request).responseString {
            (response) in
            //            self.printDev(object: postOk)
            debugPrint(response.result)
            if case let .failure(error) = response.result {
                completion(nil,nil,nil,ResponseWSType.UnKnow)
            }else{
                if let data = response.data{
                    if typeReader == "VERIFONE"{
                        if let json = try? JSON(data: data) {
                            let responsePayment:SuccessfulPaymentModelVerifone = SuccessfulPaymentModelVerifone(json: json)
                            completion(nil,responsePayment,nil,nil)
                        }else{
                            completion(nil,nil,nil, ResponseWSType.Denied)
                        }
                    }else{
                        if let json = try? JSON(data: data) {
                            let responsePayment:SuccessfulPaymentModel = SuccessfulPaymentModel(json: json)
                            completion(responsePayment,nil,nil,nil)
                            self.printDev(object: json)
                        }else{
                            completion(nil,nil,nil,ResponseWSType.Denied)
                        }
                    }
                }
            }
            
        }
    }
    
    //    func reverseServices(_ txrTPR:TypePaymentsRejectedModel?, _ completion: @escaping(_ response:SuccessfulPaymentModel?, _ failure:ErrorInfoLoginModel?, _ errorServices:ResponseWSType?) ->() ){
    //        let postOk = NSMutableString()
    //        postOk.append(String(format: "switchCommand=%@", txrTPR?.switchCommand ?? ""))
    //        postOk.append(String(format: "&processingCode=%@", txrTPR?.processingCode ?? ""))
    //        postOk.append(String(format: "&time=%@", txrTPR?.time ?? ""))
    //        postOk.append(String(format: "&merchantId=%@", txrTPR?.merchantId ?? ""))
    //        postOk.append(String(format: "&posEntryMode=%@", txrTPR?.posEntryMode ?? ""))
    //        postOk.append(String(format: "&track2Data=%@", txrTPR?.track2Data ?? ""))
    //        postOk.append(String(format: "&retreivalReference=%@", txrTPR?.retreivalReference ?? ""))
    //        postOk.append(String(format: "&terminalId=%@", txrTPR?.terminalId ?? ""))
    //        postOk.append(String(format: "&location=%@", txrTPR?.location ?? ""))
    //        postOk.append(String(format: "&authoResponse=%@", txrTPR?.authoResponse ?? ""))
    //
    //        postOk.append(String(format: "&usrId=%@", txrTPR?.usrId ?? ""))
    //        postOk.append(String(format: "&nodId=%@", txrTPR?.nodId ?? ""))
    //        postOk.append(String(format: "&idDispositivo=%@", txrTPR?.idDevice ?? ""))
    //        postOk.append(String(format: "&prctPropina=%@", txrTPR?.tipPercentage ?? ""))
    //        postOk.append(String(format: "&montoPropina=%@", txrTPR?.tipAmount ?? ""))
    //        postOk.append(String(format: "&medio=%@", txrTPR?.media ?? ""))
    //        postOk.append(String(format: "&mesesPromocion=%@", txrTPR?.monthPromotion ?? ""))
    //        postOk.append(String(format: "&nombrePromocion=%@", txrTPR?.namePromotion ?? ""))
    //        postOk.append(String(format: "&Referencia=%@", txrTPR?.reference ?? ""))
    //        postOk.append(String(format: "&Afiliacion=%@", txrTPR?.affiliate ?? ""))
    //
    //        postOk.append(String(format: "&FechaHora=%@", txrTPR?.dateAndTime ?? ""))
    //        postOk.append(String(format: "&SecureToken=%@", txrTPR?.secureToken ?? ""))
    //        postOk.append(String(format: "&Timestamp=%@", txrTPR?.timestamp ?? ""))
    //        postOk.append(String(format: "&Scope=%@", txrTPR?.scope ?? ""))
    //        postOk.append(String(format: "&Amount=%@", txrTPR?.amount ?? ""))
    //
    //        printDev(object: "body de reverso \(postOk)")
    //
    //        var url:URL!
    //        if typeReader == "VERIFONE"{
    //            url = URL(string: Constants.URL_CapX)!
    //        }else{
    //            url = URL(string: Constants.URL_PaymentWalker)!
    //        }
    //
    //        let jsonData = String(postOk).data(using: .utf8, allowLossyConversion: false)
    //
    //        var request = URLRequest(url: url)
    //        request.httpMethod = HTTPMethod.post.rawValue
    //        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    //        request.setValue("\(jsonData!.count)", forHTTPHeaderField: "Content-Length")
    //        request.httpBody = jsonData
    //
    //        Alamofire.request(request).responseString {
    //            (response) in
    //            if case let .failure(error) = response.result {
    //                completion(nil,nil,ResponseWSType.UnKnow)
    //            }else{
    //                if let data = response.data{
    //                    if let json = try? JSON(data: data) {
    //                        self.printDev(object: json)
    //                    }else{
    //                        completion(nil,nil,ResponseWSType.Denied)
    //                    }
    //                }else{
    //                    completion(nil,nil,ResponseWSType.Denied)
    //                }
    //            }
    //        }
    //    }
    
    func voucherServices(_ txrTPR:SendVoucherModel?, _ completion: @escaping(_ response:SuccessVoucherModel?, _ failure:ErrorInfoLoginModel?, _ errorServices:ResponseWSType?) ->() ){
        
        let postOk = NSMutableString()
        postOk.append(String(format: "userId=%@", txrTPR?.userId ?? ""))
        postOk.append(String(format: "&nodeId=%@", txrTPR?.nodeId ?? ""))
        postOk.append(String(format: "&scope=%@", txrTPR?.scope ?? ""))
        postOk.append(String(format: "&expiration=%@", txrTPR?.expiration ?? ""))
        postOk.append(String(format: "&secureToken=%@", txrTPR?.secureToken ?? ""))
        postOk.append(String(format: "&address=%@", txrTPR?.address ?? ""))
        postOk.append(String(format: "&commerceName=%@", txrTPR?.commerceName ?? ""))
        postOk.append(String(format: "&memberShip=%@", txrTPR?.memberShip ?? ""))
        postOk.append(String(format: "&terminal=%@", txrTPR?.terminal ?? ""))
        postOk.append(String(format: "&date=%@", txrTPR?.date ?? ""))
        postOk.append(String(format: "&cardIssuer=%@", txrTPR?.cardIssuer ?? ""))
        postOk.append(String(format: "&cardNumber=%@", txrTPR?.cardNumber ?? ""))
        postOk.append(String(format: "&aplLabel=%@", txrTPR?.aplLabel ?? ""))
        postOk.append(String(format: "&prefName=%@", txrTPR?.prefName ?? ""))
        postOk.append(String(format: "&aid=%@", txrTPR?.aid ?? ""))
        postOk.append(String(format: "&arqc=%@", txrTPR?.arqc ?? ""))
        postOk.append(String(format: "&authorization=%@", txrTPR?.authorization ?? ""))
        postOk.append(String(format: "&trxAmount=%@", txrTPR?.trxAmount ?? ""))
        postOk.append(String(format: "&trxTip=%@", txrTPR?.trxTip ?? "0.00"))
        postOk.append(String(format: "&trxTotal=%@", txrTPR?.trxTotal ?? ""))
        postOk.append(String(format: "&trxMonths=%@", txrTPR?.trxMonths ?? ""))
        postOk.append(String(format: "&cardHolder=%@", txrTPR?.cardHolder ?? ""))
        postOk.append(String(format: "&sign=%@", txrTPR?.sign ?? ""))
        postOk.append(String(format: "&location=%@", txrTPR?.location ?? ""))
        postOk.append(String(format: "&latitude=%@", txrTPR?.latitud ?? ""))
        postOk.append(String(format: "&longitude=%@", txrTPR?.longitud ?? ""))
        postOk.append(String(format: "&trxSequence=%@", txrTPR?.trxSequence ?? ""))
        postOk.append(String(format: "&trxTracing=%@", txrTPR?.trxTracing ?? ""))
        postOk.append(String(format: "&trxType=%@", txrTPR?.trxType ?? ""))
        postOk.append(String(format: "&emailClient=%@", txrTPR?.emailClient ?? ""))
        postOk.append(String(format: "&cardType=%@", txrTPR?.cardType ?? ""))
        postOk.append(String(format: "&cardEntryMode=%@", txrTPR?.cardEntryMode ?? ""))
        postOk.append(String(format: "&VoucherType=%@", txrTPR?.VoucherType ?? ""))
        printDev(object: "body de voucher \(postOk)")
        let url = URL(string: Constants.URL_Voucher)!
        let jsonData = String(postOk).data(using: .utf8, allowLossyConversion: false)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("\(jsonData!.count)", forHTTPHeaderField: "Content-Length")
        request.httpBody = jsonData
        
        Alamofire.request(request).responseString {
            (response) in
            if case let .failure(error) = response.result {
                completion(nil,nil,ResponseWSType.UnKnow)
            }else{
                if let data = response.data{
                    if let json = try? JSON(data: data) {
                        self.printDev(object: json)
                        let voucherResponse:SuccessVoucherModel = SuccessVoucherModel(json: json)
                        completion(voucherResponse,nil,nil)
                    }else{
                        completion(nil,nil,ResponseWSType.UnKnow)
                    }
                    
                }else{
                    completion(nil,nil,ResponseWSType.UnKnow)
                }
            }
        }
        
    }
    
    func loadKeyVerifoneServices(_ txrTPR:TypePaymentsRejectedModel?, _ completion: @escaping(_ response:SuccessfulPaymentModelVerifone?, _ failure:ErrorInfoLoginModel?, _ errorServices:ResponseWSType?) ->() ){
        let postOk = NSMutableString()
        postOk.append(String(format: "switchCommand=%@", txrTPR?.switchCommand ?? ""))
        postOk.append(String(format: "&processingCode=%@", txrTPR?.processingCode ?? ""))
        postOk.append(String(format: "&time=%@", txrTPR?.time ?? ""))
        postOk.append(String(format: "&merchantId=%@", txrTPR?.merchantId ?? ""))
        postOk.append(String(format: "&posEntryMode=%@", txrTPR?.posEntryMode ?? ""))
        postOk.append(String(format: "&track2Data=%@", txrTPR?.track2Data ?? ""))
        postOk.append(String(format: "&retreivalReference=%@", txrTPR?.retreivalReference ?? ""))
        postOk.append(String(format: "&terminalId=%@", txrTPR?.terminalId ?? ""))
        postOk.append(String(format: "&location=%@", txrTPR?.location ?? ""))
        postOk.append(String(format: "&usrId=%@", txrTPR?.usrId ?? ""))
        postOk.append(String(format: "&nodId=%@", txrTPR?.nodId ?? ""))
        
        postOk.append(String(format: "&idDispositivo=%@", txrTPR?.idDevice ?? ""))
        postOk.append(String(format: "&medio=%@", txrTPR?.media ?? ""))
        postOk.append(String(format: "&Afiliacion=%@", txrTPR?.affiliate ?? ""))
        postOk.append(String(format: "&FechaHora=%@", txrTPR?.dateAndHours ?? ""))
        postOk.append(String(format: "&capitulox=%@", txrTPR?.walker ?? ""))
        postOk.append(String(format: "&Timestamp=%@", txrTPR?.timestamp ?? ""))
        postOk.append(String(format: "&Scope=%@", txrTPR?.scope ?? ""))
        postOk.append(String(format: "&Amount=%@", txrTPR?.amount ?? ""))
        postOk.append(String(format: "&tipo=%@", txrTPR?.type ?? ""))
        postOk.append(String(format: "&Email=%@", txrTPR?.email ?? ""))
        postOk.append(String(format: "&Referencia=%@", txrTPR?.reference ?? ""))
        
        postOk.append(String(format: "&PrctPropina=%@", txrTPR?.tipPercentage ?? ""))
        postOk.append(String(format: "&MontoPropina=%@", txrTPR?.tipAmount ?? ""))
        postOk.append(String(format: "&HolderName=%@", txrTPR?.cardHolder ?? ""))
        postOk.append(String(format: "&MesesPromocion=%@", txrTPR?.monthPromotion ?? ""))
        postOk.append(String(format: "&NombrePromocion=%@", txrTPR?.namePromotion ?? ""))
        
        let url = URL(string: Constants.URL_Verifone)!
        let jsonData = String(postOk).data(using: .utf8, allowLossyConversion: false)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("\(jsonData!.count)", forHTTPHeaderField: "Content-Length")
        request.httpBody = jsonData
        
        Alamofire.request(request).responseString {
            (response) in
            if case let .failure(error) = response.result {
                completion(nil,nil,ResponseWSType.UnKnow)
            }else{
                if let data = response.data{
                    if let json = try? JSON(data: data) {
                        let responsePayment:SuccessfulPaymentModelVerifone = SuccessfulPaymentModelVerifone(json: json)
                        completion(responsePayment,nil,nil)
                    }else{
                        completion(nil,nil,ResponseWSType.UnKnow)
                    }
                }else{
                    completion(nil,nil,ResponseWSType.UnKnow)
                }
            }
        }
        
    }
    
    static func walletCodi(_ completion: @escaping (DataResponse<Data>?) -> Void){
        let typeReader:String = UserDefaults.standard.string(forKey: "TYPEREADER") ?? ""
        let txnInfo = "0|\(sessionGlob.Static.sessionIAcepta!.userID)|\((sessionGlob.Static.sessionIAcepta?.userInfo!.nodeId)!)|\(HelperExtensions().dateInFormat(stringFormat: "%y%m%d%H%M%S"))|\((typeReader == "WALKER") ? "Dispositivo 1" : "Dispositivo 3")|0|000|iAcepta|Sin Promocion|reference|\(sessionGlob.Static.sessionIAcepta?.authToken ?? "")|\(sessionGlob.Static.sessionIAcepta?.tokenExpiration ?? "")|\(sessionGlob.Static.sessionIAcepta?.scope ?? "")|email|iOS|\(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "")"
        
        let paramater =  ["wallets":
            ["applicationIdentification": prod! ? "IACEPTA" : "SANDBOX",
                "companyIdentification": String((sessionGlob.Static.sessionIAcepta?.userInfo!.commerceMemberShipNumber)!),//"MONETA",
                "branchIdentification":String((sessionGlob.Static.sessionIAcepta?.userInfo!.commerceMemberShipNumber)!),  //"2",
                "posIdentification": UserDefaults.standard.string(forKey: "posIdentificationUser"),//sessionGlob.Static.sessionIAcepta!.userID,//"1",
                "txnInfo" : txnInfo,
                "transactionDateTime":Date.toDayString()]] as [String : Any]
        
        
        let dictionary = paramater
        let theJSONData = try?  JSONSerialization.data(
            withJSONObject: dictionary,
            options: .prettyPrinted
        )
        let theJSONText = String(data: theJSONData!,
                                 encoding: String.Encoding.utf8)
        
        let jsonData = theJSONText!.data(using: .utf8, allowLossyConversion: false)
        
        debugPrint("parametros de Wallets: \(paramater)")
        
        let url = URL(string: "\(Constants.URL_Codi)/Wallets")!
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        Alamofire.request(request).responseData {
            (response) in
            completion(response)
            return
            
        }
        
    }
    
    static func walletRequestCodi(_ typeService:WalletRequestType,_ walletIdentification:String,_ requestKey:String,_ amount:String,_ email:String,_ reference:String,_ completion: @escaping (DataResponse<Data>?) -> Void){
        var setup: WalletRequestType!
        if typeService == .firstAttempt{
            let uuid = UUID().uuidString
            UserDefaults.standard.set(uuid, forKey: "UUIDUser")
        }

        let typeReader:String = UserDefaults.standard.string(forKey: "TYPEREADER") ?? ""
        let txnInfo = "0|\(sessionGlob.Static.sessionIAcepta!.userID)|\((sessionGlob.Static.sessionIAcepta?.userInfo!.nodeId)!)|\(HelperExtensions().dateInFormat(stringFormat: "%y%m%d%H%M%S"))|\((typeReader == "WALKER") ? "Dispositivo 1" : "Dispositivo 3")|0|000|iAcepta|Sin Promocion|\(reference)|\(sessionGlob.Static.sessionIAcepta?.authToken ?? "")|\(sessionGlob.Static.sessionIAcepta?.tokenExpiration ?? "")|\(sessionGlob.Static.sessionIAcepta?.scope ?? "")|\(email)|iOS|\(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "")"
        
        let paramater : [String : Any]
        
        if typeService == .firstAttempt{
            paramater =  ["walletsRequest":
                [
                    "applicationIdentification": prod! ? "IACEPTA" : "SANDBOX",
                    "companyIdentification":String((sessionGlob.Static.sessionIAcepta?.userInfo!.commerceMemberShipNumber)!),//"MONETA",
                    "branchIdentification":String((sessionGlob.Static.sessionIAcepta?.userInfo!.commerceMemberShipNumber)!),  //"2",
                    "posIdentification":UserDefaults.standard.string(forKey: "posIdentificationUser"),//sessionGlob.Static.sessionIAcepta!.userID,//"1",
                    "walletIdentification":walletIdentification,//dato de otro servicio
                    "transactionIdentification":UserDefaults.standard.string(forKey: "UUIDUser"),//"4",
                    "transactionDateTime":Date.toDayString(),
                    "currencyCode":"484",
                    "amount": amount,
                    "txnInfo" : txnInfo]] // as [String : Any] "transactionTimeout":"120"
        }else{
            paramater =  ["walletsRequest":
                [
                    "applicationIdentification": prod! ? "IACEPTA" : "SANDBOX",
                    "companyIdentification":String((sessionGlob.Static.sessionIAcepta?.userInfo!.commerceMemberShipNumber)!),//"MONETA",
                    "branchIdentification":String((sessionGlob.Static.sessionIAcepta?.userInfo!.commerceMemberShipNumber)!),  //"2",
                    "posIdentification":UserDefaults.standard.string(forKey: "posIdentificationUser"),//sessionGlob.Static.sessionIAcepta!.userID,//"1",
                    "walletIdentification":walletIdentification,//dato de otro servicio //e
                    "transactionIdentification":UserDefaults.standard.string(forKey: "UUIDUser"),//"4",
                    "transactionDateTime":Date.toDayString(),
                    "currencyCode":"484",
                    "amount": amount, //e
                    "requestKey":requestKey,// este viaja hasta el reintento
                    "txnInfo" : txnInfo]] // as [String : Any] "transactionTimeout":"120"
        }
        
        let dictionary = paramater
        let theJSONData = try?  JSONSerialization.data(
            withJSONObject: dictionary,
            options: .prettyPrinted
        )
        let theJSONText = String(data: theJSONData!,
                                 encoding: String.Encoding.utf8)
        
        let jsonData = theJSONText!.data(using: .utf8, allowLossyConversion: false)
        
        debugPrint("parametros de WalletsRequest: \(paramater)")
        
        let url = URL(string: "\(Constants.URL_Codi)/WalletsRequest")!
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        Alamofire.request(request).responseData {
            (response) in
            completion(response)
            return
            
        }
        
    }
    
    static func cancelCodi(_ requestKey:String,_ amount:String,_ email:String,_ reference:String,_ completion: @escaping (DataResponse<Data>?) -> Void){
        let typeReader:String = UserDefaults.standard.string(forKey: "TYPEREADER") ?? ""
        let txnInfo = "0|\(sessionGlob.Static.sessionIAcepta!.userID)|\((sessionGlob.Static.sessionIAcepta?.userInfo!.nodeId)!)|\(HelperExtensions().dateInFormat(stringFormat: "%y%m%d%H%M%S"))|\((typeReader == "WALKER") ? "Dispositivo 1" : "Dispositivo 3")|0|000|iAcepta|Sin Promocion|\(reference)|\(sessionGlob.Static.sessionIAcepta?.authToken ?? "")|\(sessionGlob.Static.sessionIAcepta?.tokenExpiration ?? "")|\(sessionGlob.Static.sessionIAcepta?.scope ?? "")|\(email)|iOS|\(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "")"
        
        let paramater =  ["cancelRequest":
            ["applicationIdentification": prod! ? "IACEPTA" : "SANDBOX",
                "companyIdentification": String((sessionGlob.Static.sessionIAcepta?.userInfo!.commerceMemberShipNumber)!),//"MONETA",
                "branchIdentification": String((sessionGlob.Static.sessionIAcepta?.userInfo!.commerceMemberShipNumber)!),  //"2",
                "posIdentification": UserDefaults.standard.string(forKey: "posIdentificationUser"),//sessionGlob.Static.sessionIAcepta!.userID,//"1",
                "requestKey":requestKey,
                "txnInfo" : txnInfo,
                "amount": amount,
                "reason":"USER"]] as [String : Any]
        
        
        let dictionary = paramater
        let theJSONData = try?  JSONSerialization.data(
            withJSONObject: dictionary,
            options: .prettyPrinted
        )
        let theJSONText = String(data: theJSONData!,
                                 encoding: String.Encoding.utf8)
        
        let jsonData = theJSONText!.data(using: .utf8, allowLossyConversion: false)
        
        debugPrint("parametros de Cancelacion por usuario: \(paramater)")
        
        let url = URL(string: "\(Constants.URL_Codi)/Cancel")!
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        Alamofire.request(request).responseData {
            (response) in
            completion(response)
            return
            
        }
        
    }
    
    static func sendVoucherCodi(_ amount:String,_ cardIssuer:String,_ cardNumber:String,_ authorization:String,_ sequence:String,_ email:String,_ completion: @escaping (DataResponse<Data>?) -> Void){
        let postOk = NSMutableString()
        
        postOk.append(String(format: "address=%@", sessionGlob.Static.sessionIAcepta?.comerAddres ?? ""))
        postOk.append(String(format: "&commerceName=%@", sessionGlob.Static.sessionIAcepta?.comerceName ?? ""))
        postOk.append(String(format: "&memberShip=%@", sessionGlob.Static.sessionIAcepta?.userInfo?.commerceMemberShipNumber ?? ""))
        postOk.append(String(format: "&terminal=%@", ""))
        postOk.append(String(format: "&date=%@", Date.toDayStringFormat()))
        postOk.append(String(format: "&cardIssuer=%@", cardIssuer))
        postOk.append(String(format: "&cardNumber=%@", cardNumber))
        postOk.append(String(format: "&aplLabel=%@", ""))
        postOk.append(String(format: "&prefName=%@", ""))
        postOk.append(String(format: "&aid=%@", ""))
        postOk.append(String(format: "&arqc=%@", ""))
        postOk.append(String(format: "&authorization=%@", authorization))
        postOk.append(String(format: "&trxAmount=%@", amount))
        postOk.append(String(format: "&trxTip=%@", "0.00"))
        postOk.append(String(format: "&trxTotal=%@", amount))
        postOk.append(String(format: "&trxMonths=%@", ""))
        postOk.append(String(format: "&cardHolder=%@", "NO DISPONIBLE"))
        postOk.append(String(format: "&userId=%@", sessionGlob.Static.sessionIAcepta!.userID))
        postOk.append(String(format: "&nodeId=%@", sessionGlob.Static.sessionIAcepta?.userInfo?.nodeId ?? ""))
        postOk.append(String(format: "&secureToken=%@", sessionGlob.Static.sessionIAcepta?.authToken ?? ""))
        postOk.append(String(format: "&expiration=%@", sessionGlob.Static.sessionIAcepta?.tokenExpiration ?? ""))
        postOk.append(String(format: "&scope=%@", sessionGlob.Static.sessionIAcepta?.scope ?? ""))
        postOk.append(String(format: "&sign=%@", ""))
        postOk.append(String(format: "&location=%@", ""))
        postOk.append(String(format: "&latitude=%@", "0.0"))
        postOk.append(String(format: "&longitude=%@", "0.0"))
        postOk.append(String(format: "&trxSequence=%@", sequence))
        postOk.append(String(format: "&trxTracing=%@", sequence))
        postOk.append(String(format: "&trxType=%@", "7"))
        postOk.append(String(format: "&emailClient=%@",email))
        postOk.append(String(format: "&cardType=%@", ""))
        postOk.append(String(format: "&voucherType=%@","7"))
        postOk.append(String(format: "&trxState=%@", "APROBADA"))
        postOk.append(String(format: "&hour=%@", Date.toHour()))
        postOk.append(String(format: "&saleReference=%@",""))
        
        debugPrint("body de voucher CODI \(postOk)")
        let url = URL(string: Constants.URL_Voucher)!
        let jsonData = String(postOk).data(using: .utf8, allowLossyConversion: false)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("\(jsonData!.count)", forHTTPHeaderField: "Content-Length")
        request.httpBody = jsonData
        
        AFManager.request(request).responseData {
            (response) in
            completion(response)
            return
            
        }
        
    }
}
