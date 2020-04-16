//
//  AppDelegate.swift
//  SHPExposureDemo
//
//  Created by Yanni Wang on 16/4/20.
//  Copyright © 2020 Yanni. All rights reserved.
//

import UIKit
import SHPExposure
import GDPerformanceView_Swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        SHPExposureConfig.sharedInstance().interval = 0.1
        PerformanceMonitor.shared().start()        
        
        let navigationController = UINavigationController(rootViewController: SHPDemoViewController())
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

