//
//  CauseStoryViewController.swift
//  Impact
//
//  Created by Phillip Ou on 11/20/15.
//  Copyright © 2015 Impact. All rights reserved.
//

import UIKit

protocol CauseStoryScrollableDelegate {
    func causeStoryControllerIsScrolling(scrollView:UIScrollView)
}

class CauseStoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, BlogPostTableViewHeaderDelegate {
    
    var scrollDelegate : CauseStoryScrollableDelegate? = nil
    
    let contributeButtonPlusLabelHeight = CGFloat(115)
    
    var summaryHeaderView = BlogPostTableViewHeader(frame:CGRectZero)
    var cause: Cause? = nil
    var joinedLabel : UILabel? = nil
    var joinCauseButton : UIButton? = nil
    var currentCauseId : Int? = nil
    var currentCauseName : String? = nil

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let frame = CGRectMake(0,0,self.tableView.frame.size.width,self.tableView.frame.size.height)
        let blogPost = BlogPost()
        blogPost.title = "About Me"
        if let cause = self.cause {
            blogPost.blog_body =  cause.descriptionField
        }
                let blogPostHeader =    BlogPostTableViewHeader(frame:frame,blogPost:blogPost, cause:self.cause )
        self.summaryHeaderView = blogPostHeader
        self.summaryHeaderView.delegate = self
        self.joinedLabel = blogPostHeader.joinLabel
        self.joinCauseButton = blogPostHeader.joinButton
        //adding 100 for buttons on the bottom
        let newHeight = summaryHeaderView.blogPostLabel.frame.origin.y + summaryHeaderView.blogPostLabel.frame.size.height + self.contributeButtonPlusLabelHeight
        summaryHeaderView.frame.size.height = newHeight
        self.tableView.tableHeaderView = summaryHeaderView
        if let profileImageURL = cause?.profileImageUrl {
            self.summaryHeaderView.imageView.setImageWithUrl(NSURL(string:profileImageURL)!)
            
        }
        
        self.summaryHeaderView.partnershipLabel.text = "In Partnership with CityLax"

    }
    
    override func viewWillAppear(animated: Bool) {
        ServerRequest.shared.getCurrentUser { (currentUser) -> Void in
            self.currentCauseId = currentUser.current_cause_id
            self.currentCauseName = currentUser.current_cause_name
            print(self.currentCauseName! + String(self.currentCauseId!))
            if self.cause?.id == self.currentCauseId && self.currentCauseId != nil{
                self.joinCauseButton?.setImage(UIImage(named: "YoureImpacting"), forState: .Normal)
            }else{
                self.joinCauseButton?.setImage(UIImage(named: "ClicktoImpact"), forState: .Normal)

            }
            self.joinedLabel?.text = self.cause?.id == self.currentCauseId ? "You're Contributing!" : "Click to Contribute"
        }
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.scrollDelegate?.causeStoryControllerIsScrolling(scrollView)
    }
    
    
    func joinCauseButtonPressed() {
        let  ai = ActivityIndicator(view: self.view)
        if let cause = self.cause {
            
            
                if self.currentCauseId == cause.id{
                    // leaving cause
                    let alertController = UIAlertController(title: "Warning", message: "Are you sure you want leave this cause?", preferredStyle: .Alert)
                    alertController.view.tintColor = UIColor.customRed()
                    
                    let cancelAction = UIAlertAction(title: "NO", style: .Cancel) { (action) in
                    }
                    alertController.addAction(cancelAction)
                    
                    let OKAction = UIAlertAction(title: "YES", style: .Default) { (action) in
                        ai.startCustomAnimation()
                        ServerRequest.shared.leaveCause(cause, success: { (successful) -> Void in
                            ai.stopAnimating()
                            self.currentCauseId = nil
                            if let joinedLabel = self.joinedLabel{
                                joinedLabel.text = "Click to Impact!"
                            }
                            if let joinCauseButton = self.joinCauseButton {
                                joinCauseButton.setImage(UIImage(named: "ClicktoImpact"), forState: .Normal)
                            }
                            }, failure: { (errorMessage) -> Void in
                                ai.stopAnimating()
                                let alertController = AlertViewController()
                                alertController.setUp(self, title: "Error", message: errorMessage, buttonText: "Dismiss")
                                alertController.show()

                                
                        })
                        
                    }
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: true) {
                        alertController.view.tintColor = UIColor.customRed()
                    }
                    
                    
                }else if self.currentCauseId != 0 && self.currentCauseId != nil && self.currentCauseName != "" && self.currentCauseName != nil{
                    
                    let alertController = UIAlertController(title: "Warning", message: "Are you sure you want switch causes? You are currently Impacting " + self.currentCauseName!, preferredStyle: .Alert)
                    alertController.view.tintColor = UIColor.customRed()

                    let cancelAction = UIAlertAction(title: "NO", style: .Cancel) { (action) in
                    }
                    alertController.addAction(cancelAction)
                    
                    let OKAction = UIAlertAction(title: "YES", style: .Default) { (action) in
                        ai.startCustomAnimation()
                        ServerRequest.shared.joinCause(cause, success: { (successful) -> Void in
                            ai.stopAnimating()
                            self.currentCauseId = cause.id
                            if let joinedLabel = self.joinedLabel{
                                joinedLabel.text = "You're Contributing!"
                            }
                            if let joinCauseButton = self.joinCauseButton {
                                joinCauseButton.setImage(UIImage(named: "YoureImpacting"), forState: .Normal)
                            }
                            }, failure: { (errorMessage) -> Void in
                                ai.stopAnimating()
                                let alertController = AlertViewController()
                                alertController.setUp(self, title: "Error", message: errorMessage, buttonText: "Dismiss")
                                alertController.show()
                        })
                        
                    }
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: true) {
                        alertController.view.tintColor = UIColor.customRed()

                    }

                    
                }else{
                    ai.startCustomAnimation()
                    ServerRequest.shared.joinCause(cause, success: { (successful) -> Void in
                        ai.stopAnimating()
                        self.currentCauseId = cause.id
                        if let joinedLabel = self.joinedLabel{
                            joinedLabel.text = "You're Contributing!"
                        }
                        if let joinCauseButton = self.joinCauseButton {
                            joinCauseButton.setImage(UIImage(named: "YoureImpacting"), forState: .Normal)
                        }
                        }, failure: { (errorMessage) -> Void in
                            ai.stopAnimating()
                            let alertController = AlertViewController()
                            alertController.setUp(self, title: "Error", message: errorMessage, buttonText: "Dismiss")
                            alertController.show()
                            
                    })

                    
                }
                
                
                
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
