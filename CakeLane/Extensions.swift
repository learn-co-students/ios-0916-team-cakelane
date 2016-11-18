//
//  Extensions.swift
//  slackOAuth
//
//  Created by Alexey Medvedev on 11/17/16.
//  Copyright © 2016 medvedev. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let closeSafariVC = Notification.Name("close-safari-view-controller")
    static let closeLoginVC = Notification.Name("close-login-view-controller")
    static let closeActivitiesTVC = Notification.Name("close-activity-table-view-controller")
}

//// extension to close SafariVC
//extension Notification.Name {
//    static let closeSafariVC = Notification.Name(rawValue: "close safari")
//}

extension URL {
    func getQueryItemValue(named name: String) -> String? {
        
        let components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        let query = components?.queryItems
        return query?.filter({$0.name == name}).first?.value
    }
}
