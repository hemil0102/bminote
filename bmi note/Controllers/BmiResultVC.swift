//
//  BmiResultVC.swift
//  bmi note
//
//  Created by Walter J on 2022/03/07.
//

import UIKit
import SafariServices

class BmiResultVC: UIViewController {
    @IBOutlet var statusImg:[UIImageView]!      //BMI 상태 이미지
    @IBOutlet var arrows:[UILabel]!     //화살표 배열
    
    //BMI 수치, 키, 몸무게
    @IBOutlet weak var bmiValueLabel: UILabel!
    @IBOutlet weak var heightForBMI: UILabel!
    @IBOutlet weak var weightForBMI: UILabel!
    
    var statusImgNames:[String] = ["bmi_01_underweight_2", "bmi_02_normal_2", "bmi_03_overweight_2", "bmi_04_obese_2", "bmi_05_extremelyobese_2"]
    var bmiStatusRangeIdx = 0   //bmi 범위에 해당하는 번호 0~4
    var bmiInfo:BMI?        //직전 화면에서 BMI 정보를 받는 변수, 종민님 이 변수로 전달해주세요!
    var bmi:Double = 0      //전달받은 BMI수치

    
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
        changeBMIImg(index: bmiStatusRangeIdx)      //User의 BMI수치에 따라 BMI이미지 교체
        visibleArrows(index: bmiStatusRangeIdx)     //User의 BMI수치에 따라 BMI이미지 아래 화살표 교체
        
        // 네비 타이틀 색 변경
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(named: "NewOrange") ?? UIColor.black]
    }
    
    @IBAction func linkToWHO(_ sender: UIButton) {
        let whoUrl = NSURL(string: "https://www.euro.who.int/en/health-topics/disease-prevention/nutrition/a-healthy-lifestyle/body-mass-index-bmi")
        let whoSafariView: SFSafariViewController = SFSafariViewController(url: whoUrl! as URL)
        self.present(whoSafariView, animated: true, completion: nil)
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
        bmiStatusRangeIdx = BMIStandard.decideLevelRange(bmiValue: bmi)
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
