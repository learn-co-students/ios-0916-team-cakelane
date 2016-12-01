//
//  SlackAPIClient.swift
//  CakeLane
//
//  Created by Bejan Fozdar on 11/17/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import Foundation
import Alamofire


class SlackAPIClient {
    
    static let store = SlackMessageStore.sharedInstance
    
    // Get User.Info from Slack
    class func getUserInfo(with completion: @escaping ([String: Any])->()) {
        // extract slack token & user id from user defaults
        guard let token = UserDefaults.standard.object(forKey: "SlackToken") else { return }
        guard let userID = UserDefaults.standard.object(forKey: "SlackUser") else { return }

        let urlString = "https://slack.com/api/users.info?user=\(userID)&token=\(token)"
        guard let url = URL(string: urlString) else { return }
        print(url)
        Alamofire.request(url).responseJSON { response in
            guard let JSON = response.result.value else { return }
            let completeJSON = JSON as! [String : Any]
            completion(completeJSON)
        }

    }
    // Post Slack Notification to webhook URL
    class func postSlackNotification() {
    
        let store = SlackMessageStore.sharedInstance

//        let newAttachment = Attachment(title: "Gamer Night", colorHex: "#b942f4", pretext: "*New Activity:* APP POST TEST IS WORKING!! _by Bejan_.", authorName: "Bejan Fozdar", authorLink: "http://github.com/ixyzt", authorIcon: "https://secure.gravatar.com/avatar/6fff6c447ce00e3080ffe5bf969811db.jpg?s=72&d=https%3A%2F%2Fa.slack-edge.com%2F3654%2Fimg%2Favatars%2Fava_0023-24.png", titleLink: "https://docs.google.com/document/d/1iGqv8zaQHcxWUmQkLAntNRLTy5czsLPWHnkbhrPK3ig/edit?usp=sharing", text: "THIS IS A TEST!", imageURL: "http://oi44.tinypic.com/t8lxfn.jpg", thumbURL: "http://static4.redcart.pl/templates/images/thumb/7546/75/75/en/0/templates/images/products/7546/100bfb31d29178fd8aab980d11db5682.jpg")
        
        //print("\n\n\n\nTHIS IS THE Attachment Dictionary!!! ++++++++++\n\n\(newAttachment.dictionary)")
        
//        store.attachmentDictionary = newAttachment.dictionary
        print("\n\n\n\nTHIS IS THE SlackMessageStore Attachment Dictionary!!! ++++++++++\n\n\(store.attachmentDictionary)")
        
        //TODO: Turn this into a model, and include Attachment initialization
        let notificationParameters: [String:Any] = [
            "icon_url": "http://gdurl.com/Ei8e",
            "text": "This was posted by running the app",
            "attachments": [store.attachmentDictionary]
        ]
        
        let webhookURL = "https://hooks.slack.com/services/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"
        guard let url = URL(string: webhookURL) else { return }
        // print(url)
        Alamofire.request(url, method: .post, parameters: notificationParameters, encoding: JSONEncoding.default)
        .response { (response) in
//            print("\n\n\nTHIS IS THE RESPONSE REQUEST!!! ++++++++++\(response.request)")  // original URL request
//            print("\n\n\n\nTHIS IS THE RESPONSE RESPONSE!!! ++++++++++\(response.response)") // URL response
//            print("\n\n\n\nTHIS IS THE RESPONSE DATA!!! ++++++++++\(response.data)")     // server data
        }
        
    }
    
    




}
