//
//  ViewController.swift
//  bmi note
//
//  Created by YEHROEI HO on 2022/03/02.
//

import UIKit
import Charts

class MainVC: UIViewController {
    
    //표준 BMI
    let bmiStd = BMIStandard()
    var bmiBrain = BMIBrain()

    var mainProfileBrain = ProfileBrain() //모든 뷰에 이 객체를 전달, 최신 상태를 유지
    
    var height: Int = 0
    var weight: Int = 0
    
    @IBOutlet weak var inputPickerView: UIPickerView!   //pickerView 변수
    @IBOutlet weak var barChartView: BarChartView!      //그래프용 변수
    @IBOutlet weak var mainUserName: UILabel! //메인 화면 프로필 유저 이름
    @IBOutlet weak var mainUserQuote: UILabel! //메인 화면 프로필 유저 격언
    @IBOutlet weak var mainUserProfileImage: UIImageView! //메인 화면 프로필 유저 이미지
    @IBOutlet weak var mainUserProTips: UILabel! //메인화면 유저 프로필
    @IBOutlet weak var heightInPickerLabel: UILabel!
    @IBOutlet weak var weightInPickerLabel: UILabel!
    
    
    @IBOutlet weak var graphIndexSV1: UIStackView!
    @IBOutlet weak var graphTriangleImage: UIImageView!
    @IBOutlet weak var graphIndexSV2: UIStackView!
    
    @IBAction func pressedProfileEdit(_ sender: UIButton) {
        performSegue(withIdentifier: "goProfileEditView", sender: self)
 
    }
    
    @IBAction func pressedCalculateBMI(_ sender: UIButton) {
        bmiBrain.setCurrentBMI(height, weight)      //[Walter] 바로 setCurrentBMI를 호출해도 댐
        performSegue(withIdentifier: "goBmiResultView", sender: self)
    }

    @IBAction func pressedHistoryList(_ sender: UIButton) {
        performSegue(withIdentifier: "goHistoryListView", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //그래프 세팅
        initSetChart()
        setChart(dataPoints: bmiBrain.bmiDateArray, values: bmiBrain.bmiValueArray)
  
        //피커뷰 세팅
        configPickerView()
        
        //네비게이션 조정
        self.navigationController?.navigationBar.topItem?.title = "메인"
        self.navigationController?.navigationBar.tintColor = UIColor(named: "NewYellow")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true) // 뷰 컨트롤러가 나타날 때 컨트롤 바를 숨기기
        
        heightInPickerLabel.text = "신장(cm)"
        weightInPickerLabel.text = "체중(kg)"
        
        initSetChart()  //[Walter] 이건 무슨 함수? //
        setChart(dataPoints: bmiBrain.bmiDateArray, values: bmiBrain.bmiValueArray)
        
        //유저데이터 불러오기 - 프로필 정보
        let savedUserProfile = UserDefaults.standard.dictionary(forKey: Key.profile)
        
        if let userInfo = savedUserProfile {
            let uName = userInfo["name"] as? String
            let uAge = userInfo["age"] as? Int
            let uGender = userInfo["gender"] as? String
            let uHeight = userInfo["height"] as? Float
            let uWeight = userInfo["weight"] as? Float
            let uQuote = userInfo["quote"] as? String
            let uProfileImg = userInfo["profileImg"] as? String
            let mainProfile = Profile(name: uName, age: uAge, gender: uGender!, profileImg: uProfileImg!, height: uHeight, weight: uWeight, quote: uQuote)
            mainProfileBrain.myProfile = mainProfile
            print("\(String(describing: mainProfileBrain.myProfile))")
        }
        
        mainUserName.text = mainProfileBrain.myProfile?.name //메인화면 유저 이름 출력
        mainUserQuote.text = "\(" ")" + "\(mainProfileBrain.myProfile?.quote ?? "나는 할 수 있다")" //메인화면 유저 격언 출력
        mainUserProfileImage.image = UIImage(named: mainProfileBrain.myProfile!.profileImg)
        
        //메인화면 유저 프로필 출력
        mainUserProTips.text = "\"Pro Tip\"" + " \(mainProfileBrain.getProTips())"
        
        //피커뷰 초기값 세팅
        setInitialValuePV()
    }

    override func viewWillDisappear(_ animated: Bool) {
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        // 뷰 컨트롤러가 사라질 때 다음 화면에서 네비가 나오게 하기
        
        bmiBrain.saveResultToUserDefaults()
        // 유저 데이터 저장하기
        profileUserData = [ "name" : (mainProfileBrain.myProfile?.name)!,
                            "age" : (mainProfileBrain.myProfile?.age)!,
                            "gender" : (mainProfileBrain.myProfile?.gender)!,
                            "height" : height,
                            "weight" : weight,
                            "profileImg" : mainProfileBrain.myProfile!.profileImg,
                            "quote" : (mainProfileBrain.myProfile?.quote)!,
                            "isUserInput" : true ]
        
        print(profileUserData)
        
        UserDefaults.standard.set(profileUserData, forKey: Key.profile)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goProfileEditView" {
            guard let secondVC = segue.destination as? MainProfileVC else { return }
            secondVC.editingDataProfileBrain = mainProfileBrain
            secondVC.originDataProfileBrain = mainProfileBrain
        }
        
