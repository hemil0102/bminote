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
    var bmiData = BMIBrain()

    //pickerView 변수
    @IBOutlet weak var inputPickerView: UIPickerView!
    
    //그래프용 변수
    @IBOutlet weak var barChartView: BarChartView!
    
    @IBAction func pressedCalculateBMI(_ sender: UIButton) {
        bmiData.setCalculatedBMI()
        bmiData.showResult()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //그래프 세팅
        initSetChart()
        setChart(dataPoints: bmiData.bmidateArray, values: bmiData.bmiValueArray)
  
        //피커뷰 세팅
        configPickerView()
        
        //임시...
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true) // 뷰 컨트롤러가 나타날 때 컨트롤 바를 숨기기
        
    }

    override func viewWillDisappear(_ animated: Bool) {
      navigationController?.setNavigationBarHidden(false, animated: true) // 뷰 컨트롤러가 사라질 때 다음 화면에서 네비가 나오게 하기
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
            return self.bmiData.bmiPickerRange.heightMinMaxArray.count
        case 1:
            return self.bmiData.bmiPickerRange.weightMinMaxArray.count
        default:
            return 0
        }
    }
    
    //pickerview 내 선택지의 값들을 원하는 데이터로 채워주는 함수
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        switch component {
        case 0:
            return String(self.bmiData.bmiPickerRange.heightMinMaxArray[row])
        case 1:
            return String(self.bmiData.bmiPickerRange.weightMinMaxArray[row])
        default:
            return nil
        }
    }
    
    //피커뷰 신장/키를 BMIBrain 으로 전달하는 함수
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            self.bmiData.setHeight(row: row)//row 가 값자체가 아니네...
        case 1:
            self.bmiData.setWeight(row: row)
        default:
            break
        }
    }
}


extension MainVC { //그래프 뷰 익스텐션
    
    //그래프 데이터 없을때 그래프 표시 세팅
    func initSetChart() {
        barChartView.noDataText = "no chart data"
        barChartView.noDataFont = .systemFont(ofSize: 20)
        barChartView.noDataTextColor = .lightGray
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
        chartDataSet.colors = barColors(with: bmiData.bmiValueArray)
        
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
    }
    
    func setChartSubdetails() {
        
        let limitValue = bmiStd.BMIStdValue

        //리미트라인
        let limit = ChartLimitLine(limit: limitValue, label: "standard")
        limit.lineColor = .blue //라인 색 변경
        barChartView.leftAxis.addLimitLine(limit)
        
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
          
        let limitValue = bmiStd.BMIStdValue
          
        if $0 > limitValue {
          return .systemRed
        } else if $0 < limitValue {
          return .systemBlue
        } else {
          return .systemGreen
        }
      }
    }
    
}
