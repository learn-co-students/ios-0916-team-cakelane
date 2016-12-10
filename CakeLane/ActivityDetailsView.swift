//
//  ActivityDetailsView.swift
//  CakeLane
//
//  Created by Rama Milaneh on 11/26/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import UIKit

protocol ActivityDetailDelegate: class {
    func closeButtonTapped(with sender: ActivityDetailsView)
    func editButtonTapped(with sender: ActivityDetailsView)
    func joinButtonTapped(with sender: ActivityDetailsView)
    func leaveActivity(with sender: ActivityDetailsView)
    func deleteActivity(with sender: ActivityDetailsView)
}

class ActivityDetailsView: UIView {
    
    @IBOutlet var contentView: UIView!
    var activityImageView: UIImageView!
    var closeButton = UIButton()
    var editButton =  UIButton()
    var joinButton = UIButton()
    var deleteButton = UIButton()
    var nameLabel = UILabel()
    var activityOverlay = UIView()
    var numberOfAttendeesLabel = UILabel()
    var firstProfileImage = UIImageView()
    var secondProfileImage = UIImageView()
    var thirdProfileImage = UIImageView()
    var locationTitlelabel = UILabel()
    var locationLabel = UILabel()
    var dateTitlelabel = UILabel()
    var dateLabel = UILabel()
    var descriptionTitlelabel = UILabel()
    var descriptionTextView = UITextView()
    
    weak var delegate: ActivityDetailDelegate?
    
    var selectedActivity: Activity! {
        
        didSet {
            OperationQueue.main.addOperation {
                self.activityImageView.sd_setImage(with: URL(string:self.selectedActivity.image))
                self.nameLabel.text = self.selectedActivity.name
                self.locationLabel.text = "  \(self.selectedActivity.location)"
                self.dateLabel.text = "  \(self.selectedActivity.date)"
                self.dateLabel.text = "  \(self.selectedActivity.date)"
                self.descriptionTextView.text = "  \(self.selectedActivity.description)"
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        
        Bundle.main.loadNibNamed("ActivityDetailsView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.constrainEdges(to: self)
        contentView.backgroundColor = UIColor.black
        setupImageView()
        setupCloseButton()
        setupEditButton()
        setupJoinButton()
        setupDeleteButton()
      //  setupActivityOverLay()
        setupLabel()
        
    }
    
    func setupImageView() {
        
        self.activityImageView = UIImageView()
        self.contentView.addSubview(activityImageView)
        self.activityImageView.translatesAutoresizingMaskIntoConstraints = false
        self.activityImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.activityImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        self.activityImageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.4).isActive = true
        self.activityImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.activityImageView.backgroundColor = UIColor.clear
        self.activityImageView.contentMode = .scaleAspectFill
        self.activityImageView.clipsToBounds = true
    }
    
    func setupCloseButton() {
        
        self.contentView.addSubview(closeButton)
        self.closeButton.translatesAutoresizingMaskIntoConstraints = false
        self.closeButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant:10.0).isActive = true
        self.closeButton.leftAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leftAnchor).isActive = true
        self.closeButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.1, constant: 0.0).isActive = true
        self.closeButton.heightAnchor.constraint(equalTo: self.closeButton.widthAnchor).isActive = true
        let image = UIImage(named: "exit")
        self.closeButton.setImage(image, for: .normal)
        self.closeButton.backgroundColor = UIColor.clear
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    func close() {
        delegate?.closeButtonTapped(with: self)
    }
    
    func setupEditButton() {
        
        self.contentView.addSubview(editButton)
        self.editButton.translatesAutoresizingMaskIntoConstraints = false
        self.editButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant:10.0).isActive = true
        self.editButton.rightAnchor.constraint(equalTo: self.activityImageView.layoutMarginsGuide.rightAnchor, constant: 0).isActive = true
        self.editButton.widthAnchor.constraint(equalTo: self.activityImageView.widthAnchor, multiplier: 0.1, constant: 0.0).isActive = true
        self.editButton.heightAnchor.constraint(equalTo: self.editButton.widthAnchor).isActive = true
        
        let image = UIImage(named: "pencil")
        
        self.editButton.setImage(image, for: .normal)
        
        editButton.addTarget(self, action: #selector(edit), for: .touchUpInside)
        
        
    }
    
    func edit() {
        delegate?.editButtonTapped(with: self)
    }
    
