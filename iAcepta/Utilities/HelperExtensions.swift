//
//  HelperExtensions.swift
//  iAcepta
//
//  Created by iOS_Dev on 2/1/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import UIKit

enum typeReader {
    case Walker
    case Verifone
}

class HelperExtensions {
    
    func setAnimation(textfiel:UITextField, view:UIView, timeDuration:Float){
        UIView.animate(withDuration: TimeInterval(timeDuration), animations: {
            textfiel.frame = CGRect(x: textfiel.frame.origin.x - view.bounds.size.width, y: textfiel.frame.origin.y, width: textfiel.bounds.size.width, height: textfiel.bounds.size.height)
        })
    }
    
    func setAnimation(button:UIButton, view:UIView, timeDuration:Float){
        UIView.animate(withDuration: TimeInterval(timeDuration), animations: {
            button.frame = CGRect(x: button.frame.origin.x - view.bounds.size.width, y: button.frame.origin.y, width: button.bounds.size.width, height: button.bounds.size.height)
        })
    }
    
    func setAnimation(label:UILabel, view:UIView, timeDuration:Float){
        UIView.animate(withDuration: TimeInterval(timeDuration), animations: {
            label.frame = CGRect(x: label.frame.origin.x-view.bounds.size.width, y: label.frame.origin.y, width: label.bounds.size.width, height: label.bounds.size.height)
        })
    }
    
    func setAnimationImg(img:UIImageView, view:UIView, timeDuration:Float, moveLogo:Int){
        UIView.animate(withDuration: TimeInterval(timeDuration), animations: {
            img.frame = CGRect(x: img.frame.origin.x, y: img.frame.origin.y + CGFloat(moveLogo), width: img.bounds.size.width, height: img.bounds.size.height)
        })
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat, view:UIView){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        view.frame = view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    func setFontText(string:String, color:String, nameFont:String, sizeFont:Float) -> NSAttributedString{
        let localizeString = string.localized
        let newColor = UIColor(hexString:color)
        let attributes = [NSAttributedString.Key.foregroundColor: newColor]
        
        let stringModi = NSAttributedString(string: localizeString,
                                            attributes: attributes)
        return stringModi
    }
    
    func isValidateEmail(email:String) ->Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailText = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailText.evaluate(with: email)
    }
    
    func getPercentage(amount:Float, percentage:Float) -> String {
        var resultPercentage:String = ""
        resultPercentage = "\(Double(amount * (percentage/100)))"
        return resultPercentage
    }
    
    func formatCurrency(format:String)-> String {
        var result:String = ""
        let formatter = NumberFormatter()
        let characterset = CharacterSet.decimalDigits.inverted
        
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_US")
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        formatter.groupingSize = 3
        
        if let newVal = Double(format) {
            result = formatter.string(from: NSNumber(value: newVal))!
        }
        
//        if !(result.rangeOfCharacter(from: characterset) != nil) {
//            result = String(format: "%@.00",result)
//        }
        
        let stringText:NSString = result as NSString
        let separatorRange : NSRange = stringText.range(of: "(?<=[.])\\d*$", options: .regularExpression)
        if (separatorRange.location == NSNotFound){
            result = String(format: "%@.00",result)
        }

//        while (result.count - separatorRange.location) < 2 {
//            result = String(format: "%@0",result)
//        }
        
        return result
    }
    
    func toDate(string: String) ->String {
        var milliseconds = Double(string)
       var date = Date(timeIntervalSince1970: (milliseconds! / 1000.0))
       let formatter = DateFormatter()
       formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let dS = formatter.string(from: date as Date)
        return dS
    }
    
