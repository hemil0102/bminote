//
//  HistoryVC.swift
//  bmi note
//
//  Created by Walter J on 2022/03/02.
//

import UIKit

class HistoryListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    //목 데이터
    let mokListData = [
        [26.5, "정상", 172.4, 62.1], [31.3, "과체중", 162.9, 99.6], [19.7, "저체중", 192.1, 45.2]
    ]
    
    //지역변수로 사용할 HistoryData
    var receivedData:BMIBrain?          //???
    var historyData:BMIBrain?           //???
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         Todo
         1. XIB 커스텀 셀 만들기 [✓]
         2. 데이터 받아와서 셋팅하기 [✓]
         3. 항목 선택시 뷰 이동 [✓]
         4. 선택된 항목 데이터 전달 [✓]
         */
        
        setTableViewXIBCell()                   //TableView에 XIB 커스텀 셀 연결
        setHistoryDataFromPrivousScreen()       //historyData에 전달받은 객체 대입
        
        //NavigationController 뒤로가기 한글로, MainVC 에서 바꿀 것
//        self.navigationController?.navigationBar.topItem?.title = "메인"
        
        //tableView DataSource, Delegate protocol 준수
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func setTableViewXIBCell() {
        self.tableView.register(UINib(nibName: Constants.historyListCell, bundle: nil), forCellReuseIdentifier: Constants.historyListCellIdentifier)
    }
    
    //전 화면에서 받아온 데이터를 로컬변수로 대입
    func setHistoryDataFromPrivousScreen() {
        if let data = receivedData {
            historyData = data
        }
    }
    
    //이력 삭제
    func deleteHistory() {
        /*
         1. BMI 데이터 삭제 []
         2. UserDefault 업데이트 []
         2. TableView Reload [✓]
         */

//        self.tableView.reloadData()
    }
}

//TableView Delegate
extension HistoryListVC: UITableViewDelegate {
    
    //항목 선택시 상세화면으로 이동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let bmiResultVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.bmiResultVC) as? BMIResultVC else {
            return
        }
        //indexPath.row 값 던져주기
        bmiResultVC.receivedIdx = indexPath.row
        self.navigationController?.pushViewController(bmiResultVC, animated: true)
    }
}

//TableView DataSource
extension HistoryListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //List Count return하기
        return mokListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.historyListCellIdentifier) as! HistoryListCell
        
        //Cell 안의 View에 데이터 셋팅하기
        let row = indexPath.row     //항목 Index
        
        //historyData에서 값 꺼내기 []
        //bim값에 따른 배경색 변경 []
        
        cell.bmiValue.text = "\(mokListData[row][0])"       //BMI 수치
        cell.bmiState.text = "\(mokListData[row][1])"       //BMI 상태
        cell.height.text = "\(mokListData[row][2])cm"         //BMI 게산에 사용된 키
        cell.weight.text = "\(mokListData[row][3])kg"         //BMI 계산에 사용된 몸무게
        
        return cell
    }
}
