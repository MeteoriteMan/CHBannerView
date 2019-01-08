//
//  CHBannerView.m
//  CHBannerCollectionView
//
//  Created by 张晨晖 on 2018/9/25.
//  Copyright © 2018 ChenhuiZhang. All rights reserved.
//

#import "CHBannerView.h"
#import "CHBannerCollectionViewFlowLayout.h"

#define kSeed (self.shouldInfiniteShuffling?1000:1)

@interface CHBannerView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic ,assign) BOOL isScrolling;

/// 原始Item个数
@property (nonatomic ,assign) NSInteger originalItems;

@property (nonatomic ,assign) NSUInteger countPage;

@end

@implementation CHBannerView

- (CGFloat)timeInterval {
    if (_timeInterval <= 0) {
        _timeInterval = 5;
    }
    return _timeInterval;
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)collectionViewLayout {
    self = [super init];
    [self setupUIWithCollectionViewLayout:collectionViewLayout];
    return self;
}

- (void)setupUIWithCollectionViewLayout:(UICollectionViewLayout *)collectionViewLayout {
    /// 应用回到前台监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillChangeStatusBarOrientationNotification:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidChangeStatusBarOrientationNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    self.shouldAutoScroll = YES;
    self.shouldInfiniteShuffling = YES;
    if (!collectionViewLayout) {
        collectionViewLayout = [[CHBannerCollectionViewFlowLayout alloc] init];
    }
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionViewLayout];
        self.collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.collectionView.pagingEnabled = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[
                                          [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0],
                                          [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0],
                                          [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]
                                          ,[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]
                                          ]];

    self.pageControl = [[CHPageControl alloc] init];
    self.pageControl.currentPage = 2;
    self.pageControl.userInteractionEnabled = NO;
    [self addSubview:self.pageControl];
    self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[
                                       [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
                                       [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-4],
                                       [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:0 constant:4]
                                       ]];

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        self.timer.fireDate = [NSDate distantFuture];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == self.collectionView) {
        self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:self.timeInterval];
    }
}

- (void)updateTimer {
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat itemWidth = flowLayout.itemSize.width;
    CGPoint contentOffset = self.collectionView.contentOffset;
    CGFloat decimals = contentOffset.x - self.countPage * itemWidth;
    while (decimals > itemWidth) {
        decimals -= itemWidth;
    }
    [self.collectionView setContentOffset:CGPointMake(contentOffset.x - decimals + itemWidth , 0) animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:numberOfItemsInSection:)]) {
        self.originalItems = [self.delegate bannerView:collectionView numberOfItemsInSection:section];
        self.pageControl.numberOfPages = self.originalItems;
        return [self.delegate bannerView:collectionView numberOfItemsInSection:section] * kSeed;
    } else {
        return 0;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:cellForItemAtIndex:)]) {
        return [self.delegate bannerView:collectionView cellForItemAtIndex:indexPath.item % self.originalItems];
    }
    NSAssert(YES, @"没有注册单元格");
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:didSelectItemAtIndex:)]) {
        [self.delegate bannerView:collectionView didSelectItemAtIndex:indexPath.item % self.originalItems];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        CGFloat offsetX = scrollView.contentOffset.x;
        CGFloat itemWidth = flowLayout.itemSize.width;
        self.countPage = (offsetX + itemWidth * .5) / itemWidth;
        if (self.originalItems != 0) {
            self.pageControl.currentPage = self.countPage % self.originalItems;
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        CGFloat offsetX = scrollView.contentOffset.x;
        CGFloat itemWidth = self.collectionView.bounds.size.width;
        NSInteger page = offsetX / self.bounds.size.width;
        if (self.shouldInfiniteShuffling) {
            NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
            if (page == 0) {
                self.collectionView.contentOffset = CGPointMake(offsetX + self.originalItems * itemWidth * kSeed, 0);
            } else if (page == cellCount - 1) {
                self.collectionView.contentOffset = CGPointMake(offsetX - self.originalItems * itemWidth * kSeed, 0);
            }
        }
    }
}

- (void)reloadData {
    [self.collectionView reloadData];
    if (self.shouldInfiniteShuffling) {
        [self.collectionView layoutIfNeeded];
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        self.collectionView.contentOffset = CGPointMake(flowLayout.itemSize.width * self.originalItems * kSeed * .5, 0);
    } else {
        self.collectionView.contentOffset = CGPointMake(0, 0);
    }
    [self invalidateTimer];
    if (self.shouldAutoScroll) {
        [self buildTimer];
    }
}

- (void)buildTimer {
    if (!self.timer) {
        self.timer = [NSTimer timerWithTimeInterval:self.timeInterval target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)invalidateTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)applicationDidBecomeActive {
    [self invalidateTimer];
    if (self.shouldAutoScroll) {
        [self buildTimer];
    }
}

- (void)applicationWillChangeStatusBarOrientationNotification:(NSNotification *)notification {

}

- (void)applicationDidChangeStatusBarOrientationNotification:(NSNotification *)notification {
    [self layoutIfNeeded];
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    [self.collectionView scrollRectToVisible:CGRectMake(flowLayout.itemSize.width * self.countPage, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height) animated:NO];
    CGFloat itemWidth = flowLayout.itemSize.width;
    CGPoint contentOffset = self.collectionView.contentOffset;
    CGFloat decimals = contentOffset.x - self.countPage * itemWidth;
    while (decimals > itemWidth) {
        decimals -= itemWidth;
    }
    [self.collectionView setContentOffset:CGPointMake(contentOffset.x - decimals , 0) animated:NO];
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    [self invalidateTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

@end
