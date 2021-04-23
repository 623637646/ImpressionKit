# ExposureKit

A library that help to analyze exposure (impression) events for UIView in iOS.

![ezgif com-gif-maker](https://user-images.githubusercontent.com/5275802/115500293-9b12c680-a2a3-11eb-9fcd-7018a78fce60.gif)

# How to use ExposureKit

```object-ve-c
[UIView ek_scheduleExposure:^(CGFloat areaRatio) {
    // The expisure is triggered.
} minDurationInWindow:1 minAreaRatioInWindow:0.5 error:&error];
```
* minDurationInWindow: The condition of min duration in window for triggering. It's in seconds.
* minAreaRatioInWindow: The condition of min area ratio in window for triggering. It's from 0 to 1.
* areaRatio: The area ratio when triggering.



```objective-c
[UIView ek_scheduleExposure:^(CGFloat areaRatio) {
    // The expisure is triggered.
    }
    minDurationInWindow:1
    minAreaRatioInWindow:0.5
    retriggerWhenLeftScreen:YES
    retriggerWhenRemovedFromWindow:YES
    error:&error];
```
* retriggerWhenLeftScreen: Retrigger the block when the UIView left screen and come back.
* retriggerWhenRemovedFromWindow: Retrigger the block when the UIView be removed from UIWindow and be added back.



```objectiv-c
[ExposureKitConfig sharedInstance].interval = 0.2
```
* Control the interval of detection. Small value makes the detection more accurate but cost more CPU.

# How to integrate ExposureKit

**ExposureKit** can be integrated by [cocoapods](https://cocoapods.org/). 

```
pod 'EasyExposureKit'
```

# Requirements

- iOS 10.0+
- Xcode 11+
