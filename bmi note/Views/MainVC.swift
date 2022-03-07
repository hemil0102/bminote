//
//  ViewController.swift
//  bmi note
//
//  Created by YEHROEI HO on 2022/03/02.
//

import UIKit
import Charts

class MainVC: UIViewController {

    //pickerView 변수(mock)
    @IBOutlet weak var inputPickerView: UIPickerView!
    
    var height: [Int] = [1, 2, 3, 4]
    var weight: [Int] = [5, 6, 7, 8]
    
    //그래프용 변수 (mock)
    @IBOutlet weak var barChartView: BarChartView!
    
    var months: [String]! = ["Jan", "Feb", "Mar", "Apr", "May"]
    var unitsSold: [Double]! = [30.0, 28.0, 23.5, 26.0, 19.0]
    
    //표준 BMI (mock)
    let BMIstd = BMIStandard()
    var BMIData = BMIBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //그래프 세팅
        initSetChart()
        setChart(dataPoints: BMIData.bmidateArray, values: BMIData.bmiValueArray)
  
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
    
    //그래프 데이터 없을때 세팅
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
        chartDataSet.colors = barColors(with: unitsSold)
        
        //데이터 삽입
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        
        chartDataSet.highlightEnabled = false
        barChartView.doubleTapToZoomEnabled = false
        
        //바 폭
        chartData.barWidth = Double(0.5)
        
        //차트 부가 기능
        setChartSubdetails()
        
        //차트 아래 아이콘 숨기는거 구현해야하는데... 무슨 옵션인지 모르겠어ㅠ

    }
    
    func setChartSubdetails() {
        
        let limitValue = BMIstd.BMIStdValue

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
          
        let limitValue = BMIstd.BMIStdValue
          
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
            return self.height.count
        case 1:
            return self.weight.count
        default:
            return 0
        }
    }
    
    //pickerview 내 선택지의 값들을 원하는 데이터로 채워주는 함수
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        switch component {
        case 0:
            return String(self.height[row])
        case 1:
            return String(self.weight[row])
        default:
            return nil
        }
    }
    
//    //피커뷰에서 선택한 값을 bmi 구조체로 세팅하는 과정.
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        switch component {
//        case 0:
//            self.bmiBrain.setHeight(row: row)
//        case 1:
//            self.bmiBrain.setWeight(row: row)
//        default:
//            break
//        }
//    }
}

