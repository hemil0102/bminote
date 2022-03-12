//
//  BMIBrain.swift
//  bmi note
//
//  Created by YEHROEI HO on 2022/03/03.
//

import Foundation

//BMI 계산을 위한 ViewModel
struct BMIBrain {
    
    typealias UDSaveFormat = [String: Any] //딕셔너리 타입 이름 재정의
    let ud = UserDefaults.standard
    
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
    
    //그래프 데이터 배열
    var bmidateArray: [String] = [] //X축
    var bmiValueArray: [Double] = [] //Y축
    
    var bmidateArray2: [String] = [] //X축
    var bmiValueArray2: [Double] = [] //Y축
    
    //신장/몸무게 피커뷰 min/max
    var bmiPickerRange = BMIPicker()
    
    //데이터 수량
    var dataCount: Int = 0
    
    //상수
    let historyKeyValue: String = Constants.history //history key값 상수
    
    //데이터 유저디폴트 저장용 배열 변수
    var saveArray: [UDSaveFormat] = []
    
    //기본 이니셜라이저
    init() {
        heightForBmi = 1
        weightForBmi = 1
        bmiValue = 1.0
        bmiStatus = ""
        regDate = ""
        
        getXAxisIndices()
        getYAxisValues()
        
        //UserDefault 에서 데이터 한번 들고와야함.
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
        let temp = Double(weightForBmi) / pow(Double(heightForBmi)/100, 2)
        
        let digit: Double = pow(10, 1)
        bmiValue = round(temp * digit) / digit //두번째 자리에서 반올림 구현
    }
    
    mutating func setDate() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd(E)"
        regDate = formatter.string(from: Date())
        //print(regDate)
    }
    
    mutating func setInitialPickerViewValue() { 
        //유저 디폴트에 저장 데이터가 0개면 프로필에서 데이터 세팅.
        //유저 디폴트에 저장 데이터가 1개 이상이면 가장 최신 데이터 세팅.
    }
    
    mutating func saveResult() {
        
        self.setCalculatedBMI() //BMI 계산/세팅
        self.setDate() //날짜 세팅
        let bmiStatus = BMIStandard.decideLevel(bmiValue: bmiValue) //bmiStatus 가져오기
        
        let dict: UDSaveFormat = ["regDate": regDate, "heightForBmi": heightForBmi, "weightForBmi": weightForBmi, "bmi" : bmiValue, "bmiStatus": bmiStatus]
        
        
        saveArray.append(dict)
        print(saveArray)
        
        ud.set(saveArray, forKey: historyKeyValue) //bmi 계산값 저장
        
        print(ud.array(forKey: historyKeyValue) ?? "No data")
        
        dataCount += 1
        print(dataCount)
        
        if let udData = ud.array(forKey: historyKeyValue) {
            if (udData.count == 0) {
                return
            } else {
                print(type(of: udData))
                print(type(of: udData[0]))
                print(udData[0])

            }
        }
        
        //let profileKeyValue: String = Constants.profile //profile key값 상수
        //print(UserDefaults.standard.dictionary(forKey: profile) ?? "No data")
    }
    
    mutating func temp () {
        if let udData = ud.array(forKey: historyKeyValue) {
            if (udData.count == 0) {
                return
            } else {
                print(udData[0])
            }
        }
    }
}
