//
//  ActivitiesTableViewCell.swift
//  CakeLane
//
//  Created by Henry Chan on 11/30/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import UIKit
import Firebase

class UserTableViewCell: UITableViewCell {
    

    var profileImage = UIImageView()
    var nameLabel = UILabel()
    let ref = FIRDatabase.database().reference()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(profileImage)
        profileImage.backgroundColor = UIColor.green
//        profileImage.layer.masksToBounds = true
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.cornerRadius = 23
        profileImage.clipsToBounds = true
        profileImage.layer.masksToBounds = true
        profileImage.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(10)
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.equalTo(contentView.snp.width).dividedBy(9)
            make.width.equalTo(contentView.snp.width)
            make.height.equalTo(contentView.snp.height).dividedBy(1.4)

        }
        
        contentView.addSubview(nameLabel)
        nameLabel.text = ""
        nameLabel.font = UIFont(name: "TrebuchetMS-Bold", size: 12)
        nameLabel.textColor = UIColor.black
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(profileImage.snp.right).offset(15)
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.equalTo(contentView.snp.width).dividedBy(2)
            make.height.equalTo(contentView.snp.height).dividedBy(1.1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
//    func updateCell(with activity: Activity) {
//       nameLabel.text = activity.name
//        
//        
////        var arrayOfImages: [UIImage] = []
////        for eachUser in activity.attendees.keys {
////            guard let teamID = UserDefaults.standard.string(forKey: "teamID") else {return}
////            let imageRef = ref.child(teamID).child("users").child(eachUser).child("image72")
////            
////            imageRef.observeSingleEvent(of:.value, with: { (snapshot) in
////                
////                let url = snapshot.value as! String
////                self.downloadImage(at: url, completion: { (success, image) in
////                    arrayOfImages.append(image)
////                    OperationQueue.main.addOperation {
////                        self.profileImage.image = image
////                        
////                    }
////                })
////            })
////        }
//        
//        
//
//    }
    func downloadImage(at url:String, completion: @escaping (Bool, UIImage)->()){
        let session = URLSession.shared
        let newUrl = URL(string: url)
        if let unwrappedUrl = newUrl {
            let request = URLRequest(url: unwrappedUrl)
            let task = session.dataTask(with: request) { (data, response, error) in
                guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
                
                guard let image = UIImage(data: data) else { return }
                completion(true, image)
            }
            task.resume()
        }
        
    }
    
}
