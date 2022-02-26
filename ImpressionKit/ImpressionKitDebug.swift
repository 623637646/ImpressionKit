//
//  Debug.swift
//  ImpressionKit
//
//  Created by Yanni Wang on 31/5/21.
//

#if DEBUG
import UIKit
#if SWIFT_PACKAGE
import SwiftHook
#else
import EasySwiftHook
#endif

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
    }
    
}

#endif
