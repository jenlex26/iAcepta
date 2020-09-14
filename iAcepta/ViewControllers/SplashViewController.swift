//
//  SplashViewController.swift
//  iAcepta
//
//  Created by iOS_Dev on 2/1/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import UIKit

class SplashViewController: MasterViewController {

    @IBOutlet weak var logoIAcepta: UIImageView!
    @IBOutlet weak var logoEvoPayment: UIImageView!
    var updateVersion:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        setAnimation()
            DispatchQueue.global().async {
                do {
                    let update = try? self.isUpdateAvailable { (update, error) in
                        if let error = error {
                            
                        }
                        else if let update = update {
                            self.updateVersion = update
                        }
                    }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        externo = modelGlob.Static.integratorModel?.externo ?? false
        if !externo{
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.performSegue(withIdentifier: "login", sender: self)
            }
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.performSegue(withIdentifier: "loaderIntegrator", sender: self)
            }
        }
    }
    
    func setAnimation(){
        HelperExtensions().setAnimationImg(img: logoIAcepta, view: view, timeDuration: 0.55, moveLogo: 144)
        HelperExtensions().setAnimationImg(img: logoEvoPayment, view: view, timeDuration: 0.55, moveLogo: 97)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "login"{
            if let destinationVC = segue.destination as? LoginViewController {
                destinationVC.update = updateVersion
            }
        }
    }
}
