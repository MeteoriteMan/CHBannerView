//
//  ViewController.m
//  CHBannerView-Demo
//
//  Created by 张晨晖 on 2019/1/4.
//  Copyright © 2019 张晨晖. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "CHBannerView.h"
#import "CHBannerCollectionViewCell.h"
#import "CollectionViewFlowLayout.h"
#import "CHBannerCollectionViewFlowLayout.h"
#import "CHBannerCollectionViewFlowLayout3DStyle.h"

@interface ViewController () <CHBannerViewDelegate>

@property (nonatomic ,strong) CHBannerView *bannerView;

@property (nonatomic ,strong) NSArray <NSObject *> *bannerModelArray;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = [NSString stringWithFormat:@"%@" ,@(self.navigationController.viewControllers.count)];
    [self.bannerView startTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.bannerView stopTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.view.backgroundColor = [UIColor whiteColor];

    self.automaticallyAdjustsScrollViewInsets = NO;

//    CHBannerCollectionViewFlowLayout3DStyle *flowLayout = [[CHBannerCollectionViewFlowLayout3DStyle alloc] init];
    self.bannerView = [[CHBannerView alloc] initWithCollectionViewLayout:nil];
    self.bannerView.delegate = self;
    self.bannerView.timeInterval = 2;
    self.bannerView.pageControl.interval = 5;
//    self.bannerView.shouldAutoScroll = NO;
//    self.bannerView.shouldInfiniteShuffling = NO;
    [self.view addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(12);
        make.left.right.offset(0);
        make.height.offset(190).multipliedBy(UIScreen.mainScreen.bounds.size.width / 375.0);
//        make.height.equalTo(self.bannerView.mas_width).multipliedBy(186.0 / 375.0);
    }];

    NSMutableArray *arrayM = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        [arrayM addObject:[[NSObject alloc] init]];
    }
    self.bannerModelArray = arrayM.copy;
    [self.bannerView.collectionView registerClass:[CHBannerCollectionViewCell class] forCellWithReuseIdentifier:@"CHBannerCollectionViewCellID"];
    [self.bannerView reloadData];

}

- (NSInteger)bannerView:(CHBannerView *)bannerView numberOfItemsInSection:(NSInteger)section {
    return self.bannerModelArray.count;
}

- (UICollectionViewCell *)bannerView:(UICollectionView *)collectionView cellForItemAtIndex:(NSInteger)index {
    CHBannerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CHBannerCollectionViewCellID" forIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1];
    cell.titleStr = [NSString stringWithFormat:@"%@",@(index)];
    return cell;

}

- (void)bannerView:(UICollectionView *)collectionView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"点击的是第%ld页",index);
}

- (void)bannerView:(UICollectionView *)collectionView scrollToItemAtIndex:(NSInteger)index numberOfPages:(NSInteger)numberOfPages {
    NSLog(@"滚动到第%ld页,总共有%ld页",index ,numberOfPages);
//    NSLog(@"%@",collectionView);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    ViewController *vc = [[ViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];

    NSInteger count = arc4random_uniform(4);
    NSMutableArray *arrayM = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        [arrayM addObject:[[NSObject alloc] init]];
    }
    self.bannerModelArray = arrayM.copy;
    [self.bannerView reloadData];
}

@end

