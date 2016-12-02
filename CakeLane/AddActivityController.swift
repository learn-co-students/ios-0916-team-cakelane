//
//  ViewController.swift
//  FireBaseTesting
//
//  Created by Rama Milaneh on 11/14/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase



class AddActivityController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var store = SlackMessageStore.sharedInstance

    var databaseReference = FIRDatabase.database().reference()
    let imagePicker = UIImagePickerController()
    var selectedActivity: Activity?
    var isEdit: Bool = false

    @IBOutlet weak var activityName: UITextField!
    @IBOutlet weak var activityDate: UITextField!
    @IBOutlet weak var activityLocation: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var activityImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        descriptionTextView.delegate = self
        descriptionTextView.text = "Description"
        descriptionTextView.textColor = UIColor.lightGray
        descriptionTextView.layer.cornerRadius = 5
        descriptionTextView.clipsToBounds = true
        descriptionTextView.font = UIFont(name: "TrebuchetMS-Bold", size: 14)
        self.activityImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addImage)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        if self.selectedActivity != nil {
            fillTextFields(with: selectedActivity!)
        }
    }


    // Mark: - create an activity on firebase using textfield's information

    @IBAction func saveButton(_ sender: Any) {

        // create an activity
        let unwrappedName = self.activityName.text ?? " "
        let location = self.activityLocation.text ?? " "
        let description = self.descriptionTextView.text ?? " "
        var date = ""
        if self.activityDate.text == "" {
            date = String(describing: Date())
        }else {
            date = self.activityDate.text ?? ""
        }

        // upload image to the storage on Firebase
        let imageName = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("activityImages").child("\(imageName).png")
        if let image = self.activityImage.image {
            if let uploadData = UIImageJPEGRepresentation(image, 0.25){
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    if let activityImageUrl = metadata?.downloadURL()?.absoluteString {
                        
                        guard let slackID = UserDefaults.standard.string(forKey: "slackID") else {return}
                        guard let userFirstName = UserDefaults.standard.string(forKey: "firstName") else {return}
                        guard let userIcon = UserDefaults.standard.string(forKey: "image72") else {return}
                        
                        // Create an activity on Firebase
                        
                        let newActivity = Activity(owner: slackID, name: unwrappedName, date: date, image: activityImageUrl, location: location, description: description)
                    
                        let newAttachment = Attachment(title: newActivity.name, pretext: "*New Activity:* \(newActivity.name) _by \(userFirstName)_. \n*Date:* \(newActivity.date)", authorName: "\(userFirstName)_.", authorIcon: userIcon, text: newActivity.description, imageURL: newActivity.image)
                        self.store.attachmentDictionary = newAttachment.dictionary
                        print("selfstoreattachment Dictionary!!!!! ++++++++++++++\(self.store.attachmentDictionary)")
                    
                    SlackAPIClient.postSlackNotification()

                    
                        guard let teamID = UserDefaults.standard.string(forKey: "teamID") else {return}
                        
                        if self.isEdit {
                            self.databaseReference.child(teamID).child("activities").child((self.selectedActivity?.id!)!).updateChildValues(newActivity.toAnyObject() as! [AnyHashable : Any])
                            self.databaseReference.child(teamID).child("users").child(slackID).child("activities").child("activitiesCreated").updateChildValues([(self.selectedActivity?.id!)!:date])
                        } else {
                            
                let addedActivity = self.databaseReference.child(teamID).child("activities").childByAutoId()
                            let key = addedActivity.key
                          
                            let newAttendingUser = [slackID:true]
                            
                                addedActivity.setValue(newActivity.toAnyObject())
                            self.databaseReference.child(teamID).child("activities").child(key).child("attending").updateChildValues(newAttendingUser)
                            
                            // add activity with its ID to the user
                            let newactivity = [key:date]
                            
                            self.databaseReference.child(teamID).child("users").child(slackID).child("activities").child("activitiesCreated").updateChildValues(newactivity)
                            self.databaseReference.child(teamID).child("users").child(slackID).child("activities").child("activitiesAttending").updateChildValues(newactivity)
                        }
                    }
                })

            }
        }
        dismiss(animated: true, completion: nil)

    }

    // MARK: - add date picker to the Date field

    @IBAction func dateTextfield(_ sender: UITextField) {

        let datePickerView:UIDatePicker = UIDatePicker()
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }

    func datePickerValueChanged(sender: UIDatePicker) {

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.timeStyle = .long
        self.activityDate.text = dateFormatter.string(from: sender.date)

    }

    // MARK: - Add Cancel Button

    @IBAction func cancelButton(_ sender: Any) {

        dismiss(animated: true, completion: nil)
    }

    // MARK: - Add activity image
    func addImage() {

        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)

    }

    func textViewDidBeginEditing(_ textView: UITextView) {

        if descriptionTextView.textColor == UIColor.lightGray {
            descriptionTextView.text = nil
            descriptionTextView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {

        if descriptionTextView.text.isEmpty {
            descriptionTextView.text = "Description"
            descriptionTextView.textColor = UIColor.lightGray
        }
    }

    func fillTextFields(with selectedActivity: Activity) {

        self.activityName.text = selectedActivity.name
        
        self.activityDate.text = selectedActivity.date
        
        self.activityLocation.text = selectedActivity.location

        DispatchQueue.main.async {
            self.activityImage.image = selectedActivity.imageview
        }
        self.descriptionTextView.textColor = UIColor.black
        self.descriptionTextView.text = selectedActivity.description
        self.isEdit = true

    }


}

// MARK: - UIImagePickerControllerDelegate Methods
extension AddActivityController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var newImage: UIImage
        if let possibleImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        OperationQueue.main.addOperation {
            self.activityImage.contentMode = .scaleToFill
            self.activityImage.image = newImage
        }

        dismiss(animated: true, completion: nil)
    }


    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}
