//
//  InitialProfileVC.swift
//  bmi note
//
//  Created by YEHROEI HO on 2022/03/04.
//

import UIKit

class InitialProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var initialUserInputName: UITextField!
    @IBOutlet weak var initialUserInputAge: UITextField!
    @IBOutlet weak var initialUserSelectGender: UISegmentedControl!
    @IBOutlet weak var initialUserInputHeight: UITextField!
    @IBOutlet weak var initialUserInputWeight: UITextField!
    
    var userInfo = Profile()
    var userInfoBrain = BMIBrain()
    
    @IBAction func initUserSelectSeg(_ sender: UISegmentedControl) {
        
        // Segment Index에 따라서 남여를 지정, 굳이 함수화 할 필요는 없지만 관리차원으로 getGenderType() 함수를 Brain에 형성, 값이 없을 수 없어서 force unwrap 함.
        let gender = initialUserSelectGender.titleForSegment(at: sender.selectedSegmentIndex)!
        userInfo.gender = userInfoBrain.getGenderType(selectedIndexTitle: gender)
        view.endEditing(true)
  
    }
    
    @IBAction func saveInitialProfile(_ sender: UIButton) {
        
        // getUserData() Brain 추가 예정
        userInfo.name = initialUserInputName.text
        userInfo.age = Int(initialUserInputAge.text! ?? "0")!
        userInfo.height = Float(initialUserInputHeight.text)
        userInfo.weight = Float(initialUserInputWeight.text)
        
        // profileDictionary() Brain 추가 예정
        profileUserData = userInfoBrain.getUserData(name: userInfo.name, age: userInfo.gender, gender: userInfo.gender, height: userInfo.height, weight: userInfo.weight)
        UserDefaults.standard.set(profileUserData, forKey: "profileData")
        
        print("\(userInfo.name ?? "none")")
        print("\(userInfo.age ?? 0)")
        print("\(userInfo.gender ?? "none")")
        print("\(userInfo.height ?? 0.0 )")
        print("\(userInfo.weight ?? 0.0 )")
        
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
