//
//  CHPageControl.h
//  张晨晖
//
//  Created by 张晨晖 on 2016/7/10.
//  Copyright © 2017年 张晨晖. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CHPageControlDocType) {///指示器样式
    CHPageControlDocTypeDoc,//圆点
    CHPageControlDocTypeImage,//图片
};

typedef NS_ENUM(NSUInteger, CHPageControlImageType) {///指示器图片样式
    CHPageControlImageTypeDefault,//选中样式和非选中样式.
    CHPageControlImageTypeArray,//根据图片数组设置
};

@interface CHPageControl : UIPageControl

/// 指示器样式
@property (nonatomic ,assign) CHPageControlDocType docType;

/// 指示器图片样式.
@property (nonatomic ,assign) CHPageControlImageType imageType;

/// 是否是圆点,默认YES
@property (nonatomic ,assign) BOOL isDoc;

/// 切边大小
@property (nonatomic ,assign) BOOL docCornerRadius;

/// 小圆点的直径
@property (nonatomic ,assign) CGFloat dotDiameter;
/// 小圆点之间的间距
@property (nonatomic ,assign) CGFloat interval;
/// 当前选中page的颜色
@property (nonatomic ,strong) UIColor *currentPageColor;
/// 正常状态Page的颜色
@property (nonatomic ,strong) UIColor *normalPageColor;

/// MARK:图片
/// 当前选中page的图片
@property (nonatomic ,strong) UIImage *currentPageImage;
/// 正常状态Page的图片
@property (nonatomic ,strong) UIImage *normalPageImage;

/// 指示器图片数组.选中状态
@property (nonatomic ,strong) NSArray <UIImage *> *currentPageImageArray;

/// 指示器图片数组.正常状态
@property (nonatomic ,strong) NSArray <UIImage *> *normalPageImageArray;

@end
