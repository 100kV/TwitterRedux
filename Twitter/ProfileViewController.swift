//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Kevin Raymundo on 9/21/15.
//  Copyright © 2015 100kV. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    var user: User? {
        didSet {
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
        }
    }
    
    var tweets: [Tweet]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = User.currentUser
        
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
