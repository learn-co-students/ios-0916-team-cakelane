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
    let slackID = UserDefaults.standard.string(forKey: "slackID") ?? " "
    let userFirstName = UserDefaults.standard.string(forKey: "firstName") ?? " "
    let userIcon = UserDefaults.standard.string(forKey: "image72") ?? " "
    let teamID = UserDefaults.standard.string(forKey: "teamID") ?? " "
    
    @IBOutlet weak var activityName: UITextField!
    @IBOutlet weak var activityDate: UITextField!
    @IBOutlet weak var activityLocation: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var activityImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        descriptionTextView.delegate = self
        // customize the description text view
        descriptionTextView.text = "Description"
        descriptionTextView.textColor = UIColor.lightGray
        descriptionTextView.layer.cornerRadius = 5
        descriptionTextView.clipsToBounds = true
        descriptionTextView.textContainer.maximumNumberOfLines = 10
        descriptionTextView.textContainer.lineBreakMode = .byCharWrapping
        descriptionTextView.font = UIFont(name: "TrebuchetMS-Bold", size: 14)
        // added gesture to the image with addImage func
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

        // unwrapping the textField input
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
        
        // 1- create an unige Id for the image
        let imageName = NSUUID().uuidString
        // 2- create a reference to the folder of images on the Firebase storage
        let storageRef = FIRStorage.storage().reference().child("activityImages").child("\(imageName).png")
        if let image = self.activityImage.image {
        // 3- covnerting the image from the UIImage picker and rezise it
            if let uploadData = UIImageJPEGRepresentation(image, 0.25) {
        // 4- upload the image to the storage
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
        // 5- get the url for the image from the storage
        if let activityImageUrl = metadata?.downloadURL()?.absoluteString {
            
        // upload the activity to Firebase 
            
            // 1- create an instance of activity by the textField info
        let newActivity = Activity(owner: self.slackID, name: unwrappedName, date: date, image: activityImageUrl, location: location, description: description)

                        // Create an attachment for the notification
                        
                        let newAttachment = Attachment(title: newActivity.name, pretext: "*New Activity:* \(newActivity.name) _by \(self.userFirstName)_. \n*Date:* \(newActivity.date)", authorName: "\(self.userFirstName)_.", authorIcon: self.userIcon, text: newActivity.description, imageURL: newActivity.image)
                        self.store.attachmentDictionary = newAttachment.dictionary
                                        SlackAPIClient.postSlackNotification()
                    
           // 2- check if the user is editing the activity and update the activity and the user's activity data
                        
        if self.isEdit {
            // 3- if the user is editing the activity we will update the value of the activity with the new info
            
         self.databaseReference.child(self.teamID).child("activities").child((self.selectedActivity?.id!)!).updateChildValues(newActivity.toAnyObject() as! [AnyHashable : Any])
            
            // 4- if the user is editing the activity we will update the value of the activity created by the user with the new info

            self.databaseReference.child(self.teamID).child("users").child(self.slackID).child("activities").child("activitiesCreated").updateChildValues([(self.selectedActivity?.id!)!:date])
                    }
            // 5- if the user not updating the activity and creating a new one
            else {
            
            // 6- create a new activity key by using the autoId
            let addedActivity = self.databaseReference.child(self.teamID).child("activities").childByAutoId()
            // 7- get the unique ID for the activity
            let key = addedActivity.key
            // 8- create a dictionary for the user to be the first attendee
            let newAttendingUser = [self.slackID:true]
            // 9- create a dictionary for the activity to add it to the user database
            let newactivity = [key:date]
            // 10- upload the new activity to the firebase with a dictionary value that is created by the function AnyObjece
            addedActivity.setValue(newActivity.toAnyObject())
            // 11- add the user to the attendees dictionary
            
        self.databaseReference.child(self.teamID).child("activities").child(key).child("attending").updateChildValues(newAttendingUser)
            // 12- add the activity to the activity created dic for the user
    self.databaseReference.child(self.teamID).child("users").child(self.slackID).child("activities").child("activitiesCreated").updateChildValues(newactivity)
            // 13- add the activity to the activity attending dic for the user

            self.databaseReference.child(self.teamID).child("users").child(self.slackID).child("activities").child("activitiesAttending").updateChildValues(newactivity)
                        }
                    }
                })

            }
        }
        // dismiss the view after saving the activity
        dismiss(animated: true, completion: nil)

    }

    //MARK: - UIDate Picker
    
    // add date picker to the Date field
    @IBAction func dateTextfield(_ sender: UITextField) {

        let datePickerView:UIDatePicker = UIDatePicker()
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    // customize the date picker and make the date text field value equals to the date picker value
    func datePickerValueChanged(sender: UIDatePicker) {

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.timeStyle = .long
        self.activityDate.text = dateFormatter.string(from: sender.date)

    }

    // Add Cancel Button to dismiss the view after clicking on it
    @IBAction func cancelButton(_ sender: Any) {

        dismiss(animated: true, completion: nil)
    }

    //  Add activity image func for the image's gesture
    func addImage() {

        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)

    }
    
    // MARK: - handling the placeholder for the textview

    // add a placeholder to the textView
    
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


    // fill the text fields with the selected activity info when the user is editing it

    
    func fillTextFields(with selectedActivity: Activity) {
        self.isEdit = true
        self.activityName.text = selectedActivity.name
        
        self.activityDate.text = selectedActivity.date
        
        self.activityLocation.text = selectedActivity.location
        self.activityImage.sd_setImage(with: URL(string: selectedActivity.image))
        self.descriptionTextView.textColor = UIColor.black
        self.descriptionTextView.text = selectedActivity.description
        

    }
    
    // change the size of the textview depends on the content size
        func textViewDidChange(_ textView: UITextView){
            
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.frame = newFrame
            
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
