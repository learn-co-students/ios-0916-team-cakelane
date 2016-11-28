//
//  UserProfileViewController.swift
//  CakeLane
//
//  Created by Alexey Medvedev on 11/28/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import UIKit
import Eureka

class UserProfileViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // добавить navigation bar
        
        // добавить back
        
        // добавить edit
        
        // добавить logout
        
        // create form via eureka
        form +++ Section("Basic Info")
            
            // MARK: Core Data fetch request
            
            <<< TextRow() { row in
                row.title = "First Name"
                row.placeholder = "Enter first name here"
            }
            
            <<< TextRow() { row in
                row.title = "Last Name"
                row.placeholder = "Enter last name here"
            }
            
            <<< TextRow() { row in
                row.title = "Email"
                row.placeholder = "Enter email here"
            }
            
            <<< PhoneRow() {
                $0.title = "Phone Number"
                $0.placeholder = "And your number here"
            }
            
            <<< TextRow() { row in
                row.title = "Time Zone"
                row.placeholder = "Enter time zone here"
            }
    }
    
    // MARK: Retrieve user profile data from Slack API
    func checkSlackForProfileChanges() {
        
    }
    
    // MARK: If there are changes on Slack, update Core Data & form contents
    func updateUserProfileLocally() {
        
    }
    
    // MARK: If there are changes on Slack, update user profile data on Firebase
    func updateUserProfileFirebase() {
        
    }
    
}
