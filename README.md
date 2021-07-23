[中文](README.zh-Hans.md)

# ImpressionKit

This is a user behavior tracking (UBT) tool to analyze impression events for UIView (exposure of UIView) in iOS.

![ezgif com-gif-maker](https://user-images.githubusercontent.com/5275802/120922347-30a2d200-c6fb-11eb-8994-f97c2bbc0ff8.gif)

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

Color.red
    .detectImpression { state in
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
            .detectImpressionForGroup(onCreated: { view in
                group.bind(view: view, index: index)
            })
    }
}
```

### Others APIs

Change the detection (scan) interval (in seconds). Smaller `detectionInterval` means more accuracy and higher CPU consumption.

```swift
UIView.detectionInterval = 0.1  // apply to all views
UIView().detectionInterval = 0.1    // apply to the specific view. `UIView.detectionInterval` will be used if it's nil.
ImpressionGroup().detectionInterval = 0.1   // apply to the group. `UIView.detectionInterval` will be used if it's nil.
```

Chage the threshold of duration in screen (in seconds). The view will be impressed if it keeps being in screen after this seconds.

```swift
UIView.durationThreshold = 2  // apply to all views
UIView().durationThreshold = 2    // apply to the specific view. `UIView.durationThreshold` will be used if it's nil.
ImpressionGroup().durationThreshold = 2   // apply to the group. `UIView.durationThreshold` will be used if it's nil.
```

Chage the threshold of area ratio in screen. It's from 0 to 1. The view will be impressed if it's area ratio keeps being bigger than this value.

```swift
UIView.areaRatioThreshold = 0.4  // apply to all views
UIView().areaRatioThreshold = 0.4    // apply to the specific view. `UIView.areaRatioThreshold` will be used if it's nil.
ImpressionGroup().areaRatioThreshold = 0.4   // apply to the group. `UIView.areaRatioThreshold` will be used if it's nil.
```

Retrigger the impression event in some situations.

```swift
// Retrigger the impression event when a view has left from the screen (The UIViewController (page) is still here, Just the view is out of the screen).
public static let leftScreen = Redetect(rawValue: 1 << 0)

// Retrigger the impression event when the UIViewController which the view in did disappear.
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

- iOS 10.0+ (UIKit)
- iOS 13.0+ (SwiftUI)
- Xcode 11+
