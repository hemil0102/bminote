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
    //기본 BMI변수
    var heightForBmi: Int
    var weightForBmi: Int
    var bmiValue: Double
    var bmiStatus: String
    var regDate: String
    
    //저장 데이터 배열
    var bmidateArray: [String] = []
    var bmiValueArray: [Double] = []
    
    //신장/몸무게 피커뷰 min/max
    var bmiPickerRange = BMIPicker()
    
    //리스트로 뿌려줌
    func getAllBMI() -> [BMI] {
        return tBMI
    }
    
    // 세그먼트에서 성별을 입력 받는 메서드
    
    init() {
        heightForBmi = 1
        weightForBmi = 1
        bmiValue = 1.0
        bmiStatus = ""
        regDate = ""
        
        getXAxisIndices()
        getYAxisValues()
    }
    
    mutating func getXAxisIndices() {
        for i in 0..<tBMI.count {
            bmidateArray.append(tBMI[i].regDate)
        }
    }
    
    mutating func getYAxisValues(){
        for i in 0..<tBMI.count {
            bmiValueArray.append(tBMI[i].bmi)
        }
    }
    
    mutating func setHeight(row: Int) {
        heightForBmi = bmiPickerRange.heightMinMaxArray[row]
    }
    
    mutating func setWeight(row: Int) {
        weightForBmi = bmiPickerRange.weightMinMaxArray[row]
    }
    
    mutating func setCalculatedBMI() {
        bmiValue = Double(weightForBmi) / pow(Double(heightForBmi)/100, 2)
    }
    
    func showResult() {
        print(heightForBmi)
        print(weightForBmi)
        print(bmiValue)
    }
    
    func showTodayDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let current_date_string = formatter.string(from: Date())
        print(current_date_string)
        print(current_date_string.components(separatedBy: "-")[0])
        print(current_date_string.components(separatedBy: "-")[1])
        print(current_date_string.components(separatedBy: "-")[2])
    }
    
    
    //종민 해야할일
    /*
     [v] 키/몸무게 피커뷰에서 받아서 BMI 결과값 도출 및 저장
     [ ] BMIStandard에서 키/몸무게에 따라서 저체중/정상/과체중 판별해서 뱉는 기능
     [ ] [나의 BMI는] 버튼 눌렀을 때 유저디폴트로 저장하는 함수 구현
     [v] 저장 시 연/월/일/요일까지 구현
     */
}
