//
//  SlackUsersDataStore.swift
//  CakeLane
//
//  Created by Alexey Medvedev on 12/2/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import Foundation

class FirebaseUsersDataStore {
    static let sharedInstance = FirebaseUsersDataStore()
    private init() { }
    
    var users = [User]()
    var bots = [User]()
}
