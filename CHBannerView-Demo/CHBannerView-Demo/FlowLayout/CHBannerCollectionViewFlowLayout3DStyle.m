//
//  CHBannerCollectionViewFlowLayout3DStyle.m
//  CHBannerView-Demo
//
//  Created by 张晨晖 on 2019/1/25.
//  Copyright © 2019 张晨晖. All rights reserved.
//

#import "CHBannerCollectionViewFlowLayout3DStyle.h"

@implementation CHBannerCollectionViewFlowLayout3DStyle

- (void)prepareLayout {
    [super prepareLayout];
    CGFloat height = self.collectionView.bounds.size.height;
    CGFloat width = height * 12.0 / 9.0;
    self.itemSize = CGSizeMake(width, height);
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    CGFloat headerFooterInterval = (self.collectionView.bounds.size.width - width) / 2.0;
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
    return loc;
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray <UICollectionViewLayoutAttributes *>*itemsArray = [super layoutAttributesForElementsInRect:rect];
    CGFloat screenW = self.collectionView.bounds.size.width;
    /// 屏幕中线的X值
    CGFloat comonX = self.collectionView.contentOffset.x  + screenW * 0.5;
    NSMutableArray *copyItemsArrayM = [[NSMutableArray alloc] initWithArray:itemsArray copyItems:YES];
//    CGFloat itemHeightScale = 160.0 / 186.0;
    for (UICollectionViewLayoutAttributes *attr in copyItemsArrayM) {
        /// item中心到commonX的值
        CGFloat margin = attr.center.x - comonX;
//        CGFloat scale = ABS(margin) / self.collectionView.bounds.size.width * .5;

//        CGFloat attrScale = (self.itemSize.height - self.itemSize.height * (1 - itemHeightScale) * scale) / self.itemSize.height;
//        CGAffineTransform transform = CGAffineTransformIdentity;
//        transform = CGAffineTransformScale(transform, attrScale, attrScale);
//        attr.transform = transform;

        CGFloat angle = - (margin/screenW * M_PI_2);
//        CGFloat scale = 1 - ABS(margin)/screenW;
//        CATransform3D transform3D = CATransform3DIdentity;
        CATransform3D transform3D = attr.transform3D;
//        CATransform3DRotate(<#CATransform3D t#>, <#CGFloat angle#>, <#CGFloat x#>, <#CGFloat y#>, <#CGFloat z#>)
        transform3D.m34 = -1 / 500;
//        transform3D = CATransform3DScale(transform3D, scale, scale, 0);
        transform3D = CATransform3DRotate(transform3D, angle, .1, 0, 0);
        attr.transform3D = transform3D;
    }
    return copyItemsArrayM.copy;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end
