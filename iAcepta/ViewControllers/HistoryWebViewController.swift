//
//  HistoryWebViewController.swift
//  iAcepta
//
//  Created by QUALITY on 7/18/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class HistoryWebViewController: MasterViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var headerIAcepta: headeriAcepta!
    @IBOutlet weak var fondoOpacity: UIImageView!
    
    var webLink:String = ""
    var txrSession:SessionIAcepta?
    var request:NSMutableURLRequest? = nil
    
    var loadUrl:URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.scrollView.bounces = false
        webView.navigationDelegate = self
        headerIAcepta.delegate = self
        txrSession = sessionGlob.Static.sessionIAcepta
        
        setHeader()
        
        let date = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy"
        let dateFormat =  formatter.string(from: date as Date)
        webLink = String(format: "%@%@?date=%@", "https://www.iaceptamx.com:2388/","PosMobileAdmin/MainTransactionMobile.aspx",dateFormat)
        loadUrl = URL(string: webLink)
        if let url = URL(string: webLink){
            request = (URLRequest(url: url) as! NSMutableURLRequest)
            prepareRequest()
            webView.load(request! as URLRequest)
        }
        viewSelect = fondoOpacity
    }
    
    func setHeader(){
        headerIAcepta.lblTitle.text = "Historial"
        headerIAcepta.btnInfo.isHidden = true
    }
    
    func prepareRequest(){
        request!.setValue(txrSession?.userInfo?.nodeId, forHTTPHeaderField: "nodeId")
        request!.setValue(txrSession?.scope, forHTTPHeaderField: "scope")
        request!.setValue(txrSession?.authToken, forHTTPHeaderField: "secureToken")
        request!.setValue(txrSession?.tokenExpiration, forHTTPHeaderField: "expiration")
        request!.setValue(txrSession?.userID, forHTTPHeaderField: "usrId")
    }
    
    func loadWebPage(url: URL)  {
        var customRequest = URLRequest(url: url)
        customRequest.setValue(txrSession?.userInfo?.nodeId, forHTTPHeaderField: "nodeId")
        customRequest.setValue(txrSession?.scope, forHTTPHeaderField: "scope")
        customRequest.setValue(txrSession?.authToken, forHTTPHeaderField: "secureToken")
        customRequest.setValue(txrSession?.tokenExpiration, forHTTPHeaderField: "expiration")
        customRequest.setValue(txrSession?.userID, forHTTPHeaderField: "usrId")
        webView!.load(customRequest)
    }
    
}

extension HistoryWebViewController:WKNavigationDelegate{
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = (navigationResponse.response as! HTTPURLResponse).url else {
            decisionHandler(.cancel)
            return
        }
        
        if url != loadUrl {
            loadUrl = url
            decisionHandler(.cancel)
            loadWebPage(url: url)
        } else {
            if (navigationResponse.response as! HTTPURLResponse).statusCode == 401{
                loadUrl = url
                decisionHandler(.cancel)
                loadWebPage(url: url)
            }else{
                decisionHandler(.allow)
            }
        }
        
    }
    
}

extension HistoryWebViewController:headerActoionDelegate{
    func btnHome() {
         self.performSegue(withIdentifier: "unwindToStar", sender: self)
    }
    
    func btnInfo() {
    }
}
