//
//  ActivityDetailsViewController.swift
//  CakeLane
//
//  Created by Alexey Medvedev on 12/5/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import UIKit

class ActivityDetailsViewController: UIViewController {

    var detailView: ActivityDetailsView!
    let firebaseClient = FirebaseClient.sharedInstance
    let slackID = FirebaseClient.sharedInstance.slackID
    let teamID = FirebaseClient.sharedInstance.teamID
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: Set frame for Activity Details View
        let frame = CGRect(x: 0.02*self.view.frame.maxX, y: 0.02*self.view.frame.maxY, width: self.view.frame.width*0.95, height: self.view.frame.height*0.96)
        
        // MARK: Instantiate Activity Details View
        self.detailView = ActivityDetailsView(frame: frame)
        
        
        let activitiesRef = firebaseClient.ref.child(teamID).child("activities").child((self.detailView.selectedActivity?.id)!)
        activitiesRef.observe(.value, with: { (snapshot) in
            
            self.detailView.selectedActivity = Activity(snapshot: snapshot)
            
            self.detailView.downloadImage(at: (self.detailView.selectedActivity?.image)!, completion: { (success, image) in
                
                self.detailView.selectedActivity?.imageview?.image = image
                
                OperationQueue.main.addOperation {
                    if self.detailView.selectedActivity.owner == self.slackID {
                        self.detailView.editButton.isHidden = false
                        self.detailView.editButton.addTarget(self, action: #selector(self.editSelectedActivity), for: .allTouchEvents)
                        self.detailView.joinButton.isHidden = true
                    } else {
                        
                        self.detailView.editButton.isHidden = true
                        if self.detailView.selectedActivity.attendees.keys.contains(self.slackID) {
                            self.detailView.joinButton.setTitle("Leave", for: .normal)
                            
                            
                        } else {
                            
                            self.detailView.joinButton.setTitle("Join Us!!!", for: .normal)
                            
                        }
                        self.detailView.joinButton.addTarget(self, action: #selector(self.joinOrLeaveToActivity), for: .allTouchEvents)
                        
                    }
                    
                }
                
            })
            // FIX LINES 62 & 77
//            self.detailView.closeButton.addTarget(self, action: #selector(self.dismissView), for: .allTouchEvents)
            
//            self.view.addSubview(self.blurEffectView)
            
            self.view.addSubview(self.detailView)
            
        })
        
        self.detailView.alpha = 0
        UIView.animate(withDuration: 0.4 , animations: {
            self.detailView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.detailView.alpha = 1
        });
    }

//    // MARK: Dismiss View
//    func dismissView() {
//        UIView.transition(with: self.activitiesCollectionView, duration: 0.8, options: .transitionCrossDissolve, animations:{
//            self.blurEffectView.removeFromSuperview()
//            self.detailView.removeFromSuperview()
//            self.activitiesCollectionView.alpha = 1
//        }) { _ in }
//    }
    
    // MARK: Edit Button takes user to Edit Activity VC
    func editSelectedActivity() {
        performSegue(withIdentifier: "editActivity", sender: self)
        
    }
    
    // MARK: Join/Leave Button
    func joinOrLeaveToActivity() {
        
        let key = self.detailView.selectedActivity?.id ?? ""
        let date = self.detailView.selectedActivity?.date ?? String(describing: Date())
        let newAttendingUser = [slackID:true]
        let newAttendingActivity: [String:String] = [key:date]
        
        if self.detailView.joinButton.titleLabel?.text == "Join Us!!!" {
            self.firebaseClient.ref.child(firebaseClient.teamID).child("users").child(slackID).child("activities").child("activitiesAttending").updateChildValues(newAttendingActivity)
            
            self.firebaseClient.ref.child(firebaseClient.teamID).child("activities").child(key).child("attending").updateChildValues(newAttendingUser)
        } else {
            
            self.firebaseClient.ref.child(firebaseClient.teamID).child("users").child(slackID).child("activities").child("activitiesAttending").child(key).removeValue()
            
            self.firebaseClient.ref.child(firebaseClient.teamID).child("activities").child(key).child("attending").child(slackID).removeValue()
        }
        
    }
    
}
