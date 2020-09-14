//
//  SuccessfulPaymentModelVerifone.swift
//  iAcepta
//
//  Created by QUALITY on 8/2/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import SwiftyJSON
class SuccessfulPaymentModelVerifone: NSCoding {
    
    public var allDates:String?
    public var code:String?
    public var authorization:String?
    public var responseCode:String?
    public var capituloX:String?
    public var date:String?
    
    private class ContentRequestModelKeys : NSObject {
        static let allDates : String = "Mensaje"
        static let code : String = "Code"
        static let authorization : String = "Authorization"
        static let responseCode : String = "Response Code"
        static let capX : String = "CapituloX"
        static let date : String = "Fecha"
    }
    
    
//    public required init(json: JSON) {
//        allDates      = "5|200229152059|Dispositivo 3|00|000|iAcepta|Sin Promocion|paquete dermapen |4CF326E0F53049EC495431DC621C5B25667E05695F5F2D49994FA4AE0C3E8C500C6346818D88A7F32DEC88C1C4FE1BB03D7EF4ECBF28F76|7500005null|4040|122241|8|4090081000002C||0A82F2CFC403C1772B24D1B98851E7B4E64E18992C226CFBB52A49BD190B03D2DABB748E44CF5D5D|00000|2059||"//json[ContentRequestModelKeys.allDates].string
//        code          = json[ContentRequestModelKeys.code].string
//        authorization = "123465"//json[ContentRequestModelKeys.authorization].string
//        responseCode  = "00"//json[ContentRequestModelKeys.responseCode].string
//        capituloX     = json[ContentRequestModelKeys.capX].string
//        date          = json[ContentRequestModelKeys.date].string
//    }
    
    public required init(json: JSON) {
        allDates      = json[ContentRequestModelKeys.allDates].string
        code          = json[ContentRequestModelKeys.code].string
        authorization = json[ContentRequestModelKeys.authorization].string
        responseCode  = json[ContentRequestModelKeys.responseCode].string
        capituloX     = json[ContentRequestModelKeys.capX].string
        date          = json[ContentRequestModelKeys.date].string
    }
    func encode(with aCoder: NSCoder) {
    }
    
    required init?(coder aDecoder: NSCoder) {
    }
}
