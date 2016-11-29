//
//  UserProfileViewController.swift
//  CakeLane
//
//  Created by Alexey Medvedev on 11/28/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // UI elements
    @IBOutlet weak var blurredProfileImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userInfoTableView: UITableView!
    // settings available to Team Owner/Admin ~ hide/show depending on user permissions
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // access user defaults
//        let defaults = UserDefaults.standard
//        guard let slackID = defaults.string(forKey: "slackID") else { return }
//        guard let teamID = defaults.string(forKey: "teamID") else { return }
//        guard let username = defaults.string(forKey: "username") else { return }
//        guard let firstName = defaults.string(forKey: "firstName") else { return }
//        guard let lastName = defaults.string(forKey: "lastName") else { return }
//        guard let email = defaults.string(forKey: "email") else { return }
//        // TODO: check if user is admin ~ present different profile view options
//        guard let isAdmin = defaults.string(forKey: "isAdmin") else { return }
//        guard let image72url = defaults.string(forKey: "image72") else { return }
//        guard let image512url = defaults.string(forKey: "image512") else { return }
//        guard let timeZoneLabel = defaults.string(forKey: "timeZoneLabel") else { return }
//        
        // set user profile image
        let imageUrl = "https://avatars.slack-edge.com/2016-11-28/109996596596_4669dd0e68809ed10107_512.jpg"
        if let url = URL(string: imageUrl) {
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
        return 8
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
    
    @IBAction func logoutButton(_ sender: Any) {
        // TODO: show alert, confirm user intention to nuke his profile
        
        // TODO: remove Firebase images
        
        // TODO: remove Firebase user
        
        // TODO: remove user's activities (potentially change owner to random person -OR- prompt user to choose new activity owner)
    }
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        
    }
    
    
}
