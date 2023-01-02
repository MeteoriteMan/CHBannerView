//
//  MinimumLineSpacingFlowLayout.m
//  CHBannerView-Demo
//
//  Created by 张晨晖 on 2019/4/23.
//  Copyright © 2019 张晨晖. All rights reserved.
//

#import "MinimumLineSpacingFlowLayout.h"

@implementation MinimumLineSpacingFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    CGFloat height = self.collectionView.bounds.size.height;
    CGFloat width = height * 16.0 / 9.0;
    self.itemSize = CGSizeMake(width, height);
    self.minimumLineSpacing = 20;
    self.minimumInteritemSpacing = 0;
    CGFloat collectionViewWidth = self.collectionView.bounds.size.width;
    // 保证在中间显示
    CGFloat headerFooterInterval = (collectionViewWidth - (width - self.minimumLineSpacing)) / 2;
    self.headerReferenceSize = CGSizeMake(headerFooterInterval, 0);
    self.footerReferenceSize = CGSizeMake(headerFooterInterval, 0);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (CGSize)collectionViewContentSize {
    CGSize contentSize = [super collectionViewContentSize];
    if (contentSize.width <= self.collectionView.bounds.size.width) {
        contentSize.width = self.collectionView.bounds.size.width + 1;
    }
    return contentSize;
}

@end
