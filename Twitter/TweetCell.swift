//
//  TweetCell.swift
//  Twitter
//
//  Created by Kevin Raymundo on 9/13/15.
//  Copyright (c) 2015 100kV. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var favoritedButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    
    var tweet: Tweet! {
        didSet {
            let url = tweet.user?.profileImageUrl
            
            if url != nil {
                self.profileImageView.setImageWithURLRequest(NSURLRequest(URL: NSURL(string: url!)!), placeholderImage: nil, success: { (NSURLRequest, NSHTTPURLResponse, UIImage) -> Void in
                    self.profileImageView.image = UIImage
                    }) { (NSURLRequest, NSHTTPURLResponse, NSError) -> Void in
                        print("Error setting tweet user profile image")
                }
            }
            
            self.nameLabel.text = tweet.user?.name
            self.screennameLabel.text = "@\(tweet.user!.screenname!)"
            self.tweetTextLabel.text = tweet.text
            
//            self.replyButton.tag = indexPath.row
            
            if (tweet.retweeted == true) {
                self.retweetButton.setImage(UIImage(named: "retweet_on.png"), forState: UIControlState.Normal)
            } else {
                self.retweetButton.setImage(UIImage(named: "retweet.png"), forState: UIControlState.Normal)
            }
//            self.retweetButton.tag = indexPath.row
            
            if (tweet.favorited == true) {
                self.favoritedButton.setImage(UIImage(named: "favorite_on.png"), forState: UIControlState.Normal)
            } else {
                self.favoritedButton.setImage(UIImage(named: "favorite.png"), forState: UIControlState.Normal)
            }
//            self.favoritedButton.tag = indexPath.row
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "h:mma"
            self.timestampLabel.text = formatter.stringFromDate(tweet.createdAt!)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
