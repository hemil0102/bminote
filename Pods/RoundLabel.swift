//
//  RoundLabel.swift
//  bmi note
//
//  Created by YEHROEI HO on 2022/03/26.
//

import UIKit

@IBDesignable
class RoundLabel: UILabel {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var LabelBgColor: UIColor = UIColor.clear{
        didSet{
            self.layer.backgroundColor = LabelBgColor.cgColor
        }
    }
    
}
