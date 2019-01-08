//
//  CHPageControl.m
//  张晨晖
//
//  Created by 张晨晖 on 2016/7/10.
//  Copyright © 2017年 张晨晖. All rights reserved.
//

#import "CHPageControl.h"

@interface CHPageControl ()

@end

@implementation CHPageControl

#define DefaultDotDiameter 5

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.isDoc = YES;
    
}

#pragma mark setter

#pragma mark getter

- (CGFloat)dotDiameter {
    if (_dotDiameter == 0) {
        _dotDiameter = DefaultDotDiameter;
    }
    return _dotDiameter;
}

- (UIColor *)normalPageColor {
    if (!_normalPageColor) {
        _normalPageColor = [UIColor lightGrayColor];
    }
    return _normalPageColor;
}

- (UIColor *)currentPageColor {
    if (!_currentPageColor) {
        _currentPageColor = [UIColor darkGrayColor];
    }
    return _currentPageColor;
}

#pragma mark UISet
- (void)layoutSubviews {
    [super layoutSubviews];
    UIView *lastView;
    //遍历subview,设置圆点frame
    for (int i = 0; i < self.subviews.count; i++) {
        CGFloat x = 0.0;
        if (lastView) {
            x = lastView.frame.origin.x + lastView.frame.size.width + self.interval;
        } else {
            x = 0.0;
        }
        UIView *dot = [self.subviews objectAtIndex:i];
        dot.layer.cornerRadius = self.docCornerRadius;
        if (self.isDoc) {
            dot.layer.cornerRadius = self.dotDiameter / 2;
        }
        if (i == self.currentPage) {///选中颜色
            switch (self.docType) {
                case CHPageControlDocTypeDoc: {
                    dot.backgroundColor = self.currentPageColor;
                    [dot setFrame:CGRectMake(x, 0, self.dotDiameter, self.dotDiameter)];
                }
                    break;
                case CHPageControlDocTypeImage: {
                    UIImage *currentPageImage;
                    switch (self.imageType) {
                        case CHPageControlImageTypeDefault: {
                            currentPageImage = self.currentPageImage;
                        }
                            break;
                        case CHPageControlImageTypeArray: {
                            NSAssert1(!(i > self.currentPageImageArray.count - 1), @"%s---currentPageImageArray中图片数小于CHPageControl的个数", __FUNCTION__);
                            currentPageImage = self.currentPageImageArray[i];
                        }
                        default:
                            break;
                    }
                    dot.layer.contents = (__bridge id _Nullable)(currentPageImage.CGImage);
                    if (currentPageImage) {
                        [dot setFrame:CGRectMake(x, 0, ((CGFloat)CGImageGetWidth(currentPageImage.CGImage)) / ((CGFloat)CGImageGetHeight(currentPageImage.CGImage)) * self.dotDiameter , self.dotDiameter)];
                    } else {
                        [dot setFrame:CGRectMake(x, 0, self.dotDiameter, self.dotDiameter)];
                    }
                }
                default:
                    break;
            }
        } else {///正常状态颜色
            switch (self.docType) {
                case CHPageControlDocTypeDoc: {
                    dot.backgroundColor = self.normalPageColor;
                    [dot setFrame:CGRectMake(x, 0, self.dotDiameter, self.dotDiameter)];
                }
                    break;
                case CHPageControlDocTypeImage: {
                    UIImage *normalPageImage;
                    switch (self.imageType) {
                        case CHPageControlImageTypeDefault: {
                            normalPageImage = self.normalPageImage;
                        }
                            break;
                        case CHPageControlImageTypeArray: {
                            NSAssert1(!(i > self.normalPageImageArray.count - 1), @"%s---normalPageImageArray中图片数小于CHPageControl的个数", __FUNCTION__);
                            normalPageImage = self.normalPageImageArray[i];
                        }
                        default:
                            break;
                    }
                    dot.layer.contents = (__bridge id _Nullable)(normalPageImage.CGImage);
                    if (normalPageImage) {
                        [dot setFrame:CGRectMake(x, 0, ((CGFloat)CGImageGetWidth(normalPageImage.CGImage)) / ((CGFloat)CGImageGetHeight(normalPageImage.CGImage)) * self.dotDiameter, self.dotDiameter)];
                    } else {
                        [dot setFrame:CGRectMake(x, 0, self.dotDiameter, self.dotDiameter)];
                    }
                }
                default:
                    break;
            }
        }
        lastView = dot;
    }
    self.bounds = CGRectMake(0, 0, lastView.frame.origin.x + lastView.frame.size.width, self.dotDiameter);
    lastView = nil;
}

@end
