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
    let webhook: String?
    
    internal init(attachment: [String: Any]?) {
        id = attachment?["id"] as? String
        name = attachment?["name"] as? String
        domain = attachment?["domain"] as? String
        emailDomain = attachment?["email_domain"] as? String
        teemChannel = "**No Team Channel Set**"
        webhook = "**No Team Webhook Set**"
    }
    
    init(id: String, name: String, domain: String, emailDomain: String, teemChannel: String, webhook: String) {
        self.id = id
        self.name = name
        self.domain = domain
        self.emailDomain = emailDomain
        self.teemChannel = teemChannel
        self.webhook = webhook
    }
    
    internal var dictionary: [String: Any] {
        var attachment = [String: Any]()
        attachment["id"] = id
        attachment["name"] = name
        attachment["domain"] = domain
        attachment["emailDomain"] = emailDomain
        attachment["teemChannel"] = teemChannel
        attachment["webhook"] = webhook
        return attachment
    }
}

