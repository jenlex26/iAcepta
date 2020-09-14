//
//  SearchWisePadViewController.swift
//  iAcepta
//
//  Created by QUALITY on 9/13/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import UIKit

class SearchWisePadViewController:MasterViewController{
    
    @IBOutlet weak var tableSearchDevices: UITableView!
    @IBOutlet weak var btnContinue: UIButton!{didSet{btnContinue.setRoundedLayout(button: btnContinue)}}
    @IBOutlet weak var headerIAcepta: headeriAcepta!
    @IBOutlet weak var nameSelectedDevice: UILabel!
    
    @IBOutlet weak var btnRefresh: UIButton!
    
    let wisePad = WisePadReaderManager()
    var walker2 = BBDeviceController();
    var isViewWillAppear:Bool = false
    var BTDeviceDictionary = NSMutableDictionary()
    var DeviceArray = NSMutableArray()
    var setDevice:String = ""
    var rowSelectedDevice:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wisePad.delegate = self
        isViewWillAppear = true
        setHeader()
        if UserDefaults.standard.string(forKey: "PREVIOUS_DEVICE") != ""{
            nameSelectedDevice.text = UserDefaults.standard.string(forKey: "PREVIOUS_DEVICE")
            setDevice = nameSelectedDevice.text ?? ""
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isViewWillAppear{
            wisePad.wisePad2.delegate = nil
            wisePad.starScan()
        }
    }
    
    
    //Func MARK: Header
    func setHeader(){
        headerIAcepta.lblTitle.text = ""
        headerIAcepta.btnHome.isHidden = false
        headerIAcepta.btnInfo.isHidden = false
        headerIAcepta.delegate = self
    }
    
    @IBAction func actionContinue(_ sender: Any) {
        if (setDevice != ""){
            wisePad.ultimoEstado = .Disconnect
            wisePad.disconect(setDimiss: true)
        }else{
            wisePad.onBTScanStopped()
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func actionRefresh(_ sender: Any) {
        print("Action REFRESH ......... ")
        tableSearchDevices.isHidden = true
        btnRefresh.isEnabled = false
        animationButton()
        wisePad.starScan()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToStar"{
            if let destinationVC = segue.destination as? MainMenuViewController {
                if (setDevice != "") {
                    destinationVC.isWisePad = true
                }
                modelGlob.Static.wisePadSDK = wisePad
            }
        }
    }
    
    func animationButton(){
        UIView.animate(withDuration: 0.5, delay: 0, options:[.curveLinear, .repeat], animations: {
            let transform : CGAffineTransform = CGAffineTransform(rotationAngle: CGFloat.pi)
            self.btnRefresh.layer.setAffineTransform(transform)
        }, completion: { (finished: Bool) in
            let transform : CGAffineTransform = CGAffineTransform.identity
            self.btnRefresh.layer.setAffineTransform(transform)
        })
    }
}
extension SearchWisePadViewController:sdkWisePadResponse{
    func onRequestDisplayText(result: BBDeviceDisplayText) {
    }
    
    func deviceErrorTypeWisePad(errorType: BBDeviceErrorType?, errorMensaje: String, ultimoEstado: StatusWisepad?, deviceConnected: Bool) {
        
    }
    
    func onReturnCardResultWisePad(result: BBDeviceCheckCardResult, ultimoEstado: StatusWisepad, cardData: [AnyHashable : Any]!) {
        
    }
    
    func onReturnTransactionResultWisePad(result: BBDeviceTransactionResult, ultimoEstado: StatusWisepad) {
        
    }
    
    func onWaitingViewWisePad(deviceConnected: Bool, cardIn: Bool) {
        print("WisePad")
    }
    
    func setValueFromModelWisePad(cardModel: CardWalkerModel?, isChipBanda: String?) {
        print("WisePad")
    }
    
    func onBTReturnScanResults(deviceArray:NSMutableArray){
        btnRefresh.isEnabled = true
        btnRefresh.layer.removeAllAnimations()
        DeviceArray = deviceArray
        if deviceArray.count > 0{
            self.tableSearchDevices.delegate = self
            self.tableSearchDevices.dataSource = self
            self.tableSearchDevices.isHidden = false
            self.tableSearchDevices.reloadData()
            self.tableSearchDevices.separatorStyle = .none
        }
    }
    func batteryStatusWisePad(isBaterryStatus:BBDeviceBatteryStatus){
        alert(alertTitle: "title_alert_batteryLow_cardReader".localized, message: "body_alert_batteryLow_cardReader".localized, alertBtnFirst: "btn_understood".localized, completion: {
            self.dismiss(animated: true, completion: nil)
        })
    }
}
extension SearchWisePadViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DeviceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellDevices", for: indexPath) as! cellSearchDevice
        let obj1: NSObject = DeviceArray[indexPath.row] as! NSObject
        var deviceName:String = ""
        if (obj1 is EAAccessory){
            deviceName = obj1.value(forKey: "serialNumber") as? String ?? ""
        }
        cell.nameDevice.text = deviceName
        if setDevice == deviceName{
            rowSelectedDevice = indexPath.row
            cell.setChecked(checked: true)
        }else{
            cell.setChecked(checked: false)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!) as! cellSearchDevice
        currentCell.setChecked(checked: true)
        
        if (rowSelectedDevice != indexPath?.row){
            let indexPath = IndexPath(row: rowSelectedDevice, section: 0)
            let currentCell = tableView.cellForRow(at: indexPath) as! cellSearchDevice
            currentCell.setChecked(checked: false)
        }
        
        rowSelectedDevice = indexPath?.row ?? 0
        setDevice = currentCell.nameDevice.text ?? ""
    }
    
    func onBTDisconnectedWisePad(){
        UserDefaults.standard.set(setDevice, forKey: "PREVIOUS_DEVICE")
        self.performSegue(withIdentifier: "unwindToStar", sender: self)
        print("Disconnect")
    }
    func onReturnAmountConfirmResultWisePad(_ isConfirmed:Bool){
    }
}
extension SearchWisePadViewController:headerActoionDelegate{
    func btnHome() {
        alertTwoOp(alertTitle: "title_alert_returnMenu_closeSession".localized, message: "body_alert_returnMenu_closeSession".localized, alertBtnFirst: "firtsBtn_alert_returnMenu_closeSession".localized, alertBtnSecond: "secondBtn_alert_returnMenu_closeSession".localized, completion: {
            self.dismiss(animated: true, completion: {
                self.wisePad.wisePad2.delegate = nil
                self.performSegue(withIdentifier: "unwindToStar", sender: self)
            })
        }) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    func btnInfo() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier:"infoHelp") as! InformationHelpViewController
        alertVC.contentName = "InfoWisepad"
        present(alertVC, animated: true, completion: nil)
    }
}
