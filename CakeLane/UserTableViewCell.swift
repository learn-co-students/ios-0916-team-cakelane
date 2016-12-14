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
    var creatorLabel = UILabel()
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
        profileImage.layer.borderColor = UIColor.black.cgColor
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        profileImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9).isActive = true
        profileImage.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9).isActive = true
        profileImage.layer.cornerRadius = contentView.frame.height / 1.5
        profileImage.clipsToBounds = true
        profileImage.layer.masksToBounds = true
        
        contentView.addSubview(nameLabel)
        nameLabel.text = ""
        nameLabel.font = UIFont.helFont(with: 16)
        nameLabel.textColor = UIColor.black
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(profileImage.snp.right).offset(15)
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.8)
            make.height.equalTo(contentView.snp.height).dividedBy(1.1)
        }
        
        contentView.addSubview(creatorLabel)
        creatorLabel.text = "Creator"
        creatorLabel.font = UIFont.helFont(with: 12)
        creatorLabel.textColor = UIColor.orange
        creatorLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.left)
            make.centerY.equalTo(contentView.snp.centerY).offset(17)
            make.width.equalTo(contentView.snp.width).dividedBy(5)
            make.height.equalTo(contentView.snp.height).dividedBy(1.1)
        }
        creatorLabel.isHidden = true
    
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
                
                guard let image = UIImage(data: data) else { return }
                completion(true, image)
            }
            task.resume()
        }
        
    }
    
}
