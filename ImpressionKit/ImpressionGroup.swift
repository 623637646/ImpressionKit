//
//  ImpressionGroup.swift
//  ImpressionKit
//
//  Created by Yanni Wang on 2/6/21.
//

import UIKit

public class ImpressionGroup {
    
    // MARK: - config
    // The detection (scan) interval in seconds.  `UIView.detectionInterval` will be used if it's nil.
    public var detectionInterval: Float?
    
    // The detection (scan) interval in seconds. `UIView.durationThreshold` will be used if it's nil.
    public var durationThreshold: Float?
    
    // The threshold of area ratio in screen for specified UIView. from 0 to 1. `UIView.areaRatioThreshold` will be used if it's nil.
    public var areaRatioThreshold: Float?
        
    // Redetect when this view leaving screen. `UIView.redetectWhenLeavingScreen` will be used if it's nil.
    public var redetectWhenLeavingScreen: Bool?
    
    // Redetect when the UIViewController the view in did disappear for specified view. `UIView.redetectWhenViewControllerDidDisappear` will be used if it's nil.
    public var redetectWhenViewControllerDidDisappear: Bool?
    
    // MARK: - public
    // TODO: 泛型?
    public typealias ImpressionClosure = (_ group: ImpressionGroup, _ index: IndexPath, _ view: UIView?, _ state: UIView.State) -> ()
    
    public private(set) var states = [IndexPath: UIView.State]()
    
    // MARK: - private
    private let allViews = NSHashTable<UIView>.weakObjects()
    
    private let impressionClosure: ImpressionClosure
    
    
    public init(impressionClosure: @escaping ImpressionClosure) {
        self.impressionClosure = impressionClosure
    }
    
    public func bind(view: UIView, index: IndexPath) {
        if !allViews.contains(view) {
            allViews.add(view)
        }
        
        let enumerator = allViews.objectEnumerator()
        while let view = enumerator.nextObject() as? UIView {
            if view.index == index {
                view.index = nil
                break
            }
        }
        
        view.index = index
        view.detectionInterval = self.detectionInterval
        view.durationThreshold = self.durationThreshold
        view.areaRatioThreshold = self.areaRatioThreshold
        view.redetectWhenLeavingScreen = self.redetectWhenLeavingScreen
        view.redetectWhenViewControllerDidDisappear = self.redetectWhenViewControllerDidDisappear
        
        if view.impressionClosure == nil {
            view.impressionClosure = { [weak self] view, state in
                guard let self = self,
                      let index = view.index else {
                    return
                }
                if case .viewDidDisappear = state,
                   view.redetectWhenViewControllerDidDisappear ?? UIView.redetectWhenViewControllerDidDisappear {
                    self.redetectWhenViewControllerDidDisappear(view: view)
                    return
                }
                
                if let currentState = self.states[index] {
                    if !currentState.isImpressed || (self.redetectWhenLeavingScreen ?? UIView.redetectWhenLeavingScreen) {
                        self.changeState(index: index, view: view, state: state)
                    }
                } else {
                    self.changeState(index: index, view: view, state: state)
                }
            }
        }
        
        if let currentState = self.states[index],
           currentState.isImpressed && !(self.redetectWhenLeavingScreen ?? UIView.redetectWhenLeavingScreen) {
            view.stopTimer()
        } else {
            view.redetect()
            self.changeState(index: index, view: view, state: .unknown)
        }
    }
    
    public func redetect() {
        self.states.removeAll()
        self.allViews.allObjects.forEach { (view) in
            view.redetect()
            guard let index = view.index else {
                return
            }
            self.changeState(index: index, view: view, state: .unknown)
        }
    }
    
    private func redetectWhenViewControllerDidDisappear(view: UIView) {
        self.states = self.states.mapValues { (_) -> UIView.State in
            return .unknown
        }
        guard let index = view.index else {
            return
        }
        self.changeState(index: index, view: view, state: .viewDidDisappear)
    }
    
    private func changeState(index: IndexPath, view: UIView?, state: UIView.State) {
        if let previousState = self.states[index] {
            guard previousState != state else {
                return
            }
        }
        self.states[index] = state
        self.impressionClosure(self, index, view, state)
    }
}

private var indexKey = 0
private extension UIView {
    var index: IndexPath? {
        set {
            objc_setAssociatedObject(self, &indexKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &indexKey) as? IndexPath
        }
    }
}
