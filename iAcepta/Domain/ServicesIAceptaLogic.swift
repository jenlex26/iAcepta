//
//  ServicesIAceptaLogic.swift
//  iAcepta
//
//  Created by QUALITY on 7/1/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import UIKit

enum ServicesResponseType {
    case INTERNAL_ERROR
    case SERVER_ERROR
    case UNAUTHORIZED
    case UNAUTHORIZED_EXPIRATION_PASSWORD
    case UNAUTHORIZED_TEMPORAL_PASSWORD
    case NO_CONNECTION
    case PASSWORD_BAD_FORMAT
    case SERVICESSUCCESS
    case GENERAL_ERROR
    case DENIED
}

protocol ServicesIAceptaLogicDelegate: AnyObject {
    func servicesResponse(_ responseType: ServicesResponseType, resultResponse:SuccessfulPaymentModel?, resultResponseCapX:SuccessfulPaymentModelVerifone?)
    func reverseResponse(_ responseType:ServicesResponseType, resultResponse:SuccessfulPaymentModel?)
}
protocol ServicesIAceptaVoucherDelegate: AnyObject {
    func servicesVoucherResponse(_ responseType: ServicesResponseType, resultResponse:SuccessVoucherModel?)
}
protocol ServicesIAceptaLoadKeysDelegate:AnyObject {
    func serviceResponseLoadKeys(_ responseType: ServicesResponseType, resultResponse: SuccessfulPaymentModelVerifone?)
}

class ServicesIAceptaLogic {
    
    weak var servicesDelegate: ServicesIAceptaLogicDelegate?
    weak var servicesVoucherDelegate: ServicesIAceptaVoucherDelegate?
    weak var servicesIAceptaLoadKeysDelegate : ServicesIAceptaLoadKeysDelegate?
    
    func typePaymentsRejected(_ txrPaymentsRejected:TypePaymentsRejectedModel?){
        let serviceManager = ServicesManager()
        serviceManager.paymentsRejacted(txrPaymentsRejected) { (response, failure, errorServices) in
            self.typePaymentsResponse(failure, response, nil, errorServices, { (servicesResponseType, response, nil) in
                self.servicesDelegate?.servicesResponse(servicesResponseType!, resultResponse: response, resultResponseCapX: nil)
            })
        }
    }
    
    func payment(_ txrPaymentsRejected:TypePaymentsRejectedModel?){
        let serviceManager = ServicesManager()
        serviceManager.paymentServices(txrPaymentsRejected) { (response, responseCapX, failure, errorServices) in
            self.typePaymentsResponse(failure, response, responseCapX, errorServices, { (servicesResponseType, response, responseCapX) in
                self.servicesDelegate?.servicesResponse(servicesResponseType!, resultResponse: response, resultResponseCapX: responseCapX)
            })
        }
    }
    
    func reverse(_ txrReverse:TypePaymentsRejectedModel?){
        let serviceManager = ServicesManager()
        serviceManager.reverseServices(txrReverse) { (response, responseCapX, failure, errorServices) in
            self.typePaymentsResponse(failure, response, responseCapX, errorServices, { (servicesResponseType, response, responseCapX) in
                self.servicesDelegate?.servicesResponse(servicesResponseType!, resultResponse: response, resultResponseCapX: responseCapX)
            })
        }
    }
    
    
//    func reverse(_ txrReverse:TypePaymentsRejectedModel?){
//        let serviceManager = ServicesManager()
//        serviceManager.reverseServices(txrReverse){(response, failure, errorServices) in
//            self.reverseResponse(failure, response, errorServices, {(ServicesResponseType, response) in
//                self.servicesDelegate?.reverseResponse(ServicesResponseType!, resultResponse: response)
//            })
//        }
//    }
    
    func voucherConnec(_ txrVoucher:SendVoucherModel?){
        let serviceManager = ServicesManager()
        serviceManager.voucherServices(txrVoucher) { (response, failure, errorServices) in
            self.typeVoucherResponse(failure, response, errorServices, { (servicesResponseType, response) in
                self.servicesVoucherDelegate?.servicesVoucherResponse(servicesResponseType!, resultResponse: response)
            })
        }
    }
    
