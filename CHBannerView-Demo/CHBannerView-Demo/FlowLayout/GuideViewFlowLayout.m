//
//  GuideViewFlowLayout.m
//  CHBannerView-Demo
//
//  Created by ChenhuiZhang on 2020/9/2.
//  Copyright © 2020 张晨晖. All rights reserved.
//

#import "GuideViewFlowLayout.h"

@implementation GuideViewFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    CGFloat height = self.collectionView.bounds.size.height;
    CGFloat width = self.collectionView.bounds.size.width;
    self.itemSize = CGSizeMake(width, height);
    self.minimumLineSpacing = 0.0;
    self.minimumInteritemSpacing = 0.0;
    CGFloat headerFooterInterval = 0.0;
    self.headerReferenceSize = CGSizeMake(headerFooterInterval, 0.0);
    self.footerReferenceSize = CGSizeMake(headerFooterInterval, 0.0);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end
