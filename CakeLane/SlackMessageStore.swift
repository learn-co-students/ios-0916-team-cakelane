//
//  SlackMessageStore.swift
//  CakeLane
//
//  Created by Bejan Fozdar on 12/1/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import Foundation

class SlackMessageStore {
    
    static let sharedInstance = SlackMessageStore()
    fileprivate init() {}
    
    var attachmentDictionary: [String:Any] = [:]
    
}
