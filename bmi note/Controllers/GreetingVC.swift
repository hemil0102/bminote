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
    }
    
    @IBAction func toInitProfile(_ sender: UIButton) {
        guard let initProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "initProfileVC") as? InitialProfileVC else { return }
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(initProfileVC , animated: false)
    }
}
