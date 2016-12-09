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
    
 //     let slackID = UserDefaults.standard.string(forKey: "slackID") ?? " "
    let teamID = UserDefaults.standard.string(forKey: "teamID") ?? " "
//    let firebaseClient = FirebaseClient.sharedInstance
   let slackID = FirebaseClient.sharedInstance.slackID
//    let teamID = FirebaseClient.sharedInstance.teamID
    var selectedActivity: Activity?
    var editedActivity: Activity?
    var attendies = [String:Bool]()

    override func viewDidLoad() {

        super.viewDidLoad()
        self.detailView = ActivityDetailsView(frame: self.view.frame)
        self.view.addSubview(self.detailView)
        detailView.delegate = self
        checkIfOwner()
    }

    override func viewWillAppear(_ animated: Bool) {
        print("@@@@@@@@@@@@@@@@@@@6")

        super.viewWillAppear(true)
        print("@@@@@@@@@@@@@@@@@@@7")

        checkIfOwner()

    }

    // check if the user is the owner and update the view with the suitable buttons
    func checkIfOwner() {

        let activitiesRef = FIRDatabase.database().reference().child(teamID).child("activities").child((self.selectedActivity?.id)!)
        print("@@@@@@@@@@@@@@@@@@@8")

        activitiesRef.observe(.value, with: { (snapshot) in

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
                self.detailView.joinButton.isHidden = true
            } else {

                self.detailView.editButton.isHidden = true
                
                
                self.detailView.joinButton.isHidden = false
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


}

