//
//  MainProfileVC.swift
//  bmi note
//
//  Created by YEHROEI HO on 2022/03/04.
//

import UIKit

/* to do list
 1. 초반 진입시 텍스트 필드 비활성화 구현 [ 완료 ]
 2. 수정 버튼 클릭 시 텍스트 필드 활성화 구현 [ 완료 ]
 3. 수정 버튼 클릭 시 문구 취소로 변경 [ 완료 ]
 4. 취소 버튼 클릭 시 유저 정보 복원 및 텍스트 필드 비활성화 [   ]
 5. 텍스트 필드에 유저 데이터 불러오기 [   ]
 6. 유효성 검사 추가 [   ]
 7. 저장 버튼 클릭 시 메인에 반영 필요, 피커뷰와 메인 프로필 [   ]
 
 ** 왜 버튼이 활성화가 안되지?
 ** 왜 버튼 폰트는 시뮬레이션에서 작아지지?
 
*/
class MainProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainUserInputName.isUserInteractionEnabled = false
        mainUserInputAge.isUserInteractionEnabled = false
        mainUserSelectGender.isUserInteractionEnabled = false
        mainUserInputHeight.isUserInteractionEnabled = false
        mainUserInputWeight.isUserInteractionEnabled = false
        mainUserInputQuote.isUserInteractionEnabled = false
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var mainUserInputName: UITextField!
    @IBOutlet weak var mainUserInputAge: UITextField!
    @IBOutlet weak var mainUserInputHeight: UITextField!
    @IBOutlet weak var mainUserInputWeight: UITextField!
    @IBOutlet weak var mainUserInputQuote: UITextField!
    @IBOutlet weak var mainUserSelectGender: UISegmentedControl!
    
    
    @IBOutlet weak var mainEditUserProfileLabel: UIButton!
    
    @IBAction func mainEditUserProfile(_ sender: UIButton) {
        
        if mainEditUserProfileLabel.currentTitle! == "수정"
        {
            
        mainUserInputName.isUserInteractionEnabled = true
        mainUserInputAge.isUserInteractionEnabled = true
        mainUserSelectGender.isUserInteractionEnabled = true
        mainUserInputHeight.isUserInteractionEnabled = true
        mainUserInputWeight.isUserInteractionEnabled = true
        mainUserInputQuote.isUserInteractionEnabled = true
        mainEditUserProfileLabel.setTitle("취소", for: .normal)
            
        } else if mainEditUserProfileLabel.currentTitle! == "취소"
        {
            
        mainUserInputName.isUserInteractionEnabled = false
        mainUserInputAge.isUserInteractionEnabled = false
        mainUserSelectGender.isUserInteractionEnabled = false
        mainUserInputHeight.isUserInteractionEnabled = false
        mainUserInputWeight.isUserInteractionEnabled = false
        mainUserInputQuote.isUserInteractionEnabled = false
        mainEditUserProfileLabel.setTitle("수정", for: .normal)
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
