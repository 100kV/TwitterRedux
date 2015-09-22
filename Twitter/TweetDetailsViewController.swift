//
//  TweetDetailsViewController.swift
//  Twitter
//
//  Created by Kevin Raymundo on 9/14/15.
//  Copyright (c) 2015 100kV. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {
    @IBOutlet weak var retweetLabelButton: UIButton!
    @IBOutlet weak var retweetUserScreenname: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    @IBOutlet weak var favoritedButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    var tweet: Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()

        if (tweet.retweetedStatus == nil) {
            retweetLabelButton.hidden = true
            retweetUserScreenname.hidden = true
        } else {
            retweetLabelButton.hidden = false
            retweetUserScreenname.hidden = false
            retweetUserScreenname.text = "\(tweet.retweetUser!.screenname!) retweeted"
        }
        
        let url = tweet.user?.profileImageUrl
        if url != nil {
            profileImageView.setImageWithURLRequest(NSURLRequest(URL: NSURL(string: url!)!), placeholderImage: nil, success: { (NSURLRequest, NSHTTPURLResponse, UIImage) -> Void in
                self.profileImageView.image = UIImage
                }) { (NSURLRequest, NSHTTPURLResponse, NSError) -> Void in
                    print("Error setting tweet user profile image")
            }
        }
        
        nameLabel.text = tweet.user?.name
        screennameLabel.text = "@\(tweet.user!.screenname!)"
        tweetTextLabel.text = tweet.text
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/YYYY hh:mm:ss a"
        timestampLabel.text = formatter.stringFromDate(tweet.createdAt!)
        
        retweetCountLabel.text = "\(tweet.retweetCount!)"
        favoriteCountLabel.text = "\(tweet.favoriteCount!)"
        
        if (tweet.retweeted == true) {
            retweetButton.setImage(UIImage(named: "retweet_on.png"), forState: UIControlState.Normal)
        } else {
            retweetButton.setImage(UIImage(named: "retweet.png"), forState: UIControlState.Normal)
        }
        
        if (tweet.favorited == true) {
            favoritedButton.setImage(UIImage(named: "favorite_on.png"), forState: UIControlState.Normal)
        } else {
            favoritedButton.setImage(UIImage(named: "favorite.png"), forState: UIControlState.Normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickRetweetButton(sender: AnyObject) {
        var params = ["id": tweet.id!]
        
        if (tweet.retweeted == true) {
            if (tweet.retweetId != nil) {
                params["id"] = tweet.retweetId!
                TwitterClient.sharedInstance.statusesDestroy(params, completion: { (tweet, error) -> () in
                    self.retweetButton.setImage(UIImage(named: "retweet.png"), forState: UIControlState.Normal)
                    self.tweet.retweeted = false
                })
            }
        } else {
            TwitterClient.sharedInstance.statusesRetweets(params, completion: { (tweet, error) -> () in
                self.retweetButton.setImage(UIImage(named: "retweet_on.png"), forState: UIControlState.Normal)
                self.tweet.retweeted = true
                self.tweet.retweetId = tweet?.id
            })
        }
    }
    
    @IBAction func onClickFavoritedButton(sender: AnyObject) {
        let params = ["id": tweet.id!]
        
        if (tweet.favorited == true) {
            TwitterClient.sharedInstance.favoritesDestroy(params, completion: { (tweet, error) -> () in
                self.favoritedButton.setImage(UIImage(named: "favorite.png"), forState: UIControlState.Normal)
                self.tweet.favorited = false
            })
        } else {
            TwitterClient.sharedInstance.favoritesCreate(params, completion: { (tweet, error) -> () in
                self.favoritedButton.setImage(UIImage(named: "favorite_on.png"), forState: UIControlState.Normal)
                self.tweet.favorited = true
            })
        }
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "Reply from Details") {
            let uiNavigationController = segue.destinationViewController as! UINavigationController
            let newTweetViewController = uiNavigationController.topViewController as! NewTweetViewController
            newTweetViewController.replyTweet = tweet
        }
        
        if (segue.identifier == "DetailsProfile") {
            let uiNavigationController = segue.destinationViewController as! UINavigationController
            let profileViewController = uiNavigationController.topViewController as! ProfileViewController
            
            profileViewController.user = tweet.user
        }
    }
}
