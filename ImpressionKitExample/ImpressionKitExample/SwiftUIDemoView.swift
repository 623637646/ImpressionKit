//
//  SwiftUIDemoView.swift
//  ImpressionKitExample
//
//  Created by PangMo5 on 2021/07/22.
//

import Foundation
import ImpressionKit
import SwiftUI

@available(iOS 13.0, *)
struct SwiftUIDemoView: View {
    var body: some View {
        List(0 ..< 100) { index in
            CellView(index: index)
                .frame(height: 100)
        }
    }
}

@available(iOS 13.0, *)
extension SwiftUIDemoView {
    struct CellView: View {
        let index: Int

        @State
        var text: String = ""
        @State
        var backgroundColor: Color = .white

        var body: some View {
            Text(text)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(backgroundColor)
                .detectImpression { state in
                    updateUI(with: state)
                    if state.isImpressed {
                        print("impressed index: \(index)")
                    }
                }
        }

        private func updateUI(with state: UIView.State) {
            switch state {
            case let .impressed(_, areaRatio):
                text = String("\(areaRatio * 100)%")
                backgroundColor = .green
            case .inScreen:
                text = "\(index)"
                backgroundColor = .red
            default:
                text = "\(index)"
                backgroundColor = .white
            }
        }
    }
}
