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
private var hookingDidMoveToWindowTokenKey = 0
private var hookingViewDidDisappearTokenKey = 0
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
    
    // The detection (scan) interval in seconds.
    public static var detectionInterval: Float = 0.2
    
    // The detection (scan) interval in seconds. `UIView.detectionInterval` will be used if it's nil.
    public var detectionInterval: Float? {
        set {
            objc_setAssociatedObject(self, &detectionIntervalKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &detectionIntervalKey) as? Float
        }
    }
    
    // The threshold of duration in screen for all UIViews in seconds.
    public static var durationThreshold: Float = 1
    
    // The threshold of duration in screen for specified UIView in seconds. `UIView.durationThreshold` will be used if it's nil.
    public var durationThreshold: Float? {
        set {
            objc_setAssociatedObject(self, &durationThresholdKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &durationThresholdKey) as? Float
        }
    }
    
    // The threshold of area ratio in screen for all UIViews. from 0 to 1.
    public static var areaRatioThreshold: Float = 0.5
    
    // The threshold of area ratio in screen for specified UIView. from 0 to 1. `UIView.areaRatioThreshold` will be used if it's nil.
    public var areaRatioThreshold: Float? {
        set {
            objc_setAssociatedObject(self, &areaRatioThresholdKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &areaRatioThresholdKey) as? Float
        }
    }
    
    // Redetect when a view leaving screen.
    public static var redetectWhenLeavingScreen = false
    
    // Redetect when this view leaving screen. `UIView.redetectWhenLeavingScreen` will be used if it's nil.
    public var redetectWhenLeavingScreen: Bool? {
        set {
            objc_setAssociatedObject(self, &redetectWhenLeavingScreenKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &redetectWhenLeavingScreenKey) as? Bool
        }
    }
    
    // Redetect when the UIViewController the view in did disappear.
    public static var redetectWhenViewControllerDidDisappear = false
    
    // Redetect when the UIViewController the view in did disappear for specified view. `UIView.redetectWhenViewControllerDidDisappear` will be used if it's nil.
    public var redetectWhenViewControllerDidDisappear: Bool? {
        set {
            objc_setAssociatedObject(self, &redetectWhenViewControllerDidDisappearKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &redetectWhenViewControllerDidDisappearKey) as? Bool
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
    
    var timer: Timer? {
        set {
            objc_setAssociatedObject(self, &timerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &timerKey) as? Timer
        }
    }
    
}
