# CHBannerView

## 效果

![](https://github.com/MeteoriteMan/Assets/blob/master/gif/CHBannerView-Demo-iPhone%208.gif?raw=true)

> 0.2.0新增垂直滚动支持
>
>![](https://github.com/MeteoriteMan/Assets/blob/master/gif/CHBannerView-VerticalScroll.gif?raw=true)

## 使用

#### 注意点

在iOS11一下需要在使用的控制器(UIViewController)内写下如下的代码.不然样式会乱(用过UIScrollView及其子类的应该都清楚吧)
```
self.automaticallyAdjustsScrollViewInsets = NO;
```

cell的适配注意点.
如果使用自动布局,比如
```
@property (nonatomic ,strong) CHBannerView *bannerView;
```
建议在方法中进行数据传递刷新.避免出现样式错乱(允许无限轮播的情况下,)
```
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
```

**1.遵循`<CHBannerViewDataSource>`以及`<CHBannerViewDelegate>`代理**

**2.UI展示实现:**`<CHBannerViewDataSource> `

```

/// 0.2.0及以上的用这个方法返回轮播图个数
- (NSInteger)numberOfItemsInBannerView:(CHBannerView *)bannerView;

/// 0.2.0以下的版本用这个返回轮播图个数
- (NSInteger)numberOfSectionsInBannerView:(CHBannerView *_Nonnull)bannerView;

- (UICollectionViewCell *_Nonnull)bannerView:(CHBannerView *_Nonnull)bannerView cellForItemAtIndex:(NSInteger)index;

```

注册cell
```
[self.bannerView registerClass:[xxx class] forCellWithReuseIdentifier:@"XXXID"];
```

"缓存池内"取Cell
```
xxx *cell = [bannerView dequeueReusableCellWithReuseIdentifier:@"XXXID" forIndex:index];
```

**3.其他代理:**`<CHBannerViewDelegate>`

```
/// 点击item的代理
- (void)bannerView:(CHBannerView *_Nonnull)bannerView didSelectItemAtIndex:(NSInteger)index;

/// 滚动到某个Item的代理.一般用来给PageControl赋值
- (void)bannerView:(CHBannerView *_Nonnull)bannerView scrollToItemAtIndex:(NSInteger)index numberOfPages:(NSInteger)numberOfPages;

/// 将要显示Cell代理.iOS8以上支持
- (void)bannerView:(CHBannerView *_Nonnull)bannerView willDisplayCell:(UICollectionViewCell *_Nonnull)cell forItemAtIndex:(NSInteger)index NS_AVAILABLE_IOS(8_0);

```

**4.属性**

```
// MARK: 轮播图有关
/// 是否允许自动滚动,默认为YES
@property (nonatomic ,assign) BOOL shouldAutoScroll;

/// 在数据源个数为1的时候是否停止自动滚动,默认为NO
@property (nonatomic ,assign) BOOL stopAutoScrollInSingleItem;

/// 是否无限轮播,默认为YES
@property (nonatomic ,assign) BOOL shouldInfiniteShuffling;

/// 在个数为1的时候取消无限轮播,默认为NO
@property (nonatomic ,assign) BOOL cancelInfiniteShufflingInSingleItem;


/// 自带PageControl有关(详情请参阅CHPageControl.自定义的话可以隐藏这个控件)
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

>`#import <CHBannerView/CHBannerViewHeader.h>`

## 更新记录

**更新预告:1.准备未来版本中移除PageControl.**

|版本|更新内容|
|:--|:--|
|0.2.0|垂直滚动的支持.注意,返回轮播图个数的代理方法改变了|
|0.1.4|重写边界处理(一般来说碰不到.如果觉得会碰到的话可以把kSeed改大一些).修复横竖屏切换有minimumLineSpacing设置会错乱的BUG.可以参考一下"TestMinimumLineSpacingFlowLayout"的组头组尾设置.转屏暂停开启Timer.修复默认选中行和滚动到某行回调的冲突|
|0.1.2|现在不需要在cellWillDisplay里头调用reloadData了.修复默认选中Item失效的BUG|
|0.1.1|修复上个版本无限轮播与自动滚动属性失效的BUG.新增minimumLineSpacing的支持|
|0.1.0|将Delegate分为DataSource与Delegate.代理方法重写.修复0.0.7版本中丢失的区块(纯手欠...)|
|0.0.7|修复在Cell内进行布局的CHBannerView的布局错误(手欠把区块删了,这个版本基本上等于没改动)|
|0.0.6|新增两个方便的属性: stopAutoScrollInSingleItem与cancelInfiniteShufflingInSingleItem |
|0.0.5|去掉示例FlowLayout中的NSLog打印|
|0.0.4|改动了page滚动的代理,将Timer有关的两个方法抛在.h中,内部Timer的启动停止优化.重写了非无限循环图片.不开启轮播的逻辑|
|0.0.3|新增滚动到page的代理.方便自定义pageControl时绑定currentPage|
|0.0.2|改了点注释,内容基本没改动|
|0.0.1|内置一个默认FlowLayout样式.支持自定义FlowLayout.|