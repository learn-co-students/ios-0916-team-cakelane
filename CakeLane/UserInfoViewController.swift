//
//  UserProfileViewController.swift
//  CakeLane
//
//  Created by Alexey Medvedev on 11/28/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import UIKit
import MessageUI

// TODO: add pull to refresh user info from Slack functionality

class UserInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , MFMailComposeViewControllerDelegate{
    
    // UI elements
    @IBOutlet weak var blurredProfileImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userInfoTableView: UITableView!
    // settings available to Team Owner/Admin ~ hide/show depending on user permissions
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    var userLabels = [String]()
    var userInfo = [String]()
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Test get channels.list
        SlackAPIClient.getChannelsList { response in
            guard let verifiedResponse = response else { return }
            //            let channels = verifiedResponse["channels"]
            //            print("\n\n\nTHIS IS THE CHANNELS LIST!!! ++++++++++\n\n\n\(verifiedResponse)\n\n\n")
        }
        
        // show appropriate user info
        if user.slackID == "" {
            loadPrimaryUserView()
        } else {
            loadOtherUserView()
        }
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
        
        cell.keyLabel.font = UIFont.helBoldFont(with: 15)
//        cell.keyLabel.numberOfLines = 1
//        cell.keyLabel.minimumScaleFactor = 0.5
        cell.keyLabel.adjustsFontSizeToFitWidth = true
        
        cell.valueLabel.font = UIFont.helFont(with: 15)
//        cell.valueLabel.numberOfLines = 1
//        cell.valueLabel.minimumScaleFactor = 0.5
        cell.valueLabel.adjustsFontSizeToFitWidth = true
        
        cell.keyLabel.text = ("\(userLabels[indexPath.row]):")
        cell.valueLabel.text = userInfo[indexPath.row]
        
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
    @IBAction func feedbackButton(_ sender: Any) {
           
        let alert = UIAlertController(title: "General Feedback", message: "Are you sure you want to send feedback to the developers?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .destructive) { (action: UIAlertAction!) in
            
            if !MFMailComposeViewController.canSendMail() {
                
                self.showSendMailErrorAlert()
            }
            let composeMail = MFMailComposeViewController()
            
            composeMail.mailComposeDelegate = self
            
            composeMail.setToRecipients(["teem.feedback@gmail.com"])
            composeMail.setSubject("General Feedback")
            composeMail.setMessageBody("Tell us your thoughts about the app", isHTML: false)
            
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
        let alertController = UIAlertController(title: nil, message: "Thanks for the Feedback!", preferredStyle: UIAlertControllerStyle.alert)
        let thanks = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default)
        alertController.addAction(thanks)
        controller.dismiss(animated: true) {
            self.present(alertController, animated: true, completion: nil)
        }
    }

    
    
    
    // MARK: Helper Methods
    
    func populateUserInfo() {
        let defaults = UserDefaults.standard
        guard let username = defaults.string(forKey: "username") else { return }
        guard let firstName = defaults.string(forKey: "firstName") else { return }
        guard let lastName = defaults.string(forKey: "lastName") else { return }
        guard let email = defaults.string(forKey: "email") else { return }
        guard let timeZoneLabel = defaults.string(forKey: "timeZoneLabel") else { return }

        userInfo.append(username)
        userInfo.append(firstName)
        userInfo.append(lastName)
        userInfo.append(email)
        userInfo.append(timeZoneLabel)
        
        userLabels.append("Slack Handle")
        userLabels.append("First Name")
        userLabels.append("Last Name")
        userLabels.append("Email")
        userLabels.append("Time Zone")
    }
    
    // MARK: 
    
    func loadPrimaryUserView() {
        populateUserInfo()
        
        // set color scheme
        navigationItem.title = "Teem!"
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orange]
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.tabBarController?.tabBar.barTintColor = UIColor.black
      //  self.navigationItem.rightBarButtonItem?.tintColor = UIColor.orange
        
        // access user defaults
        let defaults = UserDefaults.standard
        
        // handle Logout Button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(promptForConfirmation))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.orange
        
