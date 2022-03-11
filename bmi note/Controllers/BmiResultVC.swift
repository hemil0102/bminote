//
//  BmiResultVC.swift
//  bmi note
//
//  Created by Walter J on 2022/03/07.
//

import UIKit

class BmiResultVC: UIViewController {
    @IBOutlet var statusImg:[UIImageView]!      //BMI 상태 이미지
    @IBOutlet var arrows:[UILabel]!     //화살표 배열
    
    //BMI 수치, 키, 몸무게
    @IBOutlet weak var bmiValueLabel: UILabel!
    @IBOutlet weak var heightForBMI: UILabel!
    @IBOutlet weak var weightForBMI: UILabel!
    
    var statusImgNames:[String] = ["bmi_01_underweight_2", "bmi_02_normal_2", "bmi_03_overweight_2", "bmi_04_obese_2", "bmi_05_extremelyobese_2"]
    var myBMIStatus = 0
    var bmiInfo:BMI?
    
    //전달받은 BMI수치
    var bmi:Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         1. 데이터 받기 [✓]
         2. 데이터 표시 : bmi, 키, 몸무게 [✓]
         3. bmi 수치 체크 [✓]
         4. 일치하는 상태 이미지 변경 [✓]
         5. 일치하는 상태 이미지 아래 화살표 나타내기 [✓]
         6. bmi 기준표 그리기 [✓]
         */
        setBMIInfo()            //직전 View에서 전달한 BMI 정보 셋팅
        findUserBmiInRange()        //User의 BMI가 어디에 속하는지 체크
        changeBMIImg(index: myBMIStatus)      //User의 BMI수치에 따라 BMI이미지 교체
        visibleArrows(index: myBMIStatus)     //User의 BMI수치에 따라 BMI이미지 아래 화살표 교체
    }
    
    //직전 View에 전달한 BMI 정보 셋팅하기
    func setBMIInfo() {
        if let bmi = bmiInfo {
            self.bmi = bmi.bmi
            self.bmiValueLabel.text = "\(bmi.bmi)"
            self.heightForBMI.text = "\(bmi.heightForBMI)cm"
            self.weightForBMI.text = "\(bmi.weightForBMI)kg"
        }
    }
    
    //bmi 범위 찾기
    func findUserBmiInRange() {
        switch bmi {
        case 0..<18.5:
            myBMIStatus = 0
        case 18.5...24.9:
            myBMIStatus = 1
        case 25...29.9:
            myBMIStatus = 2
        case 30...34.9:
            myBMIStatus = 3
        case 35...100:
            myBMIStatus = 4
        default:
            break
        }
    }
    
    //BMI 수치에 해당하는 이미지 바꾸기
    func changeBMIImg(index: Int) {
        for (idx, img) in statusImg.enumerated() {
            if idx == index {
                img.image = UIImage(named: statusImgNames[idx])
            }
        }
    }
    
    //BMI 수치에 해당하는 이미지 아래 화살표 보이기
    func visibleArrows(index: Int) {
        for (idx, arrow) in arrows.enumerated() {
            if idx == index {
                arrow.alpha = 1
            } else {
                arrow.alpha = 0
            }
        }
    }
}
