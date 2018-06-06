# JXWeChatFloatView
高仿微信文章悬浮球

![头图.PNG](https://upload-images.jianshu.io/upload_images/1085173-bb3e00a5e84473d1.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/375)


## 前言
微信在最新版本6.6.7，新加了一个文章悬浮球功能。当你正在阅读文章的时候，突然有好友发来了紧急消息，你需要立即回复。又或者你刚好路过小吃店，需要临时打开微信支付，等等临时中断阅读的情况。以前只有退出文章详情页面，处理完事情之后，再挨着挨着找到原来的文章。对于我们这种重度微信使用者来说，每次遭遇这种情况，真的很蛋疼。所以，当这个功能推出的事情，立马更新了最新版本，这个功能感觉就像遇到了知心人一样，用起来十分顺手。可以通过下面的动图感受一下
![JXWeChatFloatView.gif](https://upload-images.jianshu.io/upload_images/1085173-57403dc5d867f949.gif?imageMogr2/auto-orient/strip)

其实悬浮球的概念早就有了。比如360助手的流量监控球，iPhone自带的AssitiveTouch（就是那个可爱的小白球）等等。

## 仓库地址
[Github地址](https://github.com/pujiaxin33/JXWeChatFloatView)喜欢就点颗❤️

## 核心技术点
 体验过后，让人手痒痒，情不自禁得想要模仿一把。如果你的APP可以集成该功能，我觉得可以让你的APP逼格瞬间提升一个level。好了，下面让我们来一一解剖，微信文章悬浮球的核心技术点：
### 1.悬浮球的出现
当我们通过屏幕边缘手势pop视图的时候，右下角会有一个圆角提示图，跟着手势进度移动。
**如何获取到`UIScreenEdgePanGestureRecognizer`的进度呢？**
  因为系统自带的`interactivePopGestureRecognizer`是被封装起来的，它的action我们无法挂钩拿到里面的手势进度。所以，需要另辟蹊径了。
- 首先，让UINavigationController的delegate等于自己，然后让多个手势可以同时响应。
```swift
self.interactivePopGestureRecognizer?.delegate = self

func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
````
- 然后自己添加一个`UIScreenEdgePanGestureRecognizer`到UINavigationController上面，用于获取pop手势的进度。
```swift
let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleNavigationTransition(gesture:)))
gesture.edges = .left
self.view.addGestureRecognizer(gesture)
```
这样子，有两个`UIScreenEdgePanGestureRecognizer`可以同时响应，系统自带的依然保持原有逻辑不动，我们新增的用于获取pop手势进度，两者井水不犯河水，其乐融融。该技巧我的这篇文章也有使用[iOS：一分钟集成主流APP个人资料页（如简书、微博等）](https://www.jianshu.com/p/77fddf7f6b0e)

### 2.悬浮球全局置顶
既然悬浮球可以在悬浮在任何一个页面，必然是放在一个新的UIWindow上面。比如系统的键盘弹出的时候，就是一个`UIRemoteKeyboardWindow`在承载。
然后这个window的生命周期不依赖某一个页面，所以用单例实现比较好。这块代码比较分散，直接看源码就可以了解

### 3.事件响应

- 悬浮UIWindow的事件传递
只要事件位置没有在圆球和右下角上，就不响应
```swift
override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let roundEntryViewPoint = self.convert(point, to: roundEntryView)
        if roundEntryView.point(inside: roundEntryViewPoint, with: event) == true {
            return true
        }
        let collectViewPoint = self.convert(point, to: collectView)
        if collectView.point(inside: collectViewPoint, with: event) == true {
            return true
        }
        return false
    }
```
- 右下角四分之一圆，事件响应
可以看到微信，只有当手指移动进右下角圆内，才能进行悬浮。而不是按着视图的frame来响应。
首先，通过`UIBezierPath`画一个四分之一圆，然后用`CGPath`的`contains(point)`方法判断。
```swift
func updateBGLayerPath(isSmall: Bool) {
        var ratio:CGFloat = 1
        if !isSmall {
            ratio = 1.3
        }
        let path = UIBezierPath()
        path.move(to: CGPoint(x: viewSize.width, y: (1 - ratio)*viewSize.height))
        path.addLine(to: CGPoint(x: viewSize.width, y: viewSize.height))
        path.addLine(to: CGPoint(x: (1 - ratio)*viewSize.width, y: viewSize.height))
        path.addArc(withCenter: CGPoint(x: viewSize.width, y: viewSize.height), radius: viewSize.width*ratio, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi*3/2), clockwise: true)
        path.close()
        bgLayer.path = path.cgPath
    }
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bgLayer.path!.contains(point)
    }
```
对这块不太了解的同学，可以参考这篇文章。[一篇搞定事件传递、响应者链条、hitTest和pointInside的使用](https://www.jianshu.com/p/2f664e71c527)

### 4.自定义转场动画
可以看到点击悬浮球打开的文章，是通过一个自定义转场动画实现的，从悬浮球的位置开始展开。
有许多文章都有讲解如何自定义转场动画，但是我推荐你看这篇文章[几句代码快速集成自定义转场效果+ 全手势驱动](https://www.jianshu.com/p/e498b956491c)

## 实现效果
![JXWeChatFloatView-2.gif](https://upload-images.jianshu.io/upload_images/1085173-7c404f4421258147.gif?imageMogr2/auto-orient/strip)

## 总结
微信的悬浮球，用到的技术点相对比较多，代码也比较分散，如果你的APP要集成该功能，需要认真封装代码。
相对于如何实现，我认为如何设计好一个需求更重要。我在模仿的过程中，发现其中有许多细节的逻辑，彼此环环相扣，最终就呈现出了你正在使用的悬浮球功能。
都说程序员和产品经理是相爱相杀，在这里我要为该功能的产品经理点个赞👍

## 仓库地址
如果代码中有任何问题，否则你有任何疑问，都可以反馈给我，我将第一时间处理。
[Github地址](https://github.com/pujiaxin33/JXWeChatFloatView)喜欢就点颗❤️











