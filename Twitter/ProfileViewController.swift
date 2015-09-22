//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Kevin Raymundo on 9/21/15.
//  Copyright © 2015 100kV. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var user: User?
    
    var tweets: [Tweet]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (user == nil) {
            user = User.currentUser
        }
        
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        tableView.estimatedRowHeight = 88.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let url = user!.profileImageUrl
        if url != nil {
            profileImageView.setImageWithURLRequest(NSURLRequest(URL: NSURL(string: url!)!), placeholderImage: nil, success: { (NSURLRequest, NSHTTPURLResponse, UIImage) -> Void in
                self.profileImageView.image = UIImage
                }) { (NSURLRequest, NSHTTPURLResponse, NSError) -> Void in
                    print("Error setting tweet user profile image")
            }
        }
        
        nameLabel.text = user!.name
        screennameLabel.text = "@\(user!.screenname!)"
        
        tweetsCountLabel.text = "\(user!.tweetsCount!)"
        followingCountLabel.text = "\(user!.followingCount!)"
        followersCountLabel.text = "\(user!.followersCount!)"
        
        var params = ["screen_name": user!.screenname!]
        TwitterClient.sharedInstance.statusesUserTimeline(params, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        let tweet = tweets![indexPath.row] as Tweet
        
        cell.tweet = tweet
        
        //        let url = tweet.user?.profileImageUrl
        //
        //        if url != nil {
        //            cell.profileImageView.setImageWithURLRequest(NSURLRequest(URL: NSURL(string: url!)!), placeholderImage: nil, success: { (NSURLRequest, NSHTTPURLResponse, UIImage) -> Void in
        //                cell.profileImageView.image = UIImage
        //            }) { (NSURLRequest, NSHTTPURLResponse, NSError) -> Void in
        //                print("Error setting tweet user profile image")
        //            }
        //        }
        //
        //        cell.nameLabel.text = tweet.user?.name
        //        cell.screennameLabel.text = "@\(tweet.user!.screenname!)"
        //        cell.tweetTextLabel.text = tweet.text
        //
        cell.replyButton.tag = indexPath.row
        //
        //        if (tweet.retweeted == true) {
        //            cell.retweetButton.setImage(UIImage(named: "retweet_on.png"), forState: UIControlState.Normal)
        //        } else {
        //            cell.retweetButton.setImage(UIImage(named: "retweet.png"), forState: UIControlState.Normal)
        //        }
        cell.retweetButton.tag = indexPath.row
        //
        //        if (tweet.favorited == true) {
        //            cell.favoritedButton.setImage(UIImage(named: "favorite_on.png"), forState: UIControlState.Normal)
        //        } else {
        //            cell.favoritedButton.setImage(UIImage(named: "favorite.png"), forState: UIControlState.Normal)
        //        }
        cell.favoritedButton.tag = indexPath.row
        //
        //        let formatter = NSDateFormatter()
        //        formatter.dateFormat = "h:mma"
        //        cell.timestampLabel.text = formatter.stringFromDate(tweet.createdAt!)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let x = tweets {
            return tweets!.count
        } else {
            return 0
        }
    }
    
    @IBAction func onClickRetweetButton(sender: AnyObject) {
        let retweetButton = sender as! UIButton
        let retweet = tweets![retweetButton.tag] as Tweet
        var params = ["id": retweet.id!]
        
        if (retweet.retweeted == true) {
            if (retweet.retweetId != nil) {
                params["id"] = retweet.retweetId!
                TwitterClient.sharedInstance.statusesDestroy(params, completion: { (tweet, error) -> () in
                    retweetButton.setImage(UIImage(named: "retweet.png"), forState: UIControlState.Normal)
                    retweet.retweeted = false
                })
            }
        } else {
            TwitterClient.sharedInstance.statusesRetweets(params, completion: { (tweet, error) -> () in
                retweetButton.setImage(UIImage(named: "retweet_on.png"), forState: UIControlState.Normal)
                retweet.retweeted = true
                retweet.retweetId = tweet?.id
            })
        }
    }
    
    @IBAction func onClickFavoritedButton(sender: AnyObject) {
        let favoritedButton = sender as! UIButton
        let favoriteTweet = tweets![favoritedButton.tag] as Tweet
        let params = ["id": favoriteTweet.id!]
        
        if (favoriteTweet.favorited == true) {
            TwitterClient.sharedInstance.favoritesDestroy(params, completion: { (tweet, error) -> () in
                favoritedButton.setImage(UIImage(named: "favorite.png"), forState: UIControlState.Normal)
                favoriteTweet.favorited = false
            })
        } else {
            TwitterClient.sharedInstance.favoritesCreate(params, completion: { (tweet, error) -> () in
                favoritedButton.setImage(UIImage(named: "favorite_on.png"), forState: UIControlState.Normal)
                favoriteTweet.favorited = true
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ProfileReply") {
            let replyButton = sender as! UIButton
            let tweet = tweets![replyButton.tag] as Tweet
            
            let uiNavigationController = segue.destinationViewController as! UINavigationController
            let newTweetViewController = uiNavigationController.topViewController as! NewTweetViewController
            newTweetViewController.replyTweet = tweet
        }
        
        if (segue.identifier == "Details") {
            let cell = sender as! TweetCell
            let indexPath = tableView.indexPathForCell(cell)!
            let tweet = tweets![indexPath.row] as Tweet
            
            let tweetDetailsViewController = segue.destinationViewController as! TweetDetailsViewController
            tweetDetailsViewController.tweet = tweet
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
