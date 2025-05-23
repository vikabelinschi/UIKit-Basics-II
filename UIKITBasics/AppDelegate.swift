//
//  AppDelegate.swift
//  UIKITBasics
//
//  Created by Victoria Belinschi   on 21.04.2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        
        let initialVC = MainViewController()
        
        window?.rootViewController = UINavigationController(rootViewController: initialVC)
        window?.makeKeyAndVisible()
        
        return true
    }
}
