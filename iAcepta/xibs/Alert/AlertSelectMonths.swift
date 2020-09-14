//
//  AlertSelectMonths.swift
//  iAcepta
//
//  Created by QUALITY on 5/29/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

protocol selectMonthsDelegate: AnyObject {
    func changeValues(value:Double, txtSelect:String, calculeTip:Bool,porcent:Double)
}

class AlertSelectMonths: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var btnAcept: UIButton!
        {didSet{btnAcept.setRoundedLayout(button: btnAcept)}}
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var msjAlertLabel: UILabel!
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var viewAlert: UIView!{didSet{viewAlert.adjustView(view: viewAlert, shadowOpacity: 0.5, shadowRadius: 5.0, cornerRadius: 30, borderWidth: 1, colorBorder: "003C64")}}
    @IBOutlet weak var percentageAmountTextfield: UITextField!{didSet{percentageAmountTextfield.setLayoutFromTextField(textField: percentageAmountTextfield, type: .inputValue, imageType: .amount)
//        percentageAmountTextfield.addToolbar(textField: percentageAmountTextfield)
        }}
    @IBOutlet weak var amountTipLabel: UILabel!

    
    weak var delegateMoths: selectMonthsDelegate?
    var circularSlider = CircularSlider()
    var helperExt = HelperExtensions()
    
    var alertTitle = String()
    var alertBody = String()
    var alertBtnTitle = String()
    var typeActionBnt = String()
    
    var amount = String()
    var newRoudedPercent:Double = 0.0
    var roudedPercent:Double = 0.0
    var calculeTip:Bool = false
    var modifyTextfield:Bool = false
    
    var newRouded:Double = 0.0

    
    var sia : SessionIAcepta?
    
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintWidth: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let text = percentageAmountTextfield.text, text.isEmpty {
            percentageAmountTextfield.text = "0"
        }
        // init slider view
        let frame = CGRect(x: 0, y: 0, width: sliderView.frame.width, height: sliderView.frame.height)
        //let
        circularSlider = CircularSlider(frame: frame)
        let myColor = UIColor.gray
        percentageAmountTextfield.layer.borderColor = myColor.cgColor
        percentageAmountTextfield.layer.borderWidth = 1.0
