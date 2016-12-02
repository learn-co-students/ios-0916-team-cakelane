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
        print(urlString)
        Alamofire.request(url).responseJSON { response in
            guard let JSON = response.result.value else { return }
            let completeJSON = JSON as! [String : Any]
//            print(completeJSON)
            completion(completeJSON)
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



}
