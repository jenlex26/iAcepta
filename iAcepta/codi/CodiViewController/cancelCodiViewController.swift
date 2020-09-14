//
//  cancelCodiViewController.swift
//  iAcepta
//
//  Created by Javier Hernandez on 10/07/20.
//  Copyright © 2020 Quality & Knowledge. All rights reserved.
//

import UIKit

class cancelCodiViewController: UIViewController {
    @IBOutlet var headeriAcepta: headeriAcepta!
    @IBOutlet weak var labelReason: UILabel!
    @IBOutlet weak var buttonCancel: UIButton!{didSet{buttonCancel.setRoundedLayout(button: buttonCancel)}}
    
    var messageService = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        headeriAcepta.delegate = self
        headeriAcepta.constraintCenter.constant = 0
        headeriAcepta.btnHome.isHidden = true
        headeriAcepta.btnInfo.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        labelReason.text = messageService
    }
}

extension cancelCodiViewController:headerActoionDelegate{
    func btnHome() {
        print("")
    }
    func btnInfo() {
        print("")
    }
}
