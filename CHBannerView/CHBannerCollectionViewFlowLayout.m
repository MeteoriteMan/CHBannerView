//
//  CHBannerCollectionViewFlowLayout.m
//  CHBannerCollectionView
//
//  Created by 张晨晖 on 2018/9/25.
//  Copyright © 2018 ChenhuiZhang. All rights reserved.
//

#import "CHBannerCollectionViewFlowLayout.h"

@implementation CHBannerCollectionViewFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    CGFloat height = self.collectionView.bounds.size.height;
    CGFloat width = height * 16.0 / 9.0;
    self.itemSize = CGSizeMake(width, height);
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    CGFloat headerFooterInterval = (self.collectionView.bounds.size.width - width) / 2.0;
    self.headerReferenceSize = CGSizeMake(headerFooterInterval, 0);
    self.footerReferenceSize = CGSizeMake(headerFooterInterval, 0);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray <UICollectionViewLayoutAttributes *>*itemsArray = [super layoutAttributesForElementsInRect:rect];
    CGFloat screenW = self.collectionView.bounds.size.width;
    CGFloat comonX = self.collectionView.contentOffset.x  + screenW * 0.5;
    NSMutableArray *copyItemsArrayM = [[NSMutableArray alloc] initWithArray:itemsArray copyItems:YES];
    CGFloat itemHeightScale = 160.0 / 186.0;
    for (UICollectionViewLayoutAttributes *attr in copyItemsArrayM) {
        CGFloat margin = attr.center.x - comonX;
        CGFloat scale = ABS(margin) / self.collectionView.bounds.size.width * .5;
        CGFloat attrScale = (self.itemSize.height - self.itemSize.height * (1 - itemHeightScale) * scale) / self.itemSize.height;
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformScale(transform, attrScale, attrScale);
        attr.transform = transform;
    }
    return copyItemsArrayM.copy;
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
