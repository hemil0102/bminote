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

    @IBOutlet weak var inputPickerView: UIPickerView!   //pickerView 변수
    @IBOutlet weak var barChartView: BarChartView!      //그래프용 변수
    
    @IBAction func pressedCalculateBMI(_ sender: UIButton) {
        bmiBrain.saveResult()
        //bmiBrain.saveResult2()
        
        performSegue(withIdentifier: "goBmiResultView", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //유저 디폴트 값 불러오기
        
        //그래프 세팅
        initSetChart()
        setChart(dataPoints: bmiBrain.bmiDateArray, values: bmiBrain.bmiValueArray) //현재 임시값
  
        //피커뷰 세팅
        configPickerView()
        
        //피커뷰 초기값 세팅
        setInitialValuePV()
        
        self.navigationController?.navigationBar.topItem?.title = "메인"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true) // 뷰 컨트롤러가 나타날 때 컨트롤 바를 숨기기
        
        initSetChart()
        setChart(dataPoints: bmiBrain.bmiDateArray, values: bmiBrain.bmiValueArray) //현재 임시값
        
    }

    override func viewWillDisappear(_ animated: Bool) {
      navigationController?.setNavigationBarHidden(false, animated: true) // 뷰 컨트롤러가 사라질 때 다음 화면에서 네비가 나오게 하기
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goBmiResultView" {
            guard let secondVC = segue.destination as? BmiResultVC else { return }
            
            secondVC.bmiInfo = bmiBrain.lastBmiData

        }
    }
}

extension MainVC: UIPickerViewDelegate, UIPickerViewDataSource { //피커뷰 익스텐션
    
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
            self.bmiBrain.setHeight(row: row)//row 가 값자체가 아니네...
        case 1:
            self.bmiBrain.setWeight(row: row)
        default:
            break
        }
    }
    
    func setInitialValuePV() {
        
        
        //피커뷰 초기값 세팅
        inputPickerView.selectRow(2, inComponent: 0, animated: false)
        inputPickerView.selectRow(2, inComponent: 1, animated: false) //초기값 세팅
        
        
    }
    
}


extension MainVC { //그래프 뷰 익스텐션
    
    //그래프 데이터 없을때 그래프 표시 세팅
    func initSetChart() {
        barChartView.noDataText = "BMI를 측정해 보세요!"
        barChartView.noDataFont = .systemFont(ofSize: 20)
        barChartView.noDataTextColor = .lightGray
        
        bmiBrain.setXaxisValues()
        bmiBrain.setYaxisValues()
    }

    
    //그래프 세팅
    func setChart(dataPoints: [String], values: [Double]) {
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
        
        barChartView.leftAxis.axisMaximum = 40.0
        barChartView.leftAxis.axisMinimum = 0.0
    }
    
    func setChartSubdetails() {
        
        let limitMinValue = bmiStd.BMIStdMinValue
        let limitMaxValue = bmiStd.BMIStdMaxValue

        //리미트라인
        let limit = ChartLimitLine(limit: limitMinValue, label: "")
        limit.lineColor = .blue //라인 색 변경
        barChartView.leftAxis.addLimitLine(limit)
        limit.lineWidth = 1.0
        
        let limit2 = ChartLimitLine(limit: limitMaxValue, label: "")
        limit2.lineColor = .green //라인 색 변경
        barChartView.leftAxis.addLimitLine(limit2)
        limit2.lineWidth = 1.0
        
        //좌측 축 사용안함
        barChartView.leftAxis.enabled = true
        barChartView.rightAxis.enabled = false
        barChartView.xAxis.enabled = false
        
        //축 라운드 처리
        
        //애니메이션
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        barChartView.layer.cornerRadius = 30.0
        
        //최근막대 위해 인디케이터....
        
        }
    
    //그래프 리미트 초과에 따른 색 배열 지정
    func barColors(with data: [Double]) -> [UIColor] {
      return data.map {
          
          let limitMinValue = bmiStd.BMIStdMinValue
          let limitMaxValue = bmiStd.BMIStdMaxValue
          
        if $0 > limitMaxValue {
          return .systemOrange
        } else if $0 < limitMinValue {
          return .systemBlue
        } else {
          return .systemGreen
        }
      }
    }
}
