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
    
    var databaseReference = FIRDatabase.database().reference()
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var activityName: UITextField!
    
    @IBOutlet weak var activityOwner: UITextField!
    
    @IBOutlet weak var activityDate: UITextField!
    
    @IBOutlet weak var activityLocation: UITextField!
    
    @IBOutlet weak var descriptionActivity: UITextView!
    
    @IBOutlet weak var activityImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // Mark: - create an activity on firebase using textfield's information
    
    @IBAction func saveButton(_ sender: Any) {
        
        // create an activity
        guard let unwrappedName = self.activityName.text else {return}
        let owner = self.activityOwner.text ?? ""
        var date = ""
        if self.activityDate.text == "" {
            date = String(describing: Date())
        }else {
            date = self.activityDate.text ?? ""
        }
        // upload image to the storage on Firebase
        let imageName = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference(forURL: "gs://cakelane-cea9c.appspot.com").child("activityImages").child("\(imageName).png")
        if let image = self.activityImage.image {
            if let uploadData = UIImagePNGRepresentation(image) {
                
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    if let locationImageUrl = metadata?.downloadURL()?.absoluteString {
                        
                        let newActivity = Activity(owner: owner, name: unwrappedName, date: date, image: locationImageUrl)
                        
                        let addedActivity = self.databaseReference.child("activities").childByAutoId()
                        let key = addedActivity.key
                        
                        addedActivity.setValue(newActivity.toAnyObject())
                        // add activity with its ID to the user
                        let newactivity = [key:date]
                        self.databaseReference.child("users").child("slackUserID123434").child("activities").child("activitiesCreated").updateChildValues(newactivity)
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
        
        self.activityDate.text = dateFormatter.string(from: sender.date)
        
    }
    
    // MARK: - Add Cancel Button
    
    @IBAction func cancelButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addImageButton(_ sender: Any) {
        
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
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

