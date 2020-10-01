//
//  ViewController.m
//  CHBannerView-Demo
//
//  Created by 张晨晖 on 2019/1/4.
//  Copyright © 2019 张晨晖. All rights reserved.
//

#import "ViewController.h"
#import "DefaultViewController.h"
#import "3DViewController.h"
#import "MinimumLineSpacingViewController.h"
#import "VerticalViewController.h"
#import "CHGuideView.h"
#import "SpecialHoverStyleViewController.h"

@interface ViewController () <UITableViewDataSource ,UITableViewDelegate>

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) NSArray <NSString *> *arrayTitle;

@end

@implementation ViewController

static NSString *UITableViewCellID = @"UITableViewCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.arrayTitle = @[@"默认样式" ,@"3DStyle" ,@"MinimumLineSpacing" ,@"Vertical" ,@"BannerViewForWindow" ,@"蚂蚁财富财富直通车样式"];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.mas_topLayoutGuide);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:UITableViewCellID];

}

// MARK: UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayTitle.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellID forIndexPath:indexPath];
    cell.textLabel.text = self.arrayTitle[indexPath.row];
    return cell;
}

// MARK: UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0: {// 默认样式
            DefaultViewController *vc = [[DefaultViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1: {// CHBannerCollectionViewFlowLayout3DStyle
            _DViewController *vc = [[_DViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2: {// MinimumLineSpacing
            MinimumLineSpacingViewController *vc = [[MinimumLineSpacingViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3: {//VerticalViewController
            VerticalViewController *vc = [[VerticalViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4: {//BannerViewForWindow
            CHGuideView *guideView = [[CHGuideView alloc] init];
            [guideView show];
        }
            break;
        case 5: {//特殊悬停
            SpecialHoverStyleViewController *vc = [[SpecialHoverStyleViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

@end

