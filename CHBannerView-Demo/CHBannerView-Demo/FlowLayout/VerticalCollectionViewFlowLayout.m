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
    CGFloat height = self.collectionView.bounds.size.height;
    CGFloat width = self.collectionView.bounds.size.width;
    self.itemSize = CGSizeMake(width, 44);
    // 间距
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;

    self.headerReferenceSize = CGSizeMake(0, 0);
    self.footerReferenceSize = CGSizeMake(0, 0);
    // 滚动方向
    self.scrollDirection = UICollectionViewScrollDirectionVertical;

}

#pragma mark - 3.修改  根据用户手指的力度 惯性 返回 将来停止的位置
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGPoint loc = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    //1.根据contentOffset 计算将要显示的区域
    CGRect rect = CGRectMake(0 , proposedContentOffset.y, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height * 2);
    //2.获取将来显示区域的格子属性
    NSArray *itemsArray = [self layoutAttributesForElementsInRect:rect];
    //3.计算格子 离中线 最短的距离
    CGFloat comonY = proposedContentOffset.y  + self.collectionView.bounds.size.height * 1;
    CGFloat maxDistance = CGFLOAT_MAX;
    //只是为了 一步获取 最短的距离
    CGFloat minDistance = 0;
    UICollectionViewLayoutAttributes *minattr = [[UICollectionViewLayoutAttributes alloc] init];
    for (UICollectionViewLayoutAttributes *attr in itemsArray) {
        //计算距离
        CGFloat distance = attr.frame.origin.y - comonY;
        if (ABS(distance) < maxDistance) {
            maxDistance = ABS(distance);
            //取出最短的距离
            minDistance = distance;
            minattr = attr;
        }
    }
    //4.修正
    loc = CGPointMake(loc.x, minattr.frame.origin.y - self.collectionView.bounds.size.height * 1);
    return loc;
}

//Invalidate 让系统的布局失效 ; 时时更新
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {

    return YES;
}

@end
