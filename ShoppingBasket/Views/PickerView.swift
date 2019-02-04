//
//  PickerView.swift
//  ShoppingBasket
//
//  Created by Imran on 2/2/19.
//  Copyright © 2019 Imran. All rights reserved.
//

import UIKit

class PickerView: UIView {
    
    @IBOutlet weak var pickerView: UIPickerView!
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
    @IBAction func doneButtonPressed(sender: UIButton)
    {
        self.superview?.isHidden = true
    }
}
