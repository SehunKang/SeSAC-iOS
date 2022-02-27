//
//  SceneDelegate.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/01/17.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        if UserDefaultManager.signInData.nick == "" {
            let sb = UIStoryboard(name: "Start", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: OnboardingViewController.identifier) as! OnboardingViewController
            window?.rootViewController = vc
        } else {
            let mainSb = UIStoryboard(name: "Main", bundle: nil)
            let mainVc = mainSb.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            let mainNav = UINavigationController(rootViewController: mainVc)

            let infoSb = UIStoryboard(name: "MyInfo", bundle: nil)
            let infoVc = infoSb.instantiateViewController(withIdentifier: MyInfoViewController.identifier) as! MyInfoViewController
            let infoNav = UINavigationController(rootViewController: infoVc)

            let shopSb = UIStoryboard(name: "Shop", bundle: nil)
            let shopVc = shopSb.instantiateViewController(withIdentifier: ShopViewController.identifier) as! ShopViewController
            let shopNav = UINavigationController(rootViewController: shopVc)

            let tabBarController = UITabBarController()

            tabBarController.viewControllers = [mainNav, shopNav ,infoNav]


            window?.rootViewController = tabBarController
        }

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
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