        // check if user is admin ~ present different profile view options
//        guard let isPrimaryOwner = defaults.string(forKey: "isPrimaryOwner") else { return }
//        
//        // show admin settings button
//        if isPrimaryOwner != "0" {
//            settingsButton.isEnabled = true
//            // do not show admin settings button
//        } else {
//            self.navigationItem.rightBarButtonItem = nil
//        }
        
        // handling profile image
        
        // retrieve slack profile image url string from user defaults
        guard let image512UrlString = defaults.string(forKey: "image512") else { return }
        // set user profile image
        if let url = URL(string: image512UrlString) {
            downloadImage(url: url)
        }
        
        // make user profile image circular
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.borderWidth = 2
        profileImage.layer.masksToBounds = true
        
        userInfoTableView.delegate = self
        userInfoTableView.dataSource = self
        
        // set user's full name
        fullNameLabel.text = "\(userInfo[1]) \(userInfo[2])"
    }
    
    // MARK: show alert, confirm user intention to nuke his profile
    func promptForConfirmation() {
        
        let ac = UIAlertController(title: "Logout", message: "Are you sure you wish to logout?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .destructive) { [unowned self, ac] (action: UIAlertAction!) in
            
            // perform logout
            // clear user defaults
            if let bundle = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: bundle)
            }
            
            // MARK: set auth and webhook flags to false and nil respectively to allow user to switch teams without closing the app
            TeamDataStore.sharedInstance.performedFirstAuth = false
            TeamDataStore.sharedInstance.webhook = nil
            
            // post notification -> have app controller take user to login view
            NotificationCenter.default.post(name: .closeProfileVC, object: self)
            
            // DELETE ACCOUNT FROM FIREBASE
            
            // TODO: remove Firebase images
            // TODO: remove Firebase user
            // TODO: remove user's activities (potentially change owner to random person -OR- prompt user to choose new activity owner)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { [unowned self, ac] (action: UIAlertAction!) in
            // do nothing (for now)
        }
        
        ac.addAction(confirmAction)
        ac.addAction(cancelAction)
        
        present(ac, animated: true)
    }
    
    func populateOtherUserInfo() {
        let username = user.username
        let firstName = user.firstName
        let lastName = user.lastName
        let email = user.email
        let timeZoneLabel = user.timeZoneLabel
        
        userInfo.append(username)
        userInfo.append(firstName)
        userInfo.append(lastName)
        userInfo.append(email)
        userInfo.append(timeZoneLabel)
        
        userLabels.append("Slack Handle")
        userLabels.append("First Name")
        userLabels.append("Last Name")
        userLabels.append("Email")
        userLabels.append("Time Zone")
    }
    
    // MARK: Load other user profile view (attendee)
    func loadOtherUserView() {
        populateOtherUserInfo()
    
        /////////////////////////
        
        // create & setup navigation bar
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height:64))
        let navigationItem = UINavigationItem()
        navigationItem.title = "Teem!"
        UIApplication.shared.statusBarStyle = .lightContent
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orange]
        navigationBar.barTintColor = UIColor.black
        
        // handle Logout Button
        let leftButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(returnToUserTableView))
        leftButton.tintColor = UIColor.orange
        
        navigationItem.leftBarButtonItem = leftButton
        navigationBar.items = [navigationItem]
        self.view.addSubview(navigationBar)
        
        // constrain image view to navigation bar
        blurredProfileImage.translatesAutoresizingMaskIntoConstraints = false
        blurredProfileImage.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor, constant: 64).isActive = true
        
        
        // handling profile image
        
        // set user profile image
        if let url = URL(string: user.image512) {
            downloadImage(url: url)
        }
        
        // make user profile image circular
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.borderWidth = 2
        profileImage.layer.masksToBounds = true
        
        userInfoTableView.delegate = self
        userInfoTableView.dataSource = self
        
        // set user's full name
        fullNameLabel.text = "\(userInfo[1]) \(userInfo[2])"
    }
    
    func returnToUserTableView() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
