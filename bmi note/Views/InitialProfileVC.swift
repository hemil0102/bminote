//
//  InitialProfileVC.swift
//  bmi note
//
//  Created by YEHROEI HO on 2022/03/04.
//

import UIKit
import Foundation

class InitialProfileVC: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //실시간 유저 입력에 대한 유효성 검사를 위한 addTarget
        initialUserInputName.addTarget(self, action: #selector(nameTextFieldDidChange), for: .editingChanged) //for와 at이 갖는 의미 그리고 .으로 시작하는 것들에 의미는 뭔가?
        initialUserInputAge.addTarget(self, action: #selector(ageTextFieldDidChange), for: .editingChanged)
        initialUserInputHeight.addTarget(self, action: #selector(heightTextFieldDidChange), for: .editingChanged)
        initialUserInputWeight.addTarget(self, action: #selector(weightTextFieldDidChange), for: .editingChanged)
        //초기 버튼 비활성화
        // 모든 입력이 유효함을 판단하는 if문, 유효할 경우 저장 버튼이 활성화됨.
        buttonDecision()
        
        //키보드 화면 가림 방지 구현
        initialUserInputName.delegate = self
        initialUserInputAge.delegate = self
        initialUserInputHeight.delegate = self
        initialUserInputWeight.delegate = self
        initialUserInputName.returnKeyType = .done
        initialUserInputAge.returnKeyType = .done
        initialUserInputHeight.returnKeyType = .done
        initialUserInputWeight.returnKeyType = .done
        
        //키보드가 나탈 떄
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //제스처가 실행될 떄 키보드를 내릴 수 있도록
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
        
        
    }
 
    var isExpand : Bool = false

    @objc func keyboardWillShow(notification: NSNotification) {
        if !isExpand {
            self.initProfileScrollView.contentSize = CGSize(width: self.view.frame.width, height: self.initProfileScrollView.frame.height + 250 )
        }
        isExpand = true
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if isExpand {
            self.initProfileScrollView.contentSize = CGSize(width: self.view.frame.width, height: self.initProfileScrollView.frame.height - 250 )
            self.isExpand = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
         return true
     }
    
    //제스처 실행시 키보드를 내리는 파트
    @objc func endEditing() {
        initialUserInputName.resignFirstResponder()
        initialUserInputAge.resignFirstResponder()
        initialUserInputHeight.resignFirstResponder()
        initialUserInputWeight.resignFirstResponder()
    }
    
    @IBOutlet weak var initialUserInputName: UITextField!
    @IBOutlet weak var initialCheckNameRegEx: UILabel!
    @IBOutlet weak var initialNameChecker: UIImageView!
    
    @IBOutlet weak var initialUserInputAge: UITextField!
    @IBOutlet weak var initialCheckAgeRegEx: UILabel!
    @IBOutlet weak var initialAgeChecker: UIImageView!
    
    @IBOutlet weak var initialUserSelectGender: UISegmentedControl!
    
    @IBOutlet weak var initialUserInputHeight: UITextField!
    @IBOutlet weak var initialCheckHeightRegEx: UILabel!
    @IBOutlet weak var initialHeightChecker: UIImageView!
    
    @IBOutlet weak var initialUserInputWeight: UITextField!
    @IBOutlet weak var initialCheckWeightRegEx: UILabel!
    @IBOutlet weak var initialWeightChecker: UIImageView!
    
    @IBOutlet weak var saveInitialProfileOutlet: UIButton!
    @IBOutlet weak var initProfileScrollView: UIScrollView!
    
    @IBOutlet weak var genderProfileImg: UIImageView!
    
    
    var userInfo = Profile()
    var userInfoBrain = ProfileBrain()
    var initialCorrectName = false
    var initialCorrectAge = false
    var initialCorrectHeight = false
    var initialCorrectWeight = false
    
    
    //남녀 성별 선택 세그먼트
    @IBAction func initUserSelectSeg(_ sender: UISegmentedControl) {
        
    // Segment Index에 따라서 남여를 지정, 굳이 함수화 할 필요는 없지만 관리차원으로 getGenderType() 함수를 Brain에 형성, 값이 없을 수 없어서 force unwrap 함.
        let gender = initialUserSelectGender.titleForSegment(at: sender.selectedSegmentIndex)! //선택된 세그먼트 인덱스의 타이틀
        userInfo.gender = userInfoBrain.getGenderType(selectedIndexTitle: gender) //선택된 세그먼트의 성별 정보를 userInfo에 저장
        userInfo.profileImg = userInfoBrain.getGenderImage(selectedIndex: sender.selectedSegmentIndex) //선택된 성별에 따라 남, 녀 미모지를 선택
        genderProfileImg.image = UIImage(named: userInfo.profileImg) //이미지 뷰에 선택된 성별 이미지를 보여줌
    }
    
    //유저 정보 저장 및 격언 뷰로 전환
    @IBAction func saveInitialProfile(_ sender: UIButton) {
        profileUserData = [ "name" : userInfo.name!, "age" : userInfo.age!, "gender" : userInfo.gender, "height" : userInfo.height!, "weight" : userInfo.weight!, "profileImg" : userInfo.profileImg  ]
        UserDefaults.standard.set(profileUserData, forKey: Constants.profile)
        
        // 격언뷰로 전환
        guard let initQuoteVC = self.storyboard?.instantiateViewController(withIdentifier: "initQuoteVC") as? InitialQuoteVC else { return }
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(initQuoteVC , animated: false)
        
    }
    
    
    // 개인 신상 정보 입력 유효성 검사
    @objc func nameTextFieldDidChange(_ textField: UITextField) {
        
        if initialUserInputName.text != "" {
            let nameRe = "[가-힣A-Za-z]{1,12}" //모든 완성형 한글과 대소문자 알파벳만 입력으로 받는다. 문자는 1자리에서 12자리까지 입력 가능.
            let tempName = NSPredicate(format:"SELF MATCHES %@", nameRe) //지정된 정규식에 해당하는 입력이 들어왔는지 체크하는 부분.
            if tempName.evaluate(with: initialUserInputName.text) {
                initialCorrectName = true
                userInfo.name = initialUserInputName.text
                print(userInfo.name!)
                initialNameChecker.image = UIImage(systemName: "checkmark.circle.fill")
                initialNameChecker.tintColor = UIColor.systemGreen
                initialCheckNameRegEx.text = ""
            } else {
                initialCorrectName = false
//                nameChecker.image = UIImage(systemName: "")
                initialCheckNameRegEx.text = "한글 및 영문만 입력 가능합니다."

            }
        } else {
            initialCorrectName = false
//            nameChecker.image = UIImage(systemName: "")
            initialCheckNameRegEx.text = "닉네임을 입력해주세요."
        }
        buttonDecision()
    }
    
    @objc func ageTextFieldDidChange(_ textField: UITextField) {

        if initialUserInputAge.text != "" {
            let ageRe = "(19|20)[0-9]{2}" //앞자리는 19또는 20이란 조건을 주고 뒷 자리는 2자리의 모든 숫자를 조건으로 지정.
            let tempAge = NSPredicate(format:"SELF MATCHES %@", ageRe)
            if tempAge.evaluate(with: initialUserInputAge.text) {
                initialCorrectAge = true
                userInfo.age = Int(initialUserInputAge.text!)! //입력이 있고 숫자가 있으므로 force unwrap
                print(userInfo.age!)
                initialAgeChecker.image = UIImage(systemName: "checkmark.circle.fill")
                initialAgeChecker.tintColor = UIColor.systemGreen
                initialCheckAgeRegEx.text = ""
            } else {
                initialCorrectAge = false
//                ageChecker.image = UIImage(systemName: "")
                initialCheckAgeRegEx.text = "1900~2099 범위 내 입력 바랍니다."

            }
        } else {
            initialCorrectAge = false
//            ageChecker.image = UIImage(systemName: "")
            initialCheckAgeRegEx.text = "출생연도를 입력해주세요."
        }
        buttonDecision()
    }
    
    @objc func heightTextFieldDidChange(_ textField: UITextField) {
        if initialUserInputHeight.text != "" {
            let heightRe = "[0-9]{2,3}" // 2~3자리의 숫자를 입력 받는다. 💡숫자 앞자리에 대한 범위를 더 지정할 필요가 있어보임.
            let tempHeight = NSPredicate(format:"SELF MATCHES %@", heightRe)
            if tempHeight.evaluate(with: initialUserInputHeight.text) {
                initialCorrectHeight = true
                userInfo.height = Float(initialUserInputHeight.text!)! //입력이 있고 숫자가 있으므로 force unwrap
                print(userInfo.height!)
                initialHeightChecker.image = UIImage(systemName: "checkmark.circle.fill")
                initialHeightChecker.tintColor = UIColor.systemGreen
                initialCheckHeightRegEx.text = ""
            } else {
                initialCorrectHeight = false
//                heightChecker.image = UIImage(systemName: "")
                initialCheckHeightRegEx.text = "소숫점 제외, 숫자 2~3자리를 입력해주세요."

            }
        } else {
            initialCorrectHeight = false
//            heightChecker.image = UIImage(systemName: "")
            initialCheckHeightRegEx.text = "신장을 입력해주세요."
        }
        buttonDecision()
    }
    
    @objc func weightTextFieldDidChange(_ textField: UITextField) {
        
        if initialUserInputWeight.text != "" {
            let weightRe = "[0-9]{2,3}" // 1~3자리의 숫자를 입력 받는다.
            let tempWeight = NSPredicate(format:"SELF MATCHES %@", weightRe)
            if tempWeight.evaluate(with: initialUserInputWeight.text) {
                initialCorrectWeight = true
                userInfo.weight = Float(initialUserInputWeight.text!)! //입력이 있고 숫자가 있으므로 force unwrap
                print(userInfo.weight!)
                initialWeightChecker.image = UIImage(systemName: "checkmark.circle.fill")
                initialWeightChecker.tintColor = UIColor.systemGreen
                initialCheckWeightRegEx.text = ""
            } else {
                initialCorrectWeight = false
//                weightChecker.image = UIImage(systemName: "")
                initialCheckWeightRegEx.text = "소숫점 제외, 숫자 2~3자리를 입력해주세요."

            }
        } else {
            initialCorrectWeight = false
//            weightChecker.image = UIImage(systemName: "")
            initialCheckWeightRegEx.text = "몸무게를 입력해주세요."
        }
        buttonDecision()
    }
    
    func buttonDecision() {
        if initialCorrectName && initialCorrectAge && initialCorrectHeight && initialCorrectWeight {
            saveInitialProfileOutlet.isEnabled = true
        } else {
            saveInitialProfileOutlet.isEnabled = false
        }
    }

  /*  // 화면 터치시 키보드를 숨기는 Function
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           self.view.endEditing(true)
   } */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
