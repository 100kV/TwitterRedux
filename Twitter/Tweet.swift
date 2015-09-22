//
//  Tweet.swift
//  Twitter
//
//  Created by Kevin Raymundo on 9/13/15.
//  Copyright (c) 2015 100kV. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var dictionary: NSDictionary
    
    var id: Int?
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var retweeted: Bool?
    var favorited: Bool?
    var favoriteCount: Int?

    var retweetId: Int?
    var retweetCount: Int?

    var retweetedStatus: NSDictionary?
    var retweetUser: User?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        id = dictionary["id"] as? Int
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        retweeted = dictionary["retweeted"] as? Bool
        favorited = dictionary["favorited"] as? Bool
        
        retweetCount = dictionary["retweet_count"] as? Int
        favoriteCount = dictionary["favorite_count"] as? Int
        
        retweetedStatus = dictionary["retweeted_status"] as? NSDictionary
        
        if (retweetedStatus != nil) {
            retweetUser = user
            user = User(dictionary: retweetedStatus?["user"] as! NSDictionary)
        }
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
}
