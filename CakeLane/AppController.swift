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
    let defaults = UserDefaults.standard
    
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
