//
//  ActivityData.swift
//  FireBaseTesting
//
//  Created by Rama Milaneh on 11/15/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import Firebase

// MARK: - Create Model Data

struct Activity {
    
    var name: String
    var owner: String
    var date: String
    var image: String
    var description: String
    var location: String
//    var attendees: [String]
// var image: UIImage?
    let reference : FIRDatabaseReference?
   
    // Mark: - initializer for activity object
    
    init(owner: String, name: String, date: String, image: String, location: String, description: String) {
        
        self.name = name
        self.owner = owner
        self.date = date
        self.image = image
        self.location = location
        self.description = description
        self.reference = nil
    }
    
    
    // Mark: - creating objects using firbase data
    init(snapshot: FIRDataSnapshot) {
        
        let snapshotValue = snapshot.value as! [String: Any]
        name = snapshotValue["name"] as! String
        owner = snapshotValue["owner"] as! String
        date = snapshotValue["date"] as! String
        image = snapshotValue["image"] as! String
        location = snapshotValue["location"] as! String
        description = snapshotValue["description"] as! String
        reference = snapshot.ref
    }
    
    // Mark: - create a dictionary
    
    func toAnyObject() -> Any {
        
        return [
            "name":name,
            "owner":owner,
            "date":date,
           "image":image,
           "location":location,
           "description":description
        ]
    }
    
    
    
}
