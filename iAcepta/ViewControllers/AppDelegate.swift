//
//  AppDelegate.swift
//  iAcepta
//
//  Created by iOS_Dev on 2/1/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import GoogleUtilities
//import Unrealm

var AFManager = SessionManager()
var timmerDispatch = true

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate/*,MessagingDelegate*/ {

    
    var window: UIWindow?
//    let gcmMessageIDKey = "gcm.message_id"
    var myOrientation: UIInterfaceOrientationMask = .portrait

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // ----
//        Realm.registerRealmables(parameterServiceQR.self)
        let serverUrl = Bundle.main.object(forInfoDictionaryKey: "ServerURL") as! String
        print(serverUrl)
        
//        FirebaseApp.configure()
//        Fabric.sharedSDK().debug = true
//        Analytics.setAnalyticsCollectionEnabled(true)
        //BOOL isPhone = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone);
        if (UIDevice.current.userInterfaceIdiom == .phone){
            print("Es un iPhone")
        }else if (UIDevice.current.userInterfaceIdiom == .pad){
            print("Es un iPAD")
            let storyboard = UIStoryboard(name: "MainStoryboard_iPad", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "SplashIPad")
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
//        let pushManager = PushNotificationManager(userID: "currently_logged_in_user_id")
//        pushManager.registerForPushNotifications()

//        IQKeyboardManager.shared.enable = false
        application.isIdleTimerDisabled = true
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5 // seconds
        configuration.timeoutIntervalForResource = 5 //seconds
        AFManager = Alamofire.SessionManager(configuration: configuration)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey:"SessionIAcepta")
        window!.rootViewController?.dismiss(animated: false, completion: nil)
        exit(0)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask{
        return myOrientation
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let txt = url.query
        let split = txt?.components(separatedBy: "&")
        var i = 0
        
        var name:String = ""
        var password:String = ""
        var amount:String = ""
        var tip:String = ""
        var mwi:String = ""
        var email:String = ""
        var reference:String = ""
        var typeTransfers:String = ""
        var stringReverse:String = ""
        var infoExtra:String = ""
        
        while (i < split?.count ?? 0) {
            switch (i){
            case 0:
                name = split?[0] ?? ""
                break
            case 1:
                password = split?[1] ?? ""
                break
            case 2:
                amount = split?[2] ?? ""
                break
            case 3:
                tip = split?[3] ?? ""
                break
            case 4:
                mwi = split?[4] ?? ""
                break
            case 5:
                email = split?[5] ?? ""
                break
            case 6:
                reference = split?[6] ?? ""
                break
            case 7:
                typeTransfers = split?[7] ?? ""
                break
            case 8:
                stringReverse = split?[8] ?? ""
                break
            case 9:
                infoExtra = split?[9] ?? ""
                break
            default:
                break
            }
            i += 1
        }
        modelGlob.Static.txrModel = TransactionModel(amount: amount, tip: tip, total: "", mwi: mwi, reference: reference, email: email, tipPercentage: "")
        modelGlob.Static.integratorModel = IntegratorModel(name: name, password: password, typeTransfers: typeTransfers, stringReverse: stringReverse, infoExtra: infoExtra, externo: true)
        return true
    }

}

