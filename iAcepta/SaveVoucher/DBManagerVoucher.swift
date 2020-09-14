//
//  DBManagerVoucher.swift
//  iAcepta
//
//  Created by QUALITY on 7/15/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import RealmSwift

class DBManagerVoucher {
    
    private var database:Realm
    static let sharedInstance = DBManagerVoucher()
    
    private init() {
        database = try! Realm()
    }
    
    func getDataFromDB() -> Results<SaveVoucher> {
        let results: Results<SaveVoucher> = database.objects(SaveVoucher.self)
        return results
    }
    
    func getVoucherCodiActive(_ result: @escaping (Result<SaveVoucher?,Error>)->Void){
        
        let users = Array(database.objects(SaveVoucher.self)).filter({$0.codi})
        if users.count > 0 {
            result(.success(users.first))
            return
        }else {
            let error = NSError(domain:"", code:499, userInfo:[ NSLocalizedDescriptionKey:"No hay vouchers disponibles."])
            result(.failure(error))
            return
        }
    }
    
    func updateValue(value:Int, sign:Data){
        let value = database.objects(SaveVoucher.self).filter("voucherIAcepta == \(value)").first
        try! database.write {
            value?.signature = sign
        }
    }
    
    func addData(object: SaveVoucher) {
        try! database.write {
            database.add(object)
        }
    }
    
    func addDataSafe(object: Object, _ completion: @escaping ()->Void ) {
        try! database.write {
            database.add(object)
            completion()
        }
    }
    
    func addDataCodi(object: codiWalletResquest) {
        try! database.write {
            database.add(object)
        }
    }
    
    func deleteAllDatabase()  {
        try! database.write {
            database.deleteAll()
        }
    }
    
    func deleteFromDb(object: SaveVoucher) {
        try! database.write {
            database.delete(object)
        }
    }
    
    
    func deleteUserFromDb(object: Object, _ completion: @escaping ()->Void ) {
        try! database.safeWrite {
            database.delete(object)
            completion()
        }
    }
    
}

extension Realm {
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}
