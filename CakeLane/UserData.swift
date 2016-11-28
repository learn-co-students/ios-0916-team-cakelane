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
    var username: String
    var firstName: String
    var lastName: String
    var email: String
    var isAdmin: Bool
    var image72: String
    var image512: String
    var timeZoneLabel: String
    
    // TODO: Integrate activities using Firebase
    var activitiesCreated = [[String:String]]()
    var attendedActivities = [[String: String]]()
    let reference : FIRDatabaseReference?
    
    // MARK: - initializer for activity object
    init(dictionary: [String:Any]) {
        let profile = dictionary["profile"] as! [String:Any]
        let username = dictionary["name"] as! String
        let firstName = profile["first_name"] as? String ?? ""
        let lastName = profile["last_name"] as? String ?? ""
        let email = profile["email"] as? String ?? ""
        let isAdmin = dictionary["is_admin"] as? Bool ?? false
        let image72 = profile["image_72"] as? String ?? ""
        let image512 = profile["image_512"] as? String ?? ""
        let timeZoneLabel = dictionary["tz_label"] as? String ?? ""
        
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.isAdmin = isAdmin
        self.image72 = image72
        self.image512 = image512
        self.timeZoneLabel = timeZoneLabel
        
        self.reference = nil
    }
    
    
    // MARK: - creating objects using firbase data
  //  init(snapshot: FIRDataSnapshot) {
        
       // let snapshotValue = snapshot.value as! [String: Any]
//        name = snapshotValue["name"] as! String
//        owner = snapshotValue["owner"] as! String
//        date = snapshotValue["date"] as! String
        //reference = snapshot.ref
//    }
    
    // MARK: - create a dictionary
    
    func toAnyObject() -> Any {
        
        return [
//            "name":name,
//            "owner":owner,
//            "date":date
        ]
    }
    
        
}


