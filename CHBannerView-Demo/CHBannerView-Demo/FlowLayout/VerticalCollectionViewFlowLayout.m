//
//  VerticalCollectionViewFlowLayout.m
//  CHBannerView-Demo
//
//  Created by 张晨晖 on 2019/5/13.
//  Copyright © 2019 张晨晖. All rights reserved.
//

#import "VerticalCollectionViewFlowLayout.h"

@implementation VerticalCollectionViewFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    // 设置item的大小
    //    12 12
//    CGFloat height = self.collectionView.bounds.size.height;
    CGFloat width = self.collectionView.bounds.size.width;
    self.itemSize = CGSizeMake(width, 44);
    // 间距
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;

    self.headerReferenceSize = CGSizeMake(0, 1.0);
    self.footerReferenceSize = CGSizeMake(0, 1.0);
    // 滚动方向
    self.scrollDirection = UICollectionViewScrollDirectionVertical;

}

//Invalidate 让系统的布局失效 ; 时时更新
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {

    return YES;
}

@end
