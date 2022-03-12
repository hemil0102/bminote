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
    
    
    
    //기본BMI변수
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
    
    //리스트로 뿌려줌
    func getAllBMI() -> [BMI] {
        return tBMI
    }
    
    //하나의 BMI정보를 가져오기
    func getBMIInfo(_ idx: Int) -> BMI {
        return tBMI[idx]
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
    
    mutating func setDate() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        regDate = formatter.string(from: Date())
        print(regDate)
    }
    
    mutating func setInitialPickerViewValue() {
        
    }
    
    mutating func saveResult() {
        self.setCalculatedBMI() //BMI 계산/세팅
        self.setDate() //날짜 세팅
        let bmiStatus = BMIStandard.decideLevel(bmiValue: bmiValue) //bmiStatus 가져오기
        let historyKeyValue: String = Constants.userDefaultsKeyHistory //key값 상수 가져오기
        
        let dict: [String: Any] = ["regDate": regDate, "heightForBmi": heightForBmi, "weightForBmi": weightForBmi, "bmi" : bmiValue, "bmiStatus": bmiStatus]
        UserDefaults.standard.set(dict, forKey: historyKeyValue)
        
        print(UserDefaults.standard.dictionary(forKey: Constants.userDefaultsKeyHistory) ?? "No data")
        print(UserDefaults.standard.dictionary(forKey: "Profile") ?? "No data")
    }
}
