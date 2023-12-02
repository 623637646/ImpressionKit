//
//  ImpressionKit.swift
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

private var impressionCallbackKey = 0

public protocol ImpressionProtocol: UIView {}

extension UIView: ImpressionProtocol {}

public extension ImpressionProtocol {
    
    typealias ImpressionCallback<ViewType: UIView> = (_ view: ViewType, _ state: ImpressionState) -> ()
    
    // The callback will be triggered when impression happens. nil value means cancellation of detection
    func detectImpression(_ block: ImpressionCallback<Self>?) {
        assert(Thread.isMainThread);
        self.impressionState = .unknown
        if let block = block {
            // set
            let value = { view, state in
                guard let view = view as? Self else {
                    return
                }
                block(view, state)
            } as ImpressionCallback<UIView>
            objc_setAssociatedObject(self, &impressionCallbackKey, value, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            // hook & notification
            self.hookDeallocIfNeeded()
            self.hookDidMoveToWindowIfNeeded()
            self.rehookViewDidDisappearIfNeeded()
            self.readdNotificationObserver()
            // timer
            self.startTimerIfNeeded()
        } else {
            // timer
            self.stopTimer()
            // cancel hook & notification
            self.removeNotificationObserverIfNeeded()
            self.cancelHookingViewDidDisappearIfNeeded()
            self.cancelHookingDidMoveToWindowIfNeeded()
            self.cancelHookingDeallocIfNeeded()
            // set
            objc_setAssociatedObject(self, &impressionCallbackKey, nil, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    var isDetectionOn: Bool {
        return self.getCallback() != nil
    }
    
    internal func getCallback() -> ImpressionCallback<UIView>? {
        return objc_getAssociatedObject(self, &impressionCallbackKey) as? ImpressionCallback<UIView>
    }
}

extension UIView {
    
    // redetect impression for the UIView.
    public func redetect() {
        self.impressionState = .unknown
        self.startTimerIfNeeded()
    }
    
    func isRedetectionOn(_ option: Redetect) -> Bool {
        let redetectOptions = self.redetectOptions ?? UIView.redetectOptions
        return redetectOptions.contains(option)
    }
    
    func keepDetectionAfterImpressed() -> Bool {
        return self.isRedetectionOn(.leftScreen) || self.isRedetectionOn(.viewControllerDidDisappear)
    }
    
    // MARK: - Hook Dealloc
    
    fileprivate func hookDeallocIfNeeded() {
        guard self.hookingDeallocToken == nil else {
            return
        }
        self.hookingDeallocToken = try? hookDeallocBefore(object: self) { obj in
            obj.removeNotificationObserverIfNeeded()
        }
    }
    
    fileprivate func cancelHookingDeallocIfNeeded() {
        guard let token = self.hookingDeallocToken else {
            return
        }
        token.cancelHook()
        self.hookingDeallocToken = nil
    }
    
    // MARK: - Hook DidMoveToWindow
    
    fileprivate func hookDidMoveToWindowIfNeeded() {
        guard self.hookingDidMoveToWindowToken == nil else {
            return
        }
        self.hookingDidMoveToWindowToken = try? hookAfter(object: self, selector: #selector(UIView.didMoveToWindow), closure: { view, _ in
            if view.window != nil {
                if !view.impressionState.isImpressed {
                    view.impressionState = .unknown
                }
                view.rehookViewDidDisappearIfNeeded()
                view.startTimerIfNeeded()
            } else {
                if !view.impressionState.isImpressed {
                    view.impressionState = .noWindow
                }
                view.stopTimer()
            }
        } as @convention(block) (UIView, Selector) -> Void)
    }
    
    fileprivate func cancelHookingDidMoveToWindowIfNeeded() {
        guard let token = self.hookingDidMoveToWindowToken else {
            return
        }
        token.cancelHook()
        self.hookingDidMoveToWindowToken = nil
    }
    
    // MARK: - Hook ViewDidDisappear
    
    fileprivate func rehookViewDidDisappearIfNeeded() {
        self.cancelHookingViewDidDisappearIfNeeded()
        guard self.isRedetectionOn(.viewControllerDidDisappear) else {
            return
        }
        
        guard let vc = self.parentViewController else {
            return
        }
        
        var hookingViewDidDisappearToken: Token?
        hookingViewDidDisappearToken = try? hookAfter(object: vc, selector: #selector(UIViewController.viewDidDisappear(_:))) { [weak self] in
            guard let self = self,
                  self.isRedetectionOn(.viewControllerDidDisappear) else {
                hookingViewDidDisappearToken?.cancelHook()
                return
            }
            self.impressionState = .viewControllerDidDisappear
        }
        self.hookingViewDidDisappearToken = hookingViewDidDisappearToken
    }
    
    fileprivate func cancelHookingViewDidDisappearIfNeeded() {
        guard let token = self.hookingViewDidDisappearToken else {
            return
        }
        token.cancelHook()
        self.hookingViewDidDisappearToken = nil
    }
    
    // MARK: - observe notifications
    
    fileprivate func readdNotificationObserver() {
        self.removeNotificationObserverIfNeeded()
        var names = [Notification.Name]()
        if self.isRedetectionOn(.didEnterBackground) {
            names.append(UIApplication.didEnterBackgroundNotification)
        }
        if self.isRedetectionOn(.willResignActive) {
            names.append(UIApplication.willResignActiveNotification)
        }
        guard names.count > 0 else {
            return
        }
        var tokens = [NSObjectProtocol]()
        for name in names {
            let token = NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil, using: {[weak self] notification in
                guard let self = self else {
                    return
                }
                if notification.name == UIApplication.didEnterBackgroundNotification {
                    self.impressionState = .didEnterBackground
                } else if notification.name == UIApplication.willResignActiveNotification {
                    self.impressionState = .willResignActive
                } else {
                    assert(false)
                    return
                }
                self.startTimerIfNeeded()
            })
            tokens.append(token)
        }
        self.notificationTokens = tokens
    }
    
    fileprivate func removeNotificationObserverIfNeeded() {
        self.notificationTokens.forEach { (token) in
            NotificationCenter.default.removeObserver(token)
        }
        self.notificationTokens.removeAll()
    }
    
    // MARK: - Algorithm
    
    private func areaRatio() -> Float {
        let alphaThreshold = CGFloat(self.alphaThreshold ?? UIView.alphaThreshold)
        guard self.isHidden == false && self.alpha >= alphaThreshold else {
            return 0
        }
        if let window = self as? UIWindow,
           self.superview == nil {
            // It's a root window
            let intersection = self.frame.intersection( window.screen.bounds)
            let ratio = (intersection.width * intersection.height) / (self.frame.width * self.frame.height)
            return self.fixRatioPrecision(number: Float(ratio))
        } else {
            // It's normal view
            guard let window = self.window,
                  window.isHidden == false && window.alpha >= alphaThreshold else {
                return 0
            }
            // If super view hidden or alpha < alphaThreshold, self can't show
            var aView = self
            var frameInSuperView = self.bounds
            while let superView = aView.superview {
                guard superView.isHidden == false && superView.alpha >= alphaThreshold else {
                    return 0
                }
                frameInSuperView = aView.convert(frameInSuperView, to: superView)
                if aView.clipsToBounds {
                    frameInSuperView = frameInSuperView.intersection(aView.frame)
                }
                guard !frameInSuperView.isEmpty else {
                    return 0
                }
                aView = superView
            }
            let frameInWindow = frameInSuperView
            let frameInScreen = CGRect.init(x: frameInWindow.origin.x + window.frame.origin.x,
                                            y: frameInWindow.origin.y + window.frame.origin.y,
                                            width: frameInWindow.width,
                                            height: frameInWindow.height)
            let intersection = frameInScreen.intersection(window.screen.bounds)
            let ratio = (intersection.width * intersection.height) / (self.frame.width * self.frame.height)
            return self.fixRatioPrecision(number: Float(ratio))
        }
    }
    
    private static let ratioPrecisionOffset: Float = 0.0001
    private func fixRatioPrecision(number: Float) -> Float {
        // As long as the different ratios on screen is within 0.01% (0.0001), then we can consider two ratios as equal. It's sufficient for this case.
        guard number > UIView.ratioPrecisionOffset else {
            return 0
        }
        guard number < 1 - UIView.ratioPrecisionOffset else {
            return 1
        }
        return number
    }
    
    private func detect() {
        if self.impressionState.isImpressed  {
            guard self.keepDetectionAfterImpressed() else {
                // The impression has already been triggered. Don't need to retrigger.
                self.stopTimer()
                return
            }
        }
        
        // background
        if UIApplication.shared.applicationState == .background {
            guard !self.isRedetectionOn(.didEnterBackground) else {
                self.impressionState = .didEnterBackground
                return
            }
        }
        
        // inactive
        if UIApplication.shared.applicationState == .inactive {
            guard !self.isRedetectionOn(.willResignActive) else {
                self.impressionState = .willResignActive
                return
            }
        }
        
        // presented
        // If current view controller presented (non-full screen) a UIViewController, the viewDidDisappear of it will not be called. We need this logic to udpate the state.
        if let vc = self.parentViewController,
           vc.presentedViewController != nil {
            guard !self.isRedetectionOn(.viewControllerDidDisappear) else {
                self.impressionState = .viewControllerDidDisappear
                return
            }
            if !self.impressionState.isImpressed {
                self.impressionState = .viewControllerDidDisappear
            }
            return
        }
        
        // leftScreen
        if self.impressionState.isImpressed {
            guard self.isRedetectionOn(.leftScreen) else {
                return
            }
        }
        
        // calculate
        let areaRatio = self.areaRatio()
        let areaRatioThreshold = self.areaRatioThreshold ?? UIView.areaRatioThreshold
        
        if case .inScreen(let fromDate) = self.impressionState {
            if areaRatio >= areaRatioThreshold {
                // keep appearance
                let interval = Date().timeIntervalSince(fromDate)
                let durationThreshold = self.durationThreshold ?? UIView.durationThreshold
                if Float(interval) >= durationThreshold {
                    // trigger impression
                    self.impressionState = .impressed(atDate: Date(), areaRatio: areaRatio)
                    
                    if !self.keepDetectionAfterImpressed() {
                        self.stopTimer()
                    }
                }
            } else {
                // from appearance to disappearance
                self.impressionState = .outOfScreen
            }
        } else if areaRatio >= areaRatioThreshold {
            // appearance
            if !self.impressionState.isImpressed {
                self.impressionState = .inScreen(fromDate: Date())
            }
        } else {
            // disappearance
            self.impressionState = .outOfScreen
        }
    }
    
    // MARK: - timer
    
    fileprivate func startTimerIfNeeded() {
        if self.impressionState.isImpressed {
            guard self.keepDetectionAfterImpressed() else {
                return
            }
        }
        guard self.timer == nil,
              self.isDetectionOn,
              self.window != nil else {
            return
        }
        self.startTimer()
    }
        
    private func startTimer() {
        let timeInterval = TimeInterval(self.detectionInterval ?? UIView.detectionInterval)
        let timer = Timer.init(timeInterval: timeInterval, repeats: true, block: { [weak self] (timer) in
            // check self
            guard let self = self else {
                timer.invalidate()
                #if DEBUG
                ImpressionKitDebug.shared.timerCount -= 1
                #endif
                return
            }
            // check timer
            let currentTimeInterval = TimeInterval(self.detectionInterval ?? UIView.detectionInterval)
            guard currentTimeInterval.isEqual(to: timeInterval) else {
                self.stopTimer()
                self.startTimerIfNeeded()
                return
            }
            // detect
            self.detect()
        })
        self.timer = timer
        RunLoop.main.add(timer, forMode: .common)
        #if DEBUG
        ImpressionKitDebug.shared.timerCount += 1
        #endif
    }
    
    func stopTimer() {
        if let timer = self.timer {
            timer.invalidate()
            self.timer = nil
            #if DEBUG
            ImpressionKitDebug.shared.timerCount -= 1
            #endif
        }
    }
    
    // MARK: - others
    // https://stackoverflow.com/a/24590678/9315497
    private var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
}
