//
//  Bminote.swift
//  bmi note
//
//  Created by YEHROEI HO on 2022/03/03.
//

import Foundation

struct Profile {
    let name: String
    var age: Int
    let gender: String
    var profileImg: String
    var height: Float
    var weight: Float
    var quote: String
}

struct BMI {
    let heightForBMI: Float
    let weightForBMI: Float
    let bmiStatus: String
    let regDate: String
    let bmi: Double
}
