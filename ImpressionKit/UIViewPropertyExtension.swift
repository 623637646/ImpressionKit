//
//  UIViewPropertyExtension.swift
//  ImpressionKit
//
//  Created by Yanni Wang on 30/5/21.
//

import UIKit
import EasySwiftHook

private var stateKey = 0
private var detectionIntervalKey = 0
private var durationThresholdKey = 0
private var areaRatioThresholdKey = 0
private var redetectWhenLeavingScreenKey = 0
private var redetectWhenViewControllerDidDisappearKey = 0
private var redetectWhenReceiveSystemNotificationKey = 0
private var hookingDidMoveToWindowTokenKey = 0
private var hookingViewDidDisappearTokenKey = 0
private var notificationTokensKey = 0
private var timerKey = 0

extension UIView {
           
    // MARK: - Main
    
    public enum State: Equatable {
        case unknown
        case impressed(atDate: Date, areaRatio: Float)
        case inScreen(fromDate: Date)
        case outOfScreen
        case noWindow
        case viewDidDisappear
        case receivedNotification(name: Notification.Name)
        
        public var isImpressed: Bool {
            if case .impressed = self {
                return true
            } else {
                return false
            }
        }
    }
    
    // Is triggered the impression event.
    public internal(set) var state: State {
        set {
            let old = self.state
            objc_setAssociatedObject(self, &stateKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            if old != newValue {
                guard let getCallback = self.getCallback() else {
                    assert(false)
                    return
                }
                getCallback(self, newValue)
            }
        }
        
        get {
            return (objc_getAssociatedObject(self, &stateKey) as? State ?? .unknown)
        }
    }
    
    // MARK: - Config
    
    // Change the detection (scan) interval (in seconds). Smaller detectionInterval means more accuracy and higher CPU consumption. Apply to all views
    public static var detectionInterval: Float = 0.2
    
    // Change the detection (scan) interval (in seconds). Smaller detectionInterval means more accuracy and higher CPU consumption. Apply to the specific view. `UIView.detectionInterval` will be used if it's nil.
    public var detectionInterval: Float? {
        set {
            objc_setAssociatedObject(self, &detectionIntervalKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &detectionIntervalKey) as? Float
        }
    }
    
    // Chage the threshold of duration in screen (in seconds). The view will be impressed if it keeps being in screen after this seconds. Apply to all views
    public static var durationThreshold: Float = 1
    
    // Chage the threshold of duration in screen (in seconds). The view will be impressed if it keeps being in screen after this seconds. Apply to the specific view. `UIView.durationThreshold` will be used if it's nil.
    public var durationThreshold: Float? {
        set {
            objc_setAssociatedObject(self, &durationThresholdKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &durationThresholdKey) as? Float
        }
    }
    
    // Chage the threshold of area ratio in screen. It's from 0 to 1. The view will be impressed if it's area ratio keeps being bigger than this value. Apply to all views
    public static var areaRatioThreshold: Float = 0.5
    
    // Chage the threshold of area ratio in screen. It's from 0 to 1. The view will be impressed if it's area ratio keeps being bigger than this value. Apply to the specific view. `UIView.areaRatioThreshold` will be used if it's nil.
    public var areaRatioThreshold: Float? {
        set {
            objc_setAssociatedObject(self, &areaRatioThresholdKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &areaRatioThresholdKey) as? Float
        }
    }
    
    // Retrigger the impression event when a view leaving from the screen (The UIViewController (page) is still here, Just the view is out of the screen). Apply to all views
    public static var redetectWhenLeavingScreen = false
    
    // Retrigger the impression event when a view leaving from the screen (The UIViewController (page) is still here, Just the view is out of the screen). Apply to the specific view. `UIView.redetectWhenLeavingScreen` will be used if it's nil.
    public var redetectWhenLeavingScreen: Bool? {
        set {
            objc_setAssociatedObject(self, &redetectWhenLeavingScreenKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &redetectWhenLeavingScreenKey) as? Bool
        }
    }
    
    // Retrigger the impression event when the UIViewController which the view in did disappear. Apply to all views
    public static var redetectWhenViewControllerDidDisappear = false
    
    // Retrigger the impression event when the UIViewController which the view in did disappear. Apply to the specific view. `UIView.redetectWhenViewControllerDidDisappear` will be used if it's nil.
    public var redetectWhenViewControllerDidDisappear: Bool? {
        set {
            objc_setAssociatedObject(self, &redetectWhenViewControllerDidDisappearKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &redetectWhenViewControllerDidDisappearKey) as? Bool
        }
    }
    
    /* Redetect when the notifications with the name in Set<Notification.Name> happen from NotificationCenter.default. This API is applied to all views.
     `UIView.redetectWhenReceiveSystemNotification.union(yourView.redetectWhenReceiveSystemNotification)` will be applied to the view finally.
     */
    public static var redetectWhenReceiveSystemNotification = Set<Notification.Name>()
    
    /* Redetect when the notifications with the name in Set<Notification.Name> happen from NotificationCenter.default. This API is applied the specific view.
     `UIView.redetectWhenReceiveSystemNotification.union(yourView.redetectWhenReceiveSystemNotification)` will be applied to the view finally.
     */
    public var redetectWhenReceiveSystemNotification: Set<Notification.Name> {
        set {
            objc_setAssociatedObject(self, &redetectWhenReceiveSystemNotificationKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &redetectWhenReceiveSystemNotificationKey) as? Set<Notification.Name> ?? []
        }
    }
    
    // MARK: - internal
    
    var hookingDidMoveToWindowToken: Token? {
        set {
            objc_setAssociatedObject(self, &hookingDidMoveToWindowTokenKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &hookingDidMoveToWindowTokenKey) as? Token
        }
    }
    
    var hookingViewDidDisappearToken: Token? {
        set {
            objc_setAssociatedObject(self, &hookingViewDidDisappearTokenKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &hookingViewDidDisappearTokenKey) as? Token
        }
    }
    
    var notificationTokens: [NSObjectProtocol] {
        set {
            objc_setAssociatedObject(self, &notificationTokensKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &notificationTokensKey) as? [NSObjectProtocol] ?? []
        }
    }
    
    var timer: Timer? {
        set {
            objc_setAssociatedObject(self, &timerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &timerKey) as? Timer
        }
    }
    
}
