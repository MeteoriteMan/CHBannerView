//
//  GlobalProgressHUD.h
//  CHBannerView-Demo
//
//  Created by 张晨晖 on 2019/5/13.
//  Copyright © 2019 张晨晖. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GlobalProgressHUD : NSObject

+ (instancetype)progressHUD;

- (void)showProgress;

- (void)hideProgress;

@end

NS_ASSUME_NONNULL_END
