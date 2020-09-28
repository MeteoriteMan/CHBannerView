//
//  BaseViewController.m
//  CHBannerView-Demo
//
//  Created by ChenhuiZhang on 2020/9/7.
//  Copyright © 2020 张晨晖. All rights reserved.
//

#import "BaseViewController.h"
#import <Masonry/Masonry.h>

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if (UIDEBUG) {
        UIView *viewLine = [UIView new];
        viewLine.backgroundColor = [UIColor redColor];
        [self.view addSubview:viewLine];
        [viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.offset(1);
            make.top.bottom.offset(0);
        }];
    }
    
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
