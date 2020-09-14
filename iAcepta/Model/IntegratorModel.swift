//
//  IntegratorModel.swift
//  iAcepta
//
//  Created by QUALITY on 8/13/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import SwiftyJSON

class IntegratorModel: NSObject, NSCoding {
    
    var name: String?
    var password: String?
    var typeTransfers: String?
    var stringReverse: String?
    var infoExtra: String?
    var externo:Bool?
    
    init(name: String? = nil, password: String? = nil, typeTransfers: String?=nil, stringReverse: String? = nil, infoExtra: String? = nil, externo: Bool? = false) {
        self.name = name
        self.password = password
        self.typeTransfers = typeTransfers
        self.stringReverse = stringReverse
        self.infoExtra = infoExtra
        self.externo = externo
    }
    
    func encode(with aCoder: NSCoder) {
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
    }
    
}
