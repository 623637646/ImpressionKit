//
//  ViewController.swift
//  MacOSExample
//
//  Created by Wang Ya on 10/6/24.
//

import Cocoa
import ImpressionKit

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.detectImpression { (view, state) in
            if state.isImpressed {
                print("impressed")
            }
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

