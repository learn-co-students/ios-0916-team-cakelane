//
//  SlackAPIClient.swift
//  CakeLane
//
//  Created by Bejan Fozdar on 11/17/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import Foundation
import Alamofire
import Locksmith

class SlackAPIClient {
    
    class func getUserInfo(with completion: @escaping ([String: Any])->()) {
        // TODO: extract token from Locksmith
        
        let token = ""
        
        let urlString = "https://slack.com/api/users.info?token=\(token)"
        guard let url = URL(string: urlString) else { return }
        
        Alamofire.request(url).responseJSON { response in
            guard let JSON = response.result.value else { return }
            let completeJSON = JSON as! [String : Any]
            completion(completeJSON)
        }
        
    }
}

