//
//  ProfileBrain.swift
//  bmi note
//
//  Created by Walter J on 2022/03/06.
//

import Foundation

//Profile 저장과 로직을 위한 ViewModel
struct ProfileBrain {
    var myProfile = Profile(name: "Movel", age: 1, gender: "남", profileImg: "logo", height: 180.3, weight: 72.2, quote: "날아올라")
    
    // 세그먼트에서 성별을 입력 받는 메서드
    func getGenderType(selectedIndexTitle: String ) -> String {
        
        return selectedIndexTitle
    }
}
