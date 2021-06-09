# ImpressionKit

这是一个用户行为追踪（UBT）工具。可以方便地检测 UIView 的曝光事件。

![ezgif com-gif-maker](https://user-images.githubusercontent.com/5275802/120922347-30a2d200-c6fb-11eb-8994-f97c2bbc0ff8.gif)

# 怎么使用

### 主要的 API

非常简单. 

```swift
UIView().detectImpression { (view, state) in
    if state.isImpressed {
        print("This view is impressed to users.")
    }
}
```

如果是在 UICollectionView，UITableView 或者其他可复用的视图中，请使用`ImpressionGroup`。

```swift

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

```

### 其他 API

更改检测间隔 (秒). 更小的 `检测间隔` 代表更高的精确性和更高的CPU消耗。

```swift
UIView.detectionInterval = 0.1  // 应用于所有 view。
UIView().detectionInterval = 0.1    // 应用于特定 view. 如果为nil，则使用 `UIView.detectionInterval`。
ImpressionGroup().detectionInterval = 0.1   // 应用于特定 group. 如果为nil，则使用 `UIView.detectionInterval`。
```

更改 view 在屏幕上的持续时间的阈值 (秒)。 如果 view 在屏幕上的持续时间超过此阈值则会触发曝光。

```swift
UIView.durationThreshold = 2  // 应用于所有 view。
UIView().durationThreshold = 2    // 应用于特定 view. 如果为nil，则使用 `UIView.durationThreshold`。
ImpressionGroup().durationThreshold = 2   // 应用于特定 group. 如果为nil，则使用 `UIView.durationThreshold`。
```

更改 view 在屏幕上的面积比例的阈值（从 0 到 1）。view 在屏幕上的面积的百分比超过此阈值则会触发曝光。

```swift
UIView.areaRatioThreshold = 0.4  // 应用于所有 view。
UIView().areaRatioThreshold = 0.4    // 应用于特定 view. 如果为nil，则使用 `UIView.areaRatioThreshold`。
ImpressionGroup().areaRatioThreshold = 0.4   // 应用于特定 group. 如果为nil，则使用 `UIView.areaRatioThreshold` 。
```

在某些情况下重新触发曝光事件。

```swift
// 当 view 离开屏幕 （页面不变，只是 view 没有显示）时，重新触发曝光。
public static let leftScreen = Redetect(rawValue: 1 << 0)

// 当 view 所在 UIViewController 消失时，重新触发曝光。
public static let viewControllerDidDisappear = Redetect(rawValue: 1 << 1)

// 当 App 进入后台时，重新触发曝光。
public static let didEnterBackground = Redetect(rawValue: 1 << 2)

// 当 App 将要进入非活跃状态时，重新触发曝光。
public static let willResignActive = Redetect(rawValue: 1 << 3)
```

```swift
UIView.redetectOptions = [.leftScreen, .viewControllerDidDisappear, .didEnterBackground, .willResignActive]  // 应用于所有 view。
UIView().redetectOptions = [.leftScreen, .viewControllerDidDisappear, .didEnterBackground, .willResignActive]    // 应用于特定 view. 如果为nil，则使用`UIView.redetectOptions`。
ImpressionGroup().redetectOptions = [.leftScreen, .viewControllerDidDisappear, .didEnterBackground, .willResignActive]   // 应用于特定 group. 如果为nil，则使用 `UIView.redetectOptions`。
```

查看Demo获取更多详情。

# How to integrate ImpressionKit

**ImpressionKit** can be integrated by [cocoapods](https://cocoapods.org/). 

```
pod 'ImpressionKit'
```

# Requirements

- iOS 10.0+
- Xcode 11+
