//
//  CardReadersVerifoneViewController.swift
//  iAcepta
//
//  Created by QUALITY on 5/30/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CardReadersVerifoneViewController: UIView {
    
    let nibName = "CardReaders_Verifone"
    let nibNameIPad = "CardReader_iPad_Verifone"
    var contentView:UIView?
    
    @IBOutlet var contentVerifone: UIView!
    
    @IBOutlet weak var arrows: UIImageView!
    @IBOutlet weak var card: UIImageView!
    @IBOutlet weak var arrowRight: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit(isSuccess:Bool? = nil) {
            guard let view = loadViewFromNib() else { return }
            view.frame = self.bounds
            self.addSubview(view)
            contentView = view
            self.setAnimation(arrows)
            self.setAnimation(card)
        
    }
    
    func loadViewFromNib() -> UIView? {
        NotificationCenter.default.addObserver(self, selector: #selector(self.animationVerifone), name: Notification.Name("iAcepta.animationVerifone"), object: nil)
        let bundle = Bundle(for: type(of: self))
        var nibs = UINib()
        if (UIDevice.current.userInterfaceIdiom == .pad){
            nibs = UINib(nibName: nibNameIPad, bundle: bundle)
        }else{
            nibs = UINib(nibName: nibName, bundle: bundle)
        }
        //let nib = UINib(nibName: nibName, bundle: bundle)
        return nibs.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func loadViewLoadVerifone() -> UIView?{
        let bundle = Bundle(for: type(of: self))
        var nibs = UINib()
        if (UIDevice.current.userInterfaceIdiom == .pad){
            nibs = UINib(nibName: nibNameIPad, bundle: bundle)
        }else{
            nibs = UINib(nibName: nibName, bundle: bundle)
        }
        return nibs.instantiate(withOwner: self, options: nil)[1] as? UIView
        /*let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil)[1] as? UIView*/
    }
    
    fileprivate func setAnimation(_ view:UIView) {
        let point = CGPoint(x: 0.0, y: 25)
        let pointObj = NSValue(cgPoint: point)
        let animations = CABasicAnimation(keyPath: "position")
        animations.isAdditive = true
        animations.fromValue = pointObj
        animations.toValue = NSValue(cgPoint: CGPoint.zero)
        animations.autoreverses = true
        animations.duration = 0.8
        animations.repeatCount = .infinity
        view.layer.add(animations, forKey: "position")
    }
    
    @objc func animationVerifone(_ notification: Notification){
        
        if let arrows2 = notification.userInfo?["arrows"] as? Bool,  let card2 = notification.userInfo?["card"] as? Bool {
            arrows.layer.removeAllAnimations()
            card.layer.removeAllAnimations()
            
            if arrows2{
                self.setAnimation(arrows)
            }
            if card2{
                self.setAnimation(card)
            }
            
        }
        if let arrowsHide = notification.userInfo?["arrowsHide"] as? Bool, let cardHide = notification.userInfo?["cardHide"] as? Bool{
            arrows.isHidden = true
            card.isHidden = true
            if arrowsHide{
                arrows.isHidden = false
            }
            if cardHide{
                card.isHidden = false
            }
            
        }
    }
    
    func setLoaders(){
        UIView.animate(withDuration: 1.5, delay: 0.5, options:[.curveEaseIn, .repeat], animations: {
            print("Empieza animación ___________________")
            self.arrowRight.isHidden = false
            self.arrowRight.transform = CGAffineTransform.identity.translatedBy(x: 55, y: 0)
        })
    }
    
    
}
