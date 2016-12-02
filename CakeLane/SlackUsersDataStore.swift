//
//  SlackUsersDataStore.swift
//  CakeLane
//
//  Created by Alexey Medvedev on 12/2/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import Foundation

class SlackUsersDataStore {
    static let sharedInstance = SlackUsersDataStore()
    private init() { }
    
    var users = [User]()
    var bots = [User]()
}
