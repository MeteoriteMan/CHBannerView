//
//  CHBannerCollectionViewCell.h
//  CHBannerCollectionView
//
//  Created by 张晨晖 on 2018/9/25.
//  Copyright © 2018 ChenhuiZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHBannerCollectionViewCell : UICollectionViewCell

@property (nonatomic ,strong) NSString *titleStr;

- (void)startAnimation;

@end

NS_ASSUME_NONNULL_END
