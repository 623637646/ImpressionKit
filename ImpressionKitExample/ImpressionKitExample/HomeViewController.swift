//
//  HomeViewController.swift
//  ImpressionKitExample
//
//  Created by Yanni Wang on 31/5/21.
//

import Foundation
import Eureka

class HomeViewController: FormViewController {
    
    private static let detectionIntervalKey = "detectionIntervalKey"
    private static let durationThresholdKey = "durationThresholdKey"
    private static let areaRatioThresholdKey = "areaRatioThresholdKey"
    private static let redetectWhenLeavingScreenKey = "redetectWhenLeavingScreenKey"
    private static let redetectWhenViewControllerDidDisappearKey = "redetectWhenViewControllerDidDisappearKey"
    private static let redetectWhenReceiveSystemNotificationKey = "redetectWhenReceiveSystemNotificationKey"

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
    static var redetectWhenLeavingScreen: Bool {
        get {
            guard UserDefaults.standard.object(forKey: redetectWhenLeavingScreenKey) != nil else {
                return UIView.redetectWhenLeavingScreen
            }
            return UserDefaults.standard.bool(forKey: redetectWhenLeavingScreenKey)
        }
        set {
            UIView.redetectWhenLeavingScreen = newValue
            UserDefaults.standard.set(newValue, forKey: redetectWhenLeavingScreenKey)
        }
    }
    static var redetectWhenViewControllerDidDisappear: Bool {
        get {
            guard UserDefaults.standard.object(forKey: redetectWhenViewControllerDidDisappearKey) != nil else {
                return UIView.redetectWhenViewControllerDidDisappear
            }
            return UserDefaults.standard.bool(forKey: redetectWhenViewControllerDidDisappearKey)
        }
        set {
            UIView.redetectWhenViewControllerDidDisappear = newValue
            UserDefaults.standard.set(newValue, forKey: redetectWhenViewControllerDidDisappearKey)
        }
    }
    static var redetectWhenReceiveSystemNotification: Set<Notification.Name> {
        get {
            guard UserDefaults.standard.object(forKey: redetectWhenReceiveSystemNotificationKey) != nil else {
                return UIView.redetectWhenReceiveSystemNotification
            }
            let result = (UserDefaults.standard.object(forKey: redetectWhenReceiveSystemNotificationKey) as? [String] ?? []).map({Notification.Name.init($0)})
            return Set.init(result)
        }
        set {
            UIView.redetectWhenReceiveSystemNotification = newValue
            let array = newValue.map({$0.rawValue})
            UserDefaults.standard.set(array, forKey: redetectWhenReceiveSystemNotificationKey)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Exposure Demo";
        self.setUpForm()
    }
    
    func setUpForm() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        form.removeAll()
        form +++ Section("Demos")
            <<< ButtonRow("UIScrollView (normal views)") { row in
                row.title = row.tag
                row.presentationMode = .show(controllerProvider: ControllerProvider<UIViewController>.callback(builder: { () -> UIViewController in
                    return ScrollViewDemoViewController()
                }), onDismiss: nil)
            }
            <<< ButtonRow("UICollectionView (resued views)") { row in
                row.title = row.tag
                row.presentationMode = .show(controllerProvider: ControllerProvider<UIViewController>.callback(builder: { () -> UIViewController in
                    return CollectionViewDemoViewController()
                }), onDismiss: nil)
            }
            <<< ButtonRow("UITableView (resued views)") { row in
                row.title = row.tag
                row.presentationMode = .show(controllerProvider: ControllerProvider<UIViewController>.callback(builder: { () -> UIViewController in
                    return TableViewDemoViewController()
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
            <<< SwitchRow() {
                $0.title = "Redetect When Leaving Screen"
                $0.value = HomeViewController.redetectWhenLeavingScreen
            }.onChange({ (row) in
                HomeViewController.redetectWhenLeavingScreen = row.value ?? false
            })
            <<< SwitchRow() {
                $0.title = "Redetect When DidDisappear"
                $0.value = HomeViewController.redetectWhenViewControllerDidDisappear
            }.onChange({ (row) in
                HomeViewController.redetectWhenViewControllerDidDisappear = row.value ?? false
            })
            <<< SwitchRow() {
                $0.title = "Redetect When didEnterBackground"
                $0.value = HomeViewController.redetectWhenReceiveSystemNotification.contains(UIApplication.didEnterBackgroundNotification)
            }.onChange({ (row) in
                if row.value ?? false {
                    HomeViewController.redetectWhenReceiveSystemNotification.insert(UIApplication.didEnterBackgroundNotification)
                } else {
                    HomeViewController.redetectWhenReceiveSystemNotification.remove(UIApplication.didEnterBackgroundNotification)
                }
            })
            <<< SwitchRow() {
                $0.title = "Redetect When willResignActive"
                $0.value = HomeViewController.redetectWhenReceiveSystemNotification.contains(UIApplication.willResignActiveNotification)
            }.onChange({ (row) in
                if row.value ?? false {
                    HomeViewController.redetectWhenReceiveSystemNotification.insert(UIApplication.willResignActiveNotification)
                } else {
                    HomeViewController.redetectWhenReceiveSystemNotification.remove(UIApplication.willResignActiveNotification)
                }
            })
            <<< ButtonRow(){
                $0.title = "Reset"
                $0.cell.tintColor = .red
            }.onCellSelection { [weak self] _,_ in
                HomeViewController.detectionInterval = 0.2
                HomeViewController.durationThreshold = 1
                HomeViewController.areaRatioThreshold = 0.5
                HomeViewController.redetectWhenLeavingScreen = false
                HomeViewController.redetectWhenViewControllerDidDisappear = false
                HomeViewController.redetectWhenReceiveSystemNotification.removeAll()
                self?.setUpForm()
            }
        CATransaction.commit()
    }
}

