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
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end
