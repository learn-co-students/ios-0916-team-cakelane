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
    let firebaseClient = FirebaseClient.sharedInstance
    let slackID = FirebaseClient.sharedInstance.slackID
    let teamID = FirebaseClient.sharedInstance.teamID
    var selectedActivity: Activity?
    var blurEffectView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
//        blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = view.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
//        self.view.addSubview(blurEffectView)
//        // Set frame for Activity Details View
//        let frame = CGRect(x: 0.02*self.view.frame.maxX, y: 0.02*self.view.frame.maxY, width: self.view.frame.width*0.95, height: self.view.frame.height*0.96)
        
        // MARK: Instantiate Activity Details View
        self.detailView = ActivityDetailsView(frame: self.view.frame)
        self.view.addSubview(self.detailView)
    }
    
    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        super.viewWillAppear(true)
    
    
        let activitiesRef = firebaseClient.ref.child(teamID).child("activities").child((self.selectedActivity?.id)!)
        activitiesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.detailView.selectedActivity = Activity(snapshot: snapshot)
             self.detailView.closeButton.addTarget(self, action: #selector(self.dismissView), for: .allTouchEvents)
            
            if self.detailView.selectedActivity.owner == self.slackID {
                print("##############1")
                print(self.detailView.selectedActivity.owner)
                print(self.slackID)
                self.detailView.editButton.isHidden = false
                self.detailView.joinButton.isHidden = true
                self.detailView.editButton.addTarget(self, action: #selector(self.editSelectedActivity), for: .allTouchEvents)
                
            }else {
                print("##############2")
                print(self.detailView.selectedActivity.owner)
                print(self.slackID)
                self.detailView.editButton.isHidden = true
                self.detailView.joinButton.isHidden = false
            }
        })
    }
    
    func editSelectedActivity() {
        performSegue(withIdentifier: "editActivity", sender: self)
        
    }
    
    // Segue to Add ActivityVC, ActivityDetailsVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editActivity" {
            let dest = segue.destination as! AddActivityController
            dest.selectedActivity = self.detailView.selectedActivity
        }
    }


            //
            //            self.detailView.downloadImage(at: (self.detailView.selectedActivity?.image)!, completion: { (success, image) in
            //                
            //                self.detailView.selectedActivity?.imageview?.image = image
            //                
            //                OperationQueue.main.addOperation {
            //
            //                        self.detailView.joinButton.isHidden = true
            //                    } else {
            //                        
            //                        self.detailView.editButton.isHidden = true
            //                        if self.detailView.selectedActivity.attendees.keys.contains(self.slackID) {
            //                            self.detailView.joinButton.setTitle("Leave", for: .normal)
            //                            
            //                            
            //                        } else {
            //                            
            //                            self.detailView.joinButton.setTitle("Join Us!!!", for: .normal)
            //                            
            //                        }
            //                        self.detailView.joinButton.addTarget(self, action: #selector(self.joinOrLeaveToActivity), for: .allTouchEvents)
            //                        
            //                    }
            //                    
            //                }
            //                
            //            })
            // FIX LINES 62 & 77
            //
            
            //            self.view.addSubview(self.blurEffectView)
            
            
            
            //        })
            
//            self.detailView.alpha = 0
//            UIView.animate(withDuration: 0.4 , animations: {
//                self.detailView.transform = CGAffineTransform(scaleX: 1, y: 1)
//                self.detailView.alpha = 1
//            });
//        })

//    // MARK: Dismiss View
    func dismissView() {
    dismiss(animated: true, completion: nil)
    }
    
    // MARK: Edit Button takes user to Edit Activity VC
        
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
