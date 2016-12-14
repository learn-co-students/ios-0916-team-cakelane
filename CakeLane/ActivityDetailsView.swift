//
//  ActivityDetailsView.swift
//  CakeLane
//
//  Created by Rama Milaneh on 11/26/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import UIKit

// MARK: Delegate to handle the functions
protocol ActivityDetailDelegate: class {
    func closeButtonTapped(with sender: ActivityDetailsView)
    func editButtonTapped(with sender: ActivityDetailsView)
    func joinButtonTapped(with sender: ActivityDetailsView)
    func leaveActivity(with sender: ActivityDetailsView)
    func deleteActivity(with sender: ActivityDetailsView)
    func reportButtonTapped(with sender: ActivityDetailsView)
}

class ActivityDetailsView: UIView {

    @IBOutlet var contentView: UIView!
    var activityImageView: UIImageView!
    var closeButton = CloseButton()
    var editButton =  UIButton()
    var joinButton = UIButton()
    var deleteButton = UIButton()
    var reportButton = ReportButton()
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
    
    // Get the selected activity info from AVC and update the labels and image
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

    // Initilizer
    private func commonInit() {

        Bundle.main.loadNibNamed("ActivityDetailsView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.constrainEdges(to: self)
        contentView.backgroundColor = UIColor.black
        // setup functions
        setupImageView()
        setupCloseButton()
        setupEditButton()
        setupJoinButton()
        setupDeleteButton()
        setupreportButton()
        setupLabel()

    }

    // MARK: Setup functions
    
    // Setup Activity Image
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

    // Setup close button
    func setupCloseButton() {

        self.contentView.addSubview(closeButton)
        self.closeButton.translatesAutoresizingMaskIntoConstraints = false
        self.closeButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant:20.0).isActive = true
        self.closeButton.rightAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.rightAnchor).isActive = true
        self.closeButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.14, constant: 0.0).isActive = true
        self.closeButton.heightAnchor.constraint(equalTo: self.closeButton.widthAnchor).isActive = true
        self.closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }

    // Close button target
    func close() {
        delegate?.closeButtonTapped(with: self)
    }

    // Setup edit button
    func setupEditButton() {

        self.contentView.addSubview(editButton)
        self.editButton.translatesAutoresizingMaskIntoConstraints = false
        self.editButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant:-50).isActive = true
        self.editButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.8).isActive = true
        self.editButton.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.editButton.setTitle("EDIT", for: .normal)
        self.editButton.titleLabel?.font = UIFont(name: "Futura-Medium", size: 17)
        self.editButton.setTitleColor(UIColor.white, for: .normal)
        self.editButton.layer.borderWidth = 1
        self.editButton.clipsToBounds = true
        self.editButton.layer.cornerRadius = 17
        self.editButton.layer.borderWidth = 2
        self.editButton.layer.borderColor = UIColor(red: 244/255.0, green: 88/255.0, blue: 53/255.0, alpha: 1.0).cgColor
        self.editButton.backgroundColor = UIColor.clear
        editButton.addTarget(self, action: #selector(edit), for: .touchUpInside)


    }

    // Edit button target
    func edit() {
        delegate?.editButtonTapped(with: self)
    }

    // Setup report button
    func setupreportButton() {

        self.contentView.addSubview(reportButton)
        self.reportButton.translatesAutoresizingMaskIntoConstraints = false
        self.reportButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant:20.0).isActive = true
        self.reportButton.leftAnchor.constraint(equalTo: self.activityImageView.layoutMarginsGuide.leftAnchor, constant: 0).isActive = true
        self.reportButton.widthAnchor.constraint(equalTo: self.activityImageView.widthAnchor, multiplier: 0.14, constant: 0.0).isActive = true
        self.reportButton.heightAnchor.constraint(equalTo: self.reportButton.widthAnchor).isActive = true
        self.reportButton.addTarget(self, action: #selector(report), for: .touchUpInside)
    }

    // Report button target
    func report() {

        delegate?.reportButtonTapped(with: self)

    }

    // Setup join button
    func setupJoinButton(){

        self.joinButton = UIButton()
        self.contentView.addSubview(joinButton)
        self.joinButton.translatesAutoresizingMaskIntoConstraints = false
        self.joinButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant:-30.0).isActive = true
        self.joinButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.8).isActive = true
        self.joinButton.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.joinButton.setTitle("JOIN", for: .normal)
        self.joinButton.titleLabel?.font = UIFont(name: "Futura-Medium", size: 17)
        self.joinButton.setTitleColor(UIColor.white, for: .normal)
        self.joinButton.layer.borderWidth = 1
        self.joinButton.clipsToBounds = true
        self.joinButton.layer.cornerRadius = 17
        self.joinButton.layer.borderWidth = 2
        self.joinButton.layer.borderColor = UIColor(red: 244/255.0, green: 88/255.0, blue: 53/255.0, alpha: 1.0).cgColor
        self.joinButton.backgroundColor = UIColor.clear
        joinButton.addTarget(self, action: #selector(join), for: .touchUpInside)
    }
    
    // Join button target
    func join() {
        
        let titleLabelIsJoin = joinButton.titleLabel!.text == "JOIN"
        
        titleLabelIsJoin ? delegate?.joinButtonTapped(with: self) : delegate?.leaveActivity(with: self)
    }
    
    func adjustButtonTitle(isAttendee: Bool) {
        joinButton.setTitle(isAttendee ? "LEAVE" : "JOIN", for: .normal)
    }

    // Setup delete button
    func setupDeleteButton(){

        self.contentView.addSubview(deleteButton)
        self.deleteButton.translatesAutoresizingMaskIntoConstraints = false
        self.deleteButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant:-10.0).isActive = true
        self.deleteButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.8).isActive = true
        self.deleteButton.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.deleteButton.setTitle("Delete", for: .normal)
        self.deleteButton.setTitleColor(UIColor.white, for: .normal)
        self.deleteButton.layer.borderWidth = 1
        self.deleteButton.clipsToBounds = true
        self.deleteButton.layer.cornerRadius = 17
        self.deleteButton.layer.borderWidth = 2
        self.deleteButton.layer.borderColor = UIColor(red: 244/255.0, green: 88/255.0, blue: 53/255.0, alpha: 1.0).cgColor
        self.deleteButton.backgroundColor = UIColor.clear
        deleteButton.addTarget(self, action: #selector(deleteActivityfromFirebase), for: .touchUpInside)
    }

    // Delete button target
    func deleteActivityfromFirebase() {
        delegate?.deleteActivity(with: self)
    }

    // Setup labels
    func setupLabel() {

        self.activityImageView.addSubview(nameLabel)
        nameLabel.font = UIFont(name: "Futura-Bold", size: 17)
        nameLabel.textColor = UIColor.white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leftAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leftAnchor, constant: 10).isActive = true
        self.nameLabel.bottomAnchor.constraint(equalTo: self.activityImageView.bottomAnchor, constant: -20).isActive = true

        self.contentView.addSubview(locationTitlelabel)
        locationTitlelabel.text = "Location"
        locationTitlelabel.font = UIFont(name: "Futura-Medium", size: 17)
        locationTitlelabel.textColor = UIColor(red: 244/255.0, green: 88/255.0, blue: 53/255.0, alpha: 1.0)
        locationTitlelabel.translatesAutoresizingMaskIntoConstraints = false
        locationTitlelabel.leftAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leftAnchor, constant: 10).isActive = true
        locationTitlelabel.topAnchor.constraint(equalTo: self.activityImageView.bottomAnchor, constant: 10).isActive = true

        self.contentView.addSubview(locationLabel)
        locationLabel.font = UIFont(name: "Futura-Medium", size: 14)
        locationLabel.textColor = UIColor.black
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.leftAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leftAnchor, constant: 10).isActive = true
        locationLabel.topAnchor.constraint(equalTo: self.locationTitlelabel.bottomAnchor).isActive = true
        locationLabel.backgroundColor = UIColor.white
        locationLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.contentView.addSubview(dateTitlelabel)
        dateTitlelabel.text = "Date"
        dateTitlelabel.font = UIFont(name: "Futura-Medium", size: 17)
        dateTitlelabel.textColor = UIColor(red: 244/255.0, green: 88/255.0, blue: 53/255.0, alpha: 1.0)
        dateTitlelabel.translatesAutoresizingMaskIntoConstraints = false
        dateTitlelabel.leftAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leftAnchor, constant: 10).isActive = true
        dateTitlelabel.topAnchor.constraint(equalTo: self.locationLabel.bottomAnchor, constant: 10).isActive = true


        self.contentView.addSubview(dateLabel)
        dateLabel.font = UIFont(name: "Futura-Medium", size: 14)
        dateLabel.textColor = UIColor.black
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.leftAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leftAnchor, constant: 10).isActive = true
        dateLabel.topAnchor.constraint(equalTo: self.dateTitlelabel.bottomAnchor).isActive = true
        dateLabel.backgroundColor = UIColor.white
        dateLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dateLabel.backgroundColor = UIColor.white
        
        self.contentView.addSubview(descriptionTitlelabel)
        descriptionTitlelabel.text = "Description"
        descriptionTitlelabel.font = UIFont(name: "Futura-Medium", size: 17)
        descriptionTitlelabel.textColor = UIColor(red: 244/255.0, green: 88/255.0, blue: 53/255.0, alpha: 1.0)

        descriptionTitlelabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionTitlelabel.leftAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leftAnchor, constant: 10).isActive = true
        descriptionTitlelabel.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor, constant: 10).isActive = true

        self.contentView.addSubview(descriptionTextView)
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.leftAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leftAnchor, constant: 10).isActive = true
        descriptionTextView.topAnchor.constraint(equalTo: self.descriptionTitlelabel.bottomAnchor, constant: 0).isActive = true
        descriptionTextView.backgroundColor = UIColor.white
        descriptionTextView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20).isActive = true
        descriptionTextView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.15).isActive = true
        descriptionTextView.font = UIFont(name: "Futura-Medium", size: 14)
        descriptionTextView.backgroundColor = UIColor.white
        descriptionTextView.textColor = UIColor.black
        descriptionTextView.isScrollEnabled = true
        descriptionTextView.isEditable = false
    }

}
// Pin the view to another view
extension UIView {

    func constrainEdges(to view: UIView) {

        leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }



}

// Extension to change the color of image
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
