//
//  CHGuideView.m
//  CHBannerView-Demo
//
//  Created by ChenhuiZhang on 2020/9/2.
//  Copyright © 2020 张晨晖. All rights reserved.
//

#import "CHGuideView.h"
#import "CHBannerView.h"
#import "GuideViewFlowLayout.h"
#import "CHBannerCollectionViewCell.h"

@interface CHGuideView () <CHBannerViewDataSource ,CHBannerViewDelegate>

@property (nonatomic ,strong) CHBannerView *bannerView;

@property (nonatomic ,strong) UIPageControl *pageControl;

@property (nonatomic ,strong) NSArray <NSObject *> *bannerModelArray;

@property (nonatomic ,strong) UIButton *buttonExit;

@end

@implementation CHGuideView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupConfig];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    GuideViewFlowLayout *flowLayout = [[GuideViewFlowLayout alloc] init];
    self.bannerView = [[CHBannerView alloc] initWithCollectionViewLayout:flowLayout];
    self.bannerView.dataSource = self;
    self.bannerView.delegate = self;
    self.bannerView.shouldItemInfinite = NO;
    self.bannerView.shouldShuffling = NO;
    
    self.bannerView.shouldAutoScroll = NO;
    self.bannerView.bounces = NO;
    
    [self addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    [self.bannerView registerClass:[CHBannerCollectionViewCell class] forCellWithReuseIdentifier:@"CHBannerCollectionViewCellID"];
 
    self.pageControl = [[UIPageControl alloc] init];
    [self addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-12);
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(-12);
        } else {
            // Fallback on earlier versions
            make.bottom.equalTo(self.mas_bottom).offset(-8);
            make.right.equalTo(self.mas_right).offset(-8);
        }
    }];
    
    self.buttonExit = [UIButton new];
    [self addSubview:self.buttonExit];
    [self.buttonExit mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(8);
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(-8);
        } else {
            // Fallback on earlier versions
            make.top.equalTo(self.mas_top).offset(8);
            make.right.equalTo(self.mas_right).offset(-8);
        }
    }];
    [self.buttonExit setTitle:@"Exit" forState:UIControlStateNormal];
    [self.buttonExit setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.buttonExit.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    self.buttonExit.layer.masksToBounds = YES;
    self.buttonExit.contentEdgeInsets = UIEdgeInsetsMake(8, 12, 8, 12);
    [self.buttonExit addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupConfig {
    NSInteger count = arc4random_uniform(10);
    NSMutableArray *arrayM = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        [arrayM addObject:[[NSObject alloc] init]];
    }
    self.bannerModelArray = arrayM.copy;
    self.pageControl.numberOfPages = self.bannerModelArray.count;
    [self.bannerView reloadData];
}

- (NSInteger)numberOfItemsInBannerView:(CHBannerView *)bannerView {
    return self.bannerModelArray.count;
}

- (UICollectionViewCell *)bannerView:(CHBannerView *)bannerView cellForItemAtIndex:(NSInteger)index orignalIndex:(NSInteger)orignalIndex {
    CHBannerCollectionViewCell *cell = [bannerView dequeueReusableCellWithReuseIdentifier:@"CHBannerCollectionViewCellID" forIndex:index];
    return cell;

}

- (void)bannerView:(CHBannerView *)bannerView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndex:(NSInteger)index {
    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1];
    ((CHBannerCollectionViewCell *)cell).titleStr = [NSString stringWithFormat:@"%@",@(index)];
}

- (void)bannerView:(UICollectionView *)collectionView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"点击的是第%ld页",index);
}

- (void)bannerView:(UICollectionView *)collectionView scrollToItemAtIndex:(NSInteger)index numberOfPages:(NSInteger)numberOfPages {
//    self.navigationItem.title = [NSString stringWithFormat:@"%ld/%ld", index + 1, numberOfPages];
    self.pageControl.currentPage = index;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.buttonExit.layer.cornerRadius = self.buttonExit.bounds.size.height * .5;
}

- (void)show {
    self.alpha = 0.0;
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [UIView animateWithDuration:.25 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
//    [UIView animateWithDuration:.25 animations:^{
//        self.alpha = 1.0;
//    }];
}

- (void)dismiss {
//    [UIView animateWithDuration:.25 animations:^{
//        self.alpha = 0.0;
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//    }];
    [UIView animateWithDuration:.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
