//
//  DonationCardView.swift
//  Impact
//
//  Created by Phillip Ou on 2/15/16.
//  Copyright © 2016 Impact. All rights reserved.
//

import UIKit

class DonationCardView: UIView {
    
    @IBOutlet weak var amountTextField: UITextField!
    var amount:Int = 0{
        willSet(newValue){
            self.amountTextField.text = "$\(newValue)"
        }
    }
    override init(frame:CGRect) {
        super.init(frame: frame)
        let xibView = NSBundle.mainBundle().loadNibNamed("DonationCardView", owner: self, options: [:]).first as! UIView
        self.amountTextField.enabled = false
        self.addSubview(xibView)
        xibView.frame = self.frame;
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
