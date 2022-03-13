//
//  ProfileBrain.swift
//  bmi note
//
//  Created by Walter J on 2022/03/06.
//

import Foundation

/*
Todo
1. 연도와 키 항목 숫자 입력 제한 걸기 [  ]
2. 남녀 성별에 따른 프로필 사진 바꾸기 [  ]
3. 격언 화면 구현 [  ]
4. 신상 정보를 개인 정보 수정 창에 업데이트 [  ]
5. 개인 정보 수정 창에서 수정 기능 구현 [  ]
 
*/
   
//Profile 저장과 로직을 위한 ViewModel
struct ProfileBrain {
    var myProfile:Profile?
    
    // 세그먼트에서 성별을 입력 받는 메서드
    func getGenderType(selectedIndexTitle: String ) -> String {
        
        return selectedIndexTitle
    }
    
    //Walter, UserDefault에서 값을 꺼내 myProfile에 대입
    //이후 다른 뷰에서 이 myProfile 객체를 이용
    mutating func setMyProfile(_ userProfile: Profile) {
        self.myProfile = userProfile
    }
}
