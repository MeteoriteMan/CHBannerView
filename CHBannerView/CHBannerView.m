//
//  CHBannerView.m
//  CHBannerCollectionView
//
//  Created by 张晨晖 on 2018/9/25.
//  Copyright © 2018 ChenhuiZhang. All rights reserved.
//

#import "CHBannerView.h"
#import "CHBannerCollectionViewFlowLayout.h"

#define kSeed ([self shouldInfiniteShuffling]?1000:1)

@interface CHBannerView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSTimer *timer;

/// 原始Item个数
@property (nonatomic ,assign) NSInteger originalItems;

@property (nonatomic ,assign) NSUInteger countPage;

/// 当前page,记录page位置,-1为初始化状态
@property (nonatomic ,assign) NSInteger currentPage;

@property (nonatomic ,assign) NSUInteger changeStatusBarPage;

@property (nonatomic ,assign) BOOL needsReload;

@property (nonatomic ,readonly ,strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation CHBannerView

/// MARK: getter
- (CGFloat)timeInterval {
    if (_timeInterval <= 0) {
        _timeInterval = 5;
    }
    return _timeInterval;
}

- (UICollectionViewFlowLayout *)flowLayout {
    return (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)collectionViewLayout {
    self = [super init];
    [self setupUIWithCollectionViewLayout:collectionViewLayout];
    return self;
}

- (void)setupUIWithCollectionViewLayout:(UICollectionViewLayout *)collectionViewLayout {
    self.currentPage = -1;
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
    [self setNeedsReload];
}

// MARK: UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfItemsInBannerView:)]) {
        self.originalItems = [self.dataSource numberOfItemsInBannerView:self];
        return [self.dataSource numberOfItemsInBannerView:self] * kSeed;
    } else {
        return 0;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(bannerView:cellForItemAtIndex:orignalIndex:)]) {
        return [self.dataSource bannerView:self cellForItemAtIndex:indexPath.item orignalIndex:indexPath.item % self.originalItems];
    }
    NSAssert(YES, @"没有注册单元格");
    return nil;
}

// MARK: UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:willDisplayCell:forItemAtIndex:)]) {
        [self.delegate bannerView:self willDisplayCell:cell forItemAtIndex:indexPath.row % self.originalItems];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:didSelectItemAtIndex:)]) {
        [self.delegate bannerView:self didSelectItemAtIndex:indexPath.item % self.originalItems];
    }
}

// MARK: UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        if (self.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            CGFloat offsetX = scrollView.contentOffset.x;
            CGFloat itemWidth = self.flowLayout.itemSize.width;
            self.countPage = (offsetX + (itemWidth + self.flowLayout.minimumLineSpacing) * .5) / (itemWidth + self.flowLayout.minimumLineSpacing);
        } else {
            CGFloat offsetY = scrollView.contentOffset.y;
            CGFloat itemHeight = self.flowLayout.itemSize.height;
            self.countPage = (offsetY + (itemHeight + self.flowLayout.minimumLineSpacing) * .5) / (itemHeight + self.flowLayout.minimumLineSpacing);
        }
        if (self.originalItems != 0) {
            if (self.currentPage != self.countPage % self.originalItems) {///如果当前page改变了
                self.currentPage = self.countPage % self.originalItems;
                if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:scrollToItemAtIndex:numberOfPages:)]) {
                    [self.delegate bannerView:self scrollToItemAtIndex:self.countPage % self.originalItems numberOfPages:self.originalItems];
                }
            }
        } else {//originalItems == 0
            if (self.currentPage == -1) {///初始状态
                self.currentPage = 0;
                if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:scrollToItemAtIndex:numberOfPages:)]) {
                    [self.delegate bannerView:self scrollToItemAtIndex:0 numberOfPages:0];
                }
            }
        }
        if (![self shouldInfiniteShuffling]) {
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
    NSInteger page = self.countPage;
    if ([self shouldInfiniteShuffling]) {//无限轮播到边界之后
        NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
        if (page == 0) {//
            NSInteger compute = self.originalItems;
            [self resetContentOffsetWithComputeItem:compute];
        } else if (page == cellCount - 1) {//
            [self resetContentOffsetWithComputeItem:-1];
        }
    }
    [self startTimer];
}

- (void)reloadData {
    self.currentPage = -1;
    [self stopTimer];
    [self.collectionView reloadData];
    [self.collectionView setNeedsLayout];
    [self.collectionView layoutIfNeeded];
    NSInteger compute = self.defaultSelectItem <= (self.originalItems - 1)?self.defaultSelectItem:0;
    [self resetContentOffsetWithComputeItem:compute];
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:scrollToItemAtIndex:numberOfPages:)]) {
        [self.delegate bannerView:self scrollToItemAtIndex:self.originalItems==0?-1:self.originalItems-1<self.defaultSelectItem?0:self.defaultSelectItem numberOfPages:self.originalItems];
    }
    [self startTimer];
    self.needsReload = NO;
}

