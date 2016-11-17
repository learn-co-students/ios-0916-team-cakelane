//
//  Extensions.swift
//  slackOAuth
//
//  Created by Alexey Medvedev on 11/17/16.
//  Copyright © 2016 medvedev. All rights reserved.
//

import Foundation

extension URL {
    func getQueryItemValue(named name: String) -> String? {
        
        let components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        let query = components?.queryItems
        return query?.filter({$0.name == name}).first?.value
    }
}
