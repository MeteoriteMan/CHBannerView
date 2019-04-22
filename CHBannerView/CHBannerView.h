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
- (NSInteger)numberOfSectionsInBannerView:(CHBannerView *)bannerView;

- (UICollectionViewCell *)bannerView:(CHBannerView *)bannerView cellForItemAtIndex:(NSInteger)index;

@end

@protocol CHBannerViewDelegate <NSObject>

@optional
- (void)bannerView:(CHBannerView *)bannerView didSelectItemAtIndex:(NSInteger)index;

- (void)bannerView:(CHBannerView *)bannerView scrollToItemAtIndex:(NSInteger)index numberOfPages:(NSInteger)numberOfPages;

@end

@interface CHBannerView : UIView

/// 初始化创建方法.
- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)collectionViewLayout;

@property (nonatomic ,assign) id <CHBannerViewDataSource> dataSource;

@property (nonatomic ,assign) id <CHBannerViewDelegate> delegate;

@property (nonatomic, strong) UICollectionView *collectionView;

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

@property (nonatomic ,strong) CHPageControl *pageControl;

/// 刷新数据
- (void)reloadData;

/// 开始Timer(内部判断了是否允许滚动)
- (void)startTimer;

/// 停止Timer
- (void)stopTimer;


// MARK:注册/获取单元格
- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;

- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;

- (__kindof UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index;

@end
