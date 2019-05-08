//
//  CHBannerView.h
//  CHBannerCollectionView
//
//  Created by 张晨晖 on 2018/9/25.
//  Copyright © 2018 ChenhuiZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CHPageControl/CHPageControl.h>

@class CHBannerView;

@protocol CHBannerViewDataSource <NSObject>

@required
- (NSInteger)numberOfSectionsInBannerView:(CHBannerView *_Nonnull)bannerView;

- (UICollectionViewCell *_Nonnull)bannerView:(CHBannerView *_Nonnull)bannerView cellForItemAtIndex:(NSInteger)index;

@end

@protocol CHBannerViewDelegate <NSObject>

@optional
- (void)bannerView:(CHBannerView *_Nonnull)bannerView didSelectItemAtIndex:(NSInteger)index;

- (void)bannerView:(CHBannerView *_Nonnull)bannerView scrollToItemAtIndex:(NSInteger)index numberOfPages:(NSInteger)numberOfPages;

- (void)bannerView:(CHBannerView *_Nonnull)bannerView willDisplayCell:(UICollectionViewCell *_Nonnull)cell forItemAtIndex:(NSInteger)index NS_AVAILABLE_IOS(8_0);

@end

@interface CHBannerView : UIView

/// 初始化创建方法.
- (instancetype _Nonnull)initWithCollectionViewLayout:(UICollectionViewLayout * _Nullable)collectionViewLayout;

@property (nonatomic ,assign ,nullable) id <CHBannerViewDataSource> dataSource;

@property (nonatomic ,assign ,nullable) id <CHBannerViewDelegate> delegate;

/// 请不要设置该属性的DataSource与Delegate
@property (nonatomic, strong ,nullable) UICollectionView *collectionView;

/// 是否允许自动滚动,默认为YES
@property (nonatomic ,assign) BOOL shouldAutoScroll;

/// 在数据源个数为1的时候是否停止自动滚动,默认为NO
@property (nonatomic ,assign) BOOL stopAutoScrollInSingleItem;

/// 是否无限轮播,默认为YES
@property (nonatomic ,assign) BOOL shouldInfiniteShuffling;

/// 在个数为1的时候取消无限轮播,默认为NO
@property (nonatomic ,assign) BOOL cancelInfiniteShufflingInSingleItem;

/// 滚动时间间距
@property (nonatomic ,assign) CGFloat timeInterval;

/// 初始选中Item(默认是第一个:0)
@property (nonatomic ,assign) NSUInteger defaultSelectItem;

@property (nonatomic ,strong ,nullable) CHPageControl *pageControl;

/// 刷新数据
- (void)reloadData;

/// 开始Timer(内部判断了是否允许滚动)
- (void)startTimer;

/// 停止Timer
- (void)stopTimer;

// MARK:注册/获取单元格
- (void)registerClass:(Class _Nullable)cellClass forCellWithReuseIdentifier:(NSString *_Nonnull)identifier;

- (void)registerNib:(UINib *_Nullable)nib forCellWithReuseIdentifier:(NSString *_Nonnull)identifier;

- (__kindof UICollectionViewCell *_Nonnull)dequeueReusableCellWithReuseIdentifier:(NSString *_Nonnull)identifier forIndex:(NSInteger)index;

@end
