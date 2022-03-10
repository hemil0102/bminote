//
//  BmiResultVC.swift
//  bmi note
//
//  Created by Walter J on 2022/03/07.
//

import UIKit

class BmiResultVC: UIViewController {
    
    //ImageView
    @IBOutlet weak var underWeightImgView: UIImageView!
    @IBOutlet weak var normalImgView: UIImageView!
    @IBOutlet weak var overWeightImgView: UIImageView!
    @IBOutlet weak var obeseWeightImgView: UIImageView!
    @IBOutlet weak var extremelyObeseImgView: UIImageView!
    
    //화살표
    @IBOutlet weak var underWeightArrowLabel: UILabel!
    @IBOutlet weak var normalArrowLabel: UILabel!
    @IBOutlet weak var overWeightArrowLabel: UILabel!
    @IBOutlet weak var obeseWeightArrowLabel: UILabel!
    @IBOutlet weak var extremelyObeseArrowLabel: UILabel!
    
    //BMI 수치, 키, 몸무게
    @IBOutlet weak var bmiValueLabel: UILabel!
    @IBOutlet weak var heightForBMI: UILabel!
    @IBOutlet weak var weightForBMI: UILabel!
    
    var tempData:String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = tempData {
            print("받아온 데이터 \(data)")
        }
    }
}
