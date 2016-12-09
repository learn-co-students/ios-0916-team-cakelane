//
//  ActivityDetailsViewController.swift
//  CakeLane
//
//  Created by Alexey Medvedev on 12/5/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import UIKit
import Firebase

class ActivityDetailsViewController: UIViewController {
    
    var detailView: ActivityDetailsView!
    
    let teamID = UserDefaults.standard.string(forKey: "teamID") ?? " "
    //    let firebaseClient = FirebaseClient.sharedInstance
    let slackID = FirebaseClient.sharedInstance.slackID
    //    let teamID = FirebaseClient.sharedInstance.teamID
    var selectedActivity: Activity?
    var editedActivity: Activity?
    var attendies = [String:Bool]()
//    let activityHandler = fir
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.detailView = ActivityDetailsView(frame: self.view.frame)
        self.view.addSubview(self.detailView)
        detailView.delegate = self

        print("in the viewDidLoad of the activitiesDetailVC")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        checkIfOwner()
        
    }
    
    // check if the user is the owner and update the view with the suitable buttons
    func checkIfOwner() {
        
        print("in checkIfOwner of the activitiesDetailVC")
        
        let activityRef = FIRDatabase.database().reference().child(teamID).child("activities").child((self.selectedActivity?.id)!)
        
        activityRef.observe(.value, with: { (snapshot) in
            
            print("in the activity observer of the activitiesDetailVC")
            
            
            // Check that we have a value before attempting to create an Activity
//            guard (snapshot.value != nil) else { print("snapshot is nil"); return }
            if let _ = snapshot.value as? [String: Any] {
                
                print("they say we've got deets")
                dump(snapshot)
                
                self.detailView.selectedActivity = Activity(snapshot: snapshot)
                self.editedActivity = self.detailView.selectedActivity
                
                self.attendies = self.detailView.selectedActivity.attendees
                if self.attendies.keys.contains(self.slackID){
                    self.detailView.adjustButtonTitle(isAttendee: true)
                    
                } else {
                    self.detailView.adjustButtonTitle(isAttendee: false)
                    
                }
                
                if self.detailView.selectedActivity.owner == self.slackID {
                    self.detailView.editButton.isHidden = false
                    self.detailView.deleteButton.isHidden = false
                    
                    self.detailView.joinButton.isHidden = true
                } else {
                    
                    self.detailView.editButton.isHidden = true
                    self.detailView.deleteButton.isHidden = true
                    self.detailView.joinButton.isHidden = false
                }
                
            }
            
        })
    }
    
    // go to the add activivty VC to edit the activity
    func editSelectedActivity() {
        performSegue(withIdentifier: "editActivity", sender: self)
        
    }
    
    // Segue to Add ActivityVC, ActivityDetailsVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editActivity" {
            let dest = segue.destination as! AddActivityController
            dest.selectedActivity = self.editedActivity
        }
    }
    
    
    // Dismiss View
    func dismissView() {
        
        print("about to dismiss details")
        
        let activityRef = FIRDatabase.database().reference().child(teamID).child("activities").child((self.selectedActivity?.id)!)
        
        activityRef.removeAllObservers()
        
        dismiss(animated: true, completion: nil)
        
    }
    
    // Join the user to the activity attendees and update firbase
    func joinActivity() {
        UIView.animate(withDuration: 0.3, animations: {
            self.detailView.joinButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            
        }, completion: { (success) in
            self.detailView.joinButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            
        })
        
        let key = self.detailView.selectedActivity?.id ?? ""
        let date = self.detailView.selectedActivity?.date ?? String(describing: Date())
        let newAttendingUser = [slackID:true]
        let newAttendingActivity: [String:String] = [key:date]
        
        FIRDatabase.database().reference().child(self.teamID).child("users").child(slackID).child("activities").child("activitiesAttending").updateChildValues(newAttendingActivity, withCompletionBlock: { error, ref in
            
            
            FIRDatabase.database().reference().child(self.teamID).child("activities").child(key).child("attending").updateChildValues(newAttendingUser, withCompletionBlock: { [unowned self] error, ref in
                
                self.detailView.adjustButtonTitle(isAttendee: true)
                
            })
            
        })
        
        
    }
    
    // make the user leave the activity and remove it from the firebase
    func leaveActivity() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.detailView.joinButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            
        }, completion: { (success) in
            self.detailView.joinButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            
        })
        
        let key = self.detailView.selectedActivity?.id ?? ""
        
        FIRDatabase.database().reference().child(self.teamID).child("users").child(slackID).child("activities").child("activitiesAttending").child(key).removeValue(completionBlock: { [unowned self] error, ref in
            
            FIRDatabase.database().reference().child(self.teamID).child("activities").child(key).child("attending").child(self.slackID).removeValue(completionBlock: { [unowned self] error, ref in
                
                self.detailView.adjustButtonTitle(isAttendee: false)
                
            })
            
        })
        
    }
    
}

// MARK: - ActivityDetailDelegate Methods
extension ActivityDetailsViewController: ActivityDetailDelegate {
    
    func closeButtonTapped(with sender: ActivityDetailsView) {
        dismissView()
    }
    
    func editButtonTapped(with sender: ActivityDetailsView) {
        editSelectedActivity()
        
        let key = self.detailView.selectedActivity?.id ?? ""
        
        FIRDatabase.database().reference().child(self.teamID).child("users").child(slackID).child("activities").child("activitiesAttending").child(key).removeValue(completionBlock: { [unowned self] error, ref in
            
            FIRDatabase.database().reference().child(self.teamID).child("activities").child(key).child("attending").child(self.slackID).removeValue(completionBlock: { [unowned self] error, ref in
                
                self.detailView.adjustButtonTitle(isAttendee: false)
                
            })
            
        })
        
    }
    
    func joinButtonTapped(with sender: ActivityDetailsView) {
        
        let activitiesRef = FIRDatabase.database().reference().child(self.teamID).child("activities").child((self.selectedActivity?.id)!)
        
        activitiesRef.observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
            
            DispatchQueue.main.async {
                
                self.joinActivity()
                
            }
        })
    }
    
    func leaveActivity(with sender: ActivityDetailsView) {
        leaveActivity()
    }
    
    func deleteActivity(with sender: ActivityDetailsView) {
        
        print("attempting to delete activity")
        
        let key = self.detailView.selectedActivity?.id ?? ""
        let activitiesRef = FIRDatabase.database().reference().child(self.teamID).child("activities").child((self.selectedActivity?.id)!)
        
        activitiesRef.removeValue()
        
        let selectedActivityRef = FIRDatabase.database().reference().child(self.teamID).child("users").child(slackID).child("activities").child("activitiesAttending").child(key)
        
        selectedActivityRef.removeValue()
        
        let usersActivityRef = FIRDatabase.database().reference().child(self.teamID).child("users").child(slackID).child("activities").child("activitiesCreated").child(key)
        
        usersActivityRef.removeValue { (error, ref) in
            self.dismissView()
        }
      //  print(self.detailView.selectedActivity.imageFirebaseStoragename)
        if let imageStorageName = self.detailView.selectedActivity.imageNameFirebaseStorage {

        let storageImageStorageRef = FIRStorage.storage().reference(forURL: "gs://cakelane-cea9c.appspot.com").child("activityImages").child("\(imageStorageName).png")
            print(imageStorageName)
            storageImageStorageRef.delete { (error) -> Void in
                if (error != nil) {
                    print("error")
                } else {
                    print("success")
                }
            }
            
        }
    }
    
}

