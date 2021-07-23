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
final class SwiftUIDemoViewModel: ObservableObject {
    lazy var group = ImpressionGroup.init { [weak self] (_, index: Int, _, state) in
        if state.isImpressed {
            print("impressed index: \(index)")
        }
        self?.list[index].1 = state
    }

    @Published
    var list = (0 ..< 100).map { index in (index, UIView.State.unknown) }
}

@available(iOS 13.0, *)
struct SwiftUIDemoView: View {
    @ObservedObject
    var viewModel = SwiftUIDemoViewModel()

    var body: some View {
        List(viewModel.list, id: \.0) { index, state in
            CellView(index: index)
                .frame(height: 100)
                .background(state.isImpressed ? Color.green : Color.red)
                .detectImpressionForGroup(onCreated: { view in
                    viewModel.group.bind(view: view, index: index)
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
