//
//  LoginExtension.swift
//  iAcepta
//
//  Created by QUALITY on 6/7/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto

class LoginExtension {
    
    var arrayHex:[NSMutableString] = ["%00", "%01", "%02", "%03", "%04", "%05", "%06", "%07",
                                 "%08", "%09", "%0A", "%0B", "%0C", "%0D", "%0E", "%0F",
                                 "%10", "%11", "%12", "%13", "%14", "%15", "%16", "%17",
                                 "%18", "%19", "%1A", "%1B", "%1C", "%1D", "%1E", "%1F",
                                 "%20", "%21", "%22", "%23", "%24", "%25", "%26", "%27",
                                 "%28", "%29", "%2A", "%2B", "%2C", "%2D", "%2E", "%2F",
                                 "%30", "%31", "%32", "%33", "%34", "%35", "%36", "%37",
                                 "%38", "%39", "%3A", "%3B", "%3C", "%3D", "%3E", "%3F",
                                 "%40", "%41", "%42", "%43", "%44", "%45", "%46", "%47",
                                 "%48", "%49", "%4A", "%4B", "%4C", "%4D", "%4E", "%4F",
                                 "%50", "%51", "%52", "%53", "%54", "%55", "%56", "%57",
                                 "%58", "%59", "%5A", "%5B", "%5C", "%5D", "%5E", "%5F",
                                 "%60", "%61", "%62", "%63", "%64", "%65", "%66", "%67",
                                 "%68", "%69", "%6A", "%6B", "%6C", "%6D", "%6E", "%6F",
                                 "%70", "%71", "%72", "%73", "%74", "%75", "%76", "%77",
                                 "%78", "%79", "%7A", "%7B", "%7C", "%7D", "%7E", "%7F",
                                 "%80", "%81", "%82", "%83", "%84", "%85", "%86", "%87",
                                 "%88", "%89", "%8A", "%8B", "%8C", "%8D", "%8E", "%8F",
                                 "%90", "%91", "%92", "%93", "%94", "%95", "%96", "%97",
                                 "%98", "%99", "%9A", "%9B", "%9C", "%9D", "%9E", "%9F",
                                 "%A0", "%A1", "%A2", "%A3", "%A4", "%A5", "%A6", "%A7",
                                 "%A8", "%A9", "%AA", "%AB", "%AC", "%AD", "%AE", "%AF",
                                 "%B0", "%B1", "%B2", "%B3", "%B4", "%B5", "%B6", "%B7",
                                 "%B8", "%B9", "%BA", "%BB", "%BC", "%BD", "%BE", "%BF",
                                 "%C0", "%C1", "%C2", "%C3", "%C4", "%C5", "%C6", "%C7",
                                 "%C8", "%C9", "%CA", "%CB", "%CC", "%CD", "%CE", "%CF",
                                 "%D0", "%D1", "%D2", "%D3", "%D4", "%D5", "%D6", "%D7",
                                 "%D8", "%D9", "%DA", "%DB", "%DC", "%DD", "%DE", "%DF",
                                 "%E0", "%E1", "%E2", "%E3", "%E4", "%E5", "%E6", "%E7",
                                 "%E8", "%E9", "%EA", "%EB", "%EC", "%ED", "%EE", "%EF",
                                 "%F0", "%F1", "%F2", "%F3", "%F4", "%F5", "%F6", "%F7",
                                 "%F8", "%F9", "%FA", "%FB", "%FC", "%FD", "%FE", "%FF"]
    
    
    func ccSha256(data: Data) -> Data {
        var digest = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        
        _ = digest.withUnsafeMutableBytes { (digestBytes) in
            data.withUnsafeBytes { (stringBytes) in
                CC_SHA256(stringBytes, CC_LONG(data.count), digestBytes)
            }
        }
        return digest
    }
    
    func sha256String(_ str: String) -> String{
        let data = ccSha256(data: str.data(using: .utf8)!)
        let hexBytes = data.map { String(format: "%02hhx", $0) }.joined()
        return hexBytes.uppercased()
    }
    
