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
    var bmiDatas:[BMI]?
    
    //기본BMI변수
    var heightForBmi: Int
    var weightForBmi: Int
    var bmiValue: Double
    var bmiStatus: String
    var regDate: String
    
    //그래프 데이터 배열
    var bmiDateArray: [String] = [] //X축
    var bmiValueArray: [Double] = [] //Y축
    
    //신장/몸무게 피커뷰 min/max
    var bmiPickerRange = BMIPicker()
    
    //Key값 상수
    let historyKeyValue: String = Constants.history //history key값 상수
    
    //데이터 유저디폴트 저장용 배열 변수
    var saveArray: [UDSaveFormat] = []
    
    //기본 이니셜라이저
    init() {
        heightForBmi = -1
        weightForBmi = -1
        bmiValue = -1.0
        bmiStatus = "No data"
        regDate = "No date"
        
        initialLoadUserDefaults()
        
        setXaxisValues()
        setYaxisValues()
    }
    
    var lastBmiData: BMI {
        
        get {
            let temp: BMI = BMI(heightForBMI: -1.0, weightForBMI: -1.0, bmiStatus: "No data", regDate: "No data", bmi: -1.0)
            
            if (bmiDatas?.count == 0) {
                return temp
            } else {
                let count = bmiDatas?.count ?? -1
                return bmiDatas?[count - 1] ?? temp
            }
            
        }
    }
    
    //리스트로 뿌려줌
    func getAllBMI() -> [BMI]? {
        if let bmi = bmiDatas {
            return bmi
        } else {
            return nil
        }
    }
    
    //하나의 BMI정보를 가져오기
    func getBMIInfo(_ idx: Int) -> BMI? {
        if let bmi = bmiDatas {
            return bmi[idx]
        } else {
            return nil
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
    
    mutating func saveResult2() {
        
        self.setCalculatedBMI() //BMI 계산/세팅
        self.setDate() //날짜 세팅
        let bmiStatus = BMIStandard.decideLevel(bmiValue: bmiValue) //bmiStatus 가져오기
        
        bmiDatas?.append(BMI(heightForBMI: Float(self.heightForBmi), weightForBMI: Float(self.weightForBmi), bmiStatus: bmiStatus, regDate: regDate, bmi: bmiValue))
        
        print("저장된 bmidata 배열 \(bmiDatas)")
    }
    
    mutating func saveResult() {
        
        self.setCalculatedBMI() //BMI 계산/세팅
        self.setDate() //날짜 세팅
        let bmiStatus = BMIStandard.decideLevel(bmiValue: bmiValue) //bmiStatus 가져오기
        
        let dict: UDSaveFormat = ["regDate": regDate, "heightForBmi": heightForBmi, "weightForBmi": weightForBmi, "bmi" : bmiValue, "bmiStatus": bmiStatus]
            
        saveArray.append(dict)
        print("계산값 저장 : \(saveArray)")

        ud.set(saveArray, forKey: historyKeyValue) //bmi 계산값 저장
        
        print(ud.array(forKey: historyKeyValue) ?? "No data")
    }
    
    
    mutating func setXaxisValues() {
        
        bmiDateArray = []
        
        if let udData = ud.array(forKey: historyKeyValue) {
            if (udData.count == 0) {
                return
            } else {
                for i in 0 ..< udData.count {
                    let tempArr = udData[i] as? UDSaveFormat
                    bmiDateArray.append(tempArr?["regDate"] as? String ?? "")
                }
            }
        }
        
        bmiDateArray = arrayCountControl(arr: bmiDateArray, count: 8)
    }
    
    mutating func setYaxisValues() {
        
        bmiValueArray = []
        
        if let udData = ud.array(forKey: historyKeyValue) {
            if (udData.count == 0) {
                return
            } else {
                for i in 0 ..< udData.count {
                    let tempArr = udData[i] as? UDSaveFormat
                    bmiValueArray.append(tempArr?["bmi"] as? Double ?? -1.0)
                }
            }
        }
        
        bmiValueArray = arrayCountControl(arr: bmiValueArray, count: 8)
        
    }
    
    func arrayCountControl<T>(arr: [T], count: Int) -> [T] {
        
        var tempArr = arr
        while (tempArr.count > count) {
            tempArr.removeFirst()
        }
        
        return tempArr
    }
}

/*
 1. 최초에 인스턴스 생성될 때, 유저디폴트에서 값 불러와서 배열[BMI]에 저장해야함 (bmiDatas)
 2. 만약, 유저디폴트에 값이 없으면 빈배열임.(bmiDatas = [])
 3. 유저디폴트에서 불러온 값으로 차트의 x,y값의 배열 만들어야함.
 4. 당연히 유저디폴트에 값이 없으면 x,y값의 배열은 빈배열임.
 5. save 버튼 누르면 bmiBrain 인스턴스에 신장/몸무게 전달되고 bmi값이 계산되어 bmiDatas에 저장해야함.
 6. bmiDatas 에서 가장 뒤에 있는 배열을 BmiResultVC 로 옮겨줘야함.
 */

