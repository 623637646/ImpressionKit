//
//  ImpressionKit+ViewModifier.swift
//  ImpressionKit
//
//  Created by PangMo5 on 2021/07/22.
//

import Foundation
import UIKit
#if canImport(SwiftUI)
    import SwiftUI
#endif

@available(iOS 13.0, *)
struct ImpressionView: UIViewRepresentable {
    let detectionInterval: Float
    let durationThreshold: Float
    let areaRatioThreshold: Float
    var redetectOptions: UIView.Redetect
    let onChanged: (UIView.State) -> Void

    func makeUIView(context: UIViewRepresentableContext<ImpressionView>) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.detectImpression { _, state in
            onChanged(state)
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

@available(iOS 13.0, *)
struct ImpressionTrackableModifier: ViewModifier {
    let detectionInterval: Float
    let durationThreshold: Float
    let areaRatioThreshold: Float
    var redetectOptions: UIView.Redetect
    let onChanged: (UIView.State) -> Void

    func body(content: Content) -> some View {
        content
            .overlay(ImpressionView(detectionInterval: detectionInterval,
                                    durationThreshold: durationThreshold,
                                    areaRatioThreshold: areaRatioThreshold,
                                    redetectOptions: redetectOptions,
                                    onChanged: onChanged))
    }
}

@available(iOS 13.0, *)
public extension View {
    func detectImpression(detectionInterval: Float = UIView.detectionInterval,
                          durationThreshold: Float = UIView.durationThreshold,
                          areaRatioThreshold: Float = UIView.areaRatioThreshold,
                          redetectOptions: UIView.Redetect = UIView.redetectOptions,
                          onChanged: @escaping (UIView.State) -> Void) -> some View
    {
        modifier(ImpressionTrackableModifier(detectionInterval: detectionInterval,
                                             durationThreshold: durationThreshold,
                                             areaRatioThreshold: areaRatioThreshold,
                                             redetectOptions: redetectOptions,
                                             onChanged: onChanged))
    }
}
