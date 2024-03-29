# CHBannerView

## 效果

> 默认样式

![](./Asset/CHBannerView-%E9%BB%98%E8%AE%A4%E6%A0%B7%E5%BC%8FDemo.gif?raw=true)

> 自定义样式

![](./Asset/CHBannerView-%E8%87%AA%E5%AE%9A%E4%B9%89%E6%A0%B7%E5%BC%8FDemo.gif?raw=true)

> 0.2.0新增垂直滚动支持

>![](./Asset/CHBannerView-VerticalScroll.gif?raw=true)

> 0.3.0新增Timer下滚动距离自定义支持

>![](./Asset/CHBannerView-Demo-iPhone%20X.gif?raw=true)

> 0.4.0新增自动滚动自定义动画解决iOS[15.0, 15.1)动画不展示的问题.

**转屏颜色变化是由于转屏后contentOffset位置变化需要重新计算.Cell为了调试方便我写的是设置的随机RGB色**

## 使用

#### 注意点

> 在iOS11一下需要在使用的控制器(UIViewController)内写下如下的代码.不然样式会乱(用过UIScrollView及其子类的应该都清楚吧).0.2.1版本以后默认在框架内部取出ViewController设置了(也是根据朋友反馈的需要精简设置)

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

/// 轮播图个数
- (NSInteger)numberOfItemsInBannerView:(CHBannerView *)bannerView;

/// 当前的轮播图,使用dequeue方法时使用index.取对应model使用orignalIndex.
/**
 获取当前Cell.getCurrentCell

 @param bannerView bannerView
 @param index 调用取cell的index
 @param orignalIndex 计算用的的index
 @return collectionViewCell
 */
- (UICollectionViewCell *_Nonnull)bannerView:(CHBannerView *_Nonnull)bannerView cellForItemAtIndex:(NSInteger)index orignalIndex:(NSInteger)orignalIndex;

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

/// 自定义计算当前Page.
/// @param numberOfPages 计算用整个Pages(非dataSourcePage)
- (NSInteger)bannerView:(CHBannerView *_Nonnull)bannerView currentPageForScrollView:(UIScrollView *_Nonnull)scrollView flowLayout:(UICollectionViewFlowLayout *_Nonnull)flowLayout numberOfPages:(NSInteger)numberOfPages;

/// 自动滚动悬停位置代理
- (CGPoint)bannerView:(CHBannerView *_Nonnull)bannerView nextHoverPointForScrollView:(UIScrollView *_Nonnull)scrollView currentPage:(NSInteger)currentPage flowLayout:(UICollectionViewFlowLayout *_Nonnull)flowLayout numberOfPages:(NSInteger)numberOfPages;

/// 停止滚动时显示的Item
/// @param bannerView bannerView
/// @param index 停止的Page
/// @param orignalIndex 数据源对应的orignalIndex
- (void)bannerView:(CHBannerView *_Nonnull)bannerView showIndexWithoutScroll:(NSInteger)index orignalIndex:(NSInteger)orignalIndex;

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

**7.iOS[15.0, 15.1)系统动画不显示问题**

**如Cell与CollectionView大小不一致,直接设置如下属性即可.**
```
if (@available(iOS 15.1, *)) {
	self.bannerView.scrollAnimationOption = CHBannerViewAnimationOptionCurveLinear;
} else if (@available(iOS 15.0, *)) {
	self.bannerView.scrollAnimationOption = CHBannerViewAnimationNone;
} else {
	self.bannerView.scrollAnimationOption = CHBannerViewAnimationOptionCurveLinear;
}
```
**如Cell大小与CollectionView大小一致,则需要给CollectionView增加一个父控件,大小与调整前的CollectionView一致,并且设置clipsToBounds = YES.然后将collectionView向外拓充部分,并且保证itemSize与调整前相同**

```
// 如横向滚动的banner
...
self.bannerViewContent.clipsToBounds = YES;
[self.view addSubview:self.bannerViewContent];
[self.bannerViewContent mas_makeConstraints:^(MASConstraintMaker *make) {
	make.top.equalTo(self.mas_topLayoutGuide).offset(12);
	make.left.right.offset(0);
		make.height.offset(190).multipliedBy(UIScreen.mainScreen.bounds.size.width / 375.0);
}];
...
[self.bannerViewContent addSubview:self.bannerView];
[self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
	make.left.offset(-1.0);
	make.right.offset(1.0);
	make.top.bottom.offset(0);
}];
...
```


## 安装

使用 [CocoaPods](http://www.cocoapods.com/) 集成.
首先在podfile中
>`pod 'CHBannerView'`

安装一下pod

>`#import <CHBannerView/CHBannerViewHeader.h>`

## 更新记录

|版本|更新内容|
|:--|:--|
|0.4.0|优化拖拽回弹效果,新增自定义动画解决iOS[15.0,15.1)系统动画显示问题.|
|0.3.5|新增currentSelectItem属性,获取当前bannerView选中的item|
|0.3.4|修复showIndexWithoutScroll delegate方法|
|0.3.3|修复cancelShufflingInSingleItem属性|
|0.3.2|修复bounces状态下,边缘Cell滑动取消了Timer后不会重启Timer的问题|
|0.3.1|更改自定义计算Page方法.新增停止滚动时显示Item的方法.item无限重复时从何处开始布局的属性.是否允许手动滚动属性|
|0.3.0|统一.m内NSInteger与NSUInteger数据类型为NSInteger.区分一次滚动与无限滚动.新增了自定义滚动范围以及计算当前Page的delegate方法|
|0.2.4|支持iPad分屏模式|
|0.2.3|完全禁止使用`init`方法创建|
|0.2.2|修复iOS8下(iOS9以及iOS9以上没影响)不显示的Bug.cellForItemAtIndex代理方法有改动.详情请看注释|
|0.2.1|移除CHPageControl的支持,因为有朋友反馈说他们的pageControl已经高度自定制了,不需要多添加一个进去.|
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