//
//  InformationViewController.swift
//  iAcepta
//
//  Created by QUALITY on 7/17/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class InformationViewController: UIView {
    
    @IBOutlet var v1: UIView!
    @IBOutlet var v2: UIView!
    @IBOutlet var v3: UIView!
    @IBOutlet var v4: UIView!
    @IBOutlet var v5: UIView!
    @IBOutlet var v6: UIView!
    @IBOutlet var v7: UIView!
    
    func instanceFromNib(size:CGFloat) -> UIView? {
        if (UIDevice.current.userInterfaceIdiom == .pad){
            v1 = (UINib(nibName: "Information_iPad", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! UIView)
            v1.frame = CGRect(x: 0, y: 0, width: size, height: v1.frame.height)
        }else{
            v1 = (UINib(nibName: "Information", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! UIView)
        }
        return v1
    }
    func instanceFromNibView2(size:CGFloat) -> UIView? {
        if (UIDevice.current.userInterfaceIdiom == .pad){
            v2 = (UINib(nibName: "Information_iPad", bundle: nil).instantiate(withOwner: self, options: nil)[1] as! UIView)
            v2.frame = CGRect(x: 0, y: 0, width: size, height: v2.frame.height)
            
        }else{
            v2 = (UINib(nibName: "Information", bundle: nil).instantiate(withOwner: self, options: nil)[1] as! UIView)
        }
        return v2
    }
    func instanceFromNibView3(size:CGFloat) -> UIView? {
        if (UIDevice.current.userInterfaceIdiom == .pad){
            v3 = (UINib(nibName: "Information_iPad", bundle: nil).instantiate(withOwner: self, options: nil)[2] as! UIView)
            v3.frame = CGRect(x: 0, y: 0, width: size, height: v3.frame.height)
        }else{
            v3 = (UINib(nibName: "Information", bundle: nil).instantiate(withOwner: self, options: nil)[2] as! UIView)
        }
        return v3
    }
    func instanceFromNibView4(size:CGFloat) -> UIView? {
        if (UIDevice.current.userInterfaceIdiom == .pad){
            v4 = (UINib(nibName: "Information_iPad", bundle: nil).instantiate(withOwner: self, options: nil)[3] as! UIView)
            v4.frame = CGRect(x: 0, y: 0, width: size, height: v4.frame.height)
        }else{
            v4 = (UINib(nibName: "Information", bundle: nil).instantiate(withOwner: self, options: nil)[3] as! UIView)
        }
        return v4
    }
    func instanceFromNibView5(size:CGFloat) -> UIView? {
        if (UIDevice.current.userInterfaceIdiom == .pad){
            v5 = (UINib(nibName: "Information_iPad", bundle: nil).instantiate(withOwner: self, options: nil)[4] as! UIView)
            v5.frame = CGRect(x: 0, y: 0, width: size, height: v5.frame.height)
        }else{
            v5 = (UINib(nibName: "Information", bundle: nil).instantiate(withOwner: self, options: nil)[4] as! UIView)
        }
        return v5
    }
    func instanceFromNibView6(size:CGFloat) -> UIView? {
        if (UIDevice.current.userInterfaceIdiom == .pad){
            v6 = (UINib(nibName: "Information_iPad", bundle: nil).instantiate(withOwner: self, options: nil)[5] as! UIView)
            v6.frame = CGRect(x: 0, y: 0, width: size, height: v6.frame.height)
        }else{
            v6 = (UINib(nibName: "Information", bundle: nil).instantiate(withOwner: self, options: nil)[5] as! UIView)
        }
        return v6
    }
    func instanceFromNibView7(size:CGFloat) -> UIView? {
        if (UIDevice.current.userInterfaceIdiom == .pad){
            v7 = (UINib(nibName: "Information_iPad", bundle: nil).instantiate(withOwner: self, options: nil)[6] as! UIView)
            v7.frame = CGRect(x: 0, y: 0, width: size, height: v7.frame.height)
        }else{
            v7 = (UINib(nibName: "Information", bundle: nil).instantiate(withOwner: self, options: nil)[6] as! UIView)
        }
        return v7
    }
}
