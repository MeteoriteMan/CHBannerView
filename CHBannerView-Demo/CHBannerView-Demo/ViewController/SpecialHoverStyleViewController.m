//
//  SpecialHoverStyleViewController.m
//  CHBannerView-Demo
//
//  Created by ChenhuiZhang on 2020/9/4.
//  Copyright © 2020 张晨晖. All rights reserved.
//

#import "SpecialHoverStyleViewController.h"
#import "CHBannerCollectionViewCell.h"
#import "SpecialHoverStyleFlowLayout.h"
#import <Masonry/Masonry.h>

@interface SpecialHoverStyleViewController () <CHBannerViewDataSource ,CHBannerViewDelegate>

@property (nonatomic ,strong) CHBannerView *bannerView;

@property (nonatomic ,strong) NSArray <NSObject *> *bannerModelArray;

@property (nonatomic ,strong) UIButton *buttonReload;

@end

@implementation SpecialHoverStyleViewController

- (void)loadData {
    [[GlobalProgressHUD progressHUD] showProgress];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * GrobalProgressAnimatedTime), dispatch_get_main_queue(), ^{
            NSInteger count = arc4random_uniform(10);
            NSMutableArray *arrayM = [NSMutableArray array];
            for (int i = 0; i < count; i++) {
                [arrayM addObject:[[NSObject alloc] init]];
            }
            self.bannerModelArray = arrayM.copy;
            [self.bannerView reloadData];
            [[GlobalProgressHUD progressHUD] hideProgress];
        });
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"push" style:UIBarButtonItemStylePlain target:self action:@selector(pushClick)];
    [self.bannerView startTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.bannerView stopTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.bannerView = [[CHBannerView alloc] initWithCollectionViewLayout:[[SpecialHoverStyleFlowLayout alloc] init]];
    self.bannerView.dataSource = self;
    self.bannerView.delegate = self;
    self.bannerView.timeInterval = 2;
    self.bannerView.shouldItemInfinite = NO;
    self.bannerView.shouldShuffling = YES;
    self.bannerView.shouldAutoScroll = YES;
    
    [self.view addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(12);
        make.left.right.offset(0);
        make.height.offset(190).multipliedBy(UIScreen.mainScreen.bounds.size.width / 375.0);
    }];

    [self.bannerView registerClass:[CHBannerCollectionViewCell class] forCellWithReuseIdentifier:@"CHBannerCollectionViewCellID"];

    self.buttonReload = [UIButton new];
    [self.buttonReload setTitle:@"reloadData" forState:UIControlStateNormal];
    [self.buttonReload setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.view addSubview:self.buttonReload];
    [self.buttonReload mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottomLayoutGuide).offset(-12);
        make.centerX.equalTo(self.view);
    }];

    [self.buttonReload addTarget:self action:@selector(loadData) forControlEvents:UIControlEventTouchUpInside];

    [self loadData];
}

// MARK: CHBannerView DataSource

- (NSInteger)numberOfItemsInBannerView:(CHBannerView *)bannerView {
    return self.bannerModelArray.count;
}

- (UICollectionViewCell *)bannerView:(CHBannerView *)bannerView cellForItemAtIndex:(NSInteger)index orignalIndex:(NSInteger)orignalIndex {
    CHBannerCollectionViewCell *cell = [bannerView dequeueReusableCellWithReuseIdentifier:@"CHBannerCollectionViewCellID" forIndex:index];
    return cell;

}

// MARK: CHBannerView Delegate

- (void)bannerView:(CHBannerView *)bannerView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndex:(NSInteger)index {
    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1];
    ((CHBannerCollectionViewCell *)cell).titleStr = [NSString stringWithFormat:@"%@",@(index)];
}

- (void)bannerView:(UICollectionView *)collectionView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"点击的是第%ld页",index);
}

- (void)bannerView:(UICollectionView *)collectionView scrollToItemAtIndex:(NSInteger)index numberOfPages:(NSInteger)numberOfPages {
    self.navigationItem.title = [NSString stringWithFormat:@"%ld/%ld", index + 1, numberOfPages];
}

- (NSInteger)bannerView:(CHBannerView *)bannerView currentPageForScrollView:(UIScrollView * _Nonnull)scrollView flowLayout:(UICollectionViewFlowLayout * _Nonnull)flowLayout {
    
    CGFloat headerReferenceWidth = flowLayout.headerReferenceSize.width;
    CGFloat minimumLineSpacing = flowLayout.minimumLineSpacing;
    CGFloat itemWidth = flowLayout.itemSize.width;
    
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    NSInteger currentPage = (contentOffsetX - headerReferenceWidth + scrollView.bounds.size.width * .5 + minimumLineSpacing * .5) / (itemWidth + minimumLineSpacing);
    if (currentPage < 0) {
        currentPage = 0;
    } else if (currentPage >= self.bannerModelArray.count) {
        currentPage = self.bannerModelArray.count - 1;
    }
    
    return currentPage;
}

- (CGPoint)bannerView:(CHBannerView *)bannerView nextHoverPointForScrollView:(UIScrollView * _Nonnull)scrollView currentPage:(NSInteger)currentPage flowLayout:(UICollectionViewFlowLayout * _Nonnull)flowLayout numberOfPages:(NSInteger)numberOfPages {
    NSInteger nextPage = (currentPage + 1)<=(numberOfPages-1)?(currentPage+1):0;
    if (nextPage == 0) {
        return CGPointMake(0.0, 0.0);
    } else if (nextPage == numberOfPages - 1) {// MARK: 目前是最后一个Item
        CGFloat contentOffsetX = scrollView.contentSize.width - scrollView.bounds.size.width;
        return CGPointMake(contentOffsetX, 0.0);
    } else {// 中间
        CGFloat contentOffsetX = nextPage * flowLayout.itemSize.width + currentPage * flowLayout.minimumLineSpacing + flowLayout.headerReferenceSize.width - flowLayout.minimumLineSpacing;
        return CGPointMake(contentOffsetX, 0.0);
    }
}

// Action
- (void)pushClick {
    [self.navigationController pushViewController:[[[self class] alloc] init] animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
