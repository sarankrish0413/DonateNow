//
//  AppDelegate.swift
//  DonateNow
//
//  Created by Saranya Krishnan on 1/26/17.
//  Copyright © 2017 Saranya Krishnan. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import OneSignal

struct OneSignalUserData {
    var userId: String? = nil
    var deviceToken: String? = nil
}

let oneSignalAppID = "6a5c72cc-2f17-49ec-a1e0-067be225b902"
var oneSignalUserData = OneSignalUserData()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //configure Firebase
        FIRApp.configure()
        OneSignal.initWithLaunchOptions(launchOptions, appId: oneSignalAppID, handleNotificationReceived: { (notification) in
             debugPrint("Received Notification - \(notification?.payload.notificationID)")
        }, handleNotificationAction: { (result) in
            let payload: OSNotificationPayload? = result?.notification.payload
            var fullMessage: String? = payload?.body
            if payload?.additionalData != nil {
                var additionalData: [AnyHashable: Any]? = payload?.additionalData
                if additionalData!["actionSelected"] != nil {
                    fullMessage = fullMessage! + "\nPressed ButtonId:\(additionalData!["actionSelected"])"
                }
            }
            
            debugPrint(fullMessage!)
            
        }, settings: [kOSSettingsKeyAutoPrompt : true])
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white ,NSFontAttributeName: UIFont(name: "Futura", size: 20.0)!]
        UINavigationBar.appearance().barTintColor = UIColor(red: 209/255, green: 73/255, blue: 59/255, alpha: 1.0)
        UITabBar.appearance().tintColor = UIColor.white
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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


}

