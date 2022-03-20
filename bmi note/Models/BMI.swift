//
//  Bminote.swift
//  bmi note
//
//  Created by YEHROEI HO on 2022/03/03.
//

import Foundation

//개인 프로필
struct Profile {
    var name: String?
    var age: Int?
    var gender: String = "여" //초기 값을 갖는 형태의 segment로 유저가 여성일 경우 선택 동작이 이뤄지지 않을 때 초기 값이 필요하다. 
    var profileImg: String = "woman_harry.png"
    var height: Float?
    var weight: Float?
    var quote: String?
    
    let quoteList = ["나는 할 수 있다!",
                     "천리길도 한 걸음부터!",
                     "작은 습관들이 삶의 큰 변화를 만든다.",
                     "어차피 먹어봤자, 아는 그 맛이다.",
                     "올 여름 바닷가에선 내가 킹카퀸카~",
                     "실패는 성공의 어머니! 실패를 두려워하지 말자!"]
}

var profileUserData: [ String : Any ] = [ "isUserInput" : false ]


//BMI 계산
struct BMI {
    let heightForBMI: Float
    let weightForBMI: Float
    let bmiStatus: String
    let regDate: String
    let bmi: Double
}

//BMI 피커뷰
struct BMIPicker {
    //신장/몸무게 피커뷰 범위
    var heightMinMaxArray: [Int] = Array(140...200)
    var weightMinMaxArray: [Int] = Array(30...150)
            
}

