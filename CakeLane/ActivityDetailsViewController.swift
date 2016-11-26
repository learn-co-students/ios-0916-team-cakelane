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
          performAnimations()
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
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 415, height: 60))
        self.view.addSubview(navBar)
        self.activityView.contentView = ActivityDetailsView(frame: self.view.frame)
        self.activityView.translatesAutoresizingMaskIntoConstraints = false
        self.activityView.constrainEdges(to: self.view)
    }
    
    
    
    
    //MARK: - dismiss the view when the user tab on any point
    
    func performAnimations() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        gestureRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    func dismissView() {
        UIView.animate(withDuration: 0.4, animations: {
            self.view.subviews.forEach { $0.alpha = 0.0 }
        }) { _ in
            self.dismiss(animated: false, completion: nil)
        }
        
    }
 
    
    
}
