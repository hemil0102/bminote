//
//  InitialProfileVC.swift
//  bmi note
//
//  Created by YEHROEI HO on 2022/03/04.
//

import UIKit
import Foundation

class InitialProfileVC: UIViewController { // 델러게이트 추가

    override func viewDidLoad() {
        super.viewDidLoad()
        initialUserInputName.addTarget(self, action: #selector(nameTextFieldDidChange), for: .editingChanged)
    }
    
    @IBOutlet weak var initialUserInputName: UITextField!
    @IBOutlet weak var checkNameRegularExpressions: UILabel!
    @IBOutlet weak var initialUserInputAge: UITextField!
    @IBOutlet weak var initialUserSelectGender: UISegmentedControl!
    @IBOutlet weak var initialUserInputHeight: UITextField!
    @IBOutlet weak var initialUserInputWeight: UITextField!
    @IBOutlet weak var nameChecker: UIImageView!
    
    var userInfo = Profile()
    var userInfoBrain = ProfileBrain()
    
    @IBAction func initUserSelectSeg(_ sender: UISegmentedControl) {
        
        // Segment Index에 따라서 남여를 지정, 굳이 함수화 할 필요는 없지만 관리차원으로 getGenderType() 함수를 Brain에 형성, 값이 없을 수 없어서 force unwrap 함.
        let gender = initialUserSelectGender.titleForSegment(at: sender.selectedSegmentIndex)!
        userInfo.gender = userInfoBrain.getGenderType(selectedIndexTitle: gender)
        view.endEditing(true)
  
    }
    
    @IBAction func saveInitialProfile(_ sender: UIButton) {
        
    }



    @objc func nameTextFieldDidChange(_ textField: UITextField) {
        
        if initialUserInputName.text != "" {
            let nameRe = "[가-힣A-Za-z]{1,12}"
            let tempName = NSPredicate(format:"SELF MATCHES %@", nameRe)
            if tempName.evaluate(with: initialUserInputName.text) {
                userInfo.name = initialUserInputName.text
                nameChecker.image = UIImage(systemName: "checkmark.circle.fill")
                checkNameRegularExpressions.text = ""
            } else {
                nameChecker.image = UIImage(systemName: "")
                checkNameRegularExpressions.text = "특수 기호, 숫자 및 공백 제외\n한글 및 영어로 입력해주세요 :)"

            }
        } else {
            nameChecker.image = UIImage(systemName: "")
            checkNameRegularExpressions.text = "닉네임을 작성해주세요 :)"
        }
    }
    
    // 화면 터치시 키보드를 숨기는 Function
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
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
