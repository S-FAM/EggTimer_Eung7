//
//  ContainerViewController.swift
//  EggTimer_Eung7
//
//  Created by 김응철 on 2022/05/25.
//

import UIKit

class ContainerViewController: UIViewController {
    enum MenuState {
        case opend
        case closed
    }
    private var menuState: MenuState = .closed
    
    let mainVC = MainViewController()
    let menuVC = MenuViewController()
    lazy var settingsVC = SettingsViewController()
    var navVC: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildVCs()
    }
    
    func addChildVCs() {
        // Menu
        menuVC.delegate = self
        addChild(menuVC)
        view.addSubview(menuVC.view)
        menuVC.didMove(toParent: self)
        
        // Main
        mainVC.delegate = self
        let navVC = UINavigationController(rootViewController: mainVC)
        addChild(navVC)
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        self.navVC = navVC
    }
}

extension ContainerViewController: MainViewControllerDelegate {
    func didTapMenuButton() {
        toggleMenu(completion: nil)
    }
    
    func toggleMenu(completion: (() -> Void)?) {
        switch menuState {
        case .closed:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.navVC?.view.frame.origin.x = self.mainVC.view.frame.size.width - 100
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .opend
                }
            }
        case .opend:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.navVC?.view.frame.origin.x = 0
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .closed
                    DispatchQueue.main.async {
                        completion?()
                    }
                }
            }
        }
    }
}

extension ContainerViewController: MenuViewControllerDelegate {
    func didSelect(menuItem: MenuViewController.MenuOptions) {
        toggleMenu(completion: nil)
        switch menuItem {
        case .home:
            resetToHome()
        case .info:
            break
        case .appRating:
            break
        case .shareApp:
            break
        case .settings:
            addSettings()
        }
    }
    
    func addSettings() {
        let vc = settingsVC
        mainVC.addChild(vc)
        mainVC.view.addSubview(vc.view)
        vc.view.frame = view.frame
        vc.didMove(toParent: mainVC)
        mainVC.title = vc.title
    }
    
    func resetToHome() {
        settingsVC.view.removeFromSuperview()
        settingsVC.didMove(toParent: nil)
        mainVC.title = "What do you up to?"
    }
}
