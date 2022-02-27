//
//  SceneDelegate.swift
//  SeSAC_Week14
//
//  Created by Sehun Kang on 2021/12/27.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        //로그인에 따른 분기처리 필요
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let id = UserDefaults.standard.string(forKey: "nickname")
        
        var rv: UIViewController = SignInViewController()
        
        //여기서 id, password로 http POST를 보내 로그인하게 하고싶은데 password를 어떻게 처리해야할지 몰라 임시방편으로 아래 코드를 사용
        if id != nil {
            rv = MainViewController()
        }
        
        window = UIWindow(windowScene: windowScene)
        
        let rootViewController = UINavigationController(rootViewController: rv)
        
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()

        
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
    }


}

