//
//  Debug.swift
//  ImpressionKit
//
//  Created by Yanni Wang on 31/5/21.
//

import Foundation

#if DEBUG

class Debug {
    
    static let shared = Debug()
    
    private static let logging = false
    
    var timerCount: UInt = 0
    
    private init() {
        guard Debug.logging else {
            return
        }
        let timer = Timer.init(timeInterval: 0.5, repeats: true, block: { (_) in
            print("totally running timer count: \(Debug.shared.timerCount)")
        })
        RunLoop.main.add(timer, forMode: .common)
    }
    
}

#endif
