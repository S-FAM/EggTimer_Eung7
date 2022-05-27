//
//  AppDelegate.swift
//  EggTimer_Eung7
//
//  Created by 김응철 on 2022/05/16.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var identifier: UIBackgroundTaskIdentifier?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
//        print("didEnterBackground")
//        identifier = UIApplication.shared.beginBackgroundTask(expirationHandler: { [weak self] in
//            guard let self = self else { return }
//            UIApplication.shared.endBackgroundTask(self.identifier!)
//        })
//        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(something), userInfo: nil, repeats: true)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner])
    }
}
