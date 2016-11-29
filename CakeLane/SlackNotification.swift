//
//  Event.swift
//  CakeLane
//
//  Created by Bejan Fozdar on 11/29/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import Foundation


struct SlackNotification {
    // Fallback needs to be a computed property of title and author_name"
    var fallback: String {
        return "*New Activity:* \(title) _by \(author_name)_."
    }
    var color: String = "#36a64f"
    // Pretext needs to be a computed property of title and author_name"
    var pretext: String {
        return "*New Activity:* \(title) _by \(author_name)_."
    }
    var author_name: String = UserDefaults.standard.string(forKey: "username")!
    // var author_link: String = "NO Author Link (e.g. github profile)"
    var author_icon: String = UserDefaults.standard.string(forKey: "image72")!
    var title: String = "NO Activity Title"
    // var title_link =  "NO Activity Information URL"
    var text: String = "NO Activity Description"
    
    var image_url: String = "NO Activity Image URL"
    var thumb_url: String = "NO Activity Thumb URL"
    var footer: String = "posted by Teem!"
    var footer_icon: String = "No Footer Icon URL"
    
    //Timestamp in Epoch format
    var ts: Int = Int(Date().timeIntervalSince1970)
    
    //Controls which text strings will register formatting markdown (e.g. bold *bold*, code `code`, italic _italic_, strike ~strike~)
    var mrkdwn_in = ["fallback","text", "pretext"]
}







