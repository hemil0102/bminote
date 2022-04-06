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
        let savedUserProfile = UserDefaults.standard.dictionary(forKey: Key.profile)
        //불러온 유저 정보에서 이름 값을 할당.
        let savedUserName = savedUserProfile?["name"] as? String
        //레이블에 저장된 유저 이름을 표시해준다.
        userName.text = "\(savedUserName ?? "나모블")님 :)"
        
        toMainOutlet.isUserInteractionEnabled = false
        toMainOutlet.alpha = 0.5
        
        configPickerView()
        configToolbar()
    }
    
    let picker = UIPickerView() //피커뷰 생성
    let userInfo = Profile()
    
    @IBOutlet weak var initialQuoteCheker: UIImageView!
    @IBOutlet weak var quoteTextField: UITextField!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var toMainOutlet: UIButton!
    
    @IBAction func toMain(_ sender: UIButton) {
        
        profileUserData["quote"] = quoteTextField.text
        profileUserData["isUserInput"] = true
        UserDefaults.standard.set(profileUserData, forKey: Key.profile)
        
            guard let NaviVC = self.storyboard?.instantiateViewController(withIdentifier: "naviVC") as? UINavigationController else { return }
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(NaviVC , animated: false)
    }
    
    func configToolbar() {
        // toolbar를 만들어준다.
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(named: "pickerViewColor")
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
        quoteTextField.inputAccessoryView = toolBar
    }
    
    // "완료" 클릭 시 데이터를 textfield에 입력 후 입력창 내리기
    @objc func donePicker() {
        let row = self.picker.selectedRow(inComponent: 0)
        self.picker.selectRow(row, inComponent: 0, animated: false)
        self.quoteTextField.text = self.userInfo.quoteList[row]
        self.quoteTextField.resignFirstResponder()
        initialQuoteCheker.image = UIImage(systemName: "checkmark.circle.fill")
        initialQuoteCheker.tintColor = UIColor(named: "NewGreen")
        toMainOutlet.isUserInteractionEnabled = true
        toMainOutlet.setTitleColor(.white, for: .normal)
        toMainOutlet.alpha = 1.0
    }
    
    // "취소" 클릭 시 textfield의 텍스트 값을 nil로 처리 후 입력창 내리기
    @objc func cancelPicker() {
        self.quoteTextField.text = nil
        self.quoteTextField.resignFirstResponder()
        initialQuoteCheker.image = UIImage(systemName: "checkmark.circle")
        initialQuoteCheker.tintColor = UIColor.systemGray
        toMainOutlet.isUserInteractionEnabled = false
        toMainOutlet.setTitleColor(.white, for: .normal)
        toMainOutlet.alpha = 0.5
    }
}

extension InitialQuoteVC: UIPickerViewDelegate, UIPickerViewDataSource {
    // delegate, datasource 연결 및 picker를 textfied의 inputview로 설정한다
    func configPickerView() {
        picker.delegate = self
        picker.dataSource = self
        quoteTextField.inputView = picker
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
        self.quoteTextField.text = self.userInfo.quoteList[row]
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
        pickerLabel?.textColor = UIColor(named: "pickerViewColor")

        return pickerLabel!
    }
}
