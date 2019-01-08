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
    self.labelTitle = [[UILabel alloc] init];
    self.labelTitle.font = [UIFont systemFontOfSize:50];
    [self addSubview:self.labelTitle];
    [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

@end
