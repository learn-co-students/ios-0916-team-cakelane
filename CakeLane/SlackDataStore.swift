//
//  DataStore.swift
//  CakeLane
//
//  Created by Alexey Medvedev on 11/17/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import Foundation

class SlackDataStore {
    static let sharedInstance = SlackDataStore()
    fileprivate init() {}
    
    var token = ""
}
