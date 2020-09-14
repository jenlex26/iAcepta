//
//  LoginLogic.swift
//  iAcepta
//
//  Created by QUALITY on 6/7/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

enum LoginResponseType {
    case INTERNAL_ERROR
    case SERVER_ERROR
    case UNAUTHORIZED
    case UNAUTHORIZED_EXPIRATION_PASSWORD
    case UNAUTHORIZED_TEMPORAL_PASSWORD
    case NO_CONNECTION
    case PASSWORD_BAD_FORMAT
    case LOGINWASSUCCESS
    case GENERAL_ERROR
}

enum changePasswordResponseType {
    case EMPTY_FORMAT
    case DIFF_NEW_PASSWORD
    case VERYFY_PASSWORD
    case UPDATE_PASSWORD
    case NOT_SECURITY_PASSWORD
    case NO_CONNECTION
    case GENERAL_ERROR
}

protocol LoginLogicDelegate: AnyObject {
    func loginResponse(_ responseType: LoginResponseType)
}

protocol ChangePasswordDelegate: AnyObject {
    func changePasswordResponse(_ responseType: changePasswordResponseType)
}


class LoginLogic {
    weak var delegate: LoginLogicDelegate?
    weak var delegateChangePassword : ChangePasswordDelegate?
    
    func loginRequest(_ user:String, _ password:String){
        let serviceManager = LoginServicesManager()
        serviceManager.logInService(user, password) { (response, failure, errorServices) in
            self.logInResponse(failure, response, errorServices, { (loginResponseType2) in
                self.delegate?.loginResponse(loginResponseType2!)
            })
            
        }
    }
    
    func changePasswordRequest(_ user:String, _ password:String, _ newPassword:String){
        let serviceManager = LoginServicesManager()
        serviceManager.changePasswordService(user, password, newPassword) { (response, failure) in
            self.changePasswordResponse(failure, response, { (changePasswordResponseType) in
                self.delegateChangePassword?.changePasswordResponse(changePasswordResponseType!)
            })
        }
    }
    
    
    func logInResponse(_ error:ErrorInfoLoginModel?, _ response:ContentLoginModel?, _ errorServices:LoginResponseType?, _ completion: @escaping(_ responseType:LoginResponseType?) ->()){
        // Manage and parse info
        if error != nil {
            let errorCode = Int(error!.code!)
            // Validate error code instead description
            let externo = modelGlob.Static.integratorModel?.externo ?? false
            if !externo{
                if (errorCode == 2001){
                    completion(LoginResponseType.UNAUTHORIZED_TEMPORAL_PASSWORD)
                }else if (errorCode! >= 3009 && errorCode! <= 3999){
                    completion(LoginResponseType.PASSWORD_BAD_FORMAT)
                }else {
                    completion(LoginResponseType.UNAUTHORIZED)
                }
            }else{
                if (errorCode == 2001 || errorCode == 2000){
                    completion(LoginResponseType.UNAUTHORIZED_TEMPORAL_PASSWORD)
                }else{
                    completion(LoginResponseType.GENERAL_ERROR)
                }
            }
        }else if errorServices != nil{
            completion(LoginResponseType.NO_CONNECTION)
        }else {
            sessionGlob.Static.sessionIAcepta = self.resolveSesionLogin(response: response!)
            completion(LoginResponseType.LOGINWASSUCCESS)
        }
    }
    
    func changePasswordResponse(_ error:Int?, _ response:Int?, _ completion: @escaping(_ responseType:changePasswordResponseType?) ->()){
        if error != nil {
            if (error! >= 3001 && error! <= 3999){
                completion(changePasswordResponseType.NOT_SECURITY_PASSWORD)
            }else {
                completion(changePasswordResponseType.VERYFY_PASSWORD)
            }
        }else{
            if response == 200{
                completion(changePasswordResponseType.UPDATE_PASSWORD)
            }
        }
    }
    
    func getMessageFromResponseType(_ responseType: LoginResponseType) -> String{
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
    
    private func resolveSesionLogin(response: ContentLoginModel) -> SessionIAcepta?{
        var sia : SessionIAcepta?
        
        sia = SessionIAcepta(authToken: response.authToken!, userID: response.userInfo!.userId!, userPhoneNumber: response.userInfo!.userPhoneNumber!, comerceName: response.userInfo!.commerceName!, comerAddres: response.userInfo!.commerceAddress!, daysForExpiration: Int(response.userInfo!.daysForExpiration!)!, tokenExpiration: response.tokenExpiration!)
        
        for cont in response.allowedOps!.split(separator: ","){
//        for cont in "1,5,3,2,4,7".split(separator: ","){
            if (cont == "1"){
                sia?.hasPayment = true
            }else if (cont == "2"){
                sia?.hasCancellation = true
            }else if (cont == "4"){
                sia?.hasRefund = true
            }else if (cont == "5"){
                sia?.canAcceptTip = true
            }else if (cont == "6"){
                sia?.hasMultiPayment = true
            }else if (cont == "7"){
                sia?.hascodi = true
            }
        }
        
        for value in response.condParameters!{
            if value.condCode == "PDIS"{
                let valueSplit:String? = "0,"+value.value!
                sia?.rangeMsi = valueSplit?.split(separator: ",")
            }else if value.condCode == "AMEX"{
                if value.value == "OPT"{
                    sia?.canAcceptOPT = true
                    sia?.amexFlag = value.value ?? ""
                }
            }
        }
        
        for value in response.definedConds!.split(separator: ","){
            if value == "AMEX"{
                sia?.canAcceptPayAmex = true
            }else if value == "RLB"{
                sia?.canAcceptPayToBad = true
            }else if value == "PPN"{
                //sia?.canAcceptTip = true
            }
        }
        
        sia?.userInfo = response.userInfo
        sia?.scope = response.allowedOps
        return sia
    }
    
}
