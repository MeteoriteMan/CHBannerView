//
//  SpecialHoverStyleFlowLayout.m
//  CHBannerView-Demo
//
//  Created by ChenhuiZhang on 2020/9/4.
//  Copyright © 2020 张晨晖. All rights reserved.
//

#import "SpecialHoverStyleFlowLayout.h"

@implementation SpecialHoverStyleFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    CGFloat height = self.collectionView.bounds.size.height;
    CGFloat width = UIScreen.mainScreen.bounds.size.width - 80;
    self.itemSize = CGSizeMake(width, height);
    self.minimumLineSpacing = 20;
    self.minimumInteritemSpacing = 0;
//    CGFloat collectionViewWidth = self.collectionView.bounds.size.width;
    // 保证在中间显示
    CGFloat headerFooterInterval = 8;
    self.headerReferenceSize = CGSizeMake(headerFooterInterval, 0);
    self.footerReferenceSize = CGSizeMake(headerFooterInterval, 0);
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
    if (loc.x < 0) {
        loc = CGPointMake(0.0, loc.y);
    } else if (loc.x > self.collectionView.contentSize.width - self.collectionView.bounds.size.width) {
        loc = CGPointMake(self.collectionView.contentSize.width - self.collectionView.bounds.size.width, loc.y);
    }
    return loc;
}

//- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
//    NSArray <UICollectionViewLayoutAttributes *>*itemsArray = [super layoutAttributesForElementsInRect:rect];
//    CGFloat screenW = self.collectionView.bounds.size.width;
//    CGFloat comonX = self.collectionView.contentOffset.x  + screenW * 0.5;
//    NSMutableArray *copyItemsArrayM = [[NSMutableArray alloc] initWithArray:itemsArray copyItems:YES];
//    CGFloat itemHeightScale = 160.0 / 186.0;
//    for (UICollectionViewLayoutAttributes *attr in copyItemsArrayM) {
//        CGFloat margin = attr.center.x - comonX;
//        CGFloat scale = ABS(margin) / self.collectionView.bounds.size.width * .5;
//        CGFloat attrScale = (self.itemSize.height - self.itemSize.height * (1 - itemHeightScale) * scale) / self.itemSize.height;
//        CGAffineTransform transform = CGAffineTransformIdentity;
//        transform = CGAffineTransformScale(transform, attrScale, attrScale);
//        attr.transform = transform;
//    }
//    return copyItemsArrayM.copy;
//}

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
