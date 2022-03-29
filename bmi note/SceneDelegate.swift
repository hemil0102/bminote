//
//  SceneDelegate.swift
//  bmi note
//
//  Created by YEHROEI HO on 2022/03/02.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    
    var isLogged: Bool = false
    
    var window: UIWindow?

    func changeRootViewController (_ vc: UIViewController, animated: Bool) {
        guard let window = self.window else { return }
        window.rootViewController = vc // 전환
    }
    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //[Walter] 첫 실행에서는 UserDefault 값 자체가 없으므로,
        let userDidInput = UserDefaults.standard.dictionary(forKey: Key.profile)
        
        //[Walter] 이 구문이 실행되지 않음
        if let checkUserDidInput = userDidInput {
          
            let status = checkUserDidInput["isUserInput"] as? Bool      //UserDefault 값을 확인하는 것만으로도 입력된 것으로 생각한다면, 이런 플래그는 중복처리
          
            /*
             [Walter]결국 userDafaults 값을 가져와 보여줄 뷰를 결정하는데,
             isLogged 라는 변수가 필요할까요?
             */
            print(status)
            if status == true {
                /*
                 [Walter] 이 부분에 바로 아래 작업을 넣는다면?!
                 */
                isLogged = true
            } else {
                isLogged = false
            }
        }
        
        if isLogged == false {
            // [Walter] 이 부분을 위에 바로 넣는다면 isLogged 값이 필요없고, 코드 또한 훨씬 간결합니다.
            guard let greetingVC = storyboard.instantiateViewController(withIdentifier: "greetingVC") as? GreetingVC else { return }
            window?.rootViewController = greetingVC
        } else {
            guard let NaviVC = storyboard.instantiateViewController(withIdentifier: "naviVC") as? UINavigationController else { return }
            window?.rootViewController = NaviVC
        }
        
        //[Walter]
//        if let checkUserDidInput = userDidInput {
//            guard let NaviVC = storyboard.instantiateViewController(withIdentifier: "naviVC") as? UINavigationController else { return }
//            window?.rootViewController = NaviVC
//        } else {
//            //이 구문이 실행될 것,
//            //그래서 여기에 그리팅 뷰로 가는 로직을 넣어야 함
//            guard let greetingVC = storyboard.instantiateViewController(withIdentifier: "greetingVC") as? GreetingVC else { return }
//            window?.rootViewController = greetingVC
//        }

    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

