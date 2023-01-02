//
//  HorizontalCollectionViewFlowLayout.m
//  CHBannerView-Demo
//
//  Created by 张晨晖 on 2023/1/2.
//  Copyright © 2023 张晨晖. All rights reserved.
//

#import "HorizontalCollectionViewFlowLayout.h"

@implementation HorizontalCollectionViewFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    // 设置item的大小
    //    12 12
    CGFloat width = self.collectionView.bounds.size.width;
    CGFloat height = self.collectionView.bounds.size.height;
    self.itemSize = CGSizeMake(width - 2.0, height);
    // 间距
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;

    self.headerReferenceSize = CGSizeMake(1.0, 0);
    self.footerReferenceSize = CGSizeMake(1.0, 0);
    // 滚动方向
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;

}

//Invalidate 让系统的布局失效 ; 时时更新
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {

    return YES;
}

@end
