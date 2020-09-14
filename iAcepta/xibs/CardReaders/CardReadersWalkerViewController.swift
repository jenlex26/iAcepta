//
//  CardReadersWalkerViewController.swift
//  iAcepta
//
//  Created by QUALITY on 6/3/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CardReadersWalkerViewController: UIView{
    
    
    let nibName = "CardReaders_Walker"
    let nibNameIPad = "CardReader_iPad_Walker"
    var contentView:UIView?
    

    @IBOutlet weak var arrows: UIImageView!
    @IBOutlet weak var terminal: UIImageView!
    @IBOutlet weak var card: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
        self.setAnimation(arrows)
        self.setAnimation(terminal)
        self.setAnimation(card)
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        
        var nibs = UINib()
        if (UIDevice.current.userInterfaceIdiom == .pad){
            nibs = UINib(nibName: nibNameIPad, bundle: bundle)
        }else{
            nibs = UINib(nibName: nibName, bundle: bundle)
        }
        //let nib = UINib(nibName: nibName, bundle: bundle)
        NotificationCenter.default.addObserver(self, selector: #selector(self.animationRemove), name: Notification.Name("iAcepta.animationRemove"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.animationLoader), name: Notification.Name("iAcepta.animationLoader"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.animationHide), name: Notification.Name("iAcepta.animationHide"), object: nil)

        return nibs.instantiate(withOwner: self, options: nil).first as? UIView
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
    
    @objc func animationRemove(_ notification: Notification){
        
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
        if let animation = notification.userInfo?["animation"] as? Bool{
            if animation{
                activityIndicator.startAnimating()
            }else{
                activityIndicator.stopAnimating()
            }
        }
    }
    
    @objc func animationHide(_ notification: Notification){
        if let animation = notification.userInfo?["animationHide"] as? Bool{
            if animation{
                activityIndicator.isHidden = false
            }else{
                activityIndicator.isHidden = true
            }
        }
    }
    
}
