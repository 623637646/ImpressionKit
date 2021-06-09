//
//  ImpressionKit.swift
//  ImpressionKit
//
//  Created by Yanni Wang on 30/5/21.
//

import UIKit
import EasySwiftHook

private var impressionCallbackKey = 0

public protocol ImpressionProtocol: UIView {}

extension UIView: ImpressionProtocol {}

public extension ImpressionProtocol {
    
    typealias ImpressionCallback<ViewType: UIView> = (_ view: ViewType, _ state: State) -> ()
    
    // The callback will be triggered when impression happens. nil value means cancellation of detection
    func detectImpression(_ block: ImpressionCallback<Self>?) {
        self.state = .unknown
        if let block = block {
            let value = { view, state in
                guard let view = view as? Self else {
                    return
                }
                block(view, state)
            } as ImpressionCallback<UIView>
            objc_setAssociatedObject(self, &impressionCallbackKey, value, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            self.hookDidMoveToWindowIfNeeded()
            self.addNotificationObserverIfNeeded()
            self.startTimerIfNeeded()
        } else {
            objc_setAssociatedObject(self, &impressionCallbackKey, nil, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            self.cancelHookingDidMoveToWindowIfNeeded()
            self.removeNotificationObserverIfNeeded()
            self.stopTimer()
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
        self.state = .unknown
        self.startTimerIfNeeded()
    }
    
    func isRedetectionOn(_ option: Redetect) -> Bool {
        let redetectOptions = self.redetectOptions ?? UIView.redetectOptions
        return redetectOptions.contains(option)
    }
    
    // MARK: - Hook DidMoveToWindow
    
    func hookDidMoveToWindowIfNeeded() {
        guard self.hookingDidMoveToWindowToken == nil else {
            return
        }
        self.hookingDidMoveToWindowToken = try? hookAfter(object: self, selector: #selector(UIView.didMoveToWindow), closure: { view, _ in
            if view.window != nil {
                if !view.state.isImpressed {
                    view.state = .unknown
                }
                view.rehookViewDidDisappearIfNeeded()
                view.startTimerIfNeeded()
            } else {
                if !view.state.isImpressed {
                    view.state = .noWindow
                }
                view.stopTimer()
            }
        } as @convention(block) (UIView, Selector) -> Void)
    }
    
    func cancelHookingDidMoveToWindowIfNeeded() {
        guard let token = self.hookingDidMoveToWindowToken else {
            return
        }
        token.cancelHook()
        self.hookingDidMoveToWindowToken = nil
    }
    
    // MARK: - Hook ViewDidDisappear
    
    private func rehookViewDidDisappearIfNeeded() {
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
            self.state = .viewControllerDidDisappear
        }
        self.hookingViewDidDisappearToken = hookingViewDidDisappearToken
    }
    
    private func cancelHookingViewDidDisappearIfNeeded() {
        guard let token = self.hookingViewDidDisappearToken else {
            return
        }
        token.cancelHook()
        self.hookingViewDidDisappearToken = nil
    }
    
    // MARK: - observe notifications
    
    func addNotificationObserverIfNeeded() {
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
            var token: NSObjectProtocol?
            token = NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil, using: {[weak self] notification in
                guard let self = self else {
                    if let token = token {
                        NotificationCenter.default.removeObserver(token)
                    }
                    return
                }
                if name == UIApplication.didEnterBackgroundNotification {
                    self.state = .didEnterBackground
                } else if name == UIApplication.willResignActiveNotification {
                    self.state = .willResignActive
                } else {
                    assert(false)
                    return
                }
                self.startTimerIfNeeded()
            })
            if let token = token {
                tokens.append(token)
            }
        }
        self.notificationTokens = tokens
    }
    
    func removeNotificationObserverIfNeeded() {
        self.notificationTokens.forEach { (token) in
            NotificationCenter.default.removeObserver(token)
        }
        self.notificationTokens.removeAll()
    }
    
    // MARK: - Algorithm
    
    private func areaRatio() -> Float {
        guard self.isHidden == false && self.alpha > 0 else {
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
                  window.isHidden == false && window.alpha > 0 else {
                return 0
            }
            // If super view hidden or alpha <= 0, self can't show
            var aView = self
            while let superView = aView.superview {
                guard superView.isHidden == false && superView.alpha > 0 else {
                    return 0
                }
                aView = superView
            }
            // Calculation
            let frameInWindow = self.convert(self.bounds, to: window)
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
        if self.state.isImpressed  {
            guard self.isRedetectionOn(.leftScreen) else {
                // has triggered impression and don't need to retrigger when leaving screen
                self.stopTimer()
                return
            }
        }
        
        if self.isRedetectionOn(.didEnterBackground) {
            guard UIApplication.shared.applicationState != .background else {
                self.state = .didEnterBackground
                return
            }
        }
        
        if self.isRedetectionOn(.willResignActive) {
            guard UIApplication.shared.applicationState != .inactive else {
                self.state = .willResignActive
                return
            }
        }
        
        let areaRatio = self.areaRatio()
        let areaRatioThreshold = self.areaRatioThreshold ?? UIView.areaRatioThreshold
        
        if case .inScreen(let fromDate) = self.state {
            if areaRatio >= areaRatioThreshold {
                // keep appearance
                let interval = Date().timeIntervalSince(fromDate)
                let durationThreshold = self.durationThreshold ?? UIView.durationThreshold
                if Float(interval) >= durationThreshold {
                    // trigger impression
                    self.state = .impressed(atDate: Date(), areaRatio: areaRatio)
                    
                    let redetectWhenLeavingScreen = self.isRedetectionOn(.leftScreen)
                    if !redetectWhenLeavingScreen {
                        self.stopTimer()
                    }
                }
            } else {
                // from appearance to disappearance
                self.state = .outOfScreen
            }
        } else if areaRatio >= areaRatioThreshold {
            // appearance
            if !self.state.isImpressed {
                self.state = .inScreen(fromDate: Date())
            }
        } else {
            // disappearance
            self.state = .outOfScreen
        }
    }
    
    // MARK: - timer
    
    func startTimerIfNeeded() {
        if self.state.isImpressed {
            guard self.isRedetectionOn(.leftScreen) else {
                return
            }
        }
        guard self.timer == nil,
              self.getCallback() != nil,
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
                Debug.shared.timerCount -= 1
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
        Debug.shared.timerCount += 1
        #endif
    }
    
    func stopTimer() {
        if let timer = self.timer {
            timer.invalidate()
            self.timer = nil
            #if DEBUG
            Debug.shared.timerCount -= 1
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
