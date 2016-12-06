//
//  FirebaseClient.swift
//  CakeLane
//
//  Created by Alexey Medvedev on 12/5/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import Foundation
import Firebase

class FirebaseClient {
    
    static let sharedInstance = FirebaseClient()
    private init() { }
    
    let ref = FIRDatabase.database().reference()
    
    let slackID = UserDefaults.standard.string(forKey: "slackID") ?? " "
    let teamID = UserDefaults.standard.string(forKey: "teamID") ?? " "
    
    // MARK: Write current user's info to Firebase
    class func writeUserInfo() {
        
        guard let userProfile = UserDefaults.standard.object(forKey: "userProfile") as? User else { return }
        
        let reference = FirebaseClient.sharedInstance.ref
        
        reference.child(userProfile.teamID).child("users").child(userProfile.slackID).setValue(userProfile.toAnyObject())
        
    }
    
    // MARK: Update activities array from Firebase using desired filter
    class func retrieveActivities(with filter: @escaping ([Activity]) -> [Activity], handler: @escaping ([Activity]) -> Void) {
        
        
        let teamID = UserDefaults.standard.string(forKey: "teamID") ?? " "
        let activitiesRef = sharedInstance.ref.child(teamID).child("activities")
        var newActivities = [Activity]()
        
        activitiesRef.observe(.value, with: { (snapshot) in
            
            for activity in snapshot.children {
                let item = Activity(snapshot: activity as! FIRDataSnapshot)
                
                newActivities.append(item)
            }
            newActivities = filter(newActivities)
            
            handler(newActivities)
        })
        
    }
    
}
