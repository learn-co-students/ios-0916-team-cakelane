//
//  UserData.swift
//  CakeLane
//
//  Created by Rama Milaneh on 11/17/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import Foundation
import Firebase

// MARK: - Create Model Data

struct User {
    
    // TODO: Add phone number property (available through Slack)
    var slackID: String
    var teamID: String
    var username: String
    var firstName: String
    var lastName: String
    var email: String
    var image72: String
    var image512: String
    var timeZoneLabel: String
    
    var isAdmin: Bool
    var isOwner: Bool
    var isPrimaryOwner: Bool
    
    // Integrate activities using Firebase of array pf dictionary of strings has 2 elements: attending activities & created ones
    // Key = AcitivityID, Value = Formatted Date
    var activities: [String:Any]
    
    // MARK: - Firebase initializer for user object
    init(snapShot: [String:Any]) {
        self.slackID = snapShot["slackID"] as! String
        self.teamID = snapShot["teamID"] as! String
        self.firstName = snapShot["firstName"] as! String
        self.lastName = snapShot["lastName"] as! String
        self.image72 = snapShot["image72"] as! String
        self.image512 = snapShot["image512"] as! String
        self.email = snapShot["email"] as! String
        self.username = snapShot["username"] as! String
        self.timeZoneLabel = snapShot["timeZoneLabel"] as! String
        self.teamID = snapShot["teamID"] as! String
        self.isAdmin = snapShot["isAdmin"] as! Bool
        self.isOwner = false
        self.isPrimaryOwner = false
        self.activities = snapShot["activities"] as? [String:Any] ?? [:]
    }
    
    // Slack initializer
    init(dictionary: [String:Any]) {
        let slackID = dictionary["id"] as! String
        let teamID = dictionary["team_id"] as! String
        let profile = dictionary["profile"] as! [String:Any]
        let username = dictionary["name"] as! String
        let firstName = profile["first_name"] as? String ?? ""
        let lastName = profile["last_name"] as? String ?? ""
        let email = profile["email"] as? String ?? ""
        let image72 = profile["image_72"] as? String ?? ""
        let image512 = profile["image_512"] as? String ?? ""
        let timeZoneLabel = dictionary["tz_label"] as? String ?? ""
        
        let isAdmin = dictionary["is_admin"] as? Bool ?? false
        let isOwner = dictionary["is_owner"] as? Bool ?? false
        let isPrimaryOwner = dictionary["is_primary_owner"] as? Bool ?? false
        
        self.slackID = slackID
        self.teamID = teamID
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.image72 = image72
        self.image512 = image512
        self.timeZoneLabel = timeZoneLabel
        
        self.isAdmin = isAdmin
        self.isOwner = isOwner
        self.isPrimaryOwner = isPrimaryOwner
        
        self.activities = [:]
        
    }
    
    init() {
        self.slackID = ""
        self.teamID = ""
        self.username = ""
        self.firstName = ""
        self.lastName = ""
        self.email = ""
        self.image72 = ""
        self.image512 = ""
        self.timeZoneLabel = ""
        
        self.isAdmin = false
        self.isOwner = false
        self.isPrimaryOwner = false
        
        self.activities = [:]
    }
    
    // MARK: - create a dictionary
    func toAnyObject() -> Any {
        
        return [
            "slackID": slackID,
            "teamID": teamID,
            "username": username,
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "isAdmin": isAdmin,
            "image72": image72,
            "image512": image512,
            "timeZoneLabel": timeZoneLabel
        ]
    }
        
}


