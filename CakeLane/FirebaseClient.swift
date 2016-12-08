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
        
        // access userProfile from singleton (passed from SlacAPIClient)
        let userProfile = FirebaseUsersDataStore.sharedInstance.primaryUser
        
        print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
        print(userProfile)
        print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
        
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
    
    // MARK: Retreieve dictionary from Firebase for user based on their SlackID (String)
    class func retrieveInfoDictionary(for userSlackID: String, with completion: @escaping ([String:Any])->()) {
        guard let teamID = UserDefaults.standard.string(forKey: "teamID") else {return}
        let userRef = FirebaseClient.sharedInstance.ref.child(teamID).child("users").child(userSlackID)
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            print(snapshot)
            print(snapshot.value)
            
            let dict = snapshot.value as! [String:Any]
            
            completion(dict)
            
        })
    }
    
    class func downloadAttendeeImages(for activity: Activity, with handler: @escaping ([UIImage])->()) {
        
        var arrayOfImages: [UIImage] = []
        
        func downloadImage(at url:String, completion: @escaping (Bool, UIImage)->()){
            let session = URLSession.shared
            let newUrl = URL(string: url)
            if let unwrappedUrl = newUrl {
                let request = URLRequest(url: unwrappedUrl)
                let task = session.dataTask(with: request) { (data, response, error) in
                    guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
                    
                    guard let image = UIImage(data: data) else { return }
                    completion(true, image)
                }
                task.resume()
            }
        }
        
        for (key, _) in activity.attendees {
            
            retrieveInfoDictionary(for: key, with: { (dict) in
                
                print("\n\n$$$$$$$$$$$$$$$$$$$$")
                print(key)
                print("\n\n$$$$$$$$$$$$$$$$$$$$\n\n")
                print(dict)
                print("\n\n$$$$$$$$$$$$$$$$$$$$")
                
                // ERROR WITH URL HERE
                guard let url = dict["image72"] as? String else { return }
                
                print("\n\n#############################")
                print(url)
                print("\n\n#############################")
                
                downloadImage(at: url, completion: { (success, image) in
                    arrayOfImages.append(image)
                    
                    print("\n\n#############################")
                    print(arrayOfImages)
                    print("\n\n#############################")
                    
                })
                
            })
            
        }
        print("We got here.")
        handler(arrayOfImages)
        
    }
    
}
