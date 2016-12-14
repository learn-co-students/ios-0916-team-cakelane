//
//  ViewController.swift
//  slackOAuth
//
//  Created by Alexey Medvedev on 11/15/16.
//  Copyright © 2016 medvedev. All rights reserved.
//

import UIKit
import Firebase
import SafariServices

class LoginViewController: UIViewController {
    
    @IBOutlet weak var signInButton: UIButton!
    var safariViewController: SFSafariViewController!

    let teamStore = TeamDataStore.sharedInstance
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        UIApplication.shared.statusBarStyle = .lightContent
        self.view.backgroundColor = UIColor.black
        self.signInButton.setTitleColor(UIColor.orange, for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(redirectFromSlack(_:)), name: .closeSafariVC, object: nil)
        
    }

    @IBAction func signInWithSlackButtonTapped(_ sender: UIButton) {
        
        // NOTE: Direct user to Slack for authentication
        let baseURL = "https://slack.com/oauth/"
        let path = "authorize"
        
        // NOTE: set up initial scopes so that user doesn't have to go through authorization multiple times
        // let query = "?client_id=\(Secrets.clientID)&scope=identity.basic&scope=users:read,incoming-webhook,bot"
        let query = "?client_id=\(Secrets.clientID)&scope=identity.basic&scope=users:read,channels:read,channels:write,team:read"
        
        let urlString = baseURL + path + query
        
        let url = URL(string: urlString)!
        
        self.safariViewController = SFSafariViewController(url: url)
        present(self.safariViewController, animated: true, completion: nil)
        
    }

    func redirectFromSlack(_ notification: Notification) {

        // MARK: Use temporary code received from Slack to request access token
        let code = notification.object as! String

        let baseURL = "https://slack.com/api/oauth.access"
        let query = "?client_id=\(Secrets.clientID)&client_secret=\(Secrets.clientSecret)&code=\(code)"
        var request = URLRequest(url: URL(string: baseURL + query)!)
        request.httpMethod = "POST"
        let queue = OperationQueue()
        queue.addOperation {

            URLSession.shared.dataTask(with: request) { (data, response, error) in

                let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]

//                print("+++++++++++++++*********++++++++++")
//                dump(json)
//                print("+++++++++++++++*********++++++++++")

                let token = json["access_token"] as! String
                let slackID = json["user_id"] as! String
                let teamID = json["team_id"] as! String
                let teamName = json["team_name"] as! String
                
                // save slack account token, team name using UserDefaults
                let defaults = UserDefaults.standard
                defaults.setValue(token, forKey: "slackToken")
                defaults.setValue(slackID, forKey: "slackID")
                defaults.setValue(teamID, forKey: "teamID")
                defaults.set(teamName, forKey: "teamName")
                
                defaults.synchronize()
                
                FIRDatabase.database().reference().observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let firebaseTeemSnapshot = snapshot.value as! [String:Any]
                    
                    print(firebaseTeemSnapshot)
                    print(snapshot)
                    
                    // does not execute if there is no team -> perform all firebase writing in AppController's secondAuthRedirect
                    if let teamJSONContents = firebaseTeemSnapshot["\(teamID)"] as? [String:Any] {
                        
                        // try to get webhook value: nil if slack team does not have a webhook, toggle flag for second auth
                        if let webhookURL = teamJSONContents["webhook"] as? String {
                            
                            self.teamStore.webhook =  webhookURL
                            
                            // storing webhook in User Defaults under "webhook" key (for not first user, i.e. someone already created a team in Firebase)
                            UserDefaults.standard.set(webhookURL, forKey: "webhook")
                            UserDefaults.standard.synchronize()
                            
                        }
                        
                        let users = teamJSONContents["users"] as! [String:Any]
                        
                        print(users)
                        
                        let user = users["\(slackID)"] as? [String:Any] ?? nil
                        
                        // write to Firebase if there is no user
                        if user == nil {
                            
                            SlackAPIClient.storeUserInfo(handler: { (success) in
                                
                                // WARNING: THIS CAUSES INTENSE LOADING TIMES
                                FirebaseClient.writeUserInfo()
                                
                            })
                            
                        }
                        
                    }
                    
                    NotificationCenter.default.post(name: .closeLoginVC, object: self)
                    
                })
                
            }.resume()
            
            self.safariViewController.dismiss(animated: true, completion: nil)
            
        }
        
    }

}
