//
//  SaveVocuher.swift
//  iAcepta
//
//  Created by QUALITY on 7/15/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class SaveVoucher: Object {
    
    @objc dynamic var voucherIAcepta = 0
    @objc dynamic var userNameVoucher = ""
    @objc dynamic var idUserVoucher = ""
    @objc dynamic var dateVoucher: Data? = nil
    @objc dynamic var hasNip:Bool = false
    @objc dynamic var codi:Bool = false
    @objc dynamic var signature: Data? = nil
    
    override static func primaryKey() -> String? {
        return "voucherIAcepta"
    }
    
}
