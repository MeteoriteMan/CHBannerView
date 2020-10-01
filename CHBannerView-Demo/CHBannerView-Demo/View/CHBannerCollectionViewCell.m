//
//  CHBannerCollectionViewCell.m
//  CHBannerCollectionView
//
//  Created by 张晨晖 on 2018/9/25.
//  Copyright © 2018 ChenhuiZhang. All rights reserved.
//

#import "CHBannerCollectionViewCell.h"
#import <Masonry.h>

@interface CHBannerCollectionViewCell ()

@property (nonatomic ,strong) UILabel *labelTitle;

@end

@implementation CHBannerCollectionViewCell

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    self.labelTitle.text = titleStr;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {

    if (UIDEBUG) {
        UIView *viewLine = [UIView new];
        viewLine.backgroundColor = [UIColor redColor];
        [self addSubview:viewLine];
        [viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.width.offset(1);
            make.top.bottom.offset(0);
        }];
        
        UIView *viewLine2 = [UIView new];
        viewLine2.backgroundColor = [UIColor greenColor];
        [self addSubview:viewLine2];
        [viewLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(viewLine);
            make.height.offset(20);
            make.width.offset(20);
        }];
    }
    
    self.labelTitle = [[UILabel alloc] init];
    self.labelTitle.font = [UIFont systemFontOfSize:50];
    [self addSubview:self.labelTitle];
    [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

- (void)startAnimation {
    UIColor *backgroundColor = self.backgroundColor;
    [UIView animateWithDuration:.25 animations:^{
        self.backgroundColor = [UIColor greenColor];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.25 animations:^{
            self.backgroundColor = backgroundColor;
        }];
    }];
}

@end
