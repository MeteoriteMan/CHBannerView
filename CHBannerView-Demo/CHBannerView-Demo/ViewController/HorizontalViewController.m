//
//  HorizontalViewController.m
//  CHBannerView-Demo
//
//  Created by 张晨晖 on 2023/1/2.
//  Copyright © 2023 张晨晖. All rights reserved.
//

#import "HorizontalViewController.h"
#import "HorizontalCollectionViewFlowLayout.h"
#import "CHBannerCollectionViewCell.h"

@interface HorizontalViewController () <CHBannerViewDataSource ,CHBannerViewDelegate>

@property (nonatomic ,strong) UIView *bannerViewContent;

@property (nonatomic ,strong) CHBannerView *bannerView;

@property (nonatomic ,strong) NSArray <NSObject *> *bannerModelArray;

@property (nonatomic ,strong) UIButton *buttonReload;

@end

@implementation HorizontalViewController

static NSString *CHBannerCollectionViewCellID = @"CHBannerCollectionViewCellID";

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
            NSInteger defaultSelectItem = 0;
            if (self.bannerView.currentSelectItem < self.bannerModelArray.count) {
                defaultSelectItem = self.bannerView.currentSelectItem;
            } else {
                defaultSelectItem = self.bannerModelArray.count - 1;
            }
            self.bannerView.defaultSelectItem = defaultSelectItem;
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
    
    self.bannerViewContent = [UIView new];
    self.bannerViewContent.clipsToBounds = YES;
    [self.view addSubview:self.bannerViewContent];
    [self.bannerViewContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(12);
        make.left.right.offset(0);
        make.height.offset(190).multipliedBy(UIScreen.mainScreen.bounds.size.width / 375.0);
    }];
    
    HorizontalCollectionViewFlowLayout *flowLayout = [[HorizontalCollectionViewFlowLayout alloc] init];
    self.bannerView = [[CHBannerView alloc] initWithCollectionViewLayout:flowLayout];
    self.bannerView.dataSource = self;
    self.bannerView.delegate = self;
    self.bannerView.timeInterval = 2;
    if (@available(iOS 15.1, *)) {
        self.bannerView.scrollAnimationOption = CHBannerViewAnimationOptionCurveLinear;
    } else if (@available(iOS 15.0, *)) {
        self.bannerView.scrollAnimationOption = CHBannerViewAnimationNone;
    } else {
        self.bannerView.scrollAnimationOption = CHBannerViewAnimationOptionCurveLinear;
    }
    [self.bannerViewContent addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(-1.0);
        make.right.offset(1.0);
        make.top.bottom.offset(0);
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
    self.navigationItem.title = [NSString stringWithFormat:@"%ld/%ld", index + 1, numberOfPages];
}

// Action
- (void)pushClick {
    [self.navigationController pushViewController:[[[self class] alloc] init] animated:YES];
}

@end
