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
 4. 취소 버튼 클릭 시 유저 정보 복원 및 텍스트 필드 비활성화 [ 완료 ]
 5. 텍스트 필드에 유저 데이터 불러오기 [ 완료 ]
 6. 유효성 검사 추가 [ 완료 ]
 7. 피커뷰 구현 [ 완료 ]
 8. 성별 메뉴 구현 [   ]
 8. 저장 버튼 클릭 시 메인에 반영 필요, 피커뷰와 메인 프로필 [   ]
 
 ** 왜 버튼 폰트는 시뮬레이션에서 작아지지?
 
*/
class MainProfileVC: UIViewController, UITextFieldDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainUserInputName.text = editProfileBrain.myProfile?.name
        mainUserInputAge.text = "\((editProfileBrain.myProfile?.age)!)"
        
        if editProfileBrain.myProfile?.gender == "여" {
            mainUserSelectGender.selectedSegmentIndex = 0
        } else {
            mainUserSelectGender.selectedSegmentIndex = 1
        }
        
        mainUserInputHeight.text = "\(Int((editProfileBrain.myProfile?.height)!))"
        mainUserInputWeight.text = "\(Int((editProfileBrain.myProfile?.weight)!))"
        mainUserInputQuote.text = "\((editProfileBrain.myProfile?.quote)!)"
        mainProfileimg.image = UIImage(named: editProfileBrain.myProfile!.profileImg)
        
        //실시간 유저 입력에 대한 유효성 검사를 위한 addTarget
        mainUserInputName.addTarget(self, action: #selector(nameTextFieldDidChange), for: .editingChanged) //for와 at이 갖는 의미 그리고 .으로 시작하는 것들에 의미는 뭔가?
        mainUserInputAge.addTarget(self, action: #selector(ageTextFieldDidChange), for: .editingChanged)
        mainUserInputHeight.addTarget(self, action: #selector(heightTextFieldDidChange), for: .editingChanged)
        mainUserInputWeight.addTarget(self, action: #selector(weightTextFieldDidChange), for: .editingChanged)
        
        disableTextField()
        buttonDecision()
        
        //제스처가 실행될 떄 키보드를 내릴 수 있도록
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
        
        mainConfigPickerView()
        mainConfigToolbar()
        
        //키보드 화면 가림 방지 구현
        mainUserInputName.delegate = self
        mainUserInputAge.delegate = self
        mainUserInputHeight.delegate = self
        mainUserInputWeight.delegate = self
        mainUserInputName.returnKeyType = .done
        mainUserInputAge.returnKeyType = .done
        mainUserInputHeight.returnKeyType = .done
        mainUserInputWeight.returnKeyType = .done
        
        
        //키보드가 나탈 떄
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
        
    }
    
    var editProfileBrain = ProfileBrain()
    var photoBrain = ProfileBrain()
    var mainCorrectName = true
    var mainCorrectAge = true
    var mainCorrectHeight = true
    var mainCorrectWeight = true
    var mainCorrectQuote = true
    let picker = UIPickerView() //피커뷰 생성
    let userInfo = Profile() // 피커뷰 격언 리스트 생성을 위한
    
    @IBOutlet weak var mainProfileScrollView: UIScrollView!
    
    @IBOutlet weak var mainUserInputName: UITextField!
    @IBOutlet weak var mainCheckNameRegEx: UILabel!
    @IBOutlet weak var mainNameChecker: UIImageView!
    
    @IBOutlet weak var mainUserInputAge: UITextField!
    @IBOutlet weak var mainCheckAgeRegEx: UILabel!
    @IBOutlet weak var mainAgeChecker: UIImageView!
    
    @IBOutlet weak var mainUserInputHeight: UITextField!
    @IBOutlet weak var mainCheckHeightRegEx: UILabel!
    @IBOutlet weak var mainHeightChecker: UIImageView!
    
    @IBOutlet weak var mainUserInputWeight: UITextField!
    @IBOutlet weak var mainCheckWeightRegEx: UILabel!
    @IBOutlet weak var mainWeightChecker: UIImageView!
    
    
    @IBOutlet weak var mainUserInputQuote: UITextField!
    @IBOutlet weak var mainQuoteChecker: UIImageView!
    
    @IBOutlet weak var mainUserSelectGender: UISegmentedControl!
    @IBOutlet weak var mainProfileimg: UIImageView!
    
    @IBOutlet weak var mainEditUserProfileLabel: UIButton!
    @IBOutlet weak var mainSaveUserProfileLabel: UIButton!
    
    @IBAction func mainUserSelectGender(_ sender: UISegmentedControl) {
        // Segment Index에 따라서 남여를 지정, 굳이 함수화 할 필요는 없지만 관리차원으로 getGenderType() 함수를 Brain에 형성, 값이 없을 수 없어서 force unwrap 함.
            let gender = mainUserSelectGender.titleForSegment(at: sender.selectedSegmentIndex)! //선택된 세그먼트 인덱스의 타이틀
            editProfileBrain.myProfile?.gender = photoBrain.getGenderType(selectedIndexTitle: gender) //선택된 세그먼트의 성별 정보를 userInfo에 저장
            editProfileBrain.myProfile?.profileImg = photoBrain.getGenderImage(selectedIndex: sender.selectedSegmentIndex) //선택된 성별에 따라 남, 녀 미모지를 선택
            mainProfileimg.image = UIImage(named: editProfileBrain.myProfile!.profileImg) //이미지 뷰에 선택된 성별 이미지를 보여줌
    }
    
    @IBAction func mainEditUserProfile(_ sender: UIButton) {
        

        if mainEditUserProfileLabel.currentTitle! == "수정"
        {
            enableTextField()
            mainEditUserProfileLabel.setTitle("취소", for: .normal)
            
        } else if mainEditUserProfileLabel.currentTitle == "취소"
        {
            
            disableTextField()
            mainEditUserProfileLabel.setTitle("수정", for: .normal)
            
        }
    }
    
    
    
    @IBOutlet weak var saveEditedDateOutlet: UIButton!
    @IBAction func saveEditedData(_ sender: UIButton) {
    }
    
    
    func disableTextField() {
        mainUserInputName.isUserInteractionEnabled = false
        mainUserInputAge.isUserInteractionEnabled = false
        mainUserSelectGender.isUserInteractionEnabled = false
        mainUserInputHeight.isUserInteractionEnabled = false
        mainUserInputWeight.isUserInteractionEnabled = false
        mainUserInputQuote.isUserInteractionEnabled = false
    }
    
    func enableTextField() {
        mainUserInputName.isUserInteractionEnabled = true
        mainUserInputAge.isUserInteractionEnabled = true
        mainUserSelectGender.isUserInteractionEnabled = true
        mainUserInputHeight.isUserInteractionEnabled = true
        mainUserInputWeight.isUserInteractionEnabled = true
        mainUserInputQuote.isUserInteractionEnabled = true
    }
    
    @objc func endEditing() {
        mainUserInputName.resignFirstResponder()
        mainUserInputAge.resignFirstResponder()
        mainUserInputHeight.resignFirstResponder()
        mainUserInputWeight.resignFirstResponder()
    }
    
    var isExpand : Bool = false

    @objc func keyboardWillShow(notification: NSNotification) {
        if !isExpand {
            self.mainProfileScrollView.contentSize = CGSize(width: self.view.frame.width, height: self.mainProfileScrollView.frame.height + 250 )
        }
        isExpand = true
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if isExpand {
            self.mainProfileScrollView.contentSize = CGSize(width: self.view.frame.width, height: self.mainProfileScrollView.frame.height - 250 )
            self.isExpand = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
         return true
     }
    
    // 피커뷰 구현 파트
    func mainConfigToolbar() {
        // toolbar를 만들어준다.
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        // 만들어줄 버튼
        // flexibleSpace는 취소~완료 간의 거리를 만들어준다.
        let doneBT = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.donePicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBT = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.cancelPicker))
        // 만든 아이템들을 세팅해주고
        toolBar.setItems([cancelBT,flexibleSpace,doneBT], animated: false)
        toolBar.isUserInteractionEnabled = true
        // 악세사리로 추가한다.
        mainUserInputQuote.inputAccessoryView = toolBar
        
    } // "완료" 클릭 시 데이터를 textfield에 입력 후 입력창 내리기
        @objc func donePicker() {
            let row = self.picker.selectedRow(inComponent: 0)
            self.picker.selectRow(row, inComponent: 0, animated: false)
            self.mainUserInputQuote.text = self.userInfo.quoteList[row]
            self.mainUserInputQuote.resignFirstResponder()
            mainQuoteChecker.image = UIImage(systemName: "checkmark.circle.fill")
            mainQuoteChecker.tintColor = UIColor.systemGreen
            mainCorrectQuote = true
            buttonDecision()
            
    }
    // "취소" 클릭 시 textfield의 텍스트 값을 nil로 처리 후 입력창 내리기
        @objc func cancelPicker() {
            self.mainUserInputQuote.text = nil
            self.mainUserInputQuote.resignFirstResponder()
            mainQuoteChecker.image = UIImage(systemName: "")
            mainCorrectQuote = false
            buttonDecision()
            
    }
    
    // 개인 신상 정보 입력 유효성 검사
    @objc func nameTextFieldDidChange(_ textField: UITextField) {
        
        if mainUserInputName.text != "" {
            let nameRe = "[가-힣A-Za-z]{1,12}" //모든 완성형 한글과 대소문자 알파벳만 입력으로 받는다. 문자는 1자리에서 12자리까지 입력 가능.
            let tempName = NSPredicate(format:"SELF MATCHES %@", nameRe) //지정된 정규식에 해당하는 입력이 들어왔는지 체크하는 부분.
            if tempName.evaluate(with: mainUserInputName.text) {
                mainCorrectName = true
                editProfileBrain.myProfile?.name = mainUserInputName.text
                print((editProfileBrain.myProfile?.name)!)
                mainNameChecker.image = UIImage(systemName: "checkmark.circle.fill")
                mainNameChecker.tintColor = UIColor.systemGreen
                mainCheckNameRegEx.text = " "
            } else {
                mainCorrectName = false
                mainNameChecker.image = UIImage(systemName: "checkmark.circle")
                mainNameChecker.tintColor = UIColor.systemGray
                mainCheckNameRegEx.text = "한글 및 영문만 입력 가능합니다.(12자 내)"
                

            }
        } else {
            mainCorrectName = false
            mainNameChecker.image = UIImage(systemName: "checkmark.circle")
            mainNameChecker.tintColor = UIColor.systemGray
            mainCheckNameRegEx.text = "닉네임을 입력해주세요.(12자 내)"
        }
        buttonDecision()
    }
    
    @objc func ageTextFieldDidChange(_ textField: UITextField) {

        if mainUserInputAge.text != "" {
            let ageRe = "(19|20)[0-9]{2}" //앞자리는 19또는 20이란 조건을 주고 뒷 자리는 2자리의 모든 숫자를 조건으로 지정.
            let tempAge = NSPredicate(format:"SELF MATCHES %@", ageRe)
            if tempAge.evaluate(with: mainUserInputAge.text) {
                mainCorrectAge = true
                editProfileBrain.myProfile?.age = Int(mainUserInputAge.text!)! //입력이 있고 숫자가 있으므로 force unwrap
                print((editProfileBrain.myProfile?.age)!)
                mainAgeChecker.image = UIImage(systemName: "checkmark.circle.fill")
                mainAgeChecker.tintColor = UIColor.systemGreen
                mainCheckAgeRegEx.text = " "
            } else {
                mainCorrectAge = false
                mainAgeChecker.image = UIImage(systemName: "checkmark.circle")
                mainAgeChecker.tintColor = UIColor.systemGray
                mainCheckAgeRegEx.text = "1900~2099 범위 내 입력 바랍니다."

            }
        } else {
            mainCorrectAge = false
            mainAgeChecker.image = UIImage(systemName: "checkmark.circle")
            mainAgeChecker.tintColor = UIColor.systemGray
            mainCheckAgeRegEx.text = "출생연도를 입력해주세요."
        }
        buttonDecision()
    }
    
    @objc func heightTextFieldDidChange(_ textField: UITextField) {
        if mainUserInputHeight.text != "" {
            let heightRe = "[0-9]{2,3}" // 2~3자리의 숫자를 입력 받는다. 💡숫자 앞자리에 대한 범위를 더 지정할 필요가 있어보임.
            let tempHeight = NSPredicate(format:"SELF MATCHES %@", heightRe)
            if tempHeight.evaluate(with: mainUserInputHeight.text) {
                mainCorrectHeight = true
                editProfileBrain.myProfile?.height = Float(mainUserInputHeight.text!)! //입력이 있고 숫자가 있으므로 force unwrap
                print((editProfileBrain.myProfile?.height)!)
                mainHeightChecker.image = UIImage(systemName: "checkmark.circle.fill")
                mainHeightChecker.tintColor = UIColor.systemGreen
                mainCheckHeightRegEx.text = " "
            } else {
                mainCorrectHeight = false
                mainHeightChecker.image = UIImage(systemName: "checkmark.circle")
                mainHeightChecker.tintColor = UIColor.systemGray
                mainCheckHeightRegEx.text = "소숫점 제외, 숫자 2~3자리를 입력해주세요."

            }
        } else {
            mainCorrectHeight = false
            mainHeightChecker.image = UIImage(systemName: "checkmark.circle")
            mainHeightChecker.tintColor = UIColor.systemGray
            mainCheckHeightRegEx.text = "신장을 입력해주세요."
        }
        buttonDecision()
    }
    
    @objc func weightTextFieldDidChange(_ textField: UITextField) {
        
        if mainUserInputWeight.text != "" {
            let weightRe = "[0-9]{2,3}" // 1~3자리의 숫자를 입력 받는다.
            let tempWeight = NSPredicate(format:"SELF MATCHES %@", weightRe)
            if tempWeight.evaluate(with: mainUserInputWeight.text) {
                mainCorrectWeight = true
                editProfileBrain.myProfile?.weight = Float(mainUserInputWeight.text!)! //입력이 있고 숫자가 있으므로 force unwrap
                print((editProfileBrain.myProfile?.weight)!)
                mainWeightChecker.image = UIImage(systemName: "checkmark.circle.fill")
                mainWeightChecker.tintColor = UIColor.systemGreen
                mainCheckWeightRegEx.text = " "
            } else {
                mainCorrectWeight = false
                mainWeightChecker.image = UIImage(systemName: "checkmark.circle")
                mainWeightChecker.tintColor = UIColor.systemGray
                mainCheckWeightRegEx.text = "소숫점 제외, 숫자 2~3자리를 입력해주세요."

            }
        } else {
            mainCorrectWeight = false
            mainWeightChecker.image = UIImage(systemName: "checkmark.circle")
            mainWeightChecker.tintColor = UIColor.systemGray
            mainCheckWeightRegEx.text = "몸무게를 입력해주세요."
        }
        buttonDecision()
    }
    
    func buttonDecision() {
        if mainCorrectName && mainCorrectAge && mainCorrectHeight && mainCorrectWeight && mainCorrectQuote {
            saveEditedDateOutlet.isEnabled = true
        } else {
            saveEditedDateOutlet.isEnabled = false
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


extension MainProfileVC: UIPickerViewDelegate, UIPickerViewDataSource {
    // delegate, datasource 연결 및 picker를 textfied의 inputview로 설정한다
    func mainConfigPickerView() {
        picker.delegate = self
        picker.dataSource = self
        mainUserInputQuote.inputView = picker
    }
    
    // pickerview는 하나만
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // pickerview의 선택지는 데이터의 개수만큼
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userInfo.quoteList.count
    }
    
    // pickerview 내 선택지의 값들을 원하는 데이터로 채워준다.
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return userInfo.quoteList[row]
    }
    
    // textfield의 텍스트에 pickerview에서 선택한 값을 넣어준다.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.mainUserInputQuote.text = self.userInfo.quoteList[row]
    }
    
    //피커뷰 리스트 텍스트 사이즈 및 폰트 설정
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "System", size: 25)
            pickerLabel?.textAlignment = .center
        }
        
        pickerLabel?.text = userInfo.quoteList[row]
        pickerLabel?.textColor = UIColor.black

        return pickerLabel!
    }
    
}
