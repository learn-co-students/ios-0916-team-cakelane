//
//  DataStore.swift
//  CakeLane
//
//  Created by Alexey Medvedev on 11/17/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import Foundation
import Locksmith

struct SlackAccount: CreateableSecureStorable, GenericPasswordSecureStorable {
    let userID: String
    let accessToken: String
    
    let service = "Slack"
    var account: String { return userID }
    
    var data: [String : Any] {
        return ["access_token": accessToken]
    }
}
