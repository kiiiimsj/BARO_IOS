//
//  AppDelegate.swift
//  Baro_user_ios
//
//  Created by 김성재 on 2020/10/17.
//

import UIKit
import SwiftyBootpay
import Firebase
import FirebaseMessaging
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UITabBar.appearance().tintColor = UIColor.baro_main_color
        Bootpay.sharedInstance.appLaunch(application_id: "5f28e2c002f57e0033305757") // production sample
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in})
        application.registerForRemoteNotifications()
        requestAuthorizationForRemotePushNotification()
        UserDefaults.standard.removeObject(forKey: "basket")
        CustomTimer.init()
        UIApplication.shared.isIdleTimerDisabled = true
        return true
    }

    // MARK: UISceneSession Lifecyclex
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
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        
    }
    func requestAuthorizationForRemotePushNotification() {
        let current = UNUserNotificationCenter.current()
        current.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
        }
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("\(#function)")
//        print(notification.request.content.userInfo)
//        Messaging.messaging().appDidReceiveMessage(notification.request.content.userInfo)
        completionHandler([.alert, .sound, .badge])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("device token : \(fcmToken)")
        UserDefaults.standard.set(fcmToken, forKey: "device_token")
        let dataDict: [String : String] = ["token" : fcmToken!]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("fir msg : \(userInfo)")
        completionHandler(UIBackgroundFetchResult.newData)
    }

}
