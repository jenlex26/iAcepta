//
//  LoginServicesManager.swift
//  iAcepta
//
//  Created by QUALITY on 6/11/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum ResponseType:String {
    case Data
    case Url
    case Error
    case HtmlContent
    case Empty
    case UnKnow
}



enum Errors: Error {
    case noData
    case unknownError
}


class LoginServicesManager: UIViewController {
    
    let loginExt = LoginExtension()
    
    func logInService(_ user:String, _ password:String, _ completion: @escaping(_ response:ContentLoginModel?, _ failure:ErrorInfoLoginModel?, _ errorServices:LoginResponseType?) ->()){
        let randomNumber = LoginExtension().generateNonce()
        
        let date = String(NSDate().timeIntervalSince1970)
        let timestamp = (date as NSString).integerValue
        
        let header = "\(ConstantsLogin.oauth_signature)=\(generateSignature(url: ConstantsLogin.URL_Login, user: user, password: password, nonce: randomNumber, timestamp: timestamp))&"+"\(ConstantsLogin.oauth_nonce)=\(randomNumber)&"+"\(ConstantsLogin.oauth_header)=\(ConstantsLogin.oauth_real)=&"+"\(ConstantsLogin.oauth_consumer_key)=\(user)&"+"\(ConstantsLogin.oauth_signature_method)"+"\(ConstantsLogin.oauth_timestamp)=\(timestamp)&"+"\(ConstantsLogin.oauth_version)=\(ConstantsLogin.oauth_value_version)"
    
        let headersPeticion = ["Authorization": "\(header)",
            "Content-Type": "application/json"]
        
        AFManager.request(ConstantsLogin.URL_Login, method: .post, parameters: nil, encoding: URLEncoding(destination: .queryString), headers: headersPeticion) .responseData{ response in
            if((response.result.value) != nil) {
                
                let jsonParse = ServiceResultLoginModel(json: JSON(response.result.value!))
                if let resultResponseType = jsonParse.responseType{
                    
                    let resultType = ResponseType(rawValue: resultResponseType)
                    let responseDictionaryContent = jsonParse.content! as [String: AnyObject]
                    
                    if(ResponseType.Data == resultType){
                        let loginResponse:ContentLoginModel = ContentLoginModel(json: responseDictionaryContent)
                        completion(loginResponse,nil, nil)
                    }else if (ResponseType.Error == resultType){
                        let error:ErrorInfoLoginModel = ErrorInfoLoginModel(json: responseDictionaryContent)
                        completion(nil,error, nil)
                    }
                }else{
                    completion(nil,nil,LoginResponseType.NO_CONNECTION)
                }
            }else{
                completion(nil,nil,LoginResponseType.NO_CONNECTION)
            }
        }
    }
    
    func changePasswordService(_ user:String, _ password:String, _ newPassword:String, _ completion: @escaping(_ response:Int?, _ failure:Int?) ->()){
        let randomNumber = LoginExtension().generateNonce()
        
        let date = String(NSDate().timeIntervalSince1970)
        let timestamp = (date as NSString).integerValue
        let rsa = RsaEncrypt()
        let encrypRSA:String = rsa.encriptaRsa(newPassword)
        
        let header = "\(ConstantsLogin.oauth_signature)=\(generateSignature(url: ConstantsLogin.URL_paswd, user: user, password: password, nonce: randomNumber, timestamp: timestamp))&"+"\(ConstantsLogin.oauth_nonce)=\(randomNumber)&"+"\(ConstantsLogin.oauth_header_new_paswd)=\(ConstantsLogin.oauth_real)=&"+"\(ConstantsLogin.oauth_consumer_key)=\(user)&"+"\(ConstantsLogin.oauth_signature_method)"+"\(ConstantsLogin.oauth_timestamp)=\(timestamp)&"+"\(ConstantsLogin.oauth_version)=\(ConstantsLogin.oauth_value_version)&"+"\(ConstantsLogin.consumer_new_paswd)=\(encrypRSA)"
        
        let headersPeticion = ["Authorization": "\(header)",
            "Content-Type": "application/json"]
        
        Alamofire.request(ConstantsLogin.URL_paswd, method: .post, parameters: nil, encoding: URLEncoding(destination: .queryString), headers: headersPeticion) .responseData{ response in
            if((response.result.value) != nil) {
                let userJson = JSON(response.result.value!)
                if let resultType = ResponseType(rawValue: userJson["ResponseType"].string!){
                    if(ResponseType.Data == resultType){
                        if userJson.error == nil{
                            completion(200,nil)
                        }
                    }else if (ResponseType.Error == resultType){
                        if let code = userJson["Content"]["Code"].string{
                            completion(nil,Int(code))
                        }
                    }
                }
            }
        }
        
    }
    
    // -----
    func generateSignature(url:String, user:String, password:String, nonce:String, timestamp:NSInteger)->String{
        let signatureBase = "POST&"+"\(loginExt.encodeUTF8(string: url))&"+"\(loginExt.encodeUTF8(string: "\(ConstantsLogin.oauth_consumer_key)=\(user)&"+"\(ConstantsLogin.oauth_nonce)=\(nonce)&"+"\(ConstantsLogin.oauth_signature_method)"+"\(ConstantsLogin.oauth_timestamp)=\(timestamp)&"+"\(ConstantsLogin.oauth_version)=\(ConstantsLogin.oauth_value_version)"))"
        
        let consumerSecret = "kd94hf93k423kf44\(loginExt.sha256String(password))&"
        let encrypHMACSha1:String = signatureBase.hmacSha1(key: consumerSecret)
        
        let customAllowedSet =  NSCharacterSet(charactersIn:"!*'();:@&=+$,/?%#[] ").inverted
        return encrypHMACSha1.addingPercentEncoding(withAllowedCharacters: customAllowedSet)!
    }
    
}
