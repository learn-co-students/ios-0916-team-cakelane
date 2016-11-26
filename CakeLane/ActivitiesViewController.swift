//
//  ActivitiesViewController.swift
//  CakeLane
//
//  Created by Rama Milaneh on 11/22/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class ActivitiesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var activitiesCollectionView: UICollectionView!
    var contentView = UIView()
    var activities = [Activity]()
    let activitiesRef = FIRDatabase.database().reference(withPath: "activities")
    
    var isAnimating: Bool = false
    var dropDownViewIsDisplayed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Best App"
        setUpActivityCollectionCells()
        createLayout()
        self.activitiesRef.observe(.value, with: { (snapshot) in
            
            var newActivites = [Activity]()
            
            for activity in snapshot.children {
                let item = Activity(snapshot: activity as! FIRDataSnapshot)
                newActivites.append(item)
                
            }
            self.activities = self.sortedActivities(newActivites)
            OperationQueue.main.addOperation {
                self.activitiesCollectionView.reloadData()
            }
            
        })
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.transition(with: self.activitiesCollectionView, duration: 0.4, options: .transitionCrossDissolve, animations:{
            self.activitiesCollectionView.alpha = 1.0
        }) { _ in }
    }
    
    
      func createLayout() {
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(activitiesCollectionView)
        activitiesCollectionView.backgroundColor = UIColor.clear
        activitiesCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.height.equalTo(view.snp.height)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
        }
        
    }
    
    
    func setUpActivityCollectionCells() {
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        //setup Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        layout.itemSize = CGSize(width: screenWidth, height: screenHeight/2)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 0
        activitiesCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        activitiesCollectionView.dataSource = self
        activitiesCollectionView.delegate = self
        
        activitiesCollectionView.register(ActivitiesCollectionViewCell.self, forCellWithReuseIdentifier: "activityCell")
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "activityCell", for: indexPath) as! ActivitiesCollectionViewCell
        OperationQueue.main.addOperation {
            cell.updateCell(with: self.activities[indexPath.row])
            
        }
        
        return cell
     }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    
    
    // MARK: _ Sort the activities based on time
    func sortedActivities(_ array: [Activity]) -> [Activity] {
        let sortedArray = array.sorted { (a, b) -> Bool in
            var result = false
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.long
            if let aDate = dateFormatter.date(from: a.date){
                if let bDate = dateFormatter.date(from: b.date){
                    if aDate < bDate {
                        result = true
                    }
                }
            }
            return result
        }
        return sortedArray
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let dest = segue.destination as! ActivityDetailsViewController
            if let index = self.activitiesCollectionView.indexPathsForSelectedItems?[0].item {
            dest.selectedActivity = self.activities[index]
            }
        }
    }
    
}
