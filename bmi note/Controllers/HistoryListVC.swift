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
        [26.5, "정상", 172.4, 62.1],
        [31.3, "과체중", 162.9, 99.6],
        [19.7, "저체중", 192.1, 45.2]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         Todo
         1. XIB 커스텀 셀 만들기 [✓]
         2. UserDefault.standard 로 저장된 값 가져오기 []
         3. 데이터 가져와서 셋팅하기 []
         4. 항목 선택시 뷰 이동 []
         5. 선택된 항목 데이터 전달 []
         6. 
         */
        
        //TableView에 XIB 커스텀 셀 연결
        setTableViewXIBCell()
        
        //tableView DataSource, Delegate protocol 준수
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func setTableViewXIBCell() {
        self.tableView.register(UINib(nibName: Constants.historyListCell, bundle: nil), forCellReuseIdentifier: Constants.historyListCellIdentifier)
    }
    
    //이력 삭제
    func deleteHistory() {
        /*
         1. BMI 데이터 삭제
         2. TableView Reload
         */
    }
}

//TableView Delegate
extension HistoryListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
        let row = indexPath.row
        
        cell.bmiValue.text = "\(mokListData[row][0])"       //BMI 수치
        cell.bmiState.text = "\(mokListData[row][1])"       //BMI 상태
        cell.height.text = "\(mokListData[row][2])cm"         //BMI 게산에 사용된 키
        cell.weight.text = "\(mokListData[row][3])kg"         //BMI 계산에 사용된 몸무게
        
        return cell
    }
}