    func generateNonce()->String{
        var bytes = [Int8](repeating: 0, count: 10)
        let status = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        let hexBytes = bytes.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
    
    func encodeUTF8(string:String) -> NSString {
        let newString = NSMutableAttributedString()
        let length = string.count
        
        for index in 0...length {
            if (index < length){
                let getPosition = string.index(string.startIndex, offsetBy: index)
                let lastChar: String = String(string[getPosition])
                let valueCharacter = lastChar.unicodeScalars.map { $0.value }.reduce(0, +)
                if ((Int(valueCharacter) >= Int(("A" as UnicodeScalar).value) && Int(valueCharacter) <= Int(("Z" as UnicodeScalar).value) )){
                    let attrString = NSAttributedString(string: lastChar)
                    newString.append(attrString)
                }else if ((Int(valueCharacter) >= Int(("a" as UnicodeScalar).value) && Int(valueCharacter) <= Int(("z" as UnicodeScalar).value) )){
                    let attrString = NSAttributedString(string: lastChar)
                    newString.append(attrString)
                }else if ((Int(valueCharacter) >= Int(("0" as UnicodeScalar).value) && Int(valueCharacter) <= Int(("9" as UnicodeScalar).value) )){
                    let attrString = NSAttributedString(string: lastChar)
                    newString.append(attrString)
                }else if (Int(valueCharacter) == Int((" " as UnicodeScalar).value)){
                    let attrString = NSAttributedString(string: "%20")
                    newString.append(attrString)
                }else if ( Int(valueCharacter) == Int(("-" as UnicodeScalar).value) || Int(valueCharacter) == Int(("_" as UnicodeScalar).value) || Int(valueCharacter) == Int(("." as UnicodeScalar).value) || Int(valueCharacter) == Int(("!" as UnicodeScalar).value) || Int(valueCharacter) == Int(("~" as UnicodeScalar).value) || Int(valueCharacter) == Int(("*" as UnicodeScalar).value) || Int(valueCharacter) == Int(("\"" as UnicodeScalar).value) || Int(valueCharacter) == Int(("(" as UnicodeScalar).value) || Int(valueCharacter) == Int((")" as UnicodeScalar).value)  ){
                    let attrString = NSAttributedString(string: lastChar)
                    newString.append(attrString)
                }else if (Int(valueCharacter) <= UnicodeScalar(0x007f)!.value){
                    let valueHex = NSMutableAttributedString(string: arrayHex[Int(valueCharacter)] as String)
                    newString.append(valueHex)
                }else if (Int(valueCharacter) <= UnicodeScalar(0x07FF)!.value){
                    let data = Data(lastChar.utf8)
                    let hexString = data.map{ String(format:"%02x", $0) }.joined()
                    let attrString = NSAttributedString(string: hexString)
                    newString.append(attrString)
                }
            }
            
        }
        return newString.string as NSString
    }
    func encryptMessage(message: String, encryptionKey: String) -> String {
        let messageData = message.data(using: .utf8)!
        let cipherData = RNCryptor.encrypt(data: messageData, withPaswd: encryptionKey)
        let c = cipherData.map { String(format: "%02hhx", $0) }.joined()
        return c.uppercased()
    }
}

extension String {
    func sha1() -> String {
        let data = Data(self.utf8)
        var digest = [UInt8](repeating: 0, count:Int(10))
        data.withUnsafeBytes {
            _ = CC_SHA1($0, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
    
    func hmac(key:String)-> String{
        let cKey = key.cString(using: String.Encoding.utf8)
        let cData = self.cString(using: String.Encoding.utf8)
        var result = [CUnsignedChar](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), cKey!, strlen(cKey!), cData!, strlen(cData!), &result)
        let hmacData:NSData = NSData(bytes: result, length: (Int(CC_SHA1_DIGEST_LENGTH)))
        let hmacBase64 = hmacData.base64EncodedData(options:NSData.Base64EncodingOptions.endLineWithLineFeed)
        let hexBytes = hmacBase64.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
    
    func hmacSha1(key: String) -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), key, key.count, self, self.count, &digest)
        let data = Data(bytes: digest)
        return data.base64EncodedString(options: .lineLength64Characters)
        //return data.map { String(format: "%02hhx", $0) }.joined()
    }
    
    /*func base64ToBase64url(base64: String) -> String {
        let base64url = base64
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\r", with: "")
        return base64url
    }*/

}
