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
    
    var performedFirstAuth = false
    var webhook: [String:String]?
    var teamInfo: [String:Any] = [:]
    var channelListJSON: [[String:Any]] = [[:]]
    var teemChannelName: String = ""
    var teemChannelID: String = ""
    
    internal func getTeemChannel(with dictionary: [String:Any]) {
        let channels = dictionary["channels"] as! [[String:Any]]
        for (_,value) in channels.enumerated() {
//            print("\n\n\nThis is the index:\(index) \n& this is the value: \(value)")
            guard let channelName = value["name"] as? String else { return }
            guard let channelID = value["id"] as? String else { return }
            print("\n\n\nThis is the channelName:  \(channelName),\nand this is the ID: \(channelID)")
            if channelName == "teem_activities" {
                self.teamInfo["channelName"] = channelName
                self.teamInfo["channelID"] = channelID
            }
        }
        print("\n\n\nThis is the TeamStore Dictionary!!:  \(self.teamInfo)")
    }
}