    func setupJoinButton(){
        
        self.joinButton = UIButton()
        self.contentView.addSubview(joinButton)
        self.joinButton.translatesAutoresizingMaskIntoConstraints = false
        self.joinButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant:-30.0).isActive = true
        self.joinButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.25).isActive = true
        self.joinButton.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.joinButton.setTitle("Join", for: .normal)
        self.joinButton.setTitleColor(UIColor.darkGray, for: .normal)
        self.joinButton.layer.borderWidth = 1
        self.joinButton.clipsToBounds = true
        self.joinButton.layer.cornerRadius = 10
        self.joinButton.backgroundColor = UIColor.orange
        joinButton.addTarget(self, action: #selector(join), for: .touchUpInside)
    }
    
    func setupDeleteButton(){
        
        self.contentView.addSubview(deleteButton)
        self.deleteButton.translatesAutoresizingMaskIntoConstraints = false
        self.deleteButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant:-30.0).isActive = true
        self.deleteButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.25).isActive = true
        self.deleteButton.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.deleteButton.setTitle("Delete", for: .normal)
        self.deleteButton.setTitleColor(UIColor.darkGray, for: .normal)
        self.deleteButton.layer.borderWidth = 1
        self.deleteButton.clipsToBounds = true
        self.deleteButton.layer.cornerRadius = 10
        self.deleteButton.backgroundColor = UIColor.orange
        deleteButton.addTarget(self, action: #selector(deleteActivityfromFirebase), for: .touchUpInside)
    }
    
    func deleteActivityfromFirebase() {
        delegate?.deleteActivity(with: self)
    }

    
    func join() {
        
        let titleLabelIsJoin = joinButton.titleLabel!.text == "Join"
        
        titleLabelIsJoin ? delegate?.joinButtonTapped(with: self) : delegate?.leaveActivity(with: self)
    }
    
    func adjustButtonTitle(isAttendee: Bool) {
        joinButton.setTitle(isAttendee ? "Leave" : "Join", for: .normal)
    }
    
    func setupLabel() {
        
        self.activityImageView.addSubview(nameLabel)
        nameLabel.font = UIFont(name: "TrebuchetMS-Bold", size: 20)
        nameLabel.textColor = UIColor.white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leftAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leftAnchor, constant: 10).isActive = true
        self.nameLabel.bottomAnchor.constraint(equalTo: self.activityImageView.bottomAnchor, constant: -20).isActive = true
        
        self.contentView.addSubview(locationTitlelabel)
        locationTitlelabel.text = "Location"
        locationTitlelabel.font = UIFont(name: "TrebuchetMS-Bold", size: 20)
        locationTitlelabel.textColor = UIColor.orange
        locationTitlelabel.translatesAutoresizingMaskIntoConstraints = false
        locationTitlelabel.leftAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leftAnchor, constant: 10).isActive = true
        locationTitlelabel.topAnchor.constraint(equalTo: self.activityImageView.bottomAnchor, constant: 10).isActive = true
        
        
        self.contentView.addSubview(locationLabel)
        locationLabel.font = UIFont(name: "TrebuchetMS-Bold", size: 14)
        locationLabel.textColor = UIColor.black
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.leftAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leftAnchor, constant: 10).isActive = true
        locationLabel.topAnchor.constraint(equalTo: self.locationTitlelabel.bottomAnchor).isActive = true
        locationLabel.backgroundColor = UIColor.white
        locationLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        locationLabel.layer.cornerRadius = 5
        locationLabel.layer.borderWidth = 1
        locationLabel.clipsToBounds = true
        
        self.contentView.addSubview(dateTitlelabel)
        dateTitlelabel.text = "Date"
        dateTitlelabel.font = UIFont(name: "TrebuchetMS-Bold", size: 20)
        dateTitlelabel.textColor = UIColor.orange
        dateTitlelabel.translatesAutoresizingMaskIntoConstraints = false
        dateTitlelabel.leftAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leftAnchor, constant: 10).isActive = true
        dateTitlelabel.topAnchor.constraint(equalTo: self.locationLabel.bottomAnchor, constant: 10).isActive = true
        
        
        self.contentView.addSubview(dateLabel)
        dateLabel.font = UIFont(name: "TrebuchetMS-Bold", size: 14)
        dateLabel.textColor = UIColor.black
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.leftAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leftAnchor, constant: 10).isActive = true
        dateLabel.topAnchor.constraint(equalTo: self.dateTitlelabel.bottomAnchor).isActive = true
        dateLabel.backgroundColor = UIColor.white
        dateLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dateLabel.backgroundColor = UIColor.white
        dateLabel.layer.cornerRadius = 5
        dateLabel.layer.borderWidth = 1
        dateLabel.clipsToBounds = true
        
        self.contentView.addSubview(descriptionTitlelabel)
        descriptionTitlelabel.text = "Description"
        descriptionTitlelabel.font = UIFont(name: "TrebuchetMS-Bold", size: 20)
        descriptionTitlelabel.textColor = UIColor.orange
        descriptionTitlelabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionTitlelabel.leftAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leftAnchor, constant: 10).isActive = true
        descriptionTitlelabel.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor, constant: 5).isActive = true
        
        self.contentView.addSubview(descriptionTextView)
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.leftAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leftAnchor, constant: 10).isActive = true
        descriptionTextView.topAnchor.constraint(equalTo: self.descriptionTitlelabel.bottomAnchor, constant: 10).isActive = true
        descriptionTextView.backgroundColor = UIColor.white
        descriptionTextView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20).isActive = true
        descriptionTextView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        descriptionTextView.font = UIFont(name: "TrebuchetMS-Bold", size: 14)
        descriptionTextView.clipsToBounds = true
        descriptionTextView.layer.cornerRadius = 5
        descriptionTextView.backgroundColor = UIColor.white
        descriptionTextView.textColor = UIColor.black
        descriptionTextView.isScrollEnabled = true
        descriptionTextView.isEditable = false
    }
    
    
    func setupActivityOverLay() {
        
        self.contentView.addSubview(activityOverlay)
        activityOverlay.backgroundColor = UIColor.white
        activityOverlay.layer.borderWidth = 1
        activityOverlay.layer.borderColor = UIColor.lightGray.cgColor
        activityOverlay.translatesAutoresizingMaskIntoConstraints = false
        activityOverlay.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        activityOverlay.topAnchor.constraint(equalTo: activityImageView.bottomAnchor).isActive = true
        activityOverlay.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        activityOverlay.heightAnchor.constraint(equalTo: self.activityImageView.heightAnchor, multiplier: 0.14).isActive = true
        
        activityOverlay.addSubview(numberOfAttendeesLabel)
        numberOfAttendeesLabel.text = "10 Attending"
        numberOfAttendeesLabel.font = UIFont(name: "TrebuchetMS-Bold", size: 12)
        numberOfAttendeesLabel.textColor = UIColor.black
        numberOfAttendeesLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfAttendeesLabel.topAnchor.constraint(equalTo: self.activityOverlay.topAnchor, constant: 10).isActive = true
        numberOfAttendeesLabel.rightAnchor.constraint(equalTo: self.activityOverlay.rightAnchor, constant: -20).isActive = true
        
        addSubViewToOverlay(profileImage: firstProfileImage)
        addSubViewToOverlay(profileImage: secondProfileImage)
        addSubViewToOverlay(profileImage: thirdProfileImage)
        
        firstProfileImage.leftAnchor.constraint(equalTo: self.activityImageView.layoutMarginsGuide.leftAnchor, constant: 5).isActive = true
        secondProfileImage.leftAnchor.constraint(equalTo: self.firstProfileImage.rightAnchor, constant: 3).isActive = true
        thirdProfileImage.leftAnchor.constraint(equalTo: self.secondProfileImage.rightAnchor, constant: 3).isActive = true
        
    }
    
    func addSubViewToOverlay(profileImage: UIImageView) {
        
        activityOverlay.addSubview(profileImage)
        profileImage.backgroundColor = UIColor.green
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.cornerRadius = 17
        profileImage.clipsToBounds = true
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.topAnchor.constraint(equalTo: self.activityOverlay.topAnchor, constant: 1.8).isActive = true
        profileImage.widthAnchor.constraint(equalTo: self.activityOverlay.widthAnchor, multiplier: 1/12).isActive = true
        profileImage.heightAnchor.constraint(equalTo: self.activityOverlay.heightAnchor, multiplier: 1/1.2).isActive = true
    }
    
    
}
// pin the view to another view
extension UIView {
    
    func constrainEdges(to view: UIView) {
        
        leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    
}

// extension to change the color of image
extension UIImage {
    
    func tint(color: UIColor) -> UIImage? {
        
        let drawRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.clip(to: drawRect, mask: self.cgImage!)
        color.setFill()
        UIRectFill(drawRect)
        draw(in: drawRect, blendMode: .overlay, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage
        
    }
    
}
