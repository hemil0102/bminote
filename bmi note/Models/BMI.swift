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
    
    let proTips = [ "무릎 보호와 근력 강화에는 스쿼트가 좋아요.",
                    "아침 식사 시간이 수면 시간을 결정한다는 연구가 있어요.",
                    "좋은 생각은 좋은 결과를 가져다 줍니다.",
                    "기분 좋은 하루 되시길 바랍니다.",
                    "고민이 많을 때는 때론 신체 감각에 집중해보세요.",
                    "많이 먹었다면, 그만큼 더 운동하면 됩니다 :)" ]
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
    var heightMinMaxArray: [Int] = Array(100...300)
    var weightMinMaxArray: [Int] = Array(30...600)
            
}

