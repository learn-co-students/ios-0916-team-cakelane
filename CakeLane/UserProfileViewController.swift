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
        
        // MARK: access user defaults
        let defaults = UserDefaults.standard
        guard let slackID = defaults.string(forKey: "slackID") else { return }
        guard let teamID = defaults.string(forKey: "teamID") else { return }
        guard let username = defaults.string(forKey: "username") else { return }
        guard let firstName = defaults.string(forKey: "firstName") else { return }
        guard let lastName = defaults.string(forKey: "lastName") else { return }
        guard let email = defaults.string(forKey: "email") else { return }
        // TODO: check if user is admin ~ present different profile view
        guard let isAdmin = defaults.string(forKey: "isAdmin") else { return }
        guard let image72url = defaults.string(forKey: "image72") else { return }
        guard let image512url = defaults.string(forKey: "image512") else { return }
        guard let timeZoneLabel = defaults.string(forKey: "timeZoneLabel") else { return }
        
        // create form via eureka
        form +++ Section("Basic Info")
            
            <<< TextRow(){ row in
                row.title = "First Name"
                row.placeholder = firstName
            }
            
            <<< TextRow(){ row in
                row.title = "Last Name"
                row.placeholder = lastName
            }
            
            <<< TextRow(){ row in
                row.title = "Email"
                row.placeholder = email
            }
            
//            <<< PhoneRow() {
//                $0.title = "Phone Number"
//                $0.placeholder = "And your number here"
//            }
            
            <<< TextRow(){ row in
                row.title = "Time Zone"
                row.placeholder = timeZoneLabel
            }
    }
    
    // MARK: Retrieve user profile data from Slack API
    func checkSlackForProfileChanges() {
        
    }
    
    // MARK: If there are changes on Slack, update User Defaults & form contents
    func updateUserProfileLocally() {
        
    }
    
    // MARK: If there are changes on Slack, update user profile data on Firebase
    func updateUserProfileFirebase() {
        
    }
    
}
