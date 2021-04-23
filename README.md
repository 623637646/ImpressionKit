# ExposureKit

A lib that help to analyze exposure (impression) events for UIView in iOS.

![ezgif com-gif-maker](https://user-images.githubusercontent.com/5275802/115500293-9b12c680-a2a3-11eb-9fcd-7018a78fce60.gif)

# How to use ExposureKit

```object-ve-c
[UIView ek_scheduleExposure:^(CGFloat areaRatio) {
    // The expisure is triggered.
} minDurationInWindow:1 minAreaRatioInWindow:0.5 error:&error];
```


# How to integrate ExposureKit

**ExposureKit** can be integrated by [cocoapods](https://cocoapods.org/). 

```
pod 'EasyExposureKit'
```

# Requirements

- iOS 10.0+
- Xcode 11+