    func loadKeysVerifone(_ txrPaymentsRejected:TypePaymentsRejectedModel?){
        let serviceManager = ServicesManager()
        serviceManager.loadKeyVerifoneServices(txrPaymentsRejected, {(response,failure,errorServices) in
            self.loadKeysResponse(errorServices, response, { (errorServices, response) in
                self.servicesIAceptaLoadKeysDelegate?.serviceResponseLoadKeys(errorServices, resultResponse: response)
            })
        })
    }
    
    func typePaymentsResponse(_ error:ErrorInfoLoginModel?, _ response:SuccessfulPaymentModel?,  _ responseVerifone:SuccessfulPaymentModelVerifone?, _ errorServices:ResponseWSType?, _ completion: @escaping(_ responseType:ServicesResponseType?, _ resultResponse: SuccessfulPaymentModel?, _ resultResponseVerifone: SuccessfulPaymentModelVerifone?) ->()){
        if error != nil {
            let errorCode = Int(error!.code!)
            if (errorCode == 2001){
                //completion(LoginResponseType.UNAUTHORIZED_TEMPORAL_PASSWORD)
            }else if (errorCode! >= 3009 && errorCode! <= 3999){
                //completion(LoginResponseType.PASSWORD_BAD_FORMAT)
            }else {
                //completion(LoginResponseType.UNAUTHORIZED)
            }
        }else if errorServices != nil{
            completion(ServicesResponseType.UNAUTHORIZED, nil,nil)
        }else if responseVerifone != nil{
            completion(ServicesResponseType.SERVICESSUCCESS, nil,responseVerifone)
        }else {
            completion(ServicesResponseType.SERVICESSUCCESS, response,nil)
        }
    }
    
    func typeVoucherResponse(_ error:ErrorInfoLoginModel?, _ response:SuccessVoucherModel?, _ errorServices:ResponseWSType?, _ completion: @escaping(_ responseType:ServicesResponseType?, _ resultResponse: SuccessVoucherModel?) ->()){
        if errorServices != nil{
            completion(ServicesResponseType.UNAUTHORIZED, nil)
        }else{
            completion(ServicesResponseType.SERVICESSUCCESS, response)
        }
    }
    
    func reverseResponse(_ error:ErrorInfoLoginModel?, _ response:SuccessfulPaymentModel?, _ errorServices:ResponseWSType?, _ completion: @escaping(_ responseType:ServicesResponseType?, _ resultResponse: SuccessfulPaymentModel?) ->()){
        if errorServices != nil{
            completion(ServicesResponseType.DENIED, nil)
        }else{
            completion(ServicesResponseType.SERVICESSUCCESS,nil)
        }
    }
    
    func loadKeysResponse(_ errorServices:ResponseWSType?, _ response:SuccessfulPaymentModelVerifone?, _ completion: @escaping(_ responseType:ServicesResponseType, _ resultResponse: SuccessfulPaymentModelVerifone?) ->()){
        if errorServices != nil{
            completion(ServicesResponseType.DENIED,nil)
        }else{
            completion(ServicesResponseType.SERVICESSUCCESS, response)
        }
    }
    
    func getMessageFromResponseType(_ responseType: ServicesResponseType) -> String{
        var message = ""
        switch responseType {
        case .UNAUTHORIZED:
            message = "Credenciales no aceptadas. Verifique su nombre de usuario y password. Si no puede acceder, consulte con el Administrador."
            break
        case .UNAUTHORIZED_TEMPORAL_PASSWORD:
            message = "bodyAlertExpiredPassword".localized
            break
        case .PASSWORD_BAD_FORMAT:
            message = "Ocurrio un problema al procesar su solicitud, intente más tarde."
            break
        default:
            break
        }
        return message
    }
    
}
