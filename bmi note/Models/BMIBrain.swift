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
    
    //이 배열을 적극 활용! Main의 8일 그래프와 리스트에서 사용될 것입니다.
    var bmiDatas: [BMI]?
    
    //그래프 데이터용 배열
    var bmiDateArray: [String] = [] //X축
    var bmiValueArray: [Double] = [] //Y축
    
    //신장/몸무게 피커뷰 min/max
    var bmiPickerRange = BMIPicker()
    
    //Key값 상수
    let historyKeyValue: String = Constants.history //history key값 상수
    
    //기본 이니셜라이저
    init() {

        //임시 유저디폴트 생성(삭제 예정)
        //createTempUserDefaults()
        
        //저장된 유저 디폴트 로드
        initialLoadUserDefaults()
        
        //로드된 유저 디폴트의 값을 그래프로 저장하기 위한 함수
        setAxisValues()
    }
    
    //리스트로 뿌려줌
//    func getAllBMI() -> [BMI]? {
//        if let bmi = bmiDatas {
//            return bmi.reversed()
//        } else {
//            return nil
//        }
//    }
    
    //하나의 BMI정보를 가져오기
//    func getBMIInfo(_ idx: Int) -> BMI? {
//        if let bmi = bmiDatas {
//            return bmi[idx]
//        } else {
//            return nil
//        }
//    }
    
    //객체화 시점에 유저디폴트 데이터 가져오는 함수
    mutating func initialLoadUserDefaults() {
        
        let udData = ud.array(forKey: historyKeyValue)
        
        bmiDatas = []
        
        if let tempData = udData {
            if (tempData.count == 0) {
                return
            } else {
                for i in 0 ..< tempData.count {
                    let tempArr = tempData[i] as? UDSaveFormat
                    let tempHeight = tempArr?["heightForBmi"] as? Float ?? -1.0
                    let tempWeight = tempArr?["weightForBmi"] as? Float ?? -1.0
                    let tempBmiStatus = tempArr?["bmiStatus"] as? String ?? "no data"
                    let tempRegDate = tempArr?["regDate"] as? String ?? "no data"
                    let tempBmi = tempArr?["bmi"] as? Double ?? -1.0
                    
                    bmiDatas?.append(BMI(heightForBMI: tempHeight, weightForBMI: tempWeight, bmiStatus: tempBmiStatus, regDate: tempRegDate, bmi: tempBmi))
                    
                }
            }
        }
        
        print(bmiDatas ?? "no data")
    }
    
    private func setCalculatedBMI(height: Int, weight: Int) -> Double {
        
        let temp = Double(weight) / pow(Double(height)/100, 2)
        let digit: Double = pow(10, 1)
        
        return round(temp * digit) / digit //두번째 자리에서 반올림 구현
    }
    
    private func setDate() -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd(E) hh:mm" //시간까지 구현 필요
        
        return formatter.string(from: Date())
    }
    
    mutating func setCurrentBMI(_ height: Int, _ weight: Int){
        let bmiValue: Double = setCalculatedBMI(height: height, weight: weight)
        let DateValue: String = setDate()
        let bmiStatusValue: String = BMIStandard.decideLevel(bmiValue: bmiValue)
        
        //self.currentBMI = BMI(heightForBMI: height, weightForBMI: weight, bmiStatus: bmiStatusValue, regDate: DateValue, bmi: bmiValue)
        bmiDatas?.append(BMI(heightForBMI: Float(height), weightForBMI: Float(weight), bmiStatus: bmiStatusValue, regDate: DateValue, bmi: bmiValue))
    }
    
    mutating func setAxisValues() { //그래프용 데이터 저장
        
        bmiDateArray = ["temp", "temp", "temp", "temp", "temp", "temp", "temp", "temp" ]
        bmiValueArray = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        
        if let data = bmiDatas {
            for i in 0 ..< data.count {
                bmiDateArray.append(data[i].regDate)
                bmiValueArray.append(data[i].bmi)
            }
        } else {
            return
        }
        
        for i in 0..<bmiValueArray.count {
            if (bmiValueArray[i] > 50) {
                bmiValueArray[i] = 50
            }
        }
        
        bmiDateArray = arrayCountControl(arr: bmiDateArray, count: 8)
        bmiValueArray = arrayCountControl(arr: bmiValueArray, count: 8)
    }
    
    func arrayCountControl<T>(arr: [T], count: Int) -> [T] {
        
        var tempArr = arr
        while (tempArr.count > count) {
            tempArr.removeFirst()
        }
        
        return tempArr
    }
    
    mutating func saveResultToArray(_ height: Int, _ weight: Int) {
        //피커뷰에서 세팅된 신장/몸무게로 BMI 구조체 인스턴스를 CurrentBMI 변수에 저장
        setCurrentBMI(height, weight)
        
        //print(bmiDatas)
        //print(bmiValueArray)
    }
    
    func getArrayIndex(arr: [Int], value: Int) -> Int? {
        return arr.firstIndex(of: value)
    }
    
    func saveResultToUserDefaults() { //최종 배열값 유저디폴트로 저장하는 함수. 앱이 백그라운드에 있거나 종료 직전에 저장하도록
        
        var saveData: [UDSaveFormat] = []
        
        if let data = bmiDatas {
            for i in 0 ..< data.count {
                //[BMI] 형태의 배열을 [String: Any] 로 저장 필요
                
                let element: UDSaveFormat = ["regDate": data[i].regDate, "heightForBmi": data[i].heightForBMI, "weightForBmi": data[i].weightForBMI, "bmi" : data[i].bmi, "bmiStatus": data[i].bmiStatus]
                saveData.append(element)
                
                ud.set(saveData, forKey: historyKeyValue)
            }
        }
        
        //print(ud.array(forKey:historyKeyValue))
    }
    
//        func createTempUserDefaults() { //삭제 예정
//
//            var saveArray: [UDSaveFormat] = []
//
//            let dict1: UDSaveFormat = ["regDate": "2022", "heightForBmi": 176, "weightForBmi": 83, "bmi" : 17.0, "bmiStatus": "정상"]
//            let dict2: UDSaveFormat = ["regDate": "2023", "heightForBmi": 177, "weightForBmi": 84, "bmi" : 25.0, "bmiStatus": "정상"]
//            let dict3: UDSaveFormat = ["regDate": "2025", "heightForBmi": 171, "weightForBmi": 86, "bmi" : 24.2, "bmiStatus": "정상"]
//            let dict4: UDSaveFormat = ["regDate": "2024", "heightForBmi": 172, "weightForBmi": 90, "bmi" : 27.0, "bmiStatus": "정상"]
//            let dict5: UDSaveFormat = ["regDate": "2021", "heightForBmi": 174, "weightForBmi": 81, "bmi" : 25.0, "bmiStatus": "정상"]
//
//            saveArray.append(dict1)
//            saveArray.append(dict2)
//            saveArray.append(dict3)
//            saveArray.append(dict4)
//            saveArray.append(dict5)
//
//            ud.set(saveArray, forKey: historyKeyValue) //bmi 계산값 저장
//
//            print("계산값 저장 : \(saveArray)")
//            print("ud개수: \(saveArray.count)")
//        }
}
