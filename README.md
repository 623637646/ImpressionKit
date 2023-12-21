[中文](README.zh-Hans.md)

# ImpressionKit

This is a user behavior tracking (UBT) tool to analyze impression events for UIView (exposure of UIView) in iOS.

![ezgif com-gif-maker](https://user-images.githubusercontent.com/5275802/120922347-30a2d200-c6fb-11eb-8994-f97c2bbc0ff8.gif)

How it works: Hook the `didMoveToWindow` method of a UIView by [SwiftHook](https://github.com/623637646/SwiftHook), periodically check the view is on the screen or not.

# How to use ImpressionKit

### Main APIs

It's quite simple. 


```swift

// UIKit

UIView().detectImpression { (view, state) in
    if state.isImpressed {
        print("This view is impressed to users.")
    }
}

// SwiftUI

Color.red.detectImpression { state in
    if state.isImpressed {
        print("This view is impressed to users.")
    }
}
```

Use `ImpressionGroup` for UICollectionView, UITableView, List or other reusable view cases.

```swift
// UIKit

var group = ImpressionGroup.init {(_, index: IndexPath, view, state) in
    if state.isImpressed {
        print("impressed index: \(index.row)")
    }
}

...

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
    self.group.bind(view: cell, index: indexPath)
    return cell
}

// SwiftUI

var group = ImpressionGroup.init { (_, index: Int, _, state) in
    if state.isImpressed {
        print("impressed index: \(index)")
    }
}

var body: some View {
    List(0 ..< 100) { index in
        CellView(index: index)
            .frame(height: 100)
            .detectImpression(group: group, index: index)
    }
}
```

### More APIs

Modify the detection (scan) interval (in seconds). Smaller `detectionInterval` means higher accuracy and higher CPU consumption.

```swift
UIView.detectionInterval = 0.1  // apply to all views
UIView().detectionInterval = 0.1    // apply to the specific view. `UIView.detectionInterval` will be used if it's nil.
ImpressionGroup().detectionInterval = 0.1   // apply to the group. `UIView.detectionInterval` will be used if it's nil.
```

Modify the threshold (seconds) for the duration of a view on the screen. If the view's duration on the screen exceeds this threshold, it may trigger an impression.

```swift
UIView.durationThreshold = 2  // apply to all views
UIView().durationThreshold = 2    // apply to the specific view. `UIView.durationThreshold` will be used if it's nil.
ImpressionGroup().durationThreshold = 2   // apply to the group. `UIView.durationThreshold` will be used if it's nil.
```

Modify the threshold (from 0 to 1) for the area ratio of the view on the screen. If the percentage of the view's area on the screen exceeds this threshold, it may trigger an impression.

```swift
UIView.areaRatioThreshold = 0.4  // apply to all views
UIView().areaRatioThreshold = 0.4    // apply to the specific view. `UIView.areaRatioThreshold` will be used if it's nil.
ImpressionGroup().areaRatioThreshold = 0.4   // apply to the group. `UIView.areaRatioThreshold` will be used if it's nil.
```

Modify the threshold (from 0 to 1) for the view opacity. If the view's opacity exceeds this threshold, it may trigger an impression.

```swift
UIView.alphaThreshold = 0.4  // apply to all views
UIView().alphaThreshold = 0.4    // apply to the specific view. `UIView.alphaThreshold` will be used if it's nil.
ImpressionGroup().alphaThreshold = 0.4   // apply to the group. `UIView.alphaThreshold` will be used if it's nil.
```

Retrigger the impression event in some situations.

```swift
// Retrigger the impression event when a view left from the screen (The UIViewController (page) is still here, Just the view is out of the screen).
public static let leftScreen = Redetect(rawValue: 1 << 0)

// Retrigger the impression event when the UIViewController of the view disappear.
public static let viewControllerDidDisappear = Redetect(rawValue: 1 << 1)

// Retrigger the impression event when the App did enter background.
public static let didEnterBackground = Redetect(rawValue: 1 << 2)

// Retrigger the impression event when the App will resign active.
public static let willResignActive = Redetect(rawValue: 1 << 3)
```

```swift
UIView.redetectOptions = [.leftScreen, .viewControllerDidDisappear, .didEnterBackground, .willResignActive]  // apply to all views
UIView().redetectOptions = [.leftScreen, .viewControllerDidDisappear, .didEnterBackground, .willResignActive]    // apply to the specific view. `UIView.redetectOptions` will be used if it's nil.
ImpressionGroup().redetectOptions = [.leftScreen, .viewControllerDidDisappear, .didEnterBackground, .willResignActive]   // apply to the group. `UIView.redetectOptions` will be used if it's nil.
```

Refer to the Demo for more details.

# How to integrate ImpressionKit

**ImpressionKit** can be integrated by [cocoapods](https://cocoapods.org/). 

```
pod 'ImpressionKit'
```

Or use Swift Package Manager. SPM is supported from 3.1.0.

# Requirements

- iOS 12.0+ (UIKit)
- iOS 13.0+ (SwiftUI)
- Xcode 15.1+
