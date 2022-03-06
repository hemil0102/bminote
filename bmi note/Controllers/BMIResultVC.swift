//
//  BMIResultVC.swift
//  bmi note
//
//  Created by Walter J on 2022/03/04.
//

import UIKit

class BMIResultVC: UIViewController {

    @IBOutlet weak var tIdx: UILabel!
    var receivedIdx:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         1. History의 마지막 인덱스 or 리스트의 인덱스를 받기
         2. 인덱스로 데이터 가져오기
         3. 데이터 뿌려주기
         4. 끝!
         */

        if let rIdx = receivedIdx {
            self.tIdx.text = "\(rIdx)"
        }
    }
}
