//
//  ViewController.swift
//  FireBaseTesting
//
//  Created by Rama Milaneh on 11/14/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase

class AddActivityController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let newActivity = Activity(owner: owner, name: unwrappedName, date: date)
        let addedActivity = self.databaseReference.child("activities").childByAutoId()
        let key = addedActivity.key
        addedActivity.setValue(newActivity.toAnyObject())
        
        // add activity with its ID to the user
        
        let newactivity = [key:date]
        self.databaseReference.child("users").child("slackUserID123434").child("activities").child("activitiesCreated").updateChildValues(newactivity)
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
    
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
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