    func containsOnlyLetters(input: String) -> Bool {
       for chr in input {
          if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
             return false
          }
       }
       return true
    }
    
    func random(digits:Int) -> String {
        var number = String()
        for _ in 1...digits {
           number += "\(Int.random(in: 1...9))"
        }
        return number
    }
    
    func typeCardLogo(typeCard:String) -> String{
        let typeCard = typeCard.replacingOccurrences(of: "F", with: "X")

        let visaType = "^4[0-9X]{12}(?:([0-9X]{3}|[0-9X]{6}))?$"
        let mastercardType = "^(?:5[1-5X][0-9X]{2}|222[1-9X]|22[3-9X][0-9X]|2[3-6][0-9X]{2}|27[01][0-9X]|2720)[0-9X]{12}$"
        let maestroType = "^(?:5[0678][0-9X][0-9X]|6304|6390|67[0-9X][0-9X])[0-9X]{8,15}$"
        let americanType = "^3[467][0-9X]{12,14}$"
        let dinersType = "^3(?:0[0-5X]|[68][0-9X])([0-9X]{11}|[0-9X]{16})$"
        let discoverType = "^6(?:011[0-9X]{12}|5[0-9X]{14}|4[4-9][0-9X]{13}|22(?:1(?:2[6-9]|[3-9][0-9])|[2-8][0-9]{2}|9(?:[01][0-9]|2[0-5]))[0-9X]{10})$"
        let JBCType = "^(?:2131|1800|35[0-9X]{3})[0-9X]{11}$"
          
        if typeCard.range(of: visaType, options: .regularExpression) != nil{
            return "Visa"
        }
        if typeCard.range(of: mastercardType, options: .regularExpression) != nil{
            return "MasterCard"
        }
        if typeCard.range(of: maestroType, options: .regularExpression) != nil{
            return "Maestro"
        }
        if typeCard.range(of: dinersType, options: .regularExpression) != nil{
            return "Diners"
        }
        if typeCard.range(of: americanType, options: .regularExpression) != nil{
            return "Amex"
        }
        if typeCard.range(of: JBCType, options: .regularExpression) != nil{
            return "JBC"
        }
        if typeCard.range(of: discoverType, options: .regularExpression) != nil{
            return "Discovery"
        }
        return "Unknow"
    }
    func CardNumberFormat(string:String) -> String{
        let CardNumber = string
        guard CardNumber.count > 5 else {
            fatalError("The NumberCard is incomplete")
        }
        let startingIndex = CardNumber.index(CardNumber.startIndex, offsetBy: 0)
        let endingIndex = CardNumber.index(CardNumber.endIndex, offsetBy: -4)
        let stars = String(repeating: "*", count: CardNumber.count - 5)
        let result = CardNumber.replacingCharacters(in: startingIndex..<endingIndex,
                with: stars)
        return result
    }
    func new (format:String)->String{
        var result:String = ""
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_US")
        formatter.maximumFractionDigits = 2
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        formatter.groupingSize = 3
        
        if let newVal = Double(format){
            result = formatter.string(from: NSNumber(value: newVal))!
        }
        return result
    }
    
    func dateInFormat(stringFormat:String) -> String{
        let bufferSize = 255
        var buffer = [CChar](repeating: 0, count: Int(bufferSize))
        var timeValue = time(nil)
        let tmValue = localtime(&timeValue)
        
        strftime(&buffer, bufferSize, stringFormat, tmValue)
        let dateFormat = String(cString: buffer, encoding: String.Encoding.utf8)!
        
        return dateFormat
    }
    
    func  convertImageToBase64String(image : UIImage ) -> String{
        let strBase64 =  image.pngData()?.base64EncodedString()
        return strBase64!
    }
    
    func convertToBase64(image: UIImage) -> String {
        return image.pngData()!
            .base64EncodedString()
    }
    
    
    
    func imageRepresentation(view:UIView)->UIImage{
        let rect:CGRect = view.bounds
        UIGraphicsBeginImageContext(rect.size)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        view.layer.render(in: context)
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img
    }
    
    func loadImage(name:String) -> UIImage?{
//        var image = UIImage()
//        let file = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(name)
//        image = UIImage(contentsOfFile: file.path)!
//        return image
        var image:UIImage?
        let file = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(name)
        image = UIImage(contentsOfFile: file.path)
        return image
    }
    
    
    
    func hexToStr(text: String) -> String {
        let regex = try! NSRegularExpression(pattern: "(0x)?([0-9A-Fa-f]{2})", options: .caseInsensitive)
        let textNS = text as NSString
        let matchesArray = regex.matches(in: textNS as String, options: [], range: NSMakeRange(0, textNS.length))
        let characters = matchesArray.map {
            Character(UnicodeScalar(UInt32(textNS.substring(with: $0.range(at: 2)), radix: 16)!)!)
        }
        return String(characters)
    }
    
    func isEntryMode(string:String) -> NSDictionary{
        do{
            let regexChip = try NSRegularExpression(pattern: "\\b(0)(5)(0|1|2|3|4|5|6|7|8|9)\\b", options: NSRegularExpression.Options.caseInsensitive)
            let regexSwipe = try NSRegularExpression(pattern: "\\b(9)(0)(0|1|2|3|4|5|6|7|8|9)\\b", options: NSRegularExpression.Options.caseInsensitive)
            let regexFallback = try NSRegularExpression(pattern: "\\b(8)(0)(0|1|2|3|4|5|6|7|8|9)\\b", options: NSRegularExpression.Options.caseInsensitive)
            let regexContactless = try NSRegularExpression(pattern: "\\b(0)(7)(0|1|2|3|4|5|6|7|8|9)\\b", options: NSRegularExpression.Options.caseInsensitive)
            
            let numberOfMatchesChip = regexChip.numberOfMatches(in: string, options: [], range: NSMakeRange(0, string.utf16.count))
            let numberOfMatchesSwipe = regexSwipe.numberOfMatches(in: string, options: [], range: NSMakeRange(0, string.utf16.count))
            let numberOfMatchesFallback = regexFallback.numberOfMatches(in: string, options: [], range: NSMakeRange(0, string.utf16.count))
            let numberOfMatchesContacless = regexContactless.numberOfMatches(in: string, options: [], range: NSMakeRange(0, string.utf16.count))
            
            var posEntryMode:String = ""
            var isEntryModeReader:String = ""
            
            if (numberOfMatchesChip == 1){
                isEntryModeReader = "Chip"
                posEntryMode = Constants.POSENTRYMODE_VERIFONE
            }else if (numberOfMatchesSwipe == 1){
                isEntryModeReader = "Banda"
                posEntryMode = Constants.POSENTRYMODE_VERIFONE_SWIPE
            }else if (numberOfMatchesFallback == 1){
                isEntryModeReader = "Banda"
                posEntryMode = Constants.POSENTRYMODE_VERIFONE_FALLBACK
            }else if (numberOfMatchesContacless == 1){
                isEntryModeReader = "Chip"
                posEntryMode = Constants.POSENTRYMODE_VERIFONE_CONTACTLESS
            }
            
            return ["postEntryMode":posEntryMode, "isEntryModeReader":isEntryModeReader]
            
        }catch{
            
        }
        return [:]
    }
}

