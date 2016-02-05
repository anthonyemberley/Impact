//
//  ProfileViewController.swift
//  Impact
//
//  Created by Phillip Ou on 1/27/16.
//  Copyright © 2016 Impact. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var user : User? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        ServerRequest.shared.getCurrentUser { (currentUser) -> Void in
            self.user = currentUser
            self.configureProfile(self.user)
        }

        // Do any additional setup after loading the view.
    }
    
    func configureProfile(user:User?) {
        self.nameLabel.text = user?.name
        self.emailLabel.text = user?.email
        self.profileImageView.layer.masksToBounds = true
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2
        if let currentUser = user {
            if currentUser.facebook_id != 0 {
                let facebookURLString = "http://graph.facebook.com/\(currentUser.facebook_id)/picture?type=large"
                self.profileImageView.setImageWithUrl(NSURL(string: facebookURLString), placeHolderImage: nil)
                return
            }
        }
        let urlString = "http://www.myoatmeal.com/media/testimonials/pictures/resized/100_100_empty.gif"
        self.profileImageView.setImageWithUrl(NSURL(string:urlString), placeHolderImage: nil)
    
    }
    
    @IBAction func settingsPressed(sender: AnyObject) {
        let svc = SettingsViewController()
        svc.user = self.user
        self.navigationController?.pushViewController(svc, animated: true)
        
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