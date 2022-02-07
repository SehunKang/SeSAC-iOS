//
//  AppDelegate.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/01/17.
//

import UIKit
import Firebase
import UserNotifications
import Toast

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge,.sound,.alert], completionHandler: { (granted,error) in })
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                UserDefaultManager.signInData.fcMtoken = token
            }
        }
        idtokenRefresh()
        
        var style = ToastStyle()
        style.backgroundColor = CustomColor.SLPWhite.color
        style.messageColor = CustomColor.SLPBlack.color
        style.messageFont = CustomFont.Body3_R14.font
        style.cornerRadius = 8
        style.displayShadow = true
        style.shadowOpacity = 0.3
        style.shadowOffset = CGSize(width: 0, height: 4)
        ToastManager.shared.style = style
        ToastManager.shared.position = .center
        ToastManager.shared.duration = 1.2
        
        return true
    }
    
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

extension AppDelegate {
    
    func idtokenRefresh() {
//        let currentUser = Auth.auth().currentUser
//        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
//            if let error = error {
//                print(error.localizedDescription)
//                return;
//            }
//            UserDefaultManager.idtoken = idToken!
//        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
}