private var kAssociationKeyMaxLength: Int = 0
extension UITextField {
    
    enum paddingImage {
        case username
        case password
        case amount
        case disabled
    }
    
    enum textFieldLayout {
        case login
        case inputValue
    }
    
    func setLayoutFromTextField(textField:UITextField,type:textFieldLayout,imageType:paddingImage){
        switch type {
        case .login:
            self.setTextFieldLayout(textField: textField)
            self.setImagePaddLayout(textField: textField, imageType: imageType)
            break
        case .inputValue:
            switch imageType{
            case .amount:
                self.setTransactionTextFieldLayout(textField: textField)
                self.setImagePaddLayout(textField: textField, imageType: imageType)
                break
            case .password:
                break
            case .username:
                break
            case .disabled:
                self.setTransactionTextFieldLayout(textField: textField)
                break
            }
            break
            
        }
    }
    
    func setTextFieldLayout(textField:UITextField){
        textField.layer.cornerRadius = textField.frame.size.height/3
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.backgroundColor = UIColor(hexString:"#00286E")
        textField.backgroundColor = UIColor(red: 0, green: 40.0/255.0, blue: 110.0/255.0, alpha: 0.2)
    }
    
    func setImagePaddLayout(textField:UITextField,imageType:paddingImage){
        var image = UIImage()
        var containerLeft = UIView()
        var imageView = UIImageView()
        textField.leftViewMode = UITextField.ViewMode.always
        textField.rightViewMode = UITextField.ViewMode.always
        
        switch imageType {
        case .username:
            image = UIImage(named:"usuario")!
            containerLeft = UIView(frame: CGRect(x: 0, y: 0, width: textField.frame.size.height * 1.1, height: textField.frame.size.height * 0.9))
            containerLeft.backgroundColor = UIColor.clear
            imageView = UIImageView(frame: CGRect(x: textField.frame.size.height/3, y: 0, width: textField.frame.size.height * 0.6, height: textField.frame.size.height * 0.8))
            break
        case .password:
            image = UIImage(named:"password")!
            containerLeft = UIView(frame: CGRect(x: 0, y: 0, width: textField.frame.size.height * 1.1, height: textField.frame.size.height * 0.9))
            containerLeft.backgroundColor = UIColor.clear
            imageView = UIImageView(frame: CGRect(x: textField.frame.size.height/3, y: 0, width: textField.frame.size.height * 0.6, height: textField.frame.size.height * 0.8))
            break
        case .amount:
            image = UIImage(named:"sign_amount")!
            containerLeft = UIView(frame: CGRect(x: 0, y: 0, width: textField.frame.size.height * 0.7, height: textField.frame.size.height * 0.9))
            containerLeft.backgroundColor = UIColor.clear
            imageView = UIImageView(frame: CGRect(x: textField.frame.size.height/8, y: textField.frame.size.height/7, width: textField.frame.size.height * 0.6, height: textField.frame.size.height * 0.8))
            break
        case .disabled:
            break
        }
        let containerRight = UIView(frame: CGRect(x: 0, y: 0, width: textField.frame.size.height/5, height: textField.frame.size.height))
        containerRight.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        containerLeft.addSubview(imageView)
        textField.leftView  = containerLeft
        textField.rightView = containerRight
        
    }
    
