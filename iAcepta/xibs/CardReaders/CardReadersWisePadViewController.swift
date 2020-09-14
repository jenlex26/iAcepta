//
//  CardReadersWisePadViewController.swift
//  iAcepta
//
//  Created by QUALITY on 9/13/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CardReadersWisePadViewController: UIView {
    
    let nibName = "CardReader_WisePad"
    let nibNameIPad = "CardReader_iPad_WisePad"
    var contentView:UIView?
    
    @IBOutlet weak var arrows: UIImageView!
    @IBOutlet weak var terminal: UIImageView!
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
        //self.setAnimation(terminal)
        self.setAnimation(card)
    }
    
    func loadViewFromNib() -> UIView? {
        NotificationCenter.default.addObserver(self, selector: #selector(self.animationWisePad), name: Notification.Name("iAcepta.animationWisePad"), object: nil)
        let bundle = Bundle(for: type(of: self))
        var nibs = UINib()
        if (UIDevice.current.userInterfaceIdiom == .pad){
            nibs = UINib(nibName: nibNameIPad, bundle: bundle)
        }else{
            nibs = UINib(nibName: nibName, bundle: bundle)
        }
        return nibs.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func loadViewLoadWisePad() -> UIView?{
        let bundle = Bundle(for: type(of: self))
        var nibs = UINib()
        if (UIDevice.current.userInterfaceIdiom == .pad){
            nibs = UINib(nibName: nibNameIPad, bundle: bundle)
        }else{
            nibs = UINib(nibName: nibName, bundle: bundle)
        }
        return nibs.instantiate(withOwner: self, options: nil)[1] as? UIView
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
    
    @objc func animationWisePad(_ notification: Notification){
        
        if let arrows2 = notification.userInfo?["arrows"] as? Bool, let terminal2 = notification.userInfo?["terminal"] as? Bool,  let card2 = notification.userInfo?["card"] as? Bool {
            arrows.layer.removeAllAnimations()
            terminal.layer.removeAllAnimations()
            card.layer.removeAllAnimations()
            
            if arrows2{
                self.setAnimation(arrows)
            }
            if terminal2{
                self.setAnimation(terminal)
            }
            if card2{
                self.setAnimation(card)
            }
        }
        if let arrowsHide = notification.userInfo?["arrowsHide"] as? Bool, let terminalHide = notification.userInfo?["terminalHide"] as? Bool,  let cardHide = notification.userInfo?["cardHide"] as? Bool {
            
            arrows.isHidden = true
            terminal.isHidden = true
            card.isHidden = true
            
            if arrowsHide{
                arrows.isHidden = false
            }
            if terminalHide{
                terminal.isHidden = false
            }
            if cardHide{
                card.isHidden = false
            }
            
        }
    }
    
    @objc func animationLoader(_ notification: Notification){
        let animation = notification.userInfo?["animation"] as? Bool
    }
    @objc func animationHide(_ notification: Notification){
        let animation = notification.userInfo?["animationHide"] as? Bool
    }
    func setLoaders(){
        UIView.animate(withDuration: 1.5, delay: 0.5, options:[.curveEaseIn, .repeat], animations: {
            print("Empieza animación ___________________")
            self.arrowRight.isHidden = false
            self.arrowRight.transform = CGAffineTransform.identity.translatedBy(x: 55, y: 0)
        })
    }
}
