//
//  Team.swift
//  CakeLane
//
//  Created by Bejan Fozdar on 12/7/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import Foundation


struct TeamInfo {
    
    let id: String?
    let name: String?
    let domain: String?
    let emailDomain: String?       // Not sure how to use this right now
    let teemChannel: String?
    let teemChannelID: String?
    let webhook: String?
    
    init(dictionary: [String: Any]?) {
        id = dictionary?["id"] as? String
        name = dictionary?["name"] as? String
        domain = dictionary?["domain"] as? String
        emailDomain = dictionary?["email_domain"] as? String
        teemChannel = "**No Team Channel Set**"
        teemChannelID = "**No Team Channel ID Set**"
        webhook = "**No Team Webhook Set**"
    }
    
    init(id: String, name: String, domain: String, emailDomain: String, teemChannel: String, teemChannelID: String, webhook: String) {
        self.id = id
        self.name = name
        self.domain = domain
        self.emailDomain = emailDomain
        self.teemChannel = teemChannel
        self.teemChannelID = teemChannelID
        self.webhook = webhook
    }
    
    internal var dictionary: [String: Any] {
        var teamParameters = [String: Any]()
        teamParameters["id"] = id
        teamParameters["name"] = name
        teamParameters["domain"] = domain
        teamParameters["emailDomain"] = emailDomain
        teamParameters["teemChannel"] = teemChannel
        teamParameters["teemChannelID"] = teemChannelID
        teamParameters["webhook"] = webhook
        return teamParameters
    }
}

