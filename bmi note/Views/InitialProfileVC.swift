//
//  InitialProfileVC.swift
//  bmi note
//
//  Created by YEHROEI HO on 2022/03/04.
//

import UIKit
import Foundation

class InitialProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initialUserInputName.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged) //for와 at이 갖는 의미 그리고 .으로 시작하는 것들에 의미는 뭔가?
        initialUserInputAge.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        initialUserInputHeight.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        initialUserInputWeight.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        saveInitialProfileOutlet.layer.isHidden = true
    }
    
    

    @IBOutlet weak var initialUserInputName: UITextField!
    @IBOutlet weak var checkNameRegularExpressions: UILabel!
    @IBOutlet weak var nameChecker: UIImageView!
    
    @IBOutlet weak var initialUserInputAge: UITextField!
    @IBOutlet weak var checkAgeRegularExpressions: UILabel!
    @IBOutlet weak var ageChecker: UIImageView!
    
    @IBOutlet weak var initialUserSelectGender: UISegmentedControl!
    
    @IBOutlet weak var initialUserInputHeight: UITextField!
    @IBOutlet weak var checkHeightRegularExpressions: UILabel!
    @IBOutlet weak var heightChecker: UIImageView!
    
    @IBOutlet weak var initialUserInputWeight: UITextField!
    @IBOutlet weak var checkWeightRegularExpressions: UILabel!
    @IBOutlet weak var weightChecker: UIImageView!
    
    @IBOutlet weak var saveInitialProfileOutlet: UIButton!
    
    
    var userInfo = Profile()
    var userInfoBrain = ProfileBrain()
    
    @IBAction func initUserSelectSeg(_ sender: UISegmentedControl) {
        
        // Segment Index에 따라서 남여를 지정, 굳이 함수화 할 필요는 없지만 관리차원으로 getGenderType() 함수를 Brain에 형성, 값이 없을 수 없어서 force unwrap 함.
        let gender = initialUserSelectGender.titleForSegment(at: sender.selectedSegmentIndex)!
        userInfo.gender = userInfoBrain.getGenderType(selectedIndexTitle: gender)
        view.endEditing(true)
  
    }
    
    @IBAction func saveInitialProfile(_ sender: UIButton) {
        profileUserData = [ "name" : userInfo.name!, "age" : userInfo.age!, "gender" : userInfo.gender, "height" : userInfo.height!, "weight" : userInfo.weight!  ]
        UserDefaults.standard.set(profileUserData, forKey: "Profile")
        
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        
        var correctName: Bool
        var correctAge: Bool
        var correctHeight: Bool
        var correctWeight: Bool
        
        if initialUserInputName.text != "" {
            let nameRe = "[가-힣A-Za-z]{1,12}"
            let tempName = NSPredicate(format:"SELF MATCHES %@", nameRe)
            if tempName.evaluate(with: initialUserInputName.text) {
                correctName = true
                userInfo.name = initialUserInputName.text
                print(userInfo.name!)
                nameChecker.image = UIImage(systemName: "checkmark.circle.fill")
                checkNameRegularExpressions.text = ""
            } else {
                correctName = false
                nameChecker.image = UIImage(systemName: "")
                checkNameRegularExpressions.text = "특수 기호, 숫자 및 공백 제외\n한글 및 영어로 입력해주세요 :)"

            }
        } else {
            correctName = false
            nameChecker.image = UIImage(systemName: "")
            checkNameRegularExpressions.text = "닉네임을 입력해주세요 :)"
        }

        if initialUserInputAge.text != "" {
            let ageRe = "(19|20)[0-9]{2}"
            let tempAge = NSPredicate(format:"SELF MATCHES %@", ageRe)
            if tempAge.evaluate(with: initialUserInputAge.text) {
                correctAge = true
                userInfo.age = Int(initialUserInputAge.text!)! //입력이 있고 숫자가 있으므로 force unwrap
                print(userInfo.age!)
                ageChecker.image = UIImage(systemName: "checkmark.circle.fill")
                checkAgeRegularExpressions.text = ""
            } else {
                correctAge = false
                ageChecker.image = UIImage(systemName: "")
                checkAgeRegularExpressions.text = "1900~2099 범위 내\n4자리 숫자를 입력해주세요."

            }
        } else {
            correctAge = false
            ageChecker.image = UIImage(systemName: "")
            checkAgeRegularExpressions.text = "출생연도를 입력해주세요 :)"
        }
        
        if initialUserInputHeight.text != "" {
            let heightRe = "^([0-9]{2,3})\\.([0-9]{1})"
            let tempHeight = NSPredicate(format:"SELF MATCHES %@", heightRe)
            if tempHeight.evaluate(with: initialUserInputHeight.text) {
                correctHeight = true
                userInfo.height = Float(initialUserInputHeight.text!)! //입력이 있고 숫자가 있으므로 force unwrap
                print(userInfo.height!)
                heightChecker.image = UIImage(systemName: "checkmark.circle.fill")
                checkHeightRegularExpressions.text = ""
            } else {
                correctHeight = false
                heightChecker.image = UIImage(systemName: "")
                checkHeightRegularExpressions.text = "소숫점 1자리까지 입력해주세요. \n예: 176.0 or 180.3"

            }
        } else {
            correctHeight = false
            heightChecker.image = UIImage(systemName: "")
            checkHeightRegularExpressions.text = "신장을 입력해주세요 :)"
        }
        
        if initialUserInputWeight.text != "" {
            let weightRe = "^([0-9]{1,3})\\.([0-9]{1})"
            let tempWeight = NSPredicate(format:"SELF MATCHES %@", weightRe)
            if tempWeight.evaluate(with: initialUserInputWeight.text) {
                correctWeight = true
                userInfo.weight = Float(initialUserInputWeight.text!)! //입력이 있고 숫자가 있으므로 force unwrap
                print(userInfo.weight!)
                weightChecker.image = UIImage(systemName: "checkmark.circle.fill")
                checkWeightRegularExpressions.text = ""
            } else {
                correctWeight = false
                heightChecker.image = UIImage(systemName: "")
                checkWeightRegularExpressions.text = "소숫점 1자리까지 입력해주세요. \n예: 176.0 or 180.3"

            }
        } else {
            correctWeight = false
            weightChecker.image = UIImage(systemName: "")
            checkWeightRegularExpressions.text = "몸무게를 입력해주세요 :)"
        }
    
        if correctName && correctAge && correctHeight && correctWeight {
            saveInitialProfileOutlet.layer.isHidden = false
        } else {
            saveInitialProfileOutlet.layer.isHidden = true
        }
    }

    /*

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
            checkNameRegularExpressions.text = "닉네임을 입력해주세요 :)"
        }

    }
  
    @objc func ageTextFieldDidChange(_ textField: UITextField) {
        
        if initialUserInputAge.text != "" {
            let ageRe = "(19|20)[0-9]{2}"
            let tempAge = NSPredicate(format:"SELF MATCHES %@", ageRe)
            if tempAge.evaluate(with: initialUserInputAge.text) {
                userInfo.age = Int(initialUserInputAge.text!)! //입력이 있고 숫자가 있으므로 force unwrap
                ageChecker.image = UIImage(systemName: "checkmark.circle.fill")
                checkAgeRegularExpressions.text = ""
            } else {
                ageChecker.image = UIImage(systemName: "")
                checkAgeRegularExpressions.text = "1900~2099 범위 내\n4자리 숫자를 입력해주세요."

            }
        } else {
            ageChecker.image = UIImage(systemName: "")
            checkAgeRegularExpressions.text = "출생연도를 입력해주세요 :)"
        }
    }
 
    @objc func heightTextFieldDidChange(_ textField: UITextField) {
        
        if initialUserInputHeight.text != "" {
            let heightRe = "^([0-9]{2,3})\\.([0-9]{1})"
            let tempHeight = NSPredicate(format:"SELF MATCHES %@", heightRe)
            if tempHeight.evaluate(with: initialUserInputHeight.text) {
                userInfo.height = Float(initialUserInputHeight.text!)! //입력이 있고 숫자가 있으므로 force unwrap
                heightChecker.image = UIImage(systemName: "checkmark.circle.fill")
                checkHeightRegularExpressions.text = ""
            } else {
                heightChecker.image = UIImage(systemName: "")
                checkHeightRegularExpressions.text = "소숫점 1자리까지 입력해주세요. \n예: 176.0 or 180.3"

            }
        } else {
            heightChecker.image = UIImage(systemName: "")
            checkHeightRegularExpressions.text = "신장을 입력해주세요 :)"
        }
    }
    
    @objc func weightTextFieldDidChange(_ textField: UITextField) {
        
        if initialUserInputWeight.text != "" {
            let weightRe = "^([0-9]{1,3})\\.([0-9]{1})"
            let tempWeight = NSPredicate(format:"SELF MATCHES %@", weightRe)
            if tempWeight.evaluate(with: initialUserInputWeight.text) {
                userInfo.weight = Float(initialUserInputWeight.text!)! //입력이 있고 숫자가 있으므로 force unwrap
                weightChecker.image = UIImage(systemName: "checkmark.circle.fill")
                checkWeightRegularExpressions.text = ""
            } else {
                heightChecker.image = UIImage(systemName: "")
                checkWeightRegularExpressions.text = "소숫점 1자리까지 입력해주세요. \n예: 176.0 or 180.3"

            }
        } else {
            weightChecker.image = UIImage(systemName: "")
            checkWeightRegularExpressions.text = "신장을 입력해주세요 :)"
        }
    }
*/
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
