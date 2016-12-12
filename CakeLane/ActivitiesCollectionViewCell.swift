//
//  ActivitiesCollectionViewCell.swift
//  CakeLane
//
//  Created by Rama Milaneh on 11/22/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import UIKit
import Firebase

protocol ActivitiesDelegate: class {

    func attendeesTapped(sender: ActivitiesCollectionViewCell)

}

class ActivitiesCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate {

    var activityImageView = UIImageView()
    var activityOverlay = UIView()
    var transparentButton = UIButton(type: UIButtonType.system)
    var activityLabel = UILabel()
    var locationLabel = UILabel()
    var timeLabel = UILabel()
    var dateLabel = UILabel()
    var numberOfAttendeesLabel = UILabel()
    var firstProfileImage = UIImageView()
    var secondProfileImage = UIImageView()
    var thirdProfileImage = UIImageView()
    let ref = FIRDatabase.database().reference()
    var placeholderImage = true

    // Each cell (activity) has an array of attending users and their corresponding images (same indices for both arrays)
    var users = [User]()
    var arrayOfImages = [UIImage]()

    var delegate: ActivitiesDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        ////////////////////////////////////////// does the data print out correctly??

        contentView.addSubview(activityImageView)
        activityImageView.backgroundColor = UIColor.black
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
        activityLabel.shadowColor = UIColor.black
        activityLabel.shadowOffset.height = 3
        activityLabel.shadowOffset.width = 3
        activityLabel.textColor = UIColor.white
        activityLabel.snp.makeConstraints { (make) in
            make.left.equalTo(activityImageView.snp.left).offset(10)
            make.top.equalTo(activityImageView.snp.bottom).offset(-120)
        }


        activityImageView.addSubview(locationLabel)
        locationLabel.font = UIFont(name: "TrebuchetMS-Bold", size: 16)
        locationLabel.shadowColor = UIColor.black
        locationLabel.shadowOffset.height = 3
        locationLabel.shadowOffset.width = 3
        locationLabel.textColor = UIColor.white
        locationLabel.snp.makeConstraints { (make) in
            make.left.equalTo(activityImageView.snp.left).offset(10)
            make.top.equalTo(activityLabel.snp.bottom)
        }

        activityImageView.addSubview(dateLabel)
        dateLabel.font = UIFont(name: "TrebuchetMS-Bold", size: 16)
        dateLabel.shadowColor = UIColor.black
        dateLabel.shadowOffset.height = 3
        dateLabel.shadowOffset.width = 3
        dateLabel.textColor = UIColor.white
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(activityImageView.snp.left).offset(10)
            make.top.equalTo(locationLabel.snp.bottom)
        }


        activityImageView.addSubview(timeLabel)
        timeLabel.font = UIFont(name: "TrebuchetMS-Bold", size: 16)
        timeLabel.shadowColor = UIColor.black
        timeLabel.shadowOffset.height = 3
        timeLabel.shadowOffset.width = 3
        timeLabel.textColor = UIColor.white
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(dateLabel.snp.right).offset(5)
            make.top.equalTo(locationLabel.snp.bottom)

        }

        activityOverlay.addSubview(firstProfileImage)
        firstProfileImage.contentMode = UIViewContentMode.scaleToFill
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
        secondProfileImage.contentMode = UIViewContentMode.scaleToFill
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
        thirdProfileImage.contentMode = UIViewContentMode.scaleToFill
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
            make.centerY.equalTo(activityOverlay.snp.centerY)

        }

        contentView.addSubview(transparentButton)
        contentView.isUserInteractionEnabled = true
        transparentButton.backgroundColor = UIColor.clear
        transparentButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(activityOverlay.snp.centerX)
            make.centerY.equalTo(activityOverlay.snp.centerY)
            make.height.equalTo(activityOverlay.snp.height)
            make.width.equalTo(activityOverlay.snp.width)
        }


        transparentButton.isUserInteractionEnabled = true
        transparentButton.isEnabled = true
        transparentButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func buttonAction(sender: UIButton) {

        delegate?.attendeesTapped(sender: self)

    }

    //////////////////////////////////

    func updateCell(with activity: Activity, handler: @escaping (Bool) -> ()) {

        self.activityLabel.text = activity.name
        self.dateLabel.text = activity.date
        self.locationLabel.text = activity.location

        self.numberOfAttendeesLabel.text = ("\(String(activity.attendees.count)) attending   >")

        // update cell with local placeholder image

         //cell.activityImageView.sd_setImage(with: URL(string: activity.image), placeholderImage: UIImage(named: "appLogo-black"))

        if activity.image == " " {
            self.activityImageView.image = UIImage(named: "appLogo-black")
            self.placeholderImage = true
        }

        handler(true)

    }

    // download images
    func downloadAttendeeImages(activity: Activity) {


        FirebaseClient.downloadAttendeeImagesAndInfo(for: activity) { (images, users) in

            self.arrayOfImages = images
            self.users = users

            OperationQueue.main.addOperation {
                if self.arrayOfImages.count == 1 {
                    self.firstProfileImage.image = self.arrayOfImages[0]
                } else if self.arrayOfImages.count == 2 {
                    self.firstProfileImage.image = self.arrayOfImages[0]
                    self.secondProfileImage.image = self.arrayOfImages[1]
                } else if self.arrayOfImages.count >= 3 {
                    self.firstProfileImage.image = self.arrayOfImages[0]
                    self.secondProfileImage.image = self.arrayOfImages[1]
                    self.thirdProfileImage.image = self.arrayOfImages[2]
                }
            }
        }

    }

}
