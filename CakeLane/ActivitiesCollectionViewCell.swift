//
//  ActivitiesCollectionViewCell.swift
//  CakeLane
//
//  Created by Rama Milaneh on 11/22/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import UIKit
import Firebase

class ActivitiesCollectionViewCell: UICollectionViewCell {
    
    var activityImageView = UIImageView()
    var activityOverlay = UIView()
    var transparentButton = UIButton()
    var activityLabel = UILabel()
    var locationLabel = UILabel()
    var timeLabel = UILabel()
    var dateLabel = UILabel()
    var numberOfAttendeesLabel = UILabel()
    var firstProfileImage = UIImageView()
    var secondProfileImage = UIImageView()
    var thirdProfileImage = UIImageView()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        contentView.addSubview(activityImageView)
        activityImageView.backgroundColor = UIColor.blue
        activityImageView.layer.borderWidth = 1
        activityImageView.layer.borderColor = UIColor.darkGray.cgColor
        activityImageView.layer.masksToBounds = true
        activityImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView.snp.centerX)
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.equalTo(contentView.snp.width)
            make.height.equalTo(contentView.snp.height)
        }
        
        
        activityImageView.addSubview(activityOverlay)
        activityOverlay.backgroundColor = UIColor.white
        activityOverlay.snp.makeConstraints { (make) in
            make.bottom.equalTo(activityImageView.snp.bottom)
            make.left.equalTo(activityImageView.snp.left)
            make.right.equalTo(activityImageView.snp.right)
            make.height.equalTo(activityImageView.snp.height).dividedBy(10)
        }
        
        
        
        activityImageView.addSubview(activityLabel)
        activityLabel.font = UIFont(name: "TrebuchetMS-Bold", size: 16)
        activityLabel.textColor = UIColor.white
        activityLabel.snp.makeConstraints { (make) in
            make.left.equalTo(activityImageView.snp.left).offset(10)
            make.top.equalTo(activityImageView.snp.bottom).offset(-120)
        }
        
        
        activityImageView.addSubview(locationLabel)
        locationLabel.font = UIFont(name: "TrebuchetMS-Bold", size: 16)
        locationLabel.textColor = UIColor.white
        locationLabel.snp.makeConstraints { (make) in
            make.left.equalTo(activityImageView.snp.left).offset(10)
            make.top.equalTo(activityLabel.snp.bottom)
        }
        
        activityImageView.addSubview(dateLabel)
        dateLabel.font = UIFont(name: "TrebuchetMS-Bold", size: 16)
        dateLabel.textColor = UIColor.white
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(activityImageView.snp.left).offset(10)
            make.top.equalTo(locationLabel.snp.bottom)
        }
        
        
        activityImageView.addSubview(timeLabel)
       // timeLabel.text = "06:40"
        timeLabel.font = UIFont(name: "TrebuchetMS-Bold", size: 16)
        timeLabel.textColor = UIColor.white
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(dateLabel.snp.right).offset(5)
            make.top.equalTo(locationLabel.snp.bottom)
            
        }
        
        activityOverlay.addSubview(firstProfileImage)
        firstProfileImage.backgroundColor = UIColor.green
        firstProfileImage.layer.masksToBounds = true
        firstProfileImage.layer.borderColor = UIColor.black.cgColor
        firstProfileImage.layer.cornerRadius = 18
        firstProfileImage.clipsToBounds = true
        firstProfileImage.snp.makeConstraints { (make) in
            make.left.equalTo(activityOverlay.snp.left).offset(10)
            make.top.equalTo(activityOverlay.snp.top).offset(1)
            make.width.equalTo(activityOverlay.snp.width).dividedBy(12)
            make.height.equalTo(activityOverlay.snp.height).dividedBy(1.1)
        }
        
        activityOverlay.addSubview(secondProfileImage)
        secondProfileImage.backgroundColor = UIColor.green
        secondProfileImage.layer.masksToBounds = true
        secondProfileImage.layer.borderColor = UIColor.black.cgColor
        secondProfileImage.layer.cornerRadius = 18
        secondProfileImage.clipsToBounds = true
        secondProfileImage.snp.makeConstraints { (make) in
            make.left.equalTo(firstProfileImage.snp.right).offset(3)
            make.top.equalTo(activityOverlay.snp.top).offset(1)
            make.width.equalTo(activityOverlay.snp.width).dividedBy(12)
            make.height.equalTo(activityOverlay.snp.height).dividedBy(1.1)
        }
        
        activityOverlay.addSubview(thirdProfileImage)
        thirdProfileImage.backgroundColor = UIColor.green
        thirdProfileImage.layer.masksToBounds = true
        thirdProfileImage.layer.borderColor = UIColor.black.cgColor
        thirdProfileImage.layer.cornerRadius = 18
        thirdProfileImage.clipsToBounds = true
        thirdProfileImage.snp.makeConstraints { (make) in
            make.left.equalTo(secondProfileImage.snp.right).offset(3)
            make.top.equalTo(activityOverlay.snp.top).offset(1)
            make.width.equalTo(activityOverlay.snp.width).dividedBy(12)
            make.height.equalTo(activityOverlay.snp.height).dividedBy(1.1)
        }
        
        activityOverlay.addSubview(numberOfAttendeesLabel)
        numberOfAttendeesLabel.text = "10 Attending"
        numberOfAttendeesLabel.font = UIFont(name: "TrebuchetMS-Bold", size: 12)
        numberOfAttendeesLabel.textColor = UIColor.black
        numberOfAttendeesLabel.snp.makeConstraints { (make) in
            make.right.equalTo(activityOverlay.snp.right).offset(-20)
            make.top.equalTo(activityOverlay.snp.top).offset(8)
            
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func downloadImage(at url:String, completion: @escaping (Bool, UIImage)->()){
        let session = URLSession.shared
        let newUrl = URL(string: url)
        if let unwrappedUrl = newUrl {
            let request = URLRequest(url: unwrappedUrl)
            let task = session.dataTask(with: request) { (data, response, error) in
                guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
                
                
                print(data)
                guard let image = UIImage(data: data) else { return }
                completion(true, image)
            }
            task.resume()
        }
        
    }
    func updateCell(with activity: Activity) {
       self.activityLabel.text = activity.name
        self.dateLabel.text = activity.date
        self.locationLabel.text = activity.location
        self.activityImageView.image = UIImage(named: "snow")
//        self.downloadImage(at: activity.image) { (success, image) in
//            DispatchQueue.main.async {
//                self.activityImageView.image = image
//                self.setNeedsLayout()
//            }
//        }
        
        
    }
    
}
