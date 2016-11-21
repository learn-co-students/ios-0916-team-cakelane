//
//  ViewController.swift
//  slackOAuth
//
//  Created by Alexey Medvedev on 11/15/16.
//  Copyright © 2016 medvedev. All rights reserved.
//

import UIKit
import SafariServices

class LoginViewController: UIViewController {
    
    @IBOutlet weak var accessToken: UILabel!
    @IBOutlet weak var teamID: UILabel!
    var safariViewController: SFSafariViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(redirectFromSlack(_:)), name: .closeSafariVC, object: nil)
    }
    
    @IBAction func signInWithSlackButtonTapped(_ sender: UIButton) {
        
        // NOTE: Direct user to Slack for authentication
        let baseURL = "https://slack.com/oauth/"
        let path = "authorize"
        let query = "?client_id=\(Secrets.clientID)&scope=identity.basic"
        let scope = "&scope=\"identify,read,post,client\""
        
        let urlString = baseURL + path + query + scope
        
        let url = URL(string: urlString)!
        
        self.safariViewController = SFSafariViewController(url: url)
        DispatchQueue.main.async {
            self.present(self.safariViewController, animated: true, completion: nil)
        }
        
    }
    
    func redirectFromSlack(_ notification: Notification) {
        
        // NOTE: Use temporary code received from Slack to request access token
        let code = notification.object as! String
        
        let baseURL = "https://slack.com/appi/oauth.access"
        let query = "?client_id=\(Secrets.clientID)&client_secret=\(Secrets.clientSecret)&code=\(code)"
        var request = URLRequest(url: URL(string: baseURL + query)!)
        request.httpMethod = "POST"
        
        let queue = OperationQueue()
        queue.addOperation {
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                print(json)
                let token = json["access_token"] as! String
                
                // store token in SlackDataStore singleton
                SlackDataStore.sharedInstance.token = token
                NotificationCenter.default.post(name: .closeLoginVC, object: self)
                OperationQueue.main.addOperation {
                    self.accessToken.text = SlackDataStore.sharedInstance.token
                }
                
            }.resume()
            
        }
        DispatchQueue.main.async {
            self.safariViewController.dismiss(animated: true, completion: nil)
        }
    }
    
}

