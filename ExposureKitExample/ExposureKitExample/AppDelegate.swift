//
//  AppDelegate.swift
//  ExposureKitExample
//
//  Created by Yanni Wang on 21/4/21.
//

import UIKit
import EasyExposureKit
import GDPerformanceView_Swift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        ExposureKitConfig.sharedInstance().interval = 0.1
        PerformanceMonitor.shared().start()        
        
        let navigationController = UINavigationController(rootViewController: EKDemoViewController())
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

