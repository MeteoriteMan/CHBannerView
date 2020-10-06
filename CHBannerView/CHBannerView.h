//
//  CHBannerView.h
//  CHBannerCollectionView
//
//  Created by 张晨晖 on 2018/9/25.
//  Copyright © 2018 ChenhuiZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CHBannerViewItemInfiniteLoadingMode) {
    CHBannerViewItemInfiniteLoadingModeMiddle,
    CHBannerViewItemInfiniteLoadingModeLeft,
};

@class CHBannerView;

@protocol CHBannerViewDataSource <NSObject>

@required

- (NSInteger)numberOfItemsInBannerView:(CHBannerView *_Nonnull)bannerView;

/**
 获取当前Cell.getCurrentCell

 @param bannerView bannerView
 @param index 调用取cell的index
 @param orignalIndex 数据源对应的index
 @return collectionViewCell
 */
- (UICollectionViewCell *_Nonnull)bannerView:(CHBannerView *_Nonnull)bannerView cellForItemAtIndex:(NSInteger)index orignalIndex:(NSInteger)orignalIndex;

@end

@protocol CHBannerViewDelegate <NSObject>

@optional

/// 选中事件以及将要显示Cell
- (void)bannerView:(CHBannerView *_Nonnull)bannerView didSelectItemAtIndex:(NSInteger)index;

/// 当前滚动到的Item
- (void)bannerView:(CHBannerView *_Nonnull)bannerView scrollToItemAtIndex:(NSInteger)index numberOfPages:(NSInteger)numberOfPages;

/// 将要显示的Cell
- (void)bannerView:(CHBannerView *_Nonnull)bannerView willDisplayCell:(UICollectionViewCell *_Nonnull)cell forItemAtIndex:(NSInteger)index NS_AVAILABLE_IOS(8_0);

/// 自定义计算当前Page.(分页位置)
/// @param numberOfPages 计算用整个Pages(非dataSourcePage)
- (NSInteger)bannerView:(CHBannerView *_Nonnull)bannerView currentPageForScrollView:(UIScrollView *_Nonnull)scrollView flowLayout:(UICollectionViewFlowLayout *_Nonnull)flowLayout numberOfPages:(NSInteger)numberOfPages;

/// 悬停位置代理
/// @param bannerView bannerView
/// @param scrollView 轮播图容器
/// @param currentPage 计算用当前Page(非dataSourcePage)
/// @param flowLayout flowLayout
/// @param numberOfPages 计算用整个Pages(非dataSourcePage)
- (CGPoint)bannerView:(CHBannerView *_Nonnull)bannerView nextHoverPointForScrollView:(UIScrollView *_Nonnull)scrollView currentPage:(NSInteger)currentPage flowLayout:(UICollectionViewFlowLayout *_Nonnull)flowLayout numberOfPages:(NSInteger)numberOfPages;

/// 停止滚动时显示的Item
/// @param bannerView bannerView
/// @param index 停止的Page
/// @param orignalIndex 数据源对应的orignalIndex
- (void)bannerView:(CHBannerView *_Nonnull)bannerView showIndexWithoutScroll:(NSInteger)index orignalIndex:(NSInteger)orignalIndex;

@end

@interface CHBannerView : UIView

/// 初始化创建方法.
- (instancetype _Nonnull)initWithCollectionViewLayout:(UICollectionViewLayout * _Nullable)collectionViewLayout;

@property (nonatomic ,assign ,nullable) id <CHBannerViewDataSource> dataSource;

@property (nonatomic ,assign ,nullable) id <CHBannerViewDelegate> delegate;

#pragma mark property

/// 是否允许自动滚动,默认为YES
@property (nonatomic ,assign) BOOL shouldAutoScroll;

/// 在数据源个数为1的时候是否停止自动滚动,默认为NO
@property (nonatomic ,assign) BOOL stopAutoScrollInSingleItem;

/// item是否无限,默认为YES.为NO时,当展示第一个item时,左边无item
@property (nonatomic ,assign) BOOL shouldItemInfinite;

/// shouldItemInfinite为YES时的从哪里开始布局.默认从中间
@property (nonatomic ,assign) CHBannerViewItemInfiniteLoadingMode itemInfiniteLoadingMode;

/// 不停轮播,默认为YES.当一轮滚动完了后不再滚动,设置为NO.
@property (nonatomic ,assign) BOOL shouldShuffling;

/// 在个数为1的时候取消无限轮播,默认为NO
@property (nonatomic ,assign) BOOL cancelShufflingInSingleItem;

/// 滚动时间间隔.默认5s
@property (nonatomic ,assign) NSTimeInterval timeInterval;

/// 初始选中Item(默认是第一个:0)
@property (nonatomic ,assign) NSInteger defaultSelectItem;

/// BannerViewd的Bounces效果.默认为YES
@property (nonatomic ,assign) BOOL bounces;

/// 是否允许滚动
@property (nonatomic ,assign) BOOL scrollEnable;

/// 减速速度.范围0~1.0
@property(nonatomic , assign) UIScrollViewDecelerationRate decelerationRate API_AVAILABLE(ios(3.0));

/// 当前显示的Item的indexPaths
@property (nonatomic, readonly) NSArray<NSIndexPath *> * _Nullable indexPathsForVisibleItems;

- (nullable UICollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *_Nonnull)indexPath;

#pragma mark reloadData

/// 刷新数据
- (void)reloadData;

#pragma mark Timer

/// 开始Timer(内部判断了是否允许滚动)
- (void)startTimer;

/// 停止Timer
- (void)stopTimer;

#pragma mark RegisterItem

// MARK:注册/获取单元格
- (void)registerClass:(Class _Nullable)cellClass forCellWithReuseIdentifier:(NSString *_Nonnull)identifier;

- (void)registerNib:(UINib *_Nullable)nib forCellWithReuseIdentifier:(NSString *_Nonnull)identifier;

- (__kindof UICollectionViewCell *_Nonnull)dequeueReusableCellWithReuseIdentifier:(NSString *_Nonnull)identifier forIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
