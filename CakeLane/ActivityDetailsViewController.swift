//
//  ActivityDetailsViewController.swift
//  CakeLane
//
//  Created by Rama Milaneh on 11/25/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import UIKit

class ActivityDetailsViewController: UIViewController {
    
    var selectedActivity: Activity!

    @IBOutlet weak var activityView: ActivityDetailsView!
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        //ToDo: -
//        if selectedActivity.owner == userID {
//            display editable activity details
//        }else{
//            display regural activity details
//
//        }
        //  performAnimations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
   
}

extension ActivityDetailsViewController {
    
    //MARK: - Setup function
    
    func setup() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.activityView.contentView = ActivityDetailsView(frame: self.view.frame)
        self.activityView.translatesAutoresizingMaskIntoConstraints = false
        self.activityView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.activityView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.activityView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.activityView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.activityView.closeButton.addTarget(self, action: #selector(dismissView), for: .allTouchEvents)
    }
    
    func dismissView() {
        UIView.animate(withDuration: 0.4, animations: {
            self.view.subviews.forEach { $0.alpha = 0.0 }
        }) { _ in
            self.dismiss(animated: false, completion: nil)
        }
        
    }
 
    
    
}
