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

/// 当前page,记录page位置,-1为初始化状态
@property (nonatomic ,assign) NSInteger currentPage;

@property (nonatomic ,assign) NSUInteger changeStatusBarPage;

@end

@implementation CHBannerView

/// MARK: getter
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
    ///
    self.currentPage = -1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillChangeStatusBarOrientationNotification:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidChangeStatusBarOrientationNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    self.shouldAutoScroll = YES;
    self.shouldInfiniteShuffling = YES;
    if (!collectionViewLayout) {
        collectionViewLayout = [[CHBannerCollectionViewFlowLayout alloc] init];
    }
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionViewLayout];
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
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
    self.pageControl.userInteractionEnabled = NO;
    [self addSubview:self.pageControl];
    self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[
                                       [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
                                       [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-4],
                                       [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:0 constant:4]
                                       ]];

}

// MARK: UICollectionViewDataSource
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

// MARK: UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:didSelectItemAtIndex:)]) {
        [self.delegate bannerView:collectionView didSelectItemAtIndex:indexPath.item % self.originalItems];
    }
}

// MARK: UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        CGFloat offsetX = scrollView.contentOffset.x;
        CGFloat itemWidth = flowLayout.itemSize.width;
        self.countPage = (offsetX + itemWidth * .5) / itemWidth;
        if (self.originalItems != 0) {
            if (self.currentPage != self.countPage % self.originalItems) {///如果当前page改变了
                self.currentPage = self.countPage % self.originalItems;
                self.pageControl.currentPage = self.currentPage;
                if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:scrollToItemAtIndex:numberOfPages:)]) {
                    [self.delegate bannerView:self.collectionView scrollToItemAtIndex:self.countPage % self.originalItems numberOfPages:self.originalItems];
                }
            }
        } else {//originalItems == 0
            if (self.currentPage == -1) {///初始状态
                self.currentPage = 0;
                self.pageControl.currentPage = self.currentPage;
                if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:scrollToItemAtIndex:numberOfPages:)]) {
                    [self.delegate bannerView:self.collectionView scrollToItemAtIndex:0 numberOfPages:0];
                }
            }
        }
        if (self.shouldInfiniteShuffling == NO) {
            if (self.originalItems - 1 >= self.currentPage) {//最后一页
                [self stopTimer];
            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {///开始手动滑动
    if (scrollView == self.collectionView) {
        [self stopTimer];
    }
}

/// ScrollView停止滚动动画
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        [self scrollViewDidEndScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        // 停止类型3
        BOOL stop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
        if (stop) {
            [self scrollViewDidEndScroll];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 停止类型1、停止类型2
    BOOL stop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (stop) {
        [self scrollViewDidEndScroll];
    }
}

/// MARK: scrollView停止滚动(user.是否是用户操作的)
- (void)scrollViewDidEndScroll {
    CGFloat offsetX = self.collectionView.contentOffset.x;
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
    [self startTimer];
}

- (void)reloadData {
    self.currentPage = -1;
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat width = flowLayout.itemSize.width;
    NSInteger compute = self.defaultSelectItem <= (self.originalItems - 1)?self.defaultSelectItem:(self.originalItems - 1);
    CGFloat computeWidth = width * compute;
    if (self.shouldInfiniteShuffling) {
        self.collectionView.contentOffset = CGPointMake(flowLayout.itemSize.width * self.originalItems * kSeed * .5 + computeWidth, 0);
    } else {
        self.collectionView.contentOffset = CGPointMake(computeWidth, 0);
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:scrollToItemAtIndex:numberOfPages:)]) {
        [self.delegate bannerView:self.collectionView scrollToItemAtIndex:self.originalItems==0?-1:self.defaultSelectItem numberOfPages:self.originalItems];
    }
    [self startTimer];
}

// MARK: Timer
- (void)startTimer {
    if (self.shouldAutoScroll) {
        if (self.shouldInfiniteShuffling == YES) {
            if (self.originalItems != 0) {
                [self buildTimer];
            }
        } else {
            if (self.originalItems - 1 > (self.currentPage!=-1?self.currentPage:0)) {
                [self buildTimer];
            }
        }
    }
}

- (void)buildTimer {
    if (self.timer) {
        [self stopTimer];
    }
    self.timer = [NSTimer timerWithTimeInterval:self.timeInterval target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
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

- (void)applicationWillChangeStatusBarOrientationNotification:(NSNotification *)notification {
    self.changeStatusBarPage = self.currentPage<0?0:self.currentPage;
}

- (void)applicationDidChangeStatusBarOrientationNotification:(NSNotification *)notification {
    [self.collectionView reloadData];
    [self layoutIfNeeded];
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat width = flowLayout.itemSize.width;
    CGFloat computeWidth = width * self.changeStatusBarPage;
    if (self.shouldInfiniteShuffling) {
        self.collectionView.contentOffset = CGPointMake(flowLayout.itemSize.width * self.originalItems * kSeed * .5 + computeWidth, 0);
    } else {
        self.collectionView.contentOffset = CGPointMake(computeWidth, 0);
    }
//    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
//    [self.collectionView scrollRectToVisible:CGRectMake(flowLayout.itemSize.width * self.changeStatusBarPage, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height) animated:NO];
//    CGFloat itemWidth = flowLayout.itemSize.width;
//    CGPoint contentOffset = self.collectionView.contentOffset;
//    CGFloat decimals = contentOffset.x - self.changeStatusBarPage * itemWidth;
//    while (decimals > itemWidth) {
//        decimals -= itemWidth;
//    }
//    [self.collectionView setContentOffset:CGPointMake(contentOffset.x - decimals , 0) animated:NO];
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    [self stopTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

@end
