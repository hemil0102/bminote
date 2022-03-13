//
//  InitialQuoteVC.swift
//  bmi note
//
//  Created by YEHROEI HO on 2022/03/04.
//

import UIKit

class InitialQuoteVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //뷰가 로드될 때 앞에 저장되었던 딕셔너리 형태의 유저 정보를 불러온다.
        let savedUserProfile = UserDefaults.standard.dictionary(forKey: Constants.profile)
        //불러온 유저 정보에서 이름 값을 할당.
        let savedUserName = savedUserProfile?["name"] as? String
        //레이블에 저장된 유저 이름을 표시해준다.
        userName.text = "\(savedUserName ?? "나모블")님 :)"
        // Do any additional setup after loading the view.
        
        /*
         [Walter] UserDefault 값을 객체로 만든다는 것은,
         */
        if let userInfo = savedUserProfile {
            let uName = userInfo["name"] as? String
            let uAge = userInfo["age"] as? Int
            let uGender = userInfo["gender"] as? String
            let uHeight = userInfo["height"] as? Float
            let uWeight = userInfo["weight"] as? Float
            
            //UserDefulat 의 값을 Profile 객체로 만드는 것
            let profile = Profile(name: uName, age: uAge, gender: uGender!, profileImg: "", height: uHeight, weight: uWeight)
            var myProfile = ProfileBrain()      //모든 뷰에 이 객체를 전달, 이용 또는 수정하는 것
            myProfile.myProfile = profile
            
            print(myProfile.myProfile)  //Profile의 모든 값을 출력
        }
    }
    
    @IBOutlet weak var quoteTextField: UITextField!
    @IBOutlet weak var userName: UILabel!
    let picker = UIPickerView() //피커뷰 생성
    let userQuote = Profile()
    
    @IBAction func toMain(_ sender: UIButton) {
            guard let NaviVC = self.storyboard?.instantiateViewController(withIdentifier: "naviVC") as? UINavigationController else { return }
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(NaviVC , animated: false)
    }
    
    /*
    extension InitialQuoteVC: UIPickerViewDelegate, UIPickerViewDataSource {
        // delegate, datasource 연결 및 picker를 textfied의 inputview로 설정한다
        func configPickerView() {
            picker.delegate = self
            picker.dataSource = self
            quoteTextField.inputView = picker
        }
        
        // pickerview는 하나만
        public func numberOfComponents(in pickerView: UIPickerView) -> Int
        {
            return 1
            
        }
        
        // pickerview의 선택지는 데이터의 개수만큼
        public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
        {
            return userQuote.quote.count
            
        }
        
        // pickerview 내 선택지의 값들을 원하는 데이터로 채워준다.
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
        {
            return userQuote.quote[row]
            
        }
        // textfield의 텍스트에 pickerview에서 선택한 값을 넣어준다.
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
        {
            self.quoteTextField.text = self.userQuote.quote[row]
            
        }
        
    }
*/
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
