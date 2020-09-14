//
//  SelectMonthsViewController.swift
//  iAcepta
//
//  Created by QUALITY on 5/28/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import UIKit


protocol valueSelectMonthsDelegate: AnyObject {
    func changeValues(value:String)
}

class SelectMonthsViewController: UIViewController {
    
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var btnContinue: UIButton!{didSet{btnContinue.setRoundedLayout(button: btnContinue)}}
    @IBOutlet weak var viewAlert: UIView!{didSet{viewAlert.adjustView(view: viewAlert, shadowOpacity: 0.5, shadowRadius: 5.0, cornerRadius: 30, borderWidth: 1, colorBorder: "003C64")}}
    
    @IBOutlet weak var percentageLabel: UILabel!
    
    
    weak var delegateMoths: valueSelectMonthsDelegate?
    
    
    var alertTitle = String()
    var alertBody = String()
    var alertBtnTitle = String()
    var typeActionBnt = String()
    var valueBtn:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init slider view
        let frame = CGRect(x: 0, y: 0, width: sliderView.frame.width, height: sliderView.frame.height)
        let circularSlider = CircularSlider(frame: frame)
        
        // setup slider defaults
        circularSlider.handleType = .bigCircle
        circularSlider.minimumValue = 0
        circularSlider.maximumValue = 18
        circularSlider.lineWidth = 20
        circularSlider.filledColor = UIColor.clear
        circularSlider.unfilledColor = UIColor.clear
        circularSlider.typeImage = .Propina
        
        // setup target to watch for value change
        circularSlider.addTarget(self, action: #selector(CircleSliderViewController.valueChanged(_:)), for: UIControl.Event.valueChanged)
        
        // add to view
        sliderView.addSubview(circularSlider)
        
        //headeriAcepta
        /*headeriAcepta.lblTitle.text = "Pagos"
        headeriAcepta.btnHome.isHidden = true*/
        
    }
    
    @objc func valueChanged(_ slider: CircularSlider) {
        percentageLabel.text = "\(slider.currentValue)"
    }
    
    @IBAction func btnAction(_ sender: Any) {
        delegateMoths?.changeValues(value: percentageLabel.text!)
        dismiss(animated: true, completion: nil)
    }
}
