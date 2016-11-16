//
//  AppDelegate.swift
//  slackOAuth
//
//  Created by Alexey Medvedev on 11/15/16.
//  Copyright © 2016 medvedev. All rights reserved.
//

import UIKit
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if let sourceAppKey = options[UIApplicationOpenURLOptionsKey.sourceApplication] {
            
            if (String(describing: sourceAppKey) == "com.apple.SafariViewService") {
                
                let codeString = String(describing: url)
                let code = codeString.components(separatedBy: "=").last!
                
                NotificationCenter.default.post(name: .closeSafariVC, object: code)
                
                return true
            }
        }
        return false
    }
    
}

extension Notification.Name {
    static let closeSafariVC = Notification.Name(rawValue: "close safari")
}