        if segue.identifier == "goBmiResultView" {
            guard let secondVC = segue.destination as? BmiResultVC else { return }

            if let data = bmiBrain.bmiDatas?.last {
                secondVC.bmiInfo = data
            } else {
                print("data transfer failed")
            }
        }
        
        if segue.identifier == "goHistoryListView" {
            guard let secondVC = segue.destination as? HistoryListVC else { return }
            secondVC.receivedData = bmiBrain.bmiDatas   //[Walter] 그냥 배열을 넘기는 방식으로 처리
        }
    }
}

//MARK: - 피커뷰 익스텐션
extension MainVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func configPickerView() {
        inputPickerView.delegate = self
        inputPickerView.dataSource = self
    }
    
    //picker view 컬럼 수
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    //pickerview 의 선택지는 데이터의 개수만큼 세팅
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return self.bmiBrain.bmiPickerRange.heightMinMaxArray.count
        case 1:
            return self.bmiBrain.bmiPickerRange.weightMinMaxArray.count
        default:
            return 0
        }
    }
    
    //pickerview 내 선택지의 값들을 원하는 데이터로 채워주는 함수
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        switch component {
        case 0:
            return String(self.bmiBrain.bmiPickerRange.heightMinMaxArray[row])
        case 1:
            return String(self.bmiBrain.bmiPickerRange.weightMinMaxArray[row])
        default:
            return nil
        }
    }
    
    //피커뷰 신장/키를 BMIBrain 으로 전달하는 함수
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch component {
        case 0:
            self.height = bmiBrain.bmiPickerRange.heightMinMaxArray[row]
            self.heightInPickerLabel.text = "신장(\(self.height)cm)"
        case 1:
            self.weight = bmiBrain.bmiPickerRange.weightMinMaxArray[row]
            self.weightInPickerLabel.text = "체중(\(self.weight)kg)"
        default:
            break
        }
    }
    
    func setInitialValuePV() {
        
        //[Harry] 피커 뷰 값은 유저 데이터에 기반하여 최신 유저 데이터 값을 갖고 오도록 구현
        height = Int(mainProfileBrain.myProfile?.height ?? -1.0)
        weight = Int(mainProfileBrain.myProfile?.weight ?? -1.0)
        
        //bmiBrain.setCurrentBMI(Int(height), Int(weight))
        
        let heightIndex = bmiBrain.getArrayIndex(arr: bmiBrain.bmiPickerRange.heightMinMaxArray, value: Int(height)) ?? 0
        let weightIndex = bmiBrain.getArrayIndex(arr: bmiBrain.bmiPickerRange.weightMinMaxArray, value: Int(weight)) ?? 0
        
        inputPickerView.selectRow(heightIndex, inComponent: 0, animated: false)
        inputPickerView.selectRow(weightIndex, inComponent: 1, animated: false) //초기값 세팅
        
        /*
        if let data = bmiBrain.bmiDatas {
            
            if (data.count == 0) {
                
                height = Int(mainProfileBrain.myProfile?.height ?? -1.0)
                weight = Int(mainProfileBrain.myProfile?.weight ?? -1.0)
                
                //bmiBrain.setCurrentBMI(Int(height), Int(weight))
                
                let heightIndex = bmiBrain.getArrayIndex(arr: bmiBrain.bmiPickerRange.heightMinMaxArray, value: Int(height)) ?? 0
                let weightIndex = bmiBrain.getArrayIndex(arr: bmiBrain.bmiPickerRange.weightMinMaxArray, value: Int(weight)) ?? 0
                
                inputPickerView.selectRow(heightIndex, inComponent: 0, animated: false)
                inputPickerView.selectRow(weightIndex, inComponent: 1, animated: false) //초기값 세팅
                
            } else {
                
                /* [Harry]
                height = Int(bmiBrain.bmiDatas?.last?.heightForBMI ?? -1.0)
                weight = Int(bmiBrain.bmiDatas?.last?.weightForBMI ?? -1.0)
                */
                
                height = Int(mainProfileBrain.myProfile?.height ?? -1.0)
                weight = Int(mainProfileBrain.myProfile?.weight ?? -1.0)
                //bmiBrain.setCurrentBMI(Int(height), Int(weight))
                let heightIndex = bmiBrain.getArrayIndex(arr: bmiBrain.bmiPickerRange.heightMinMaxArray, value: Int(height)) ?? 0
                let weightIndex = bmiBrain.getArrayIndex(arr: bmiBrain.bmiPickerRange.weightMinMaxArray, value: Int(weight)) ?? 0
                
                inputPickerView.selectRow(heightIndex, inComponent: 0, animated: false)
                inputPickerView.selectRow(weightIndex, inComponent: 1, animated: false) //초기값 세팅
            }
        } else {
            print("bmiDatas nil")
        }
      } */
    }
}

//MARK: - 그래프 뷰 익스텐션
extension MainVC {
    
