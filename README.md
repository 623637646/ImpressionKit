# ImpressionKit

This is a user behavior tracking (UBT) tool to analyze impression events for UIView (exposure of UIView) in iOS.

![ezgif com-gif-maker](https://user-images.githubusercontent.com/5275802/120922347-30a2d200-c6fb-11eb-8994-f97c2bbc0ff8.gif)

# How to use ImpressionKit

It's quite simple. 

```swift
UIView().detectImpression { (view, state) in
    if state.isImpressed {
        print("This view is impressed to users.")
    }
}
```

Refer to the Demo for more APIs.

# How to integrate ImpressionKit

**ImpressionKit** can be integrated by [cocoapods](https://cocoapods.org/). 

```
pod 'ImpressionKit'
```

# Requirements

- iOS 10.0+
- Xcode 11+
