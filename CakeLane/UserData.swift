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
    
    var firstName: String
    var lastName: String
    var hobbies: String = ""
    var isAdmin: Bool
    var email: String
    var activitiesCreated = [[String:String]]()
    var attendedActivities = [[String: String]]()
    let reference : FIRDatabaseReference?
    
    // Mark: - initializer for activity object
    
    init(dictinary: [String:Any]) {
        let profile = dictinary["profile"] as! [String:Any]
        let firstName = profile["first_name"] as? String ?? ""
        let lastName = profile["last_name"] as? String ?? ""
        let email = profile["email"] as? String ?? ""
        let isAdmin = dictinary["is_admin"] as? Bool ?? false
        self.isAdmin = isAdmin
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.reference = nil
    }
    
    
    // Mark: - creating objects using firbase data
  //  init(snapshot: FIRDataSnapshot) {
        
       // let snapshotValue = snapshot.value as! [String: Any]
//        name = snapshotValue["name"] as! String
//        owner = snapshotValue["owner"] as! String
//        date = snapshotValue["date"] as! String
        //reference = snapshot.ref
//    }
    
    // Mark: - create a dictionary
    
    func toAnyObject() -> Any {
        
        return [
//            "name":name,
//            "owner":owner,
//            "date":date
        ]
    }
    
    
    
}


