//
//  Debug.swift
//  ImpressionKit
//
//  Created by Yanni Wang on 31/5/21.
//

#if DEBUG
import Foundation
import EasySwiftHook

public class ImpressionKitDebug {
    
    public static let shared = ImpressionKitDebug()
        
    internal var timerCount: UInt = 0
    internal var loggedTimerCount: UInt?
    
    private var viewControllerCount: UInt = 0
    private var loggedViewControllerCount: UInt?
    
    private var viewCount: UInt = 0
    private var loggedViewCount: UInt?
        
    private init() {}
    private static let dispatchOnce: () = {
        ImpressionKitDebug.shared.hook()
        ImpressionKitDebug.shared.timer()
    }()
    
    public func openLogs() {
        _ = ImpressionKitDebug.dispatchOnce
    }
    
    private func timer() {
        let timer = Timer.init(timeInterval: 0.1, repeats: true, block: { (_) in
            let timerCount = ImpressionKitDebug.shared.timerCount
            if let loggedTimerCount = ImpressionKitDebug.shared.loggedTimerCount,
               loggedTimerCount == timerCount {} else {
                   print("[ImpressionKit] Timer: \(timerCount)")
                   ImpressionKitDebug.shared.loggedTimerCount = timerCount
            }
            
            let viewControllerCount = ImpressionKitDebug.shared.viewControllerCount
            if let loggedViewControllerCount = ImpressionKitDebug.shared.loggedViewControllerCount,
               loggedViewControllerCount == viewControllerCount {} else {
                   print("[ImpressionKit] UIViewController: \(viewControllerCount)")
                   ImpressionKitDebug.shared.loggedViewControllerCount = viewControllerCount
            }
            
            let viewCount = ImpressionKitDebug.shared.viewCount
            if let loggedViewCount = ImpressionKitDebug.shared.loggedViewCount,
               loggedViewCount == viewCount {} else {
                   print("[ImpressionKit] UIView: \(viewCount)")
                   ImpressionKitDebug.shared.loggedViewCount = viewCount
            }
        })
        RunLoop.main.add(timer, forMode: .common)
    }
    
    private func hook() {
        try! hookAfter(targetClass: UIResponder.self, selector:  #selector(UIResponder.init)) { object, selector in
            if object is UIViewController {
                ImpressionKitDebug.shared.viewControllerCount += 1
            } else if object is UIView {
                ImpressionKitDebug.shared.viewCount += 1
            }
        }
        
        try! hookDeallocBefore(targetClass: UIResponder.self) { object in
            if object is UIViewController {
                ImpressionKitDebug.shared.viewControllerCount -= 1
            } else if object is UIView {
                ImpressionKitDebug.shared.viewCount -= 1
            }
        }
        
        try! hookAfter(targetClass: UIViewController.self, selector:  #selector(UIViewController.viewWillAppear(_:))) { object, selector in
            guard object == ImpressionKitDebug.shared.currentShowingViewController() else {
                return
            }
            print("[ImpressionKit] Page =======> \(type(of: object))")
        }
        
//        try! hookBefore(targetClass: UIViewController.self, selector:  #selector(UIViewController.viewWillDisappear(_:))) { object, selector in
//            print("?")
//        }
//        
//        try! hookAfter(targetClass: UIViewController.self, selector:  #selector(UIViewController.viewWillDisappear(_:))) { object, selector in
//            print("?")
//        }
//        
//        try! hookBefore(targetClass: UIViewController.self, selector:  #selector(UIViewController.viewDidDisappear(_:))) { object, selector in
//            print("?")
//        }
//        
//        try! hookAfter(targetClass: UIViewController.self, selector:  #selector(UIViewController.viewDidDisappear(_:))) { object, selector in
//            print("?")
//        }
    }
    
    private func currentShowingViewController() -> UIViewController? {
        var vc = UIApplication.shared.keyWindow?.rootViewController
        while true {
            if let presented = vc?.presentedViewController { // TODO: 当present一个vc时，然后返回，不会再触发 [ImpressionKit] Page =======>
                vc = presented
                continue
            }
            if let tab = vc as? UITabBarController {
                vc = tab.selectedViewController
                continue
            }
            if let nav = vc as? UINavigationController {
                vc = nav.topViewController
                continue
            }
            break
        }
        return vc
    }
    
}

#endif
