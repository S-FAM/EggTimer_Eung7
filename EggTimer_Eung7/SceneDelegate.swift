//
//  SceneDelegate.swift
//  EggTimer_Eung7
//
//  Created by 김응철 on 2022/05/16.
//

import UIKit

// TODO: [x] Timer가 백그라운드에서도 잘 작동되도록 하기.
protocol timeDelivery: AnyObject {
    func sceneWillEnterForeground(_ interval: Int, isvalid: Bool)
    func sceneDidEnterBackground()
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    weak var delegate: timeDelivery?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let mainVC = MainViewController()
        self.delegate = mainVC
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .systemBackground
        window?.rootViewController = UINavigationController(rootViewController: mainVC)
        window?.makeKeyAndVisible()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        UserDefaults.standard.setValue(Date(), forKey: "BackGround")
        delegate?.sceneDidEnterBackground()
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        guard let recentlyTime = UserDefaults.standard.object(forKey: "BackGround") as? Date else { return }
        let interval = Int(Date().timeIntervalSince(recentlyTime))
        let isvalid = UserDefaults.standard.bool(forKey: "IsValid")
        delegate?.sceneWillEnterForeground(interval, isvalid: isvalid)
    }
}
