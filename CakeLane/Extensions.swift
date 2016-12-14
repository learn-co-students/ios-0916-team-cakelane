//
//  Extensions.swift
//  slackOAuth
//
//  Created by Alexey Medvedev on 11/17/16.
//  Copyright © 2016 medvedev. All rights reserved.
//

import Foundation

// MARK: Extension on Notification.Name to avoid errors in strings
extension Notification.Name {
    static let closeSafariVC = Notification.Name("close-safari-view-controller")
    static let closeLoginVC = Notification.Name("close-login-view-controller")
    static let closeProfileVC = Notification.Name("close-profile-view-controller")
    static let showActivityDetailsVC = Notification.Name("show-activity-details-view-controller")
}

// MARK: Helper method for query parsing -> used in AppDelegate during OAuth
extension URL {
    func getQueryItemValue(named name: String) -> String? {
        
        let components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        let query = components?.queryItems
        return query?.filter({$0.name == name}).first?.value
    }
}

// MARK: Filter functions for DropDown menu & FirebaseClient activity retrieval
extension ActivitiesViewController {
    
    // MARK: _ Sort the activities based on time
    func sortedActivities(_ array: [Activity]) -> [Activity] {
        let sortedArray = array.sorted { (a, b) -> Bool in
            var result = false
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            dateFormatter.timeStyle = .short
            if let aDate = dateFormatter.date(from: a.date){
                if let bDate = dateFormatter.date(from: b.date){
                    if aDate < bDate {
                        result = true
                    }
                }
            }
            return result
        }
        return sortedArray
    }
    
    // MARK: Today's DropDown Filter
    func filterTodayActivities(_ array: [Activity]) -> [Activity] {
        let filterArray = array.filter { (a) -> Bool in
            var result = false
            let calendar = NSCalendar.current
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            dateFormatter.timeStyle = .short
            if let aDate = dateFormatter.date(from: a.date) {
                if calendar.isDateInToday(aDate){
                    result = true
                }
            }
            return result
        }
        return filterArray
    }
    
    // MARK: This Week's DropDown Filter
    func filterWeekActivities(_ array: [Activity]) -> [Activity] {
        let filterArray = array.filter { (a) -> Bool in
            var result = false
            let calendar = NSCalendar.current
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            dateFormatter.timeStyle = .short
            
            let currentDate = Date()
            let currentWeek = calendar.component(.weekOfMonth, from: currentDate)
            
            if let aDate = dateFormatter.date(from: a.date) {
                let thisWeek = calendar.component(.weekOfMonth, from: aDate)
                if currentWeek == thisWeek {
                    result = true
                }
            }
            return result
        }
        return filterArray
    }
    
    // MARK: This Month's DropDown Filter
    func filterMonthActivities(_ array: [Activity]) -> [Activity] {
        let filterArray = array.filter { (a) -> Bool in
            var result = false
            let calendar = NSCalendar.current
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            dateFormatter.timeStyle = .short
            
            let currentDate = Date()
            let currentMonth = calendar.component(.month, from: currentDate)
            
            
            if let aDate = dateFormatter.date(from: a.date) {
                let thisMonth = calendar.component(.month, from: aDate)
                if currentMonth == thisMonth {
                    result = true
                }
            }
            return result
        }
        return filterArray
    }
}

extension UIFont {
    
    class func futuraFont(with size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue", size: size)!
    }
}
