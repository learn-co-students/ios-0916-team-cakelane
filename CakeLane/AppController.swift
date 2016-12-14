//
//  AppController.swift
//  CakeLane
//
//  Created by Alexey Medvedev on 11/18/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import UIKit
import Firebase
import SafariServices

class AppController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    var actingViewController: UIViewController!
    var token: String?
    let defaults = UserDefaults.standard
    var safariViewController: SFSafariViewController!
    
    
    // View lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadInitialViewController()
        addNotificationObservers()
        
    }
    
    // Initial Set Up
    
    private func loadInitialViewController() {
        
        // access defaults
        // NOTE: token is stored as Optional value
        if defaults.object(forKey: "slackToken") == nil {
            actingViewController = loadViewController(withID: .loginVC)
        } else {
            actingViewController = loadViewController(withID: .tabBarController)
        }
        
        addActing(viewController: actingViewController)
        
    }
    
    private func addNotificationObservers() {
        
        // close login view controller & switch to activities once user has obtained an authorization token
        NotificationCenter.default.addObserver(self, selector: #selector(switchViewController(with:)), name: .closeLoginVC, object: nil)
        
        // close activities if user has logged out
        NotificationCenter.default.addObserver(self, selector: #selector(switchViewController(with:)), name: .closeProfileVC, object: nil)
        
        // perform redirect for second auth
        NotificationCenter.default.addObserver(self, selector: #selector(secondAuthRedirect(_:)), name: .finishSecondAuth, object: nil)
    }
    
    // MARK: View Controller Handling
    private func loadViewController(withID id: StoryboardID) -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch id {
        case .loginVC:
            return storyboard.instantiateViewController(withIdentifier: id.rawValue) as! LoginViewController
        case .tabBarController:
            let vc = storyboard.instantiateViewController(withIdentifier: id.rawValue) as! UITabBarController
            return vc
        default:
            fatalError("ERROR: Unable to find controller with storyboard id: \(id)")
        }
    }
    
    private func addActing(viewController: UIViewController) {
        self.addChildViewController(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParentViewController: self)
    }
    
    func switchViewController(with notification: Notification) {
        
        switch notification.name {
        case Notification.Name.closeLoginVC:
            
            DispatchQueue.main.async {
                
                // if there is no entry for a given slack team in Teem's Firebase, create it
                if TeamDataStore.sharedInstance.webhook == nil {
                    
                    // start second auth to create webhook
                    SlackAPIClient.userJoinChannel(with: { (channelJSON) in
                        
                        print(channelJSON)
                        
                        self.startSecondAuth()
                        
                    })
                    
                }
                
            }
            
            // MARK: Switch from Login Flow to Main Flow (Activity Feed)
            switchToViewController(withID: .tabBarController)
            
        case Notification.Name.closeProfileVC:
            switchToViewController(withID: .loginVC)
        default:
            fatalError("ERROR: Unable to match notification name")
        }
        
    }
    
    private func switchToViewController(withID id: StoryboardID) {
        
        let exitingViewController = actingViewController
        exitingViewController?.willMove(toParentViewController: nil)
        actingViewController = loadViewController(withID: id)
        self.addChildViewController(actingViewController)
        
        // REMOVE: call to addActing
        //        addActing(viewController: actingViewController)
        
        // TO ADD: add acting view, set frame, layout view
        containerView.addSubview(actingViewController.view)
        actingViewController.view.frame = containerView.bounds
        actingViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        actingViewController.view.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.actingViewController.view.alpha = 1
            exitingViewController?.view.alpha = 0
        }) { completed in
            exitingViewController?.view.removeFromSuperview()
            exitingViewController?.removeFromParentViewController()
            self.actingViewController.didMove(toParentViewController: self)
        }
        
    }
    
    // MARK: starts second authentication process for first user on a team
    func startSecondAuth() {
        
        // NOTE: Direct user to Slack for authentication
        let baseURL = "https://slack.com/oauth/"
        let path = "authorize"
        
        // NOTE: set up initial scopes so that user doesn't have to go through authorization multiple times
        // let query = "?client_id=\(Secrets.clientID)&scope=identity.basic&scope=users:read,incoming-webhook,bot"
        let query = "?client_id=\(Secrets.clientID)&scope=identity.basic&scope=users:read,channels:read,channels:write,team:read,incoming-webhook"
        
        let urlString = baseURL + path + query
        
        let url = URL(string: urlString)!
        
        self.safariViewController = SFSafariViewController(url: url)
        present(self.safariViewController, animated: true, completion: nil)
        
    }
    
    // selector for second auth redirect
    func secondAuthRedirect(_ notification: Notification) {
        
        let code = notification.object as! String
        
        let baseURL = "https://slack.com/api/oauth.access"
        let query = "?client_id=\(Secrets.clientID)&client_secret=\(Secrets.clientSecret)&code=\(code)"
        var request = URLRequest(url: URL(string: baseURL + query)!)
        request.httpMethod = "POST"
        
        OperationQueue().addOperation {
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                
                print("+++++++++++++++*********++++++++++")
                dump(json)
                print("+++++++++++++++*********++++++++++")
                
                let token = json["access_token"] as! String
                let slackID = json["user_id"] as! String
                let teamID = json["team_id"] as! String
                let teamName = json["team_name"] as! String
                
                if let webhook = json["incoming-webhook"] as? [String:Any], let webhookURL = webhook["url"] as? String {
                    
                    print(webhook)
                    print(webhookURL)
                    
                    // MARK: actually write the webhook to Firebase
                    FIRDatabase.database().reference().child(teamID).setValue([
                        "webhook": webhookURL,
                        "users": slackID
                        ])
                }
                
                // save *new* token with webhook
                let defaults = UserDefaults.standard
                defaults.setValue(token, forKey: "slackToken")
                defaults.synchronize()
                
                SlackAPIClient.storeUserInfo(handler: { (success) in
                    
                    // WARNING: THIS CAUSES INTENSE LOADING TIMES
                    FirebaseClient.writeUserInfo()
                    
                })
                
                NotificationCenter.default.post(name: .closeLoginVC, object: self)
                
                
                }.resume()
            
            self.safariViewController.dismiss(animated: true, completion: nil)
            
            
        }
        
    }
    
}
