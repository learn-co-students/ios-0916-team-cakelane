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
    
//    var channelListDict: [[String:Any]] = [[:]]
    
    var teemChannel: String = ""
    
//    public func getTeemChannel(with dictionary: [[String:Any]]) -> String {
//        
//        for (index,value) in dictionary.enumerated() {
//            print("This is the index:\(index) & this is the \(value)")
//            //            for index in value.enumerated() {
//            //
//            //            }
//        }
//        
//        return ""
//    }
    
}
