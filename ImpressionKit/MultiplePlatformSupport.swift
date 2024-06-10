//
//  MacOSSupport.swift
//  ImpressionKit
//
//  Created by Wang Ya on 10/6/24.
//

#if canImport(UIKit)
import UIKit
public typealias ViewType = UIView
public typealias ViewControllerType = UIViewController
public typealias ResponderType = UIResponder
public typealias ApplicationType = UIApplication

#elseif canImport(AppKit)
import AppKit
public typealias ViewType = NSView
public typealias ViewControllerType = NSViewController
public typealias ResponderType = NSResponder
public typealias ApplicationType = NSApplication

#endif
