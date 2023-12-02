//
//  HomeViewController.swift
//  ImpressionKitExample
//
//  Created by Yanni Wang on 31/5/21.
//

import Foundation
import Eureka
import SwiftUI

class HomeViewController: FormViewController {
    
    private static let detectionIntervalKey = "detectionIntervalKey"
    private static let durationThresholdKey = "durationThresholdKey"
    private static let areaRatioThresholdKey = "areaRatioThresholdKey"
    private static let alphaThresholdKey = "alphaThresholdKey"
    private static let alphaInDemoKey = "alphaInDemoKey"
    private static let redetectOptionsKey = "redetectOptionsKey"
    
    static var detectionInterval: Float {
        get {
            guard UserDefaults.standard.object(forKey: detectionIntervalKey) != nil else {
                return UIView.detectionInterval
            }
            return UserDefaults.standard.float(forKey: detectionIntervalKey)
        }
        set {
            UIView.detectionInterval = newValue
            UserDefaults.standard.set(newValue, forKey: detectionIntervalKey)
        }
    }
    
    static var durationThreshold: Float {
        get {
            guard UserDefaults.standard.object(forKey: durationThresholdKey) != nil else {
                return UIView.durationThreshold
            }
            return UserDefaults.standard.float(forKey: durationThresholdKey)
        }
        set {
            UIView.durationThreshold = newValue
            UserDefaults.standard.set(newValue, forKey: durationThresholdKey)
        }
    }
    static var areaRatioThreshold: Float {
        get {
            guard UserDefaults.standard.object(forKey: areaRatioThresholdKey) != nil else {
                return UIView.areaRatioThreshold
            }
            return UserDefaults.standard.float(forKey: areaRatioThresholdKey)
        }
        set {
            UIView.areaRatioThreshold = newValue
            UserDefaults.standard.set(newValue, forKey: areaRatioThresholdKey)
        }
    }
    static var alphaThreshold: Float {
        get {
            guard UserDefaults.standard.object(forKey: alphaThresholdKey) != nil else {
                return UIView.alphaThreshold
            }
            return UserDefaults.standard.float(forKey: alphaThresholdKey)
        }
        set {
            UIView.alphaThreshold = newValue
            UserDefaults.standard.set(newValue, forKey: alphaThresholdKey)
        }
    }
    static var alphaInDemo: Float {
        get {
            guard UserDefaults.standard.object(forKey: alphaInDemoKey) != nil else {
                return 1
            }
            return UserDefaults.standard.float(forKey: alphaInDemoKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: alphaInDemoKey)
        }
    }
    static var redetectOptions: UIView.Redetect {
        get {
            guard UserDefaults.standard.object(forKey: redetectOptionsKey) != nil else {
                return UIView.redetectOptions
            }
            let value = UserDefaults.standard.integer(forKey: redetectOptionsKey)
            return UIView.Redetect.init(rawValue: value)
        }
        set {
            UIView.redetectOptions = newValue
            UserDefaults.standard.set(newValue.rawValue, forKey: redetectOptionsKey)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ImpressionKit Demo";
        self.setUpForm()
    }
    
    func setUpForm() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        form.removeAll()
        form +++ Section("Demos")
        <<< ButtonRow("UIScrollView") { row in
            row.title = row.tag
            row.presentationMode = .show(controllerProvider: ControllerProvider<UIViewController>.callback(builder: { () -> UIViewController in
                return ScrollViewDemoViewController()
            }), onDismiss: nil)
        }
        <<< ButtonRow("UICollectionView (reusable views)") { row in
            row.title = row.tag
            row.presentationMode = .show(controllerProvider: ControllerProvider<UIViewController>.callback(builder: { () -> UIViewController in
                return CollectionViewDemoViewController()
            }), onDismiss: nil)
        }
        <<< ButtonRow("UICollectionView (only detect 2nd section)") { row in
            row.title = row.tag
            row.presentationMode = .show(controllerProvider: ControllerProvider<UIViewController>.callback(builder: { () -> UIViewController in
                return CollectionViewDemo2ViewController()
            }), onDismiss: nil)
        }
        <<< ButtonRow("UITableView (reusable views)") { row in
            row.title = row.tag
            row.presentationMode = .show(controllerProvider: ControllerProvider<UIViewController>.callback(builder: { () -> UIViewController in
                return TableViewDemoViewController()
            }), onDismiss: nil)
        }
        <<< ButtonRow("SwiftUI ScrollView") { row in
            row.title = row.tag
            row.presentationMode = .show(controllerProvider: ControllerProvider<UIViewController>.callback(builder: { () -> UIViewController in
                if #available(iOS 13.0, *) {
                    return UIHostingController(rootView: SwiftUIScrollViewDemoView())
                } else {
                    fatalError()
                }
            }), onDismiss: nil)
        }
        <<< ButtonRow("SwiftUI List (reusable views)") { row in
            row.title = row.tag
            row.presentationMode = .show(controllerProvider: ControllerProvider<UIViewController>.callback(builder: { () -> UIViewController in
                if #available(iOS 13.0, *) {
                    return UIHostingController(rootView: SwiftUIListDemoView())
                } else {
                    fatalError()
                }
            }), onDismiss: nil)
        }
        +++ Section("SETTINGS")
        <<< DecimalRow() {
            $0.title = "Detection Interval"
            $0.value = Double(HomeViewController.detectionInterval)
            $0.formatter = DecimalFormatter()
            $0.useFormatterDuringInput = true
            //$0.useFormatterOnDidBeginEditing = true
        }.cellSetup { cell, _  in
            cell.textField.keyboardType = .numberPad
        }.onChange({ (row) in
            HomeViewController.detectionInterval = Float(row.value ?? 0)
        })
        <<< DecimalRow() {
            $0.title = "Duration Threshold"
            $0.value = Double(HomeViewController.durationThreshold)
            $0.formatter = DecimalFormatter()
            $0.useFormatterDuringInput = true
            //$0.useFormatterOnDidBeginEditing = true
        }.cellSetup { cell, _  in
            cell.textField.keyboardType = .numberPad
        }.onChange({ (row) in
            HomeViewController.durationThreshold = Float(row.value ?? 0)
        })
        <<< SliderRow() {
            $0.title = "Area Ratio Threshold"
            $0.value = Float(Int(HomeViewController.areaRatioThreshold * 100))
            $0.cell.slider.minimumValue = 1
            $0.cell.slider.maximumValue = 100
            $0.displayValueFor = {
                return "\(Int($0 ?? 0))%"
            }
        }.onChange({ (row) in
            HomeViewController.areaRatioThreshold = Float((row.value ?? 0) / 100)
        })
        <<< SliderRow() {
            $0.title = "Alpha Threshold"
            $0.value = Float(Int(HomeViewController.alphaThreshold * 100))
            $0.cell.slider.minimumValue = 1
            $0.cell.slider.maximumValue = 100
            $0.displayValueFor = {
                return "\(Int($0 ?? 0))%"
            }
        }.onChange({ (row) in
            HomeViewController.alphaThreshold = Float((row.value ?? 0) / 100)
        })
        <<< SliderRow() {
            $0.title = "Alpha of views in Demo"
            $0.value = Float(Int(HomeViewController.alphaInDemo * 100))
            $0.cell.slider.minimumValue = 1
            $0.cell.slider.maximumValue = 100
            $0.displayValueFor = {
                return "\(Int($0 ?? 0))%"
            }
        }.onChange({ (row) in
            HomeViewController.alphaInDemo = Float((row.value ?? 0) / 100)
        })
        <<< SwitchRow() {
            $0.title = "Redetect When Left Screen"
            $0.value = HomeViewController.redetectOptions.contains(.leftScreen)
        }.onChange({ (row) in
            if row.value ?? false {
                HomeViewController.redetectOptions.insert(.leftScreen)
            } else {
                HomeViewController.redetectOptions.remove(.leftScreen)
            }
        })
        <<< SwitchRow() {
            $0.title = "Redetect When DidDisappear"
            $0.value = HomeViewController.redetectOptions.contains(.viewControllerDidDisappear)
        }.onChange({ (row) in
            if row.value ?? false {
                HomeViewController.redetectOptions.insert(.viewControllerDidDisappear)
            } else {
                HomeViewController.redetectOptions.remove(.viewControllerDidDisappear)
            }
        })
        <<< SwitchRow() {
            $0.title = "Redetect When didEnterBackground"
            $0.value = HomeViewController.redetectOptions.contains(.didEnterBackground)
        }.onChange({ (row) in
            if row.value ?? false {
                HomeViewController.redetectOptions.insert(.didEnterBackground)
            } else {
                HomeViewController.redetectOptions.remove(.didEnterBackground)
            }
        })
        <<< SwitchRow() {
            $0.title = "Redetect When willResignActive"
            $0.value = HomeViewController.redetectOptions.contains(.willResignActive)
        }.onChange({ (row) in
            if row.value ?? false {
                HomeViewController.redetectOptions.insert(.willResignActive)
            } else {
                HomeViewController.redetectOptions.remove(.willResignActive)
            }
        })
        <<< ButtonRow(){
            $0.title = "Reset"
            $0.cell.tintColor = .red
        }.onCellSelection { [weak self] _,_ in
            HomeViewController.detectionInterval = 0.2
            HomeViewController.durationThreshold = 1
            HomeViewController.areaRatioThreshold = 0.5
            HomeViewController.alphaThreshold = 0.1
            HomeViewController.alphaInDemo = 1
            HomeViewController.redetectOptions = []
            self?.setUpForm()
        }
        CATransaction.commit()
    }
}

