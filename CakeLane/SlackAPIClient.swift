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
    static let teamStore = TeamDataStore.sharedInstance

    // MARK: POST channels.join specified on Slack - uses channels:write (Bejan)
    class func userJoinChannel(with completion: @escaping ([String: Any])->()) {
        guard let token = UserDefaults.standard.object(forKey: "SlackToken") else { return }
        let channelName = "teem_activities"
        let urlString = "https://slack.com/api/channels.join?token=\(token)&name=\(channelName)"
        guard let url = URL(string: urlString) else { return }
        print("\n\n\nTHIS IS THE userJoinChannel API REQUEST URL!!! ++++++++++\n\n\(url)\n\n\n\n")

        Alamofire.request(url, method: .post).responseJSON { response in
            guard let JSON = response.result.value else { return }
            let completeJSON = JSON as! [String : Any]
            //            print("\n\n\nTHIS IS THE userJoinChannel COMPLETION!!! ++++++++++\(completeJSON)")
            completion(completeJSON)
        }
    }

    // MARK: GET channels.list from Slack - uses scope channels:read (Bejan)
    class func getChannelsList(with completion: @escaping ([String: Any]?)->()) {
        // extract slack token & user id from user defaults
        guard let token = UserDefaults.standard.object(forKey: "SlackToken") else { completion(nil); return }
        let excludedArchive = 1 // includes archived channels, else set to 0
        let urlString = "https://slack.com/api/channels.list?token=\(token)&excluded_archive=\(excludedArchive)"
        guard let url = URL(string: urlString) else { return }
        print("\n\n\nTHIS IS THE getChannelsList API REQUEST URL!!! ++++++++++\n\n\(url)\n\n\n\n")

        Alamofire.request(url).responseJSON { response in
            guard let JSON = response.result.value else { completion(nil); return }
            let completeJSON = JSON as! [String:Any]
            //            print("\n\n\nTHIS IS THE getChannelsList API CALL RESPONSE!!! ++++++++++\n\n\(channels)\n\n\n\n")
            teamStore.getTeemChannel(with: completeJSON)
            completion(completeJSON)
        }
    }


    // MARK: GET user.Info from Slack - uses scope users:read, users:read.email (read.email as of 1/4/2017 (Bejan)
    class func getUserInfo(with completion: @escaping ([String: Any]?)->()) {
        // extract slack token & user id from user defaults

        guard let token = UserDefaults.standard.object(forKey: "slackToken") else { completion(nil); return }

        guard let userID = UserDefaults.standard.object(forKey: "slackID") else { completion(nil); return }

        let urlString = "https://slack.com/api/users.info?user=\(userID)&token=\(token)"
        guard let url = URL(string: urlString) else { return }
        print("\n\n\nTHIS IS THE getUserInfo API REQUEST URL!!! ++++++++++\n\n\(url)\n\n\n\n")

        Alamofire.request(url).responseJSON { response in
            guard let JSON = response.result.value else { completion(nil); return }
            let completeJSON = JSON as! [String : Any]
            //            print("\n\n\nTHIS IS THE getUserInfo Completion!!! ++++++++++\(completeJSON)")
            completion(completeJSON)
        }
    }
    // Post Slack Notification to webhook URL
//    class func postSlackNotification() {
//
//        let store = SlackMessageStore.sharedInstance
//
////        let newAttachment = Attachment(title: "Gamer Night", colorHex: "#b942f4", pretext: "*New Activity:* APP POST TEST IS WORKING!! _by Bejan_.", authorName: "Bejan Fozdar", authorLink: "http://github.com/ixyzt", authorIcon: "https://secure.gravatar.com/avatar/6fff6c447ce00e3080ffe5bf969811db.jpg?s=72&d=https%3A%2F%2Fa.slack-edge.com%2F3654%2Fimg%2Favatars%2Fava_0023-24.png", titleLink: "https://docs.google.com/document/d/1iGqv8zaQHcxWUmQkLAntNRLTy5czsLPWHnkbhrPK3ig/edit?usp=sharing", text: "THIS IS A TEST!", imageURL: "http://oi44.tinypic.com/t8lxfn.jpg", thumbURL: "http://static4.redcart.pl/templates/images/thumb/7546/75/75/en/0/templates/images/products/7546/100bfb31d29178fd8aab980d11db5682.jpg")
//
//        //print("\n\n\n\nTHIS IS THE Attachment Dictionary!!! ++++++++++\n\n\(newAttachment.dictionary)")
//
////        store.attachmentDictionary = newAttachment.dictionary
//
//    }


    // MARK: Get team.info from Slack - uses scope team:read (Bejan)
    class func getTeamInfo(with completion: @escaping ([String: Any]?)->()) {
        // extract slack token & user id from user defaults
        guard let token = UserDefaults.standard.object(forKey: "SlackToken") else { completion(nil); return }
        let urlString = "https://slack.com/api/team.info?token=\(token)"
        guard let url = URL(string: urlString) else { return }
        print("\n\n\nTHIS IS THE getTeamInfo API REQUEST URL!!! ++++++++++\n\n\(url)\n\n\n\n")

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
        let channelID = teamStore.teamInfo["teemChannelID"]
        let channelPurpose = teamStore.teamInfo["teemChannelPurpose"]
        let urlString = "https://slack.com/api/channels.join?token=\(token)&name=\(channelID)&purpose=\(channelPurpose)"
        guard let url = URL(string: urlString) else { return }

        Alamofire.request(url, method: .post).responseJSON { response in
            guard let JSON = response.result.value else { return }
            let completeJSON = JSON as! [String : Any]
            //            print("\n\n\nTHIS IS THE SET CHANNEL PURPOSE COMPLETION!!! ++++++++++\(completeJSON)")
            completion(completeJSON)
        }
    }

    // MARK: Post Slack Notification to webhook URL - uses scope channel:write
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
        //            print("\n\n\nTHIS IS THE postSlackNotification COMPLETION!!! ++++++++++\(response)")
        }

    }

    class func getAllUsersInfo(with completion: @escaping ([String: Any])->()) {
        guard let token = UserDefaults.standard.object(forKey: "slackToken") else { return }
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

                // instantiate user profile
                let userProfile = User(dictionary: userData)

                // store user profile in FirebaseUsersDataStore (and use it later in FirebaseClient)
                FirebaseUsersDataStore.sharedInstance.primaryUser = userProfile

                let defaults = UserDefaults.standard

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
