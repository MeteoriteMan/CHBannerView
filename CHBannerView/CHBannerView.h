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
@protocol CHBannerViewDelegate <NSObject>

@required
- (NSInteger)bannerView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;

- (UICollectionViewCell *)bannerView:(UICollectionView *)collectionView cellForItemAtIndex:(NSInteger)index;

@optional
- (void)bannerView:(UICollectionView *)collectionView didSelectItemAtIndex:(NSInteger)index;

- (void)bannerView:(UICollectionView *)collectionView scrollToItemAtIndex:(NSInteger)index;

@end

@interface CHBannerView : UIView

/// 初始化创建方法.
- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)collectionViewLayout;

@property (nonatomic, strong) UICollectionView *collectionView;

/// 是否允许自动滚动,默认为YES
@property (nonatomic ,assign) BOOL shouldAutoScroll;

/// 是否无限轮播,默认为YES
@property (nonatomic ,assign) BOOL shouldInfiniteShuffling;

/// 滚动时间间距
@property (nonatomic ,assign) CGFloat timeInterval;

@property (nonatomic ,strong) CHPageControl *pageControl;

@property (nonatomic ,assign) id <CHBannerViewDelegate> delegate;

/// 刷新数据
- (void)reloadData;

@end