    func setTransactionTextFieldLayout(textField:UITextField){
        textField.layer.cornerRadius = textField.frame.size.height/3
        textField.backgroundColor    = UIColor.white
//        textField.addToolbar(textField: textField)
        
    }
    
    func setCornerRadious(textfield:UITextField){
        textfield.layer.cornerRadius = textfield.frame.size.height/3
    }
    
    func addToolbar(textField:UITextField){
        let bar = UIToolbar()
        let reset = UIBarButtonItem(title: "Aceptar", style: .plain, target: self, action: #selector(doneTapped))
        reset.tintColor = .black
        bar.items = [reset]
        bar.barStyle = UIBarStyle.default
        bar.sizeToFit()
        textField.inputAccessoryView = bar
    }
    
    @objc func doneTapped()  {
        self.resignFirstResponder()
    }
    
    
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text,
            prospectiveText.count > maxLength
            else {
                return
        }
        
        let selection = selectedTextRange
        let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        text = String (prospectiveText.prefix(upTo: maxCharIndex))
        selectedTextRange = selection
    }
    
    func calculateExt(range:NSRange, string:String) -> Bool{
        if string.count == 0{
            return true;
        }
        
        let result = NSString(string: self.text!).replacingCharacters(in: range, with: string)
        let numbers:String = "0123456789"//0123456789
        let numbersPeriod:String = "01234567890."//01234567890
        let numbersComma:String = "0123456789,"//0123456789
        
        if (range.length > 0 && string.count == 0){
            return true
        }
        
        let symbol:String = Locale.current.decimalSeparator!
        
        if ((range.location == 0) && (string == symbol)){
            return false
        }
        
        let stringText:NSString = self.text! as NSString
        let characterSet = NSMutableCharacterSet()
        
        let separatorRange : NSRange = stringText.range(of: "(?<=[.])\\d*$", options: .regularExpression)
        if separatorRange.location == NSNotFound{
            if (symbol == "."){
                characterSet.addCharacters(in: numbersPeriod)
            }else{
                characterSet.addCharacters(in: numbersComma)
            }
        }else{
            if (range.location > (separatorRange.location + 1)){
                return false
            }
            characterSet.addCharacters(in: numbers)
        }
        
        let trimmedString = string.trimmingCharacters(in: characterSet.inverted as CharacterSet)
        
        return (trimmedString.count > 0 && !(result.count > 13))
    }
    
