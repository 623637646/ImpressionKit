# ImpressionKit

这是一个用户行为追踪（UBT）工具。可以方便地检测 UIView 的曝光事件。

![ezgif com-gif-maker](https://user-images.githubusercontent.com/5275802/120922347-30a2d200-c6fb-11eb-8994-f97c2bbc0ff8.gif)

# 怎么使用

非常简单. 

```swift
UIView().detectImpression { (view, state) in
    if state.isImpressed {
        print("This view is impressed to users.")
    }
}
```

查看Demo获取更多API

# How to integrate ImpressionKit

**ImpressionKit** can be integrated by [cocoapods](https://cocoapods.org/). 

```
pod 'ImpressionKit'
```

# Requirements

- iOS 10.0+
- Xcode 11+
