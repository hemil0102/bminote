//
//  BMIBrain.swift
//  bmi note
//
//  Created by YEHROEI HO on 2022/03/03.
//

import Foundation

//BMI 계산을 위한 ViewModel
struct BMIBrain {
    var tBMI = [
        BMI(heightForBMI: 170, weightForBMI: 72, bmiStatus: "정상", regDate: "2022-03-01(일)", bmi: 25.3),
        BMI(heightForBMI: 180, weightForBMI: 58, bmiStatus: "저체중", regDate: "2022-03-02(일)", bmi: 19.3),
        BMI(heightForBMI: 164, weightForBMI: 93, bmiStatus: "과체중", regDate: "2022-03-03(일)", bmi: 33.3),
        BMI(heightForBMI: 198, weightForBMI: 37, bmiStatus: "저체중", regDate: "2022-03-04(일)", bmi: 12.3),
        BMI(heightForBMI: 162, weightForBMI: 64, bmiStatus: "정상", regDate: "2022-03-05(일)", bmi: 28.3),
        BMI(heightForBMI: 173, weightForBMI: 81, bmiStatus: "정상 ", regDate: "2022-03-06(일)", bmi: 20.3)
    ]
    
    //리스트로 뿌려줌
    func getAllBMI() -> [BMI] {
        return tBMI
    }
}