    func calculeNumbersLettersNoPoint(range:NSRange, string:String) -> Bool{
        let alphaNumericRegEx = "[a-zA-Z0-9]"
        let predicate = NSPredicate(format:"SELF MATCHES %@", alphaNumericRegEx)
        return predicate.evaluate(with: string)
    }
    
    func setIcon(_ image: UIImage,textField:UITextField) {
    
       let iconView = UIImageView(frame: CGRect(x: textField.frame.size.height/8, y: textField.frame.size.height/7, width: textField.frame.size.height * 0.4, height: textField.frame.size.height * 0.8))
       iconView.image = image
        
        let iconContainerView =  UIView(frame: CGRect(x: 0, y: 0, width: textField.frame.size.height * 0.7, height: textField.frame.size.height * 0.9))
       iconContainerView.addSubview(iconView)
       leftView = iconContainerView
       leftViewMode = .always
    }
}

extension UIButton{
    func setRoundedLayout(button:UIButton){
        button.layer.cornerRadius = button.frame.size.height/3
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment:"")
    }
    
    var hexadecimal: Data? {
        var data = Data(capacity: self.count / 2)
        
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSRange(startIndex..., in: self)) { match, _, _ in
            let byteString = (self as NSString).substring(with: match!.range)
            let num = UInt8(byteString, radix: 16)!
            data.append(num)
        }
        
        guard data.count > 0 else { return nil }
        
        return data
    }
    //func typeCard(card:String) -> String{
//    var typeCard : String {
//        let visaType:String = "^4[0-9X]{12}(?:[0-9X]{3})?$"
//        let mastercardType:String = "^5[1-5X][0-9X]{14}$"
//        let americanType:String = "^3[467][0-9X]{12,14}$"
//        
//        let cardMatch = NSPredicate(format: "SELF MATCHES %@", visaType)
//        if (cardMatch.evaluate(with: self)){
//            return "Visa"
//        }else{
//            let cardMatch = NSPredicate(format: "SELF MATCHES %@", mastercardType)
//            if cardMatch.evaluate(with: self){
//                return "Mastercard"
//            }else{
//                let cardMatch = NSPredicate(format: "SELF MATCHES %@", americanType)
//                if cardMatch.evaluate(with: self){
//                    return "Amex"
//                }else{
//                    return "Unknow"
//                }
//            }
//        }
//    }
    func typeCardNew(typeReader:typeReader) -> String{
        let endCard = self.trimmingCharacters(in: .whitespaces)
        var visaType:String = ""
        var mastercardType:String = ""
        var americanType:String = ""
        
        switch typeReader {
        case .Walker:
            visaType = "^4[0-9X]{12}(?:[0-9X]{3})?$"
            mastercardType = "^5[1-5X][0-9X]{14}$"
            americanType = "^3[467][0-9X]{12,14}$"
        default:
            visaType = "^4[0-9]{12}(?:[0-9]{3})?$"
            mastercardType = "^(?:5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)[0-9]{12}$"
            americanType = "^3[47][0-9]{13}$"
        }
        
        let cardVisa = NSPredicate(format: "SELF MATCHES %@", visaType)
        let cardMastercar = NSPredicate(format: "SELF MATCHES %@", mastercardType)
        let cardAmex = NSPredicate(format: "SELF MATCHES %@", americanType)
        
        if (cardVisa.evaluate(with: endCard)){
            return "Visa"
        }else if cardMastercar.evaluate(with: endCard){
            return "Mastercard"
        }else if cardAmex.evaluate(with: endCard){
            return "Amex"
        }else{
            return "Unknow"
        }
    }
    //ToDo Remover Esto sino funciona
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    
    
    func dropLastWhileLetter() -> String {
        var count = 0
        for  char in self.unicodeScalars.reversed(){
            if CharacterSet.letters.contains(char) {
                count += 1
            } else {
                break
            }
        }
        return  String(self.dropLast(count))
    }
}

extension String {
    var bool: Bool? {
        switch self.lowercased() {
        case "true", "t", "yes", "y", "1":
            return true
        case "false", "f", "no", "n", "0":
            return false
        default:
            return nil
        }
    }
}
extension String{
    
