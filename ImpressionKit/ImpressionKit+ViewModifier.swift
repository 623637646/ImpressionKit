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
    let isForGroup: Bool
    let detectionInterval: Float
    let durationThreshold: Float
    let areaRatioThreshold: Float
    var redetectOptions: UIView.Redetect
    let onCreated: ((UIView) -> Void)?
    let onChanged: ((UIView.State) -> Void)?

    func makeUIView(context: UIViewRepresentableContext<ImpressionView>) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.detectionInterval = detectionInterval
        view.durationThreshold = durationThreshold
        view.areaRatioThreshold = areaRatioThreshold
        view.redetectOptions = redetectOptions
        if !isForGroup {
            view.detectImpression { _, state in
                onChanged?(state)
            }
        }
        onCreated?(view)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

@available(iOS 13.0, *)
struct ImpressionTrackableModifier: ViewModifier {
    let isForGroup: Bool
    let detectionInterval: Float
    let durationThreshold: Float
    let areaRatioThreshold: Float
    var redetectOptions: UIView.Redetect
    let onCreated: ((UIView) -> Void)?
    let onChanged: ((UIView.State) -> Void)?

    func body(content: Content) -> some View {
        content
            .overlay(ImpressionView(isForGroup: isForGroup,
                                    detectionInterval: detectionInterval,
                                    durationThreshold: durationThreshold,
                                    areaRatioThreshold: areaRatioThreshold,
                                    redetectOptions: redetectOptions,
                                    onCreated: onCreated,
                                    onChanged: onChanged))
    }
}

@available(iOS 13.0, *)
public extension View {
    func detectImpression(detectionInterval: Float = UIView.detectionInterval,
                          durationThreshold: Float = UIView.durationThreshold,
                          areaRatioThreshold: Float = UIView.areaRatioThreshold,
                          redetectOptions: UIView.Redetect = UIView.redetectOptions,
                          onCreated: ((UIView) -> Void)? = nil,
                          onChanged: @escaping (UIView.State) -> Void) -> some View
    {
        modifier(ImpressionTrackableModifier(isForGroup: false,
                                             detectionInterval: detectionInterval,
                                             durationThreshold: durationThreshold,
                                             areaRatioThreshold: areaRatioThreshold,
                                             redetectOptions: redetectOptions,
                                             onCreated: onCreated,
                                             onChanged: onChanged))
    }

    func detectImpressionForGroup(detectionInterval: Float = UIView.detectionInterval,
                                  durationThreshold: Float = UIView.durationThreshold,
                                  areaRatioThreshold: Float = UIView.areaRatioThreshold,
                                  redetectOptions: UIView.Redetect = UIView.redetectOptions,
                                  onCreated: ((UIView) -> Void)? = nil) -> some View
    {
        modifier(ImpressionTrackableModifier(isForGroup: true,
                                             detectionInterval: detectionInterval,
                                             durationThreshold: durationThreshold,
                                             areaRatioThreshold: areaRatioThreshold,
                                             redetectOptions: redetectOptions,
                                             onCreated: onCreated,
                                             onChanged: nil))
    }
}
