//
//  NewTweetViewController.swift
//  Twitter
//
//  Created by Kevin Raymundo on 9/13/15.
//  Copyright (c) 2015 100kV. All rights reserved.
//

import UIKit

let TWEET_MAX_CHARACTERS: Int = 140

class NewTweetViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var tweetBarButtonItem: UIBarButtonItem!
    
    lazy var characterCountLabel:UILabel = UILabel()
    var replyTweet: Tweet?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bodyTextView.delegate = self

        profileImageView.setImageWithURL(NSURL(string: User.currentUser!.profileImageUrl!))
        nameLabel.text = User.currentUser?.name
        screennameLabel.text = User.currentUser?.screenname
        
        if (replyTweet != nil) {
            let screenname = replyTweet!.user!.screenname
            bodyTextView.text = "@\(screenname!) "
            tweetBarButtonItem.title = "Reply"
        } else {
            bodyTextView.text = ""
        }
        bodyTextView.becomeFirstResponder()
        
        characterCountLabel.frame = CGRectMake(0, 0, 40, 40)
        characterCountLabel.text = "\(TWEET_MAX_CHARACTERS - bodyTextView.text.utf16.count)"
        characterCountLabel.textColor = UIColor.grayColor()
        let rightBarButtonItemCharacterCount: UIBarButtonItem = UIBarButtonItem(customView: characterCountLabel)

        self.navigationItem.setRightBarButtonItems([tweetBarButtonItem, rightBarButtonItemCharacterCount], animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let newLength = textView.text.utf16.count + text.utf16.count - range.length
        return newLength <= 140 // Bool
    }
    
    func textViewDidChange(textView: UITextView) {
        characterCountLabel.text = "\(TWEET_MAX_CHARACTERS - bodyTextView.text.utf16.count)"
    }

    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onTweetButton(sender: AnyObject) {
        if bodyTextView.text != "" {
            var params: NSDictionary?
            if (replyTweet != nil) {
                let replyTweetId = replyTweet!.id!
                params = ["status": bodyTextView.text, "in_reply_to_status_id": replyTweetId]
            } else {
                params = ["status": bodyTextView.text]
            }
            TwitterClient.sharedInstance.update(params, completion: { (tweet, error) -> () in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
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
