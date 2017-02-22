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
import FBSDKLoginKit
import GoogleSignIn

struct OneSignalUserData {
    var userId: String? = nil
    var deviceToken: String? = nil
}

let oneSignalAppID = "6a5c72cc-2f17-49ec-a1e0-067be225b902"
var oneSignalUserData = OneSignalUserData()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //configure Firebase
        FIRApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
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
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        
        GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        
        return handled
    }
    
    //called when the google button is clicked.
    //IMPORTANT
    //Enable Google Auth on FIREBASE panel
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error {
            print("Failed to complete google log in :(", err)
            return
        }
        print("Successfully logged into Google", user)
        
        //to dump it in our firebase
        guard let idToken = user.authentication.idToken else { return }
        guard let accessToken = user.authentication.accessToken else { return }
        let credentials = FIRGoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if let err = error {
                print("Failed to create a Firebase user with google!! :( ", err)
                return
            }
            guard let uid = user?.uid else { return }
            print("Successfully logged into Firebase with Google", uid)
        })
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

