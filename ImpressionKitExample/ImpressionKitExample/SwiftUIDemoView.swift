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
    var group = ImpressionGroup.init { (_, index: IndexPath, _, state) in
        if state.isImpressed {
            print("impressed index: \(index.row)")
        }
    }

    var body: some View {
        List(0 ..< 100) { index in
            CellView(index: index)
                .frame(height: 100)
                .detectImpressionForGroup(onCreated: { view in
                    group.bind(view: view, index: IndexPath(row: index, section: 0))
                })
        }
    }
}

@available(iOS 13.0, *)
extension SwiftUIDemoView {
    struct CellView: View {
        let index: Int

        var body: some View {
            Text(String(index))
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}
