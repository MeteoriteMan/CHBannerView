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

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGPoint loc = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    CGRect rect = CGRectMake(proposedContentOffset.x , 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray *itemsArray = [self layoutAttributesForElementsInRect:rect];
    CGFloat comonX = proposedContentOffset.x  + self.collectionView.bounds.size.width * .5;
    CGFloat maxDistance = CGFLOAT_MAX;
    CGFloat minDistance = 0;
    UICollectionViewLayoutAttributes *minattr = [[UICollectionViewLayoutAttributes alloc] init];
    for (UICollectionViewLayoutAttributes *attr in itemsArray) {
        CGFloat distance = attr.center.x - comonX;
        if (ABS(distance) < maxDistance) {
            maxDistance = ABS(distance);
            minDistance = distance;
            minattr = attr;
        }
    }
    loc = CGPointMake(minattr.center.x - self.collectionView.bounds.size.width * .5, loc.y);
    return loc;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

//- (CGSize)collectionViewContentSize {
//    CGSize contentSize = [super collectionViewContentSize];
//    if (contentSize.width <= self.collectionView.bounds.size.width) {
//        contentSize.width = self.collectionView.bounds.size.width + 1;
//    }
//    return contentSize;
//}


@end
