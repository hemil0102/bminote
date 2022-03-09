//
//  BmiResultVC.swift
//  bmi note
//
//  Created by Walter J on 2022/03/07.
//

import UIKit

class BmiResultVC: UIViewController {
    
    var tempData:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = tempData {
            print("받아온 데이터 \(data)")
        }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
