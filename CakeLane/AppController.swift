//
//  AppController.swift
//  CakeLane
//
//  Created by Alexey Medvedev on 11/18/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import UIKit
import Firebase

class AppController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    var actingViewController: UIViewController!
    var notificationObject: Any?
    var token: String?
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadInitialViewController()
        addNotificationObservers()
    }
    
    // MARK: Set Up
    
    private func loadInitialViewController() {
        // access defaults
        // NOTE: token is stored as Optional value
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "SlackToken") == nil {
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
        // MARK: Add observer: close activities feed -> show activity details
        NotificationCenter.default.addObserver(self, selector: #selector(switchViewController(with:)), name: .showActivityDetailsVC, object: nil)
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
        case .activityDetailsVC:
            let advc = storyboard.instantiateViewController(withIdentifier: id.rawValue) as! ActivityDetailsViewController
            if let activity = notificationObject {
                advc.detailView.selectedActivity = activity as! Activity
            }
            return advc
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
            // MARK: Slack API Call for full user data (TODO: move to NetworkManager)
            SlackAPIClient.getUserInfo { userInfo in
                
                let userData = userInfo["user"] as! [String: Any]
                
                print("***************++++++++**********\n\n")
                print("USER DATA STILL BEING STORED AFTER LE GREAT REFACTOR #GREATSUCCESS")
                print(userData)
                print("***************++++++++**********\n\n")
                print(userData["is_primary_owner"])
                print("***************++++++++**********\n\n")
                
                OperationQueue.main.addOperation {
                    
                    // instantiate user profile
                    let userProfile = User(dictionary: userData)
                    let defaults = UserDefaults.standard
                    defaults.set(userProfile.slackID, forKey: "slackID")
                    defaults.set(userProfile.teamID, forKey: "teamID")
                    defaults.set(userProfile.username, forKey: "username")
                    defaults.set(userProfile.firstName, forKey: "firstName")
                    defaults.set(userProfile.lastName, forKey: "lastName")
                    defaults.set(userProfile.email, forKey: "email")
                    defaults.set(userProfile.image72, forKey: "image72")
                    defaults.set(userProfile.image512, forKey: "image512")
                    defaults.set(userProfile.timeZoneLabel, forKey: "timeZoneLabel")
                    
                    defaults.set(userProfile.isAdmin, forKey: "isAdmin")
                    defaults.set(userProfile.isOwner, forKey: "isOwner")
                    defaults.set(userProfile.isPrimaryOwner, forKey: "isPrimaryOwner")
                    
                    defaults.synchronize()
                    
                    // sync to Firebase
                    let reference = FirebaseClient.sharedInstance.ref
                    reference.child(userProfile.teamID).child("users").child(userProfile.slackID).setValue(userProfile.toAnyObject())
                }
                
            }
            
            // MARK: Switch from Login Flow to Main Flow (Activity Feed)
            switchToViewController(withID: .tabBarController)
        case Notification.Name.closeProfileVC:
            switchToViewController(withID: .loginVC)
        case Notification.Name.showActivityDetailsVC:
            self.notificationObject = notification.object as! Activity
            switchToViewController(withID: .activityDetailsVC)
        default:
            fatalError("ERROR: Unable to match notification name")
        }
        
    }
    
    private func switchToViewController(withID id: StoryboardID) {
        
        let exitingViewController = actingViewController
        exitingViewController?.willMove(toParentViewController: nil)
        
        actingViewController = loadViewController(withID: id)
        self.addChildViewController(actingViewController)
        
        addActing(viewController: actingViewController)
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

}
