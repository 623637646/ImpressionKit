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

如果视图是在 UICollectionView 或者 UITableView 中，请使用`ImpressionGroup`。

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

查看Demo获取更多API

# How to integrate ImpressionKit

**ImpressionKit** can be integrated by [cocoapods](https://cocoapods.org/). 

```
pod 'ImpressionKit'
```

# Requirements

- iOS 10.0+
- Xcode 11+
