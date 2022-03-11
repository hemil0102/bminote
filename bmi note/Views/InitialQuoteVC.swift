//
//  InitialQuoteVC.swift
//  bmi note
//
//  Created by YEHROEI HO on 2022/03/04.
//

import UIKit

class InitialQuoteVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func toMain(_ sender: UIButton) {
            guard let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "mainVC") as? MainVC else { return }
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainVC , animated: false)
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
