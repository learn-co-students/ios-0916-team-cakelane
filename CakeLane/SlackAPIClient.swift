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
//            print(completeJSON)
            completion(completeJSON)
        }

    }
    
    class func postSlackNotification() {
        // Post Slack Notification to webhook URL
        
        let attachments: [[String:Any]] = [[
        "fallback": "*New Activity:* APP POST TEST IS WORKING!! _by Bejan_.",
        "color": "#b942f4",
        "pretext": "*New Activity:* APP POST TEST IS WORKING!! _by Bejan_.",
        "author_name": "Bejan Fozdar",
        "author_link": "http://github.com/ixyzt",
        "author_icon": "https://secure.gravatar.com/avatar/6fff6c447ce00e3080ffe5bf969811db.jpg?s=72&d=https%3A%2F%2Fa.slack-edge.com%2F3654%2Fimg%2Favatars%2Fava_0023-24.png",
        "title": "Gamer Night",
        "title_link": "https://docs.google.com/document/d/1iGqv8zaQHcxWUmQkLAntNRLTy5czsLPWHnkbhrPK3ig/edit?usp=sharing",
        "text": "THIS IS A TEST!",
        "image_url": "http://www.commondreams.org/sites/default/files/imce-images/screen_shot_2012-01-24_at_3.48.15_pm.png",
        "thumb_url": "http://nineplanets.org/images/themoon.jpg",
        "footer": "posted by Teem!",
        "footer_icon": "https://mlblogsmlbastian.files.wordpress.com/2010/07/tlogo.gif",
        "ts": 1480535140,
        "mrkdwn_in": ["fallback","text", "pretext"]
        ]]
        
        let parameters: [String:Any] = [
            "text":"Another Test for Attachments",
            "attachments": attachments
        ]
        
        let webhookURL = "https://hooks.slack.com/services/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"
        guard let url = URL(string: webhookURL) else { return }
        // print(url)
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
        .response { (response) in
//            print("\n\n\nTHIS IS THE RESPONSE REQUEST!!! ++++++++++\(response.request)")  // original URL request
//            print("\n\n\n\nTHIS IS THE RESPONSE RESPONSE!!! ++++++++++\(response.response)") // URL response
//            print("\n\n\n\nTHIS IS THE RESPONSE DATA!!! ++++++++++\(response.data)")     // server data
        }
        
    }
    
    




}
