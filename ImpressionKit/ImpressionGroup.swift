//
//  ImpressionGroup.swift
//  ImpressionKit
//
//  Created by Yanni Wang on 2/6/21.
//

import UIKit

public class ImpressionGroup<IndexType: Hashable> {
    
    // MARK: - config
    // Change the detection (scan) interval (in seconds). Smaller detectionInterval means more accuracy and higher CPU consumption. Apply to the group. `UIView.detectionInterval` will be used if it's nil.
    public var detectionInterval: Float?
    
    // Chage the threshold of duration in screen (in seconds). The view will be impressed if it keeps being in screen after this seconds. Apply to the group. `UIView.durationThreshold` will be used if it's nil.
    public var durationThreshold: Float?
    
    // Chage the threshold of area ratio in screen. It's from 0 to 1. The view will be impressed if it's area ratio remains equal to or greater than this value. Apply to the group. `UIView.areaRatioThreshold` will be used if it's nil.
    public var areaRatioThreshold: Float?
    
    // Chage the threshold of alpha. It's from 0 to 1. The view will be impressed if it's alpha is equal to or greater than this value. Apply to the group. `UIView.alphaThreshold` will be used if it's nil.
    public var alphaThreshold: Float?
        
    // Retrigger the impression. Apply to the group. `UIView.redetectOptions` will be used if it's nil.
    public var redetectOptions: UIView.Redetect? {
        didSet {
            readdNotificationObserver()
        }
    }
    
    // MARK: - public
    public typealias ImpressionGroupCallback = (_ group: ImpressionGroup, _ index: IndexType, _ view: UIView, _ state: UIView.ImpressionState) -> ()
    
    public private(set) var states = [IndexType: UIView.ImpressionState]()
    
    // MARK: - private
    private var views = [IndexType: () -> UIView?]()
        
    private var notificationTokens = [NSObjectProtocol]()
    
    private let impressionGroupCallback: ImpressionGroupCallback
    
    private lazy var impressionBlock: (_ view: UIView, _ state: UIView.ImpressionState) -> () = { [weak self] (view, state) in
        guard let self = self,
              let index = self.views.first(where: { $1() == view })?.key else {
            return
        }
        if let previousSates = self.states[index] {
            guard previousSates != state else {
                return
            }
        }
        
        // Redetection of didEnterBackground & willResignActive are handled by group
        
        // redetect viewControllerDidDisappear
        if view.isRedetectionOn(.viewControllerDidDisappear),
           case .viewControllerDidDisappear = state {
            self.resetGroupStateAndRedetect(.viewControllerDidDisappear)
            return
        }
        
        // redetect leftScreen
        if let previousSates = self.states[index],
           previousSates.isImpressed {
            guard view.isRedetectionOn(.leftScreen) else {
                return
            }
        }
        
        self.changeState(index: index, view: view, state: state)
    }
    
    public init(detectionInterval: Float? = nil,
         durationThreshold: Float? = nil,
         areaRatioThreshold: Float? = nil,
         alphaThreshold: Float? = nil,
         redetectOptions: UIView.Redetect? = nil,
         impressionGroupCallback: @escaping ImpressionGroupCallback) {
        self.detectionInterval = detectionInterval
        self.durationThreshold = durationThreshold
        self.areaRatioThreshold = areaRatioThreshold
        self.alphaThreshold = alphaThreshold
        self.redetectOptions = redetectOptions
        self.impressionGroupCallback = impressionGroupCallback
        readdNotificationObserver()
    }
    
    /**
     This method must be called every time in
     1. UICollectionView: `func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell`
     2. or UITableView: `func cellForRow(at indexPath: IndexPath) -> UITableViewCell?`
     3. or your customized methods.
     Non-calling may cause abnormal impression.
     if a index doesn't need to be impressed.  pass `ignoreDetection = true` to ignore this index.
     */
    public func bind(view: UIView, index: IndexType, ignoreDetection: Bool = false) {
        if let previousIndex = views.first(where: { $1() == view })?.key {
            views[previousIndex] = nil
        }
        
        if let previousView = views[index]?() {
            previousView.detectImpression(nil)
        }
        
        guard ignoreDetection == false else {
            view.detectImpression(nil) // Cancel the detection if the view is detecting.
            self.changeState(index: index, view: view, state: .unknown)
            return
        }
        
        views[index] = { [weak view] in view }
        
        // setup views
        view.detectionInterval = self.detectionInterval
        view.durationThreshold = self.durationThreshold
        view.areaRatioThreshold = self.areaRatioThreshold
        view.alphaThreshold = self.alphaThreshold
        // No need to set .willResignActive and .didEnterBackground for views. Group will handle this.
        var redetectOptions = self.redetectOptions
        redetectOptions?.remove(.willResignActive)
        redetectOptions?.remove(.didEnterBackground)
        view.redetectOptions = redetectOptions
        
        guard let currentState = self.states[index],
              currentState.isImpressed else {
            self.changeState(index: index, view: view, state: .unknown)
            view.detectImpression(impressionBlock)
            return
        }
        
        // The view is impressed.
        guard view.keepDetectionAfterImpressed() else {
            view.detectImpression(nil)
            return
        }
        
        if view.isRedetectionOn(.leftScreen) {
            self.changeState(index: index, view: view, state: .unknown)
        }
        view.detectImpression(impressionBlock)
    }
    
    public func redetect() {
        resetGroupStateAndRedetect(.unknown)
    }
    
    private func resetGroupStateAndRedetect(_ state: UIView.ImpressionState) {
        self.views.forEach { (index, closure) in
            guard let view = closure() else {
                self.views.removeValue(forKey: index)
                return
            }
            self.changeState(index: index, view: view, state: state)
            view.detectImpression(impressionBlock)
            view.redetect()
        }
        self.states = self.states.mapValues { _ in state }
    }
    
    private func changeState(index: IndexType, view: UIView, state: UIView.ImpressionState) {
        if let previousState = self.states[index] {
            guard previousState != state else {
                return
            }
        }
        self.states[index] = state
        self.impressionGroupCallback(self, index, view, state)
    }
    
    private func readdNotificationObserver() {
        self.notificationTokens.forEach { (token) in
            NotificationCenter.default.removeObserver(token)
        }
        self.notificationTokens.removeAll()
        let redetectOptions = self.redetectOptions ?? UIView.redetectOptions
        if redetectOptions.contains(.willResignActive) {
            let token = NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: nil) { [weak self] _ in
                guard let self = self else {
                    return
                }
                self.resetGroupStateAndRedetect(.willResignActive)
            }
            self.notificationTokens.append(token)
        }
        if redetectOptions.contains(.didEnterBackground) {
            let token = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { [weak self] _ in
                guard let self = self else {
                    return
                }
                self.resetGroupStateAndRedetect(.didEnterBackground)
            }
            self.notificationTokens.append(token)
        }
    }
}
