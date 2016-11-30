//
//  UserProfileViewController.swift
//  CakeLane
//
//  Created by Alexey Medvedev on 11/28/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import UIKit

// TODO: add pull to refresh user info from Slack functionality

class UserInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // UI elements
    @IBOutlet weak var blurredProfileImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userInfoTableView: UITableView!
    // settings available to Team Owner/Admin ~ hide/show depending on user permissions
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    var userInfo = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateUserInfo()
        
        // access user defaults
        let defaults = UserDefaults.standard

        // MARK: Handle Logout Button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(promptForConfirmation))
        
        // MARK: check if user is admin ~ present different profile view options
        guard let isPrimaryOwner = defaults.string(forKey: "isPrimaryOwner") else { return }
        
        // show admin settings button
        if isPrimaryOwner != "0" {
            settingsButton.isEnabled = true
        // do not show admin settings button
        } else {
            settingsButton.isEnabled = false
        }
        
        // MARK: handling profile image
        
        // retrieve slack profile image url string from user defaults
        guard let image512UrlString = defaults.string(forKey: "image512") else { return }
        // set user profile image
        if let url = URL(string: image512UrlString) {
            downloadImage(url: url)
        }
        
        // make user profile image circular
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
        
        profileImage.layer.masksToBounds = true
        
        userInfoTableView.delegate = self
        userInfoTableView.dataSource = self
    }
    
    // MARK: Table View Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // load user defaults data into cells
        let cell = tableView.dequeueReusableCell(withIdentifier: "userInfoCell") as! UserInfoCell
        
        
        
        
        
        return cell
    }
    
    // MARK: Image Handling Methods
    
    // get image data
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
        }.resume()
    }
    
    // download image & set image view
    func downloadImage(url: URL) {
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data else { return }
            DispatchQueue.main.async() { () -> Void in
//                print("********************")
//                print(data)
//                print("********************")
//                self.profileImage.image = UIImage(data: data)
                self.blurredProfileImage.image = UIImage(data: data)
                self.profileImage.image = UIImage(data: data)
            }
        }
    }
    
    // MARK: Backend Update Methods
    
    // retrieve user profile data from Slack API
    func checkSlackForProfileChanges() {
        
    }
    
    // if there are changes on Slack, update User Defaults & form contents
    func updateUserProfileLocally() {
        
    }
    
    // if there are changes on Slack, update user profile data on Firebase
    func updateUserProfileFirebase() {
        
    }
    
    // MARK: Button Functionality Methods
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        
    }
    
    // MARK: Helper Methods
    
    func populateUserInfo() {
        let defaults = UserDefaults.standard
        guard let slackID = defaults.string(forKey: "slackID") else { return }
        guard let teamID = defaults.string(forKey: "teamID") else { return }
        guard let username = defaults.string(forKey: "username") else { return }
        guard let firstName = defaults.string(forKey: "firstName") else { return }
        guard let lastName = defaults.string(forKey: "lastName") else { return }
        guard let email = defaults.string(forKey: "email") else { return }
        guard let image72UrlString = defaults.string(forKey: "image72") else { return }
        guard let image512UrlString = defaults.string(forKey: "image512") else { return }
        guard let timeZoneLabel = defaults.string(forKey: "timeZoneLabel") else { return }
        
        guard let isAdmin = defaults.string(forKey: "isAdmin") else { return }
        guard let isOwner = defaults.string(forKey: "isOwner") else { return }
        guard let isPrimaryOwner = defaults.string(forKey: "isPrimaryOwner") else { return }
        
        userInfo.append(slackID)
        userInfo.append(teamID)
        userInfo.append(username)
        userInfo.append(firstName)
        userInfo.append(lastName)
        userInfo.append(email)
        userInfo.append(image72UrlString)
        userInfo.append(image512UrlString)
        userInfo.append(timeZoneLabel)
        
        userInfo.append(isAdmin)
        userInfo.append(isOwner)
        userInfo.append(isPrimaryOwner)
    }
    
    // TODO: show alert, confirm user intention to nuke his profile
    func promptForConfirmation() {
        let ac = UIAlertController(title: "Logout", message: "Are you sure you wish to logout?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [unowned self, ac] (action: UIAlertAction!) in
            // perform logout
            
            // TODO: remove Firebase images
            
            // TODO: remove Firebase user
            
            // TODO: remove user's activities (potentially change owner to random person -OR- prompt user to choose new activity owner)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { [unowned self, ac] (action: UIAlertAction!) in
            // do nothing
        }
        
        ac.addAction(confirmAction)
        ac.addAction(cancelAction)
        
        present(ac, animated: true)
    }
    
}
