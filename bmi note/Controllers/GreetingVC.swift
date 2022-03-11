//
//  GreetingViewController.swift
//  bmi note
//
//  Created by YEHROEI HO on 2022/03/03.
//

import UIKit

class GreetingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func toInitProfile(_ sender: UIButton) {
        guard let initProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "initProfileVC") as? InitialProfileVC else { return }
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(initProfileVC , animated: false)
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
