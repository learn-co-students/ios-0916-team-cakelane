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

    override func viewDidLoad() {
        super.viewDidLoad()
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 415, height: 60))
               view.addSubview(navBar)
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
