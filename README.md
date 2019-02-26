# CHBannerView

## 效果

![](https://github.com/MeteoriteMan/Assets/blob/master/gif/CHBannerView-Demo-iPhone%208.gif?raw=true)

## 使用

#### 注意点

在iOS11一下需要在使用的控制器(UIViewController)内写下如下的代码.不然样式会乱(用过UIScrollView及其子类的应该都清楚吧)
```
self.automaticallyAdjustsScrollViewInsets = NO;
```

1.遵循`<CHBannerViewDelegate>`代理

2.UI展示实现

```
- (NSInteger)bannerView:(CHBannerView *)bannerView numberOfItemsInSection:(NSInteger)section;

- (UICollectionViewCell *)bannerView:(UICollectionView *)collectionView cellForItemAtIndex:(NSInteger)index;
```

3.其他代理

```
/// 点击item的代理
- (void)bannerView:(UICollectionView *)collectionView didSelectItemAtIndex:(NSInteger)index;

/// 滚动到某页的代理
- (void)bannerView:(UICollectionView *)collectionView scrollToItemAtIndex:(NSInteger)index;
```

4.属性

```
/// 是否允许自动滚动,默认为YES
@property (nonatomic ,assign) BOOL shouldAutoScroll;

/// 是否无限轮播,默认为YES
@property (nonatomic ,assign) BOOL shouldInfiniteShuffling;

/// 滚动时间间距.默认为5s
@property (nonatomic ,assign) CGFloat timeInterval;

```

**5.自定义滚动样式(flowlayout)注意点**

```
系统pagingEnabled被被我禁用了.如果自定义flowlayout.需要重写
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
方法去计算停止位置
```

**6.设置页面时消失停止Timer与页面出现时开始Timer**

```
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = [NSString stringWithFormat:@"%@" ,@(self.navigationController.viewControllers.count)];
    [self.bannerView startTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.bannerView stopTimer];
}
```


## 安装

使用 [CocoaPods](http://www.cocoapods.com/) 集成.
首先在podfile中
>`pod 'CHBannerView'`

安装一下pod

>`#import <CHBannerView/CHBannerView.h>`

## 更新记录

|版本|更新内容|
|:--|:--|
|0.0.4|改动了page滚动的代理,将Timer有关的两个方法抛在.h中,内部Timer的启动停止优化|
|0.0.3|新增滚动到page的代理.方便自定义pageControl时绑定currentPage|
|0.0.2|改了点注释,内容基本没改动|
|0.0.1|内置一个默认FlowLayout样式.支持自定义FlowLayout.|