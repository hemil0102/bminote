//
//  ProfileBrain.swift
//  bmi note
//
//  Created by Walter J on 2022/03/06.
//

import Foundation
import UIKit

/*
 
Todo
1. 연도와 키 항목 숫자 입력 제한 걸기 [  ]
2. 남녀 성별에 따른 프로필 사진 바꾸기 [ ok ]
3. 격언 화면 구현 [ ok ]
4. 신상 정보를 개인 정보 수정 창에 업데이트 [ ok ]
5. 개인 정보 수정 창에서 수정 기능 구현 [ok]
6. 유효성 검사 함수화 [  ]
7. 클린 코드 정리 [  ]
8. 개인정보 화면 스크롤 뷰 구현 [  ]
 
*/
   
//Profile 저장과 로직을 위한 ViewModel
struct ProfileBrain {
    var myProfile:Profile?
    
    // 세그먼트에서 성별을 입력 받는 메서드
    func getGenderType(selectedIndexTitle: String ) -> String {
        return selectedIndexTitle
    }
    
    // 세그먼트 성별 선택에 따른 이미지 선택
    func getGenderImage(selectedIndex: Int) -> String {
        
        var image: String = ""
        
        if selectedIndex == 0 {
            image = "Movel Logo - Yellow.png"
        } else if selectedIndex == 1 {
            image = "Movel Logo - Emerald.png"
        }
        
        return image
        
    }
    
    // 메인화면 ProTips를 랜덤으로 출력할 함수
    func getProTips() -> String {
        let arraynum: Int = (myProfile?.proTips.count)!
        let numbers = Int.random(in: 0..<arraynum)
        return (myProfile?.proTips[numbers])!
    }
    // Walter, UserDefault에서 값을 꺼내 myProfile에 대입
    // 이후 다른 뷰에서 이 myProfile 객체를 이용
    mutating func setMyProfile(_ userProfile: Profile) {
        self.myProfile = userProfile
    }
    
    // 유저 정보 입력 검사
    /*
    func isUserData(_ LoadedUserProfile: Profile?) -> Bool {
        let available: Bool = false
        let UserProfile = UserDefaults.standard.dictionary(forKey: Constants.profile)
        
        return available
    }*/
    
    func testPrint(_ input: [String : Any]?) {
        print(input!)
    }
    // 유효성 검사
    func overallRegex (_ input: String) {
        
    }
}
