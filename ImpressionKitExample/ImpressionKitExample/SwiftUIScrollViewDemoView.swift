//
//  SwiftUIScrollViewDemoView.swift
//  ImpressionKitExample
//
//  Created by PangMo5 on 2021/07/22.
//

import Foundation
import ImpressionKit
import SwiftUI

@available(iOS 13.0, *)
struct SwiftUIScrollViewDemoView: View {
    var body: some View {
        ScrollView{
            ForEach(0 ..< 100) { _ in
                CellView()
            }
        }
    }
}

@available(iOS 13.0, *)
extension SwiftUIScrollViewDemoView {
    struct CellView: View {
        @State var state: UIView.ImpressionState = .unknown
        var body: some View {
            (state.isImpressed ? Color.green : Color.red)
                .frame(height: 44)
                .detectImpression { (state) in
                    self.state = state
                }
        }
    }
}
