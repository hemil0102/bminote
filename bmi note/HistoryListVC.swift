//
//  HistoryVC.swift
//  bmi note
//
//  Created by Walter J on 2022/03/02.
//

import UIKit

class HistoryListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         Todo
         1. UserDefault.standard 로 저장된 값 가져오기
         2. 데이터 가져와서 셋팅하기ㅡㅡ? 음 끝났는데...ㅋ
         3. 데이터 삭제
         4. 
         */

        self.tableView.dataSource = self
    }
    
    //이력 삭제
    func deleteHistory() {
        
    }
}

extension HistoryListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //List Count return하기
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryListCell") as? HistoryListCell else {
            return UITableViewCell()
        }
        
        //Cell 안의 View에 데이터 셋팅하기
        
        return cell
    }
}
