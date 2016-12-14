//
//  ActivityDetailsViewController.swift
//  CakeLane
//
//  Created by Alexey Medvedev on 12/5/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class ActivityDetailsViewController: UIViewController, MFMailComposeViewControllerDelegate  {

    var detailView: ActivityDetailsView!

    let firebaseClient = FIRDatabase.database().reference()
    let slackID = UserDefaults.standard.string(forKey: "slackID") ?? " "
    let teamID = UserDefaults.standard.string(forKey: "teamID") ?? " "
    var selectedActivity: Activity?
    var editedActivity: Activity?
    var attendies = [String:Bool]()

    override func viewDidLoad() {

        super.viewDidLoad()
        self.detailView = ActivityDetailsView(frame: self.view.frame)
        self.view.addSubview(self.detailView)
        detailView.delegate = self
        
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(true)

        checkIfOwner()

    }

    // check if the user is the owner and update the view with the suitable buttons
    func checkIfOwner() {

        let activityRef = FIRDatabase.database().reference().child(teamID).child("activities").child((self.selectedActivity?.id)!)

        activityRef.observe(.value, with: { (snapshot) in
            
            // Check that we have a value before attempting to create an Activity

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
                    self.detailView.reportButton.isHidden = true
                    self.detailView.deleteButton.isHidden = false

                    self.detailView.joinButton.isHidden = true
                } else {

                    self.detailView.editButton.isHidden = true
                    self.detailView.deleteButton.isHidden = true
                    self.detailView.joinButton.isHidden = false
                    self.detailView.reportButton.isHidden = false
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

        let alert = UIAlertController(title: "Delete Activity", message: "Are you sure you want to delete this activity?", preferredStyle: .alert)
        
         alert.addAction(UIAlertAction(title: "Confirm", style: .destructive) { [unowned self] (action: UIAlertAction!) in
            
            let key = self.detailView.selectedActivity?.id ?? ""
            let activitiesRef = FIRDatabase.database().reference().child(self.teamID).child("activities").child((self.selectedActivity?.id)!)
            
            activitiesRef.removeValue()
            
            let selectedActivityRef = FIRDatabase.database().reference().child(self.teamID).child("users").child(self.slackID).child("activities").child("activitiesAttending").child(key)
            
            selectedActivityRef.removeValue()
            
            let usersActivityRef = FIRDatabase.database().reference().child(self.teamID).child("users").child(self.slackID).child("activities").child("activitiesCreated").child(key)
            
            usersActivityRef.removeValue { (error, ref) in
                self.dismissView()
            }
            
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
          })

     
      alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        present(alert, animated: true)
    }
    
    // MARK: Send Report Email functions
    func reportButtonTapped(with sender: ActivityDetailsView) {
        
        let alert = UIAlertController(title: "Report Activity", message: "Are you sure you want to report this activity?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .destructive) { (action: UIAlertAction!) in
            
            if !MFMailComposeViewController.canSendMail() {
                
                self.showSendMailErrorAlert()
            }
            let composeMail = MFMailComposeViewController()
            
            composeMail.mailComposeDelegate = self
            
            composeMail.setToRecipients(["teem.feedback@gmail.com"])
            composeMail.setSubject("Feedback for Activity")
            composeMail.setMessageBody("Tell us your thoughts about this activity", isHTML: false)
            
            self.present(composeMail, animated: true, completion: nil)
        
        })
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        present(alert, animated: true)
    }
    
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,didFinishWith result: MFMailComposeResult, error: Error?) {
        let alertController = UIAlertController(title: nil, message: "Thanks for the Feedback", preferredStyle: UIAlertControllerStyle.alert)
        let thanks = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default)         
        alertController.addAction(thanks)
        controller.dismiss(animated: true) {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
}
