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
                
                // MARK:
                var slackTeamExistsInTeamDatabase = false
                FIRDatabase.database().reference().observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let value = snapshot.value as! [String:Any]
                    
                    for key in value.keys {
                        
                        // check if currently registering Slack user is part of Teem's Database on Firebase
                        if key == teamID {
                            
                            // indicate that slack team is part of Teem database: toggle flag
                            slackTeamExistsInTeamDatabase = true
                            print(value)
                            
                            let teamJSONContents = value["\(teamID)"] as! [String:Any]
                            let users = teamJSONContents["users"] as! [String:Any]
                            
                            print(users)
                            
                            let user = users["\(slackID)"] as? [String:Any] ?? nil
                            
                            // write to Firebase if there is no user
                            if user == nil {
                                
                                SlackAPIClient.storeUserInfo(handler: { (success) in
                                    
                                    // WARNING: THIS CAUSES INTENSE LOADING TIMES
                                    FirebaseClient.writeUserInfo()
                                    
                                })
                                
                                break
                                
                            }
                            
                        }
                        
                    }
                    
                    // if there is no entry for a given slack team in Teem's Firebase, create it
                    if slackTeamExistsInTeamDatabase == false {
                        
                        /////////////////////////////////////////////
                        
                        // create webhook
                        SlackAPIClient.userJoinChannel(with: { (channelJSON) in
                            
                            print(channelJSON)
                            
                            
                        })
                        
                        /////////////////////////////////////////////
                        
                        // create users entry
                        FIRDatabase.database().reference().child(teamID).setValue(["users": slackID])
                        
                        // write user info to Firebase
                        SlackAPIClient.storeUserInfo(handler: { (success) in
                            
                            // WARNING: THIS CAUSES INTENSE LOADING TIMES
                            FirebaseClient.writeUserInfo()
                            
                        })
                    }
                    
                    NotificationCenter.default.post(name: .closeLoginVC, object: self)
                    
                })
                
            }.resume()
            
            self.safariViewController.dismiss(animated: true, completion: nil)
            
        }
        
    }

}
