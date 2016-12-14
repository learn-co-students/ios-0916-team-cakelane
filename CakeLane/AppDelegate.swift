//
//  AppDelegate.swift
//  FireBaseTesting
//
//  Created by Rama Milaneh on 11/14/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import DropDown
import SDWebImage


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    override init() {
        super.init()
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .default
         IQKeyboardManager.sharedManager().enable = true
        
        DropDown.startListeningToKeyboard()
        UITabBar.appearance().tintColor = UIColor.orange
        
        SDWebImageManager.shared().imageCache.maxCacheAge = 60*60*24*14
        let sd = SDImageCache()
        print("%%%%%%%%%%%%%%")
        print(sd.getDiskCount())
        print(sd.getSize())
        

    
        return true
    }
    
    // opening safari view controller to retrieve authorization code from Slack API (which will be exchanged for a token)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if let sourceAppKey = options[UIApplicationOpenURLOptionsKey.sourceApplication] {
            
            if (String(describing: sourceAppKey) == "com.apple.SafariViewService") {
                
                let code = url.getQueryItemValue(named: "code")
                
                print("\n%%%%%%%%%%%%%%%%%%%%%%%%%%")
                print(TeamDataStore.sharedInstance.performedFirstAuth)
                print(TeamDataStore.sharedInstance.webhook)
                print("%%%%%%%%%%%%%%%%%%%%%%%%%%")
                
                // this flag check helps avoid first auth after it has already been performed
                if TeamDataStore.sharedInstance.performedFirstAuth == false {
                    
                    // first authentication
                    NotificationCenter.default.post(name: .closeSafariVC, object: code)
                    
                } else {
                    
                    // only if there is no webhook for a given slack team do we perform second auth (sole purpose := create webhook)
                    
                    if TeamDataStore.sharedInstance.webhook == nil {
                        
                        // second  authentication
                        NotificationCenter.default.post(name: .finishSecondAuth, object: code)
                        
                    }
                    
                }
                
                return true
                
            }
            
        }
        
        return false
        
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

