//
//  AppDelegate.swift
//  ImpressionKitExample
//
//  Created by Yanni Wang on 30/5/21.
//

import UIKit
import GDPerformanceView_Swift
import ImpressionKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UIView.detectionInterval = HomeViewController.detectionInterval
        UIView.durationThreshold = HomeViewController.durationThreshold
        UIView.areaRatioThreshold = HomeViewController.areaRatioThreshold
        UIView.redetectWhenLeavingScreen = HomeViewController.redetectWhenLeavingScreen
        UIView.redetectWhenViewControllerDidDisappear = HomeViewController.redetectWhenViewControllerDidDisappear
        UIView.redetectWhenReceiveSystemNotification = HomeViewController.redetectWhenReceiveSystemNotification
        
        PerformanceMonitor.shared().start()
        
        let navigationController = UINavigationController(rootViewController: HomeViewController())
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = true
        navigationController.view.backgroundColor = .clear
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
        
        return true
    }


}