    func currency() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en_MX")
        formatter.currencySymbol = "$"
        let digits = NSDecimalNumber(string: sanitized())
        let place = NSDecimalNumber(value: powf(10, 2))
        return formatter.string(from: digits.dividing(by: place))
    }
    
    func sanitized() -> String {
        return filter { "01234567890".contains($0) }
    }
}
extension UILabel {
    func labelSize(label:UILabel,lblText:String,lblSize:CGFloat,nameFont:String){
        label.text = lblText.localized
        label.font = UIFont(name:nameFont, size: lblSize)
        label.adjustsFontSizeToFitWidth = true;
        label.sizeToFit()
    }
}

extension UIView{
    func adjustView(view:UIView, shadowOpacity:CGFloat, shadowRadius:CGFloat, cornerRadius: CGFloat, borderWidth:CGFloat, colorBorder:String){
        view.layer.shadowOpacity = Float(shadowOpacity)
        view.layer.shadowRadius = shadowRadius
        view.layer.cornerRadius = cornerRadius
        //view.layer.borderWidth = borderWidth
        view.layer.borderColor = UIColor(hexString:colorBorder).cgColor
    }
    func createDashedLine(startPoint:CGPoint, endPoint:CGPoint, colorLine:String) {
        let line = CAShapeLayer()
        let path = CGMutablePath()
        path.addLines(between: [startPoint, endPoint])
        line.lineWidth = 2
        line.path = path
        line.strokeColor = UIColor(hexString:colorLine).cgColor
        line.fillColor = UIColor.lightGray.cgColor
        line.lineDashPattern = [4, 6]
        layer.addSublayer(line)
    }
}

enum StoryBoard:String {
    
    case spinner  = "loaderViewController"

    
    func name() -> String {
        return self.rawValue
    }
}

extension UIStoryboard {
    static func overFullScreen(type:StoryBoard) -> UIViewController {
        let vc = UIStoryboard(name: type.name(), bundle: nil).instantiateInitialViewController()!
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }
}

extension UIProgressView{
    func setAdjustProgress (progress:UIProgressView,colorImg:String, cornerRadious:CGFloat){
        progress.progressImage = UIImage(named: colorImg)
        progress.trackTintColor = UIColor.white
        progress.layer.cornerRadius = cornerRadious/2
        progress.clipsToBounds = true
        progress.layer.sublayers![1].cornerRadius = cornerRadious/2
        progress.subviews[1].clipsToBounds = true
    }
}

extension Data{
    
    struct HexEncodingOptions:OptionSet {
        let rawValue:Int
        static let uppercase = HexEncodingOptions(rawValue: 1 << 0)
    }
    
    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.uppercase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}

extension Date{
    static func toDayString() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.string(from: Date())
    }
    static func toDayStringFormat() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM, yy"
        return formatter.string(from: Date())
    }
    
    static func toHour() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
    }
}

extension UIImage{
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

extension UIImageView{
     //Function MARK: Loader
    func startLoader(image: UIImageView){
            var imgArray:[UIImage] = []
            if let nameImg = UIImage(named: "loader_ft1"){
                imgArray.append(nameImg)
            }
            if let nameImg2 = UIImage(named: "loader_ft2"){
                imgArray.append(nameImg2)
            }
            if let nameImg3 = UIImage(named: "loader_ft3"){
                imgArray.append(nameImg3)
            }
            if let nameImg4 = UIImage(named: "loader_ft4"){
                imgArray.append(nameImg4)
            }
            if let nameImg5 = UIImage(named: "loader_ft5"){
                imgArray.append(nameImg5)
            }
            if let nameImg6 = UIImage(named: "loader_ft6"){
                imgArray.append(nameImg6)
            }
            if let nameImg7 = UIImage(named: "loader_ft7"){
                imgArray.append(nameImg7)
            }
            image.animationImages = imgArray
            image.animationDuration = 0.75
            image.isHidden = false
            image.startAnimating()
        }
}
extension CharacterSet {

    static var urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: generalDelimitersToEncode + subDelimitersToEncode)

        return allowed
    }()

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
