//
//  Attachment.swift
//  CakeLane
//
//  Created by Bejan Fozdar on 11/30/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import Foundation


struct Attachment {
    
    let fallback: String?
    let color: String?
    let pretext: String?
    let authorName: String?
    let authorLink: String?
    let authorIcon: String?
    let title: String?
    let titleLink: String?
    let text: String?
    let imageURL: String?
    let thumbURL: String?  // image must be 75 x 75px, doesn't show if imageURL is available
    let footer: String?
    let footerIcon: String?
    let ts: Int?
    
    internal init(attachment: [String: Any]?) {
        fallback = attachment?["fallback"] as? String
        color = attachment?["color"] as? String
        pretext = attachment?["pretext"] as? String
        authorName = attachment?["author_name"] as? String
        authorLink = attachment?["author_link"] as? String
        authorIcon = attachment?["author_icon"] as? String
        title = attachment?["title"] as? String
        titleLink = attachment?["title_link"] as? String
        text = attachment?["text"] as? String
        imageURL = attachment?["image_url"] as? String
        thumbURL = attachment?["thumb_url"] as? String
        footer = attachment?["footer"] as? String
        footerIcon = attachment?["footer_icon"] as? String
        ts = attachment?["ts"] as? Int
    }
    
    init(title:String, colorHex: String? = nil, pretext: String, authorName: String, authorLink: String? = nil, authorIcon: String, titleLink: String? = nil, text: String? = nil, imageURL: String? = nil, thumbURL: String? = nil) {
        self.fallback = pretext //setting fallback to pretext for now
        self.color = colorHex
        self.pretext = pretext
        self.authorName = authorName
        self.authorLink = authorLink
        self.authorIcon = authorIcon
        self.title = title
        self.titleLink = titleLink
        self.text = text
        self.imageURL = imageURL
        self.thumbURL = thumbURL
        self.footer = "posted by Teem!"
        self.footerIcon = "https://mlblogsmlbastian.files.wordpress.com/2010/07/tlogo.gif"
        self.ts = Int(Date().timeIntervalSince1970)
    }
    
    internal var dictionary: [String: Any] {
        var attachment = [String: Any]()
        attachment["fallback"] = fallback
        attachment["color"] = color
        attachment["pretext"] = pretext
        attachment["authorName"] = authorName
        attachment["author_link"] = authorLink
        attachment["author_icon"] = authorIcon
        attachment["title"] = title
        attachment["title_link"] = titleLink
        attachment["text"] = text
        attachment["image_url"] = imageURL
        attachment["thumb_url"] = thumbURL
        attachment["footer"] = footer
        attachment["footer_icon"] = footerIcon
        attachment["ts"] = ts
        return attachment
    }
}
