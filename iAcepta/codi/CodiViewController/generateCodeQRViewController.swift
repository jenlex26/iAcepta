//
//  generateCodeQR.swift
//  iAcepta
//
//  Created by QUALITY on 12/02/20.
//  Copyright © 2020 Quality & Knowledge. All rights reserved.
//

import UIKit
import AVFoundation
//import Unrealm
import RealmSwift

class generateCodeQR: MasterViewController {
    
    @IBOutlet weak var imageQR: UIImageView!
    @IBOutlet weak var headeriAcepta: headeriAcepta!
    @IBOutlet weak var loaderSpinner: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!{didSet{cancelButton.setRoundedLayout(button: cancelButton)}}
    @IBOutlet weak var labelCancel: UILabel!
    @IBOutlet weak var labelDisplay: UILabel!
    
    var player: AVAudioPlayer?
    var modelResponse = codiWalletResquest()//parameterServiceQR()
    var buttonOn = false
    var dataAmount = ""
    var dataReference = ""
    var dataAlert = ""
    var dataEmail = ""
    var dataVoucher : [String] = []
    var dataReject = ""
    var timeCancel = ""
    var timer: Timer!
    var timerLbl = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        headeriAcepta.delegate = self
        headeriAcepta.lblTitle.text = "QR CoDi"
        headeriAcepta.constraintCenter.constant = 0
        headeriAcepta.btnHome.isHidden = true
        headeriAcepta.btnInfo.isHidden = true
        cancelButton.isHidden = true
        labelCancel.isHidden = true
        generate()
        self.dataEmail = self.modelResponse.email
    }
    
    func star(){
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
        loaderSpinner.animationImages = imgArray
        loaderSpinner.animationDuration = 0.75
        loaderSpinner.startAnimating()
    
     }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "sound", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func timeDispatch(time:String){
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int(time)!)) {
            if timmerDispatch {
              self.retrailService()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSuccess"{
            if let destinationVC = segue.destination as? voucherCodiViewController{
                destinationVC.amountService    = dataAmount
                destinationVC.referenceService = dataReference
                destinationVC.alertService     = dataAlert
                destinationVC.voucherService   = dataVoucher
                destinationVC.emailService     = dataEmail
            }
        }
        if segue.identifier == "toReject"{
            if let destinationVC = segue.destination as? cancelCodiViewController{
                destinationVC.messageService =  dataReject
            }
        }
    }
    
    func retrailService(){
        let realm = try! Realm()
        let database = realm.objects(codiWalletResquest.self).last
        let identificiation = self.modelResponse.identidification.isEmpty ? database?.identidification : modelResponse.identidification
        let key = modelResponse.walletsRequest?.requestKey ?? database?.walletsRequest?.requestKey
        let amount = self.modelResponse.amount.isEmpty ? database?.amount : self.modelResponse.amount
        let email = self.modelResponse.email.isEmpty ? database?.email : self.modelResponse.email
        let reference = self.modelResponse.reference.isEmpty ? database?.reference : self.modelResponse.reference

        
        
        CodiPresenter.walletRequest(.retry, identificiation! , key!, amount!, email!, reference!) { (result) in
            switch result {
            case .success(let success):
                self.timeDispatch(time: (success?.walletsRequest!.retryTime)!)
                self.timeCancel = (success?.walletsRequest!.retryTime)!
                if self.buttonOn == false{
                    if (success?.walletsRequest?.responseActions.contains("PaymentFlowIsCancelable"))! {
                        self.cancelButton.isHidden = false
                        self.labelCancel.isHidden = false
                        self.buttonOn = true
                    }
                }
                if (success?.walletsRequest?.responseActions.contains("Display"))!{
                    self.labelDisplay.text = success?.walletsRequest?.displayResponseMessage
                }
                break
            case .failure(let fail):
                debugPrint(fail.content.reason)
                self.imageQR.stopAnimating()
                self.dataAmount = self.modelResponse.amount.isEmpty ? database!.amount : self.modelResponse.amount
                self.dataReference = self.modelResponse.reference.isEmpty ? database!.reference : self.modelResponse.reference
                let realm = try! Realm()
                if let database = realm.objects(codiWalletResquest.self).first{
                    DBManagerVoucher.sharedInstance.deleteUserFromDb(object: database) {
                        if fail.content.code == 200{
                            self.dataAlert   = fail.content.reason
                            self.dataVoucher = fail.content.reason2
                            self.performSegue(withIdentifier: "toSuccess", sender: self)
                        }else{
                            self.dataReject = fail.content.reason
                            self.performSegue(withIdentifier: "toReject", sender: self)
                        }
                        
                    }
                }
                
                break
            }
        }
    }

    func generate(){
        star()
        let realm = try! Realm()
        let database = realm.objects(codiWalletResquest.self).last
        // Get define string to encode
        let myString = modelResponse.walletsRequest?.walletRequestToken ?? database?.walletsRequest?.walletRequestToken
        // Get data from the string
        let data = myString!.data(using: String.Encoding.ascii)
        // Get a QR CIFilter
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
        // Input the data
        timmerDispatch = true
        playSound()
        let time = modelResponse.walletsRequest?.retryTime ?? "2000"//database?.walletsRequest?.retryTime
        timeDispatch(time: time)
        qrFilter.setValue(data, forKey: "inputMessage")
        // Get the output image
        guard let qrImage = qrFilter.outputImage else { return }
        // Scale the image
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrImage.transformed(by: transform)
        // Do some processing to get the UIImage
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledQrImage, from: scaledQrImage.extent) else { return }
        let processedImage = UIImage(cgImage: cgImage)
        imageQR.image = processedImage
    }

    @IBAction func cancelButton(_ sender: Any) {
        timmerDispatch = false
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(changeTimer), userInfo: nil, repeats: true)
        self.imageQR.stopAnimating()
        self.present(self.vc, animated: true) {
            let realm = try! Realm()
            let database = realm.objects(codiWalletResquest.self).last

            let requestKeyService = self.modelResponse.walletsRequest?.requestKey ?? database?.walletsRequest?.requestKey
            let amountService     = self.modelResponse.amount.isEmpty ? database!.amount : self.modelResponse.amount
            let emailService      = self.modelResponse.email.isEmpty ? database!.email : self.modelResponse.email
            let referenceService  = self.modelResponse.reference.isEmpty ? database!.reference : self.modelResponse.reference

            
            CodiPresenter.cancelWallet(requestKeyService!, amountService, emailService,referenceService) { (result) in
                self.vc.dismiss(animated: true) {
                    switch result {
                    case .success( _):
                        self.timer.invalidate()
                        let realm = try! Realm()
                        if let database = realm.objects(codiWalletResquest.self).first{
                            DBManagerVoucher.sharedInstance.deleteUserFromDb(object: database) {
                                self.performSegue(withIdentifier: "toReject", sender: self)
                            }
                        }
                        break
                    case .failure(let fail):
                        self.alertServicesLogin(alertTitle: "titleAlertiAcepta".localized, message: fail.content.reason, alertBtnFirst: "titleBtnAlert_Accept".localized, completion: {
                            self.dismiss(animated: true) {
                                self.timer.invalidate()
                                print("\(self.timerLbl)>=\(Int(self.timeCancel)!)")
                                if self.timerLbl >= Int(self.timeCancel)! {
                                    timmerDispatch = true
                                    self.timerLbl = 0
                                    self.timeDispatch(time: "1000")
                                }else{
                                    self.timerLbl = 0
                                    timmerDispatch = true
                                }
                            }
                        })
                        break
                    }
                }
            }
        }
        
    }
    
    @objc func changeTimer(){
        timerLbl += 1000
        print(timerLbl)
    }
}

extension generateCodeQR:headerActoionDelegate{
    func btnHome() {
        alertTwoOp(alertTitle: "title_alert_returnMenu_closeSession".localized, message: "body_alert_returnMenu_closeSession".localized, alertBtnFirst: "firtsBtn_alert_returnMenu_closeSession".localized, alertBtnSecond: "secondBtn_alert_returnMenu_closeSession".localized, completion: {
            self.dismiss(animated: true, completion: {
                self.performSegue(withIdentifier: "unwindToStar", sender: self)
            })
        }) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    func btnInfo() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier:"infoHelp") as! InformationHelpViewController
        present(alertVC, animated: true, completion: nil)
    }
}