    //그래프 데이터 없을때 그래프 표시 세팅
    func initSetChart() {
        barChartView.noDataText = "BMI를 측정해 보세요!"
        barChartView.noDataFont = .systemFont(ofSize: 20)
        barChartView.noDataTextColor = .lightGray
        
        bmiBrain.setAxisValues()
    }

    
    //그래프 세팅
    func setChart(dataPoints: [String], values: [Double]) {
        
        if (values.count == 0) {
            graphIndexTurnOnOff(on: false)
            return
        }
        graphIndexTurnOnOff(on: true)
        
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        } //x, y 데이터 세팅
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Quantity")
        
        //차트컬러
        //chartDataSet.colors = [.systemGreen, .systemRed, .systemCyan]
        //chartDataSet.colors = [.systemGreen]
        chartDataSet.colors = barColors(with: bmiBrain.bmiValueArray)
        
        //데이터 삽입
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        
        chartDataSet.highlightEnabled = false
        barChartView.doubleTapToZoomEnabled = false
        
        //바 폭
        chartData.barWidth = Double(0.5)
        
        //차트 부가 기능
        setChartSubdetails()
        
        //차트 x축 아래 라벨 숨기는 옵션
        barChartView.legend.enabled = false
        
        //y축 최대/최소
        barChartView.leftAxis.axisMaximum = 55.0
        barChartView.leftAxis.axisMinimum = 0.0
        
    }
    
    func setChartSubdetails() {
        
        let limitMinValue = bmiStd.BMIStdMinValue
        let limitMaxValue = bmiStd.BMIStdMaxValue

        //리미트라인
        let limit = ChartLimitLine(limit: limitMinValue, label: "")
        limit.lineColor = UIColor(red: 120/255, green: 192/255, blue: 184/255, alpha: 1.0) //라인 색 변경
        barChartView.leftAxis.addLimitLine(limit)
        limit.lineWidth = 1.0
        
        let limit2 = ChartLimitLine(limit: limitMaxValue, label: "")
        limit2.lineColor = UIColor(red: 120/255, green: 192/255, blue: 184/255, alpha: 1.0) //라인 색 변경
        barChartView.leftAxis.addLimitLine(limit2)
        limit2.lineWidth = 1.0
        
        //좌측 축 사용안함
        barChartView.leftAxis.enabled = true
        barChartView.leftAxis.drawLabelsEnabled = false
        
        //x축
        barChartView.rightAxis.enabled = false
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.drawLabelsEnabled = false
        
        
        //격자 제거
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        
        //축 삭제
        

        //애니메이션
        barChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
        
        }
    
    //그래프 리미트 초과에 따른 그래프별 색 배열 지정
    func barColors(with data: [Double]) -> [UIColor] {
        let limitMinValue = bmiStd.BMIStdMinValue
        let limitMaxValue = bmiStd.BMIStdMaxValue
        
        let alphaValue = 0.3
        
        var colorData: [UIColor] = []
        
        //이전값 전부 컬러 알파값 적용
        for i in 0 ..< data.count {
            if data[i] > limitMaxValue {
                //[Harry] 모벨 로고 오렌지
                colorData.append(UIColor(red: 231/255, green: 150/255, blue: 107/255, alpha: alphaValue))
                //colorData.append(UIColor(red: 255/255, green: 149/255, blue: 0, alpha: alphaValue))
            } else if data[i] < limitMinValue {
                //[Harry] 모벨 로고 에메랄드
                colorData.append(UIColor(red: 117/255, green: 142/255, blue: 230/255, alpha: alphaValue))
                //colorData.append(UIColor(red: 0, green: 122/255, blue: 255/255, alpha: alphaValue))
            } else {
                //[Harry] 모벨 로고 라일락
                colorData.append(UIColor(red: 120/255, green: 192/255, blue: 184/255, alpha: alphaValue))
                //colorData.append(UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: alphaValue))
            }
        }
        
        //최신값 알파값 미적용
        if (data.count > 0) {
            colorData.removeLast()
            
            if let value = data.last {
                if value > limitMaxValue {
                    colorData.append(UIColor(red: 231/255, green: 150/255, blue: 107/255, alpha: 1.0))
                    //colorData.append(UIColor(red: 255/255, green: 149/255, blue: 0, alpha: 1.0))
                } else if value < limitMinValue {
                    colorData.append(UIColor(red: 117/255, green: 142/255, blue: 230/255, alpha: 1.0))
                    //colorData.append(UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1.0))
                } else {
                    colorData.append(UIColor(red: 120/255, green: 192/255, blue: 184/255, alpha: 1.0))
                    //colorData.append(UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0))
                }
            }
        }
        return colorData
    }
    
    func graphIndexTurnOnOff(on: Bool) {
        if (on == true) {
            graphIndexSV1.isHidden = false
            graphIndexSV2.isHidden = false
            graphTriangleImage.isHidden = false
        } else {
            graphIndexSV1.isHidden = true
            graphIndexSV2.isHidden = true
            graphTriangleImage.isHidden = true
        }
    }
}