/// 刷新数据
- (void)reloadDataIfNeeded {
    if (self.needsReload) {
        [self reloadData];
    }
}

- (void)setNeedsReload {
    self.needsReload = YES;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self reloadDataIfNeeded];
}

// MARK: Timer
- (void)startTimer {
    if ([self shouldAutoScroll]) {
        if ([self shouldInfiniteShuffling]) {
            if (self.originalItems != 0) {
                if ([self shouldAutoScroll]) {
                    [self buildTimer];
                }
            }
        } else {
            if (self.originalItems - 1 > (self.currentPage!=-1?self.currentPage:0)) {
                if ([self shouldAutoScroll]) {
                    [self buildTimer];
                }
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
    if (self.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        CGFloat itemWidth = self.flowLayout.itemSize.width;
        CGPoint contentOffset = self.collectionView.contentOffset;
        CGFloat decimals = contentOffset.x - self.countPage * itemWidth - (self.countPage - 1) * self.flowLayout.minimumLineSpacing;
        while (decimals > itemWidth + self.flowLayout.minimumLineSpacing) {
            decimals -= itemWidth;
            decimals -= self.flowLayout.minimumLineSpacing;
        }
        [self.collectionView setContentOffset:CGPointMake(contentOffset.x - decimals + itemWidth + self.flowLayout.minimumLineSpacing, 0) animated:YES];
    } else {
        CGFloat itemHeight = self.flowLayout.itemSize.height;
        CGPoint contentOffset = self.collectionView.contentOffset;
        CGFloat decimals = contentOffset.y - self.countPage * itemHeight - (self.countPage - 1) * self.flowLayout.minimumLineSpacing;
        while (decimals > itemHeight + self.flowLayout.minimumLineSpacing) {
            decimals -= itemHeight;
            decimals -= self.flowLayout.minimumLineSpacing;
        }
        [self.collectionView setContentOffset:CGPointMake(0, contentOffset.y - decimals + itemHeight + self.flowLayout.minimumLineSpacing) animated:YES];
    }
}

/**
 通过给定的Item设置contentOffset

 @param compute 当前中间显示的Item
 */
- (void)resetContentOffsetWithComputeItem:(NSInteger)compute {
    if (self.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        CGFloat computeWidth = compute * (self.flowLayout.itemSize.width + self.flowLayout.minimumLineSpacing);
        if ([self shouldInfiniteShuffling]) {
            self.collectionView.contentOffset = CGPointMake(self.flowLayout.itemSize.width * self.originalItems * kSeed * .5 + computeWidth + (self.originalItems * kSeed * .5) * self.flowLayout.minimumLineSpacing, 0);
        } else {
            self.collectionView.contentOffset = CGPointMake(computeWidth, 0);
        }
    } else {
        CGFloat computeHeight = compute * (self.flowLayout.itemSize.height + self.flowLayout.minimumLineSpacing);
        if ([self shouldInfiniteShuffling]) {
            self.collectionView.contentOffset = CGPointMake(0, self.flowLayout.itemSize.height * self.originalItems * kSeed * .5 + computeHeight + (self.originalItems * kSeed * .5) * self.flowLayout.minimumLineSpacing);
        } else {
            self.collectionView.contentOffset = CGPointMake(0, computeHeight);
        }
    }

}

- (void)applicationWillChangeStatusBarOrientationNotification:(NSNotification *)notification {
    [self stopTimer];
    self.changeStatusBarPage = self.currentPage<0?0:self.currentPage;
}

- (void)applicationDidChangeStatusBarOrientationNotification:(NSNotification *)notification {
    [self.collectionView reloadData];
    [self layoutIfNeeded];
    [self resetContentOffsetWithComputeItem:self.changeStatusBarPage];
    [self startTimer];
}

/// 是否允许自动滚动
- (BOOL)shouldAutoScroll {
    if (_shouldAutoScroll == NO) {
        return NO;
    }
    if (self.originalItems == 1 && self.stopAutoScrollInSingleItem) {
        return NO;
    } else {
        return YES;
    }
}

/// 是否允许无限轮播
- (BOOL)shouldInfiniteShuffling {
    if (_shouldInfiniteShuffling == NO) {
        return NO;
    }
    if (self.originalItems == 1 && self.cancelInfiniteShufflingInSingleItem) {
        return NO;
    } else {
        return YES;
    }
}

- (void)didMoveToSuperview {
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        [self ch_viewController].automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    [self stopTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

// MARK:注册/获取单元格
- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier {
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
}

- (UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index {
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}

- (UIViewController *)ch_viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
