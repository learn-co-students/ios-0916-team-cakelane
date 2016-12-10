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

    // MARK: Write current user's info to Firebase
    class func writeUserInfo() {

        ///////////////////////// CAN BE IMPROVED
        
        // access userProfile from singleton (passed from SlacAPIClient)
        let userProfile = FirebaseUsersDataStore.sharedInstance.primaryUser
        FIRDatabase.database().reference().child(userProfile.teamID).child("users").child(userProfile.slackID).setValue(userProfile.toAnyObject())

    }

    // MARK: Update activities array from Firebase using desired filter
    class func retrieveActivities(with filter: @escaping ([Activity]) -> [Activity], handler: @escaping ([Activity]) -> Void) {

        let teamID = UserDefaults.standard.string(forKey: "teamID") ?? " "
        let activitiesRef = FIRDatabase.database().reference().child(teamID).child("activities")
        var newActivities: [Activity] = []

        ////////////////////////////////////////////////////

        activitiesRef.observe(.value, with: { (snapshot) in

            for activity in snapshot.children {
                let item = Activity(snapshot: activity as! FIRDataSnapshot)

                newActivities.append(item)
            }
            print("\n\n\n\n\n*************")
            print(newActivities)
            print("*************\n\n\n\n\n")
            newActivities = filter(newActivities)

            print("\n\n\n\n\n*************")
            print(newActivities)
            print("*************\n\n\n\n\n")

            handler(newActivities)

            print("\n\n\n\n\n*************")
            print(newActivities)
            print("*************\n\n\n\n\n")
        })

    }

    // MARK: Retreieve dictionary from Firebase for user based on their SlackID (String)
    class func retrieveInfoDictionary(for userSlackID: String, with completion: @escaping ([String:Any])->()) {
        guard let teamID = UserDefaults.standard.string(forKey: "teamID") else {return}
        let userRef = FIRDatabase.database().reference().child(teamID).child("users").child(userSlackID)
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in

            guard let dict = snapshot.value as? [String : Any] else { print("Whats up???????"); return }
            completion(dict)

        })

    }

    class func downloadImage(at url:String, completion: @escaping (Bool, UIImage)->()){
        let session = URLSession.shared
        let newUrl = URL(string: url)
        if let unwrappedUrl = newUrl {
            let request = URLRequest(url: unwrappedUrl)
            let task = session.dataTask(with: request) { (data, response, error) in

                // ASYNCHRONOUS LOADING: ALL ITERATIONS NO USERS APPENDED (USERS.COUNT) -> THEN, INTERATE & PRINT DICT & USER INSTANCE FOR EACH KEY

                guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }

                guard let image = UIImage(data: data) else { return }
                completion(true, image)
            }
            task.resume()
        }
    }

    //////////////////////////////////////

    class func downloadAttendeeImagesAndInfo(for activity: Activity, with handler: @escaping ([UIImage], [User])->Void) {

        // this
        var arrayOfImages: [UIImage] = []
        var users: [User] = []

        for (key, _) in activity.attendees {

            let dictionary = retrieveInfoDictionary(for: key, with: { (dict) in

                // MAKE SURE YOU GET DICT

                print("\nCODECODECODECODECODE")
                print("CODECODECODECODECODE")
                print("CODECODECODECODECODE")

                // dict prints, after a while

                print("this is a problem.")
                print("dict has values: confirmed: ~~~WINNING~~~")
                print(dict)
                dump(dict)
                print("CODECODECODECODECODE")
                print("CODECODECODECODECODE")
                print("CODECODECODECODECODE\n\n\n")

                // initialize user
                let user = User(snapShot: dict)
                print("*")

                print(user)

                print("Code\n\n\n\n\n\n\n\n")
                users.append(user)

                guard let url = dict["image72"] as? String else { return }

                downloadImage(at: url, completion: { (success, image) in

                    arrayOfImages.append(image)
                    handler(arrayOfImages, users)
                    
                    
                    print("We got here.")
                    print("\n**********************")
                    print(image)
                    print("\n**********************")
                    

                })

            })

            print("LOOPING THROUGH USERS ARRAY AT THE END OF EACH LOOP")
            print("NEVER GOT TO APPEND USER -> USERS.COUNT DOESN\"T GROW")
            print(users.count)


            print("\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")

            print("IS THIS DICTIONARY EMPTY???")
            print("IS THIS DICTIONARY EMPTY???")
            print(dictionary)
            print("IS THIS DICTIONARY EMPTY???")
            print("IS THIS DICTIONARY EMPTY???")

            print("\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
            print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")

        }

    }

}