//        let imageView = UIImageView()
//        let image = UIImage(named: "sign_amount")
//        imageView.image = image
//        percentageAmountTextfield.leftView = imageView
//        percentageAmountTextfield.leftViewMode = UITextField.ViewMode.always

        
        // setup slider defaults
        circularSlider.handleType = .bigCircle
        circularSlider.minimumValue = 0
        circularSlider.lineWidth = 20
        circularSlider.filledColor = UIColor.clear
        circularSlider.unfilledColor = UIColor.clear
        
        
        
        if (typeActionBnt == Constants.tip){
            circularSlider.typeImage = .Propina
            percentageAmountTextfield.delegate = self
            percentageLabel.text = "0%"
            calculeTip = true
            amountTipLabel.text = "text_enter_tip_amount".localized
            circularSlider.maximumValue = 25
            if roudedPercent != 0.0{
                let intText = Float(roudedPercent)
                let operation:Double = Double((100 * intText) / Float(amount.replacingOccurrences(of: ",", with: ""))!)
                let aux:Double = round(operation)
                newRoudedPercent = aux
                circularSlider.minimumValue = 0
                if Float(operation) < 25{
                    circularSlider.maximumValue = 25
                }else{
                    circularSlider.maximumValue = Float(operation+1)
                }
                percentageLabel.text = "\(Int(newRoudedPercent)) %"
                percentageAmountTextfield.text = String(roudedPercent)
                circularSlider.currentValue = Float(operation)
            }
        }else if (typeActionBnt == Constants.mounthsWithoutInterest){
            percentageLabel.text = "0"
            calculeTip = false
            if let sessionIAcepta = sessionGlob.Static.sessionIAcepta{
                sia = sessionIAcepta
                circularSlider.maximumValue = Float((sia?.rangeMsi?.count)!) - 1
            }
            if roudedPercent != 0.0{
                let valueForArray = Int(roudedPercent)
                if let arrayMsi :NSArray = sia?.rangeMsi as NSArray?{
                    let getPositionArray = arrayMsi.index(of: "\(valueForArray)")
                    let valMsi = sia?.rangeMsi![getPositionArray]
                    percentageLabel.text = String(describing: valMsi!)
                    circularSlider.currentValue = Float(getPositionArray)
                }
            }
            circularSlider.typeImage = .Meses
            percentageAmountTextfield.isHidden = true
            amountTipLabel.isHidden = true
        }
        // setup target to watch for value change
        circularSlider.addTarget(self, action: #selector(CircleSliderViewController.valueChanged(_:)), for: UIControl.Event.valueChanged)
        percentageAmountTextfield.addTarget(self, action: #selector(AlertSelectMonths.textFieldDidChangeEdit(_:)), for: UIControl.Event.editingChanged)
        // add to view
        sliderView.addSubview(circularSlider)
        msjAlertLabel.text = alertBody.localized
//        btnAcept.setTitle(alertBtnTitle.localized, for: .normal)
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
//        view.addGestureRecognizer(tap)
        
        if (UIDevice.current.userInterfaceIdiom == .pad){
            isiPad()
        }
        
    }
    

    func isiPad(){
        DispatchQueue.main.async {
            self.constraintHeight.constant = 450
            self.constraintWidth.constant = 300
            self.viewAlert.layoutIfNeeded()
        }
    }
    
    // Function MARK: Notifiers
    @objc func valueChanged(_ slider: CircularSlider) {
        
        var newVal:Double = 0.0;
        newVal = Double(slider.currentValue)
        let aux1:Double =  round(newVal)

           newRoudedPercent = aux1

        if (typeActionBnt == Constants.tip){
            
            if (modifyTextfield == false){
                percentageLabel.text = "\(Int(newRoudedPercent)) %"
                self.calculateGetPercentage()
            }else{
                if newRoudedPercent < 100.0{
                    percentageLabel.text = "\(newRoudedPercent) %"
                }else{
                  percentageLabel.text = "0.0 %"
                }
                
            }
            calculeTip = true
        }else if (typeActionBnt == Constants.mounthsWithoutInterest){
            let valueForArray = Int(newRoudedPercent)
            if (sia?.rangeMsi != nil){
                let valueMSI = sia?.rangeMsi![valueForArray]
                percentageLabel.text = String(describing: valueMSI!)
            }
            calculeTip = false
        }
  
    }
    
    
    @objc func textFieldDidChangeEdit(_ textField: UITextField) {
        let text = Int(textField.text ?? "")
        let val = 0.0
        let IntAmount = Int(amount.replacingOccurrences(of: ",", with: "")) ?? 0
            let intText = Float(text ?? Int(val))
                let operation = (100 * intText) / Float(amount.replacingOccurrences(of: ",", with: ""))!
                let valor = Double(operation)
                let aux:Double = round(valor)
                newRouded = valor
                percentageLabel.text = "\(Int(aux)) %"
            circularSlider.minimumValue = 0
            if Float(operation) < 25{
                circularSlider.maximumValue = 25
            }else{
                circularSlider.maximumValue = Float(operation+1)
            }
            circularSlider.currentValue = Float(operation)
        
//      }  else {
//            self.percentageLabel.text = "\(0) %"
//            self.circularSlider.minimumValue = 0
//            if Float(0) < 25{
//                self.circularSlider.maximumValue = 25
//            }else{
//                self.circularSlider.maximumValue = Float(newRouded+1)
//            }
//            self.circularSlider.currentValue = Float(newRouded)
//        }
    }
    

    
    // Function MARK: Buttons
    @IBAction func aceptAction(_ sender: Any) {
        if percentageAmountTextfield.text == nil{
            dismiss(animated: true, completion: nil)
            return
        }
            if calculeTip == true {
                var percentageString:String = percentageAmountTextfield.text!.replacingOccurrences(of: ",", with: "")
                if(percentageString.isEmpty){
                    percentageString = "0.00"
                }
                if let percentageDouble = Double(percentageString) {
                    let dbAmount = Double(amount.replacingOccurrences(of: ",", with: "")) ?? 0
                    if percentageDouble >= dbAmount {
                        let alert = UIAlertController(title: "", message: "La propina no puede ser mayor que el importe.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { (action) in
                            
                        }))
                        
                        self.present(alert, animated: true) {}
                    } else {
                        delegateMoths?.changeValues(value: percentageDouble, txtSelect: typeActionBnt, calculeTip: calculeTip, porcent: newRoudedPercent)
                        dismiss(animated: true, completion: nil)
                    }
                    
                }
            }else{
                if let resultMsi = Double(percentageLabel.text!){
                    delegateMoths?.changeValues(value: resultMsi, txtSelect: typeActionBnt, calculeTip: calculeTip, porcent: 0.0)
                    dismiss(animated: true, completion: nil)
                }
            }
        
    }
    
    @objc func DismissKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func returnAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //Mark : Delegate Txtfield
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let text = textField.text else {return}
        if Int(text) ?? 0 >= Int(amount) ?? 0 {
            let alert = UIAlertController(title: "", message: "La propina no puede ser mayor que el importe.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { (action) in
                self.newRoudedPercent = 0.0
            }))

            self.present(alert, animated: true) {}
        }else{
        if(textField == percentageAmountTextfield){
            if percentageAmountTextfield.text == ""{
                circularSlider.minimumValue = 0
                circularSlider.maximumValue = 25
            }else{
                let intText = Float(textField.text!)
                let operation = (100 * intText!) / Float(amount.replacingOccurrences(of: ",", with: ""))!
                circularSlider.minimumValue = 0
                circularSlider.maximumValue = Float(operation+5)
                
                percentageLabel.text = String(operation)
                circularSlider.currentValue = Float(operation)
                
            }
            if (modifyTextfield) {
                modifyTextfield = false
                calculeTip = true
            }
        }
        }
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if(textField == percentageAmountTextfield){
            modifyTextfield = true
            //return textField.calculateExt(range: range, string: string)
            let newString = string.replacingOccurrences(of: ",", with: ".")
            let texBool:Bool = textField.calculateExt(range: range, string: newString)
            if texBool{
                return texBool
            }else{
                if (textField.text!.contains(".")){
                    return false
                }
                if newString == "."{
                    let resultTextfield = String(format: "%@%@", textField.text! , newString)
                    textField.text = resultTextfield
                    return false
                }
            }
        }
        return true
    }
    
    func calculateGetPercentage(){
        let totalAmount:String = amount.replacingOccurrences(of: ",", with: "")
        if let floatAmount = Float(totalAmount){
            let tipValue = helperExt.getPercentage(amount: floatAmount, percentage: Float(newRoudedPercent))
            percentageAmountTextfield.text = helperExt.formatCurrency(format: tipValue)
        }
    }
}
