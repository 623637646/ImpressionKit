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
        UIView.alphaThreshold = HomeViewController.alphaThreshold
        UIView.redetectOptions = HomeViewController.redetectOptions
        ImpressionKitDebug.shared.openLogs()
        
        PerformanceMonitor.shared().start()
        
        let navigationController = UINavigationController(rootViewController: HomeViewController())
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
        
        return true
    }


}

