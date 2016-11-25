//
//  ActivityDetailsViewController.swift
//  CakeLane
//
//  Created by Rama Milaneh on 11/25/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import UIKit

class ActivityDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
          performAnimations()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
