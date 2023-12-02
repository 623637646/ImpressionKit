//
//  UIViewPropertyExtension.swift
//  ImpressionKit
//
//  Created by Yanni Wang on 30/5/21.
//

import UIKit
#if SWIFT_PACKAGE
import SwiftHook
#else
import EasySwiftHook
#endif

private var stateKey = 0
private var detectionIntervalKey = 0
private var durationThresholdKey = 0
private var areaRatioThresholdKey = 0
private var alphaThresholdKey = 0
private var redetectOptionsKey = 0
private var hookingDeallocTokenKey = 0
private var hookingDidMoveToWindowTokenKey = 0
private var hookingViewDidDisappearTokenKey = 0
private var notificationTokensKey = 0
private var timerKey = 0

extension UIView {
           
    // MARK: - Main
    
    public enum ImpressionState: Equatable {
        case unknown
        case impressed(atDate: Date, areaRatio: Float)
        case inScreen(fromDate: Date)
        case outOfScreen
        case noWindow
        case viewControllerDidDisappear
        case didEnterBackground
        case willResignActive
        
        public var isImpressed: Bool {
            if case .impressed = self {
                return true
            } else {
                return false
            }
        }
    }
    
    // Is triggered the impression event.
    public internal(set) var impressionState: ImpressionState {
        set {
            let old = self.impressionState
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
            return (objc_getAssociatedObject(self, &stateKey) as? ImpressionState ?? .unknown)
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
    
    // Chage the threshold of area ratio in screen. It's from 0 to 1. The view will be impressed if it's area ratio remains equal to or greater than this value. Apply to all views
    public static var areaRatioThreshold: Float = 0.5
    
    // Chage the threshold of area ratio in screen. It's from 0 to 1. The view will be impressed if it's area ratio remains equal to or greater than this value. Apply to the specific view. `UIView.areaRatioThreshold` will be used if it's nil.
    public var areaRatioThreshold: Float? {
        set {
            objc_setAssociatedObject(self, &areaRatioThresholdKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &areaRatioThresholdKey) as? Float
        }
    }
    
    // Chage the threshold of alpha. It's from 0 to 1. The view will be impressed if it's alpha is equal to or greater than this value. Apply to all views
    public static var alphaThreshold: Float = 0.1
    
    // Chage the threshold of alpha. It's from 0 to 1. The view will be impressed if it's alpha is equal to or greater than this value. Apply to the specific view. `UIView.alphaThreshold` will be used if it's nil.
    public var alphaThreshold: Float? {
        set {
            objc_setAssociatedObject(self, &alphaThresholdKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &alphaThresholdKey) as? Float
        }
    }
    
    public struct Redetect: OptionSet {
        
        public let rawValue: Int
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        // Retrigger the impression event when a view left from the screen (The UIViewController (page) is still here, Just the view is out of the screen).
        public static let leftScreen = Redetect(rawValue: 1 << 0)
        
        // Retrigger the impression event when the UIViewController of the view disappear.
        public static let viewControllerDidDisappear = Redetect(rawValue: 1 << 1)
        
        // Retrigger the impression event when the App did enter background.
        public static let didEnterBackground = Redetect(rawValue: 1 << 2)
        
        // Retrigger the impression event when the App will resign active.
        public static let willResignActive = Redetect(rawValue: 1 << 3)
    }
    
    // Retrigger the impression. Apply to all views.
    public static var redetectOptions: Redetect = []
    
    // Retrigger the impression. Apply to the specific view. `UIView.redetectOptions` will be used if it's nil.
    public var redetectOptions: Redetect? {
        set {
            objc_setAssociatedObject(self, &redetectOptionsKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &redetectOptionsKey) as? Redetect
        }
    }
    
    // MARK: - internal
    
    var hookingDeallocToken: Token? {
        set {
            let closure = { return newValue }
            objc_setAssociatedObject(self, &hookingDeallocTokenKey, closure, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            guard let closure = objc_getAssociatedObject(self, &hookingDeallocTokenKey) as? () -> Token? else { return nil }
            return closure()
        }
    }
    
    var hookingDidMoveToWindowToken: Token? {
        set {
            let closure = { return newValue }
            objc_setAssociatedObject(self, &hookingDidMoveToWindowTokenKey, closure, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            guard let closure = objc_getAssociatedObject(self, &hookingDidMoveToWindowTokenKey) as? () -> Token? else { return nil }
            return closure()
        }
    }
    
    var hookingViewDidDisappearToken: Token? {
        set {
            let closure = { return newValue }
            objc_setAssociatedObject(self, &hookingViewDidDisappearTokenKey, closure, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            guard let closure = objc_getAssociatedObject(self, &hookingViewDidDisappearTokenKey) as? () -> Token? else { return nil }
            return closure()
        }
    }
    
    var notificationTokens: [NSObjectProtocol] {
        set {
            objc_setAssociatedObject(self, &notificationTokensKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
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
