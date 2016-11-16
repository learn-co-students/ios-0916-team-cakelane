//
//  ViewController.swift
//  slackOAuth
//
//  Created by Alexey Medvedev on 11/15/16.
//  Copyright © 2016 medvedev. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController {
    
    @IBOutlet weak var accessToken: UILabel!
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
        
        let urlString = baseURL + path + query
        
        let url = URL(string: urlString)!
        
        self.safariViewController = SFSafariViewController(url: url)
        present(self.safariViewController, animated: true, completion: nil)
        
    }
    
    func redirectFromSlack(_ notification: Notification) {
        
        // NOTE: Use temporary code received from Slack to request access token
        let code = notification.object as! String
        
        self.safariViewController.dismiss(animated: true)
        
        let baseURL = "https://slack.com/api/oauth.access"
        
        var request = URLRequest(url: URL(string: baseURL)!)
        
        request.httpMethod = "GET"
        
        let parameters = ["client_id": Secrets.clientID, "client_secret": Secrets.clientSecret, "code": code]
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let queue = OperationQueue()
        queue.addOperation {
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                let token = json["access_token"] as! String
                
                OperationQueue.main.addOperation {
                    self.accessToken.text = token
                }
                print(token)
                }.resume()
            
        }
    }
    
}

