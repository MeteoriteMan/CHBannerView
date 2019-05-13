//
//  GlobalProgressHUD.m
//  CHBannerView-Demo
//
//  Created by 张晨晖 on 2019/5/13.
//  Copyright © 2019 张晨晖. All rights reserved.
//

#import "GlobalProgressHUD.h"

@interface GlobalProgressHUD ()

@property (nonatomic ,strong ,readonly) UIWindow *window;

@property (nonatomic ,strong ,readonly) MBProgressHUD *progress;

@end

@implementation GlobalProgressHUD

+ (instancetype)progressHUD {
    return [self new];
}

- (UIWindow *)window {
    return UIApplication.sharedApplication.delegate.window;
}

- (MBProgressHUD *)progress {
    if ([MBProgressHUD HUDForView:self.window]) {
        return [MBProgressHUD HUDForView:self.window];
    } else {
        return [MBProgressHUD showHUDAddedTo:self.window animated:NO];
    }
}

- (void)showProgress {
    [self.progress showAnimated:YES];
}

- (void)hideProgress {
    [self.progress hideAnimated:YES];
}

@end
