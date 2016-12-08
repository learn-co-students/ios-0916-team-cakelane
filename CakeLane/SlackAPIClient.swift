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
    static let teamStore = TeamDataStore.sharedInstance
    
    // MARK: Get user token, then POST user to join the channel specified - uses channels:write
    class func userJoinChannel(with completion: @escaping ([String: Any])->()) {
        guard let token = UserDefaults.standard.object(forKey: "SlackToken") else { return }
        let channelName = "teem_activitiesa"
        let urlString = "https://slack.com/api/channels.join?token=\(token)&name=\(channelName)"
        guard let url = URL(string: urlString) else { return }
        Alamofire.request(url, method: .post).responseJSON { response in
            guard let JSON = response.result.value else { return }
            let completeJSON = JSON as! [String : Any]
            //            print("\n\n\nTHIS IS THE USER JOIN CHANNEL COMPLETION!!! ++++++++++\(completeJSON)")
            completion(completeJSON)
        }
    }
    
    // MARK: Get channels.list from Slack - uses scope channels:read
    class func getChannelsList(with completion: @escaping ([String: Any]?)->()) {
        // extract slack token & user id from user defaults
        guard let token = UserDefaults.standard.object(forKey: "SlackToken") else { completion(nil); return }
        let excludedArchive = 1 // includes archived channels, else set to 0
        
        let urlString = "https://slack.com/api/channels.list?token=\(token)&excluded_archive=\(excludedArchive)"
        guard let url = URL(string: urlString) else { return }
        print(url)
        Alamofire.request(url, method: .post).responseJSON { response in
            guard let JSON = response.result.value else { completion(nil); return }
            let completeJSON = JSON as! [String:Any]
            let channels = completeJSON["channels"] as! [[String:Any]]
            print("\n\n\nTHIS IS THE GET CHANNELS LIST API CALL RESPONSE!!! ++++++++++\n\n\(channels)\n\n\n\n")
            completion(completeJSON)
        }
    }
    
    
    // MARK: Get User.Info from Slack
    class func getUserInfo(with completion: @escaping ([String: Any]?)->()) {
        // extract slack token & user id from user defaults
        guard let token = UserDefaults.standard.object(forKey: "SlackToken") else { completion(nil); return }
        guard let userID = UserDefaults.standard.object(forKey: "SlackUser") else { completion(nil); return }

        let urlString = "https://slack.com/api/users.info?user=\(userID)&token=\(token)"
        guard let url = URL(string: urlString) else { return }
        print(url)
        Alamofire.request(url).responseJSON { response in
            guard let JSON = response.result.value else { completion(nil); return }
            let completeJSON = JSON as! [String : Any]
            completion(completeJSON)
        }
    }
    
    // MARK: Get Team.info from Slack - uses scope team:read
    class func getTeamInfo(with completion: @escaping ([String: Any]?)->()) {
        // extract slack token & user id from user defaults
        guard let token = UserDefaults.standard.object(forKey: "SlackToken") else { completion(nil); return }
        
        let urlString = "https://slack.com/api/team.info?token=\(token)"
        guard let url = URL(string: urlString) else { return }
        print(url)
        Alamofire.request(url).responseJSON { response in
            guard let JSON = response.result.value else { completion(nil); return }
            let completeJSON = JSON as! [String : Any]
//            print("\n\n\nTHIS IS THE getTeamInfo Completion!!! ++++++++++\(completeJSON)")
            completion(completeJSON)
        }
    }
    
    // MARK: Post set.channelPurpose
    class func setChannelPurpose(with completion: @escaping ([String: Any])->()) {
        guard let token = UserDefaults.standard.object(forKey: "SlackToken") else { return }
        let channelID = "Insert Channel ID"
        let channelPurpose = "A channel for all the cool activities everyone is creating through Teem!\nDownload it here: https://goo.gl/SIAHLa"
        let urlString = "https://slack.com/api/channels.join?token=\(token)&name=\(channelID)&purpose=\(channelPurpose)"
        guard let url = URL(string: urlString) else { return }
        Alamofire.request(url, method: .post).responseJSON { response in
            guard let JSON = response.result.value else { return }
            let completeJSON = JSON as! [String : Any]
            //            print("\n\n\nTHIS IS THE USER JOIN CHANNEL COMPLETION!!! ++++++++++\(completeJSON)")
            completion(completeJSON)
        }
    }

    // MARK: Post Slack Notification to webhook URL
    class func postSlackNotification() {
        
        //TODO: Turn this into a model, and include Attachment initialization
        let notificationParameters: [String:Any] = [
            "icon_url": "http://gdurl.com/Ei8e",
            "text": "This was posted by running the app",
            "channel": "teem_activities",
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
    
    class func getAllUsersInfo(with completion: @escaping ([String: Any])->()) {
        guard let token = UserDefaults.standard.object(forKey: "SlackToken") else { return }
        let urlString = "https://slack.com/api/users.list?token=\(token)"
        guard let url = URL(string: urlString) else { return }
        Alamofire.request(url).responseJSON { response in
            guard let JSON = response.result.value else { return }
            let completeJSON = JSON as! [String : Any]
//            print(completeJSON)
            completion(completeJSON)
        }
    }

    // TODO: call in NetworkManager
    class func storeUserInfo(handler: @escaping (Bool) -> Void) {
        // MARK: Basic Slack API call ~ used to populate user profile (called once during signup)
        self.getUserInfo { rawUserInfo in
            
            guard let userInfo = rawUserInfo else { handler(false); return }
            
            let userData = userInfo["user"] as! [String: Any]
            
//            print("***************++++++++**********\n\n")
//            print("USER DATA STILL BEING STORED AFTER LE GREAT REFACTOR #GREATSUCCESS")
//            print(userData)
//            print("***************++++++++**********\n\n")
//            print(userData["is_primary_owner"])
//            print("***************++++++++**********\n\n")
            
            OperationQueue.main.addOperation {
                
//                // instantiate user profile
                let userProfile = User(dictionary: userData)
//                
                let defaults = UserDefaults.standard
//                defaults.set(userProfile, forKey: "userProfile")
//                defaults.synchronize()
                
                defaults.set(userProfile.slackID, forKey: "slackID")
                defaults.set(userProfile.teamID, forKey: "teamID")
                defaults.set(userProfile.username, forKey: "username")
                defaults.set(userProfile.firstName, forKey: "firstName")
                defaults.set(userProfile.lastName, forKey: "lastName")
                defaults.set(userProfile.email, forKey: "email")
                defaults.set(userProfile.image72, forKey: "image72")
                defaults.set(userProfile.image512, forKey: "image512")
                defaults.set(userProfile.timeZoneLabel, forKey: "timeZoneLabel")
                
                defaults.set(userProfile.isAdmin, forKey: "isAdmin")
                defaults.set(userProfile.isOwner, forKey: "isOwner")
                defaults.set(userProfile.isPrimaryOwner, forKey: "isPrimaryOwner")
                
                defaults.synchronize()
                
                handler(true)
            }
            
        }
    }

}
