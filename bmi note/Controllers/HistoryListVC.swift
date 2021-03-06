//
//  HistoryVC.swift
//  bmi note
//
//  Created by Walter J on 2022/03/02.
//

import UIKit

class HistoryListVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var isThereRecordLabel: UILabel!
    
    let bmiStd = BMIStandard()
    
    //지역변수로 사용할 HistoryData
    var receivedData:[BMI]?          //MainVC에서 전달받는 bmi 배열
    var historyData:[BMI] = []       //receivedData를 옵셔널 처리한 bmi 배열
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableViewXIBCell()                   //TableView에 XIB 커스텀 셀 연결
        setHistoryDataFromPrivousScreen()       //historyData에 전달받은 객체 대입
        
        //tableView DataSource, Delegate protocol 준수
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //네비 타이틀 색 변경
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(named: "NewGreen") ?? UIColor.black]
    }
    
    //XIB Table View Cell 연결
    func setTableViewXIBCell() {
        self.tableView.register(UINib(nibName: Key.historyListCell, bundle: nil), forCellReuseIdentifier: Key.historyListCellIdentifier)
    }
    
    //전 화면에서 받아온 데이터를 로컬변수로 대입, 기록된 데이터가 없을 때 '기록이 없습니다' 출력
    func setHistoryDataFromPrivousScreen() {
        if let data = receivedData {
            historyData = data.reversed()
            isThereRecordLabel.isHidden = data.count == 0 ? false : true
        }
    }
}

//TableView Delegate
extension HistoryListVC: UITableViewDelegate {
    //항목 선택시 상세화면으로 이동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let bmiResultVC = self.storyboard?.instantiateViewController(withIdentifier: Key.bmiResultVC) as? BmiResultVC else {
            return
        }
        //indexPath.row 값 던져주기
        let row = indexPath.row
        let bmiInfo = historyData[row]
        bmiResultVC.bmiInfo = bmiInfo
        
        self.navigationController?.pushViewController(bmiResultVC, animated: true)
    }
}

//TableView DataSource
extension HistoryListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //List Count return하기
        return historyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Key.historyListCellIdentifier) as! HistoryListCell
        
        //Cell 안의 View에 데이터 셋팅하기
        let row = indexPath.row     //항목 Index
        
        cell.bmiValue.text = "\(historyData[row].bmi)"       //BMI 수치
        cell.bmiState.text = "\(historyData[row].bmiStatus)"       //BMI 상태
        cell.height.text = "\(historyData[row].heightForBMI)cm"         //BMI 게산에 사용된 키
        cell.weight.text = "\(historyData[row].weightForBMI)kg"         //BMI 계산에 사용된 몸무게
        cell.regDate.text = "\(historyData[row].regDate)"
        
        let limitMinValue = bmiStd.BMIStdMinValue
        let limitMaxValue = bmiStd.BMIStdMaxValue
        
      if historyData[row].bmi > limitMaxValue {
          cell.bmiValue.textColor = UIColor(red: 231/255, green: 150/255, blue: 107/255, alpha: 1.0)
      } else if historyData[row].bmi < limitMinValue {
          cell.bmiValue.textColor = UIColor(red: 117/255, green: 142/255, blue: 230/255, alpha: 1.0)
      } else {
          cell.bmiValue.textColor = UIColor(red: 120/255, green: 192/255, blue: 184/255, alpha: 1.0)
      }
        
        return cell
    }
}
