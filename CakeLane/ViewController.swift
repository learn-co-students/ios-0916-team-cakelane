//
//  ViewController.swift
//  FireBaseTesting
//
//  Created by Rama Milaneh on 11/14/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController , UITextFieldDelegate{
    
    var databaseReference = FIRDatabase.database().reference()
    
    @IBOutlet weak var activityName: UITextField!
    
    @IBOutlet weak var activityOwner: UITextField!
    
    @IBOutlet weak var activityDate: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Mark: - create an activity on firebase using textfield's information
    @IBAction func saveButton(_ sender: Any) {
        // create an activity
        
        let randomID = UUID().uuidString
        guard let unwrappedName = self.activityName.text else {return}
        let owner = self.activityOwner.text ?? ""
        let date = self.activityDate.text ?? ""
        let newActivity = Activity(owner: owner, name: unwrappedName, date: date)
        let addedActivity = self.databaseReference.child("activities").childByAutoId()
        let key = addedActivity.key
        addedActivity.setValue(newActivity.toAnyObject())
        
        // add activity with its ID to the user
        
        let newactivity = [randomID:[key,date]]
        self.databaseReference.child("users").child("slackUserID123434").child("activities").child("activitiesCreated").updateChildValues(newactivity)
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func dateTextfield(_ sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.long
        
        self.activityDate.text = dateFormatter.string(from: sender.date)
        
    }
    
    
}

