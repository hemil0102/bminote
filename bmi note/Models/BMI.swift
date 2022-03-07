//
//  Bminote.swift
//  bmi note
//
//  Created by YEHROEI HO on 2022/03/03.
//

import Foundation

struct Profile {
    var name: String?
    var age: Int?
    var gender: String = "여" //초기 값을 갖는 형태의 segment로 유저가 여성일 경우 선택 동작이 이뤄지지 않을 때 초기 값이 필요하다. 
    var profileImg: String?
    var height: Float?
    var weight: Float?
    var quote: String?
}

var profileUserData: [ String : Any ] = [ "test" : "test" ]

struct BMI {
    let heightForBMI: Float
    let weightForBMI: Float
    let bmiStatus: String
    let regDate: String
    let bmi: Double
}


