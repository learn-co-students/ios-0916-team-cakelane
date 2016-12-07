//
//  TeamDataStore.swift
//  CakeLane
//
//  Created by Bejan Fozdar on 12/7/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import Foundation


class TeamDataStore {
    
    static let sharedInstance = TeamDataStore()
    fileprivate init() {}
    
    var teamInfo: [String:Any] = [:]
    
}
