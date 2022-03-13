//
//  BMIStandard.swift
//  bmi note
//
//  Created by JONGMIN Youn on 2022/03/07.
//

import Foundation




struct BMIStandard {
    
    let BMIStdValue: Double = 23.5
    
    static let underWeightRange: Range<Double> = 0.0 ..< 18.0
    static let normalWeightRange: Range<Double> = 18.0 ..< 25.0
    static let overWeightRange: Range<Double> = 25.0 ..< 30.0
    static let obesWeightRange: Range<Double> = 30.0 ..< 40.0
    static let highObesWeightRange: Range<Double> = 40.0 ..< 100.0
    
    static func decideLevel(bmiValue: Double) -> String {
        switch bmiValue {
        case underWeightRange:
            return "저체중"
        case normalWeightRange:
            return "정상체중"
        case overWeightRange:
            return "과체중"
        case obesWeightRange:
            return "비만"
        case highObesWeightRange:
            return "고도비만"
        default :
            return "범위없음"
        }
    }
    
    //bmi 수치가 어느 범위에 속하는지 리턴 0~4
    static func decideLevelRange(bmiValue: Double) -> Int {
        switch bmiValue {
        case underWeightRange:
            return 0
        case normalWeightRange:
            return 1
        case overWeightRange:
            return 2
        case obesWeightRange:
            return 3
        case highObesWeightRange:
            return 4
        default :
            return 5
        }
    }
    
}

/*
 underWeightRange 저체중: ~18
 normalWeightRange 정상: 18~24
 overWeightRange 과체중: 25~29
 obesWeightRange 비만: 30~39
 highObesWeightRange 고도비만: 40~
 */
