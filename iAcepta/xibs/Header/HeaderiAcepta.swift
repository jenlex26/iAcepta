//
//  HeaderiAcepta.swift
//  iAcepta
//
//  Created by QUALITY on 5/23/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import UIKit

protocol headerActoionDelegate: AnyObject {
    func btnInfo()
    func btnHome()
}

@IBDesignable class headeriAcepta: UIView {
    let nibName = "HeaderiAcepta"
    var contentView:UIView?
    var contentName:String = ""
    weak var delegate: headerActoionDelegate?
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnInfo: UIButton!
    @IBOutlet var constraintCenter: NSLayoutConstraint!
    
    
    @IBAction func buttonTap(_ sender: UIButton) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        if (UIDevice.current.userInterfaceIdiom == .pad){
            isiPad()
        }
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func isiPad(){
        DispatchQueue.main.async {
            self.lblTitle.font = self.lblTitle.font.withSize(30)
        }
    }
    
    @IBAction func actionInfo(_ sender: Any) {
        delegate?.btnInfo()
    }
    @IBAction func actionHome(_ sender: Any) {
        delegate?.btnHome()
    }
}

