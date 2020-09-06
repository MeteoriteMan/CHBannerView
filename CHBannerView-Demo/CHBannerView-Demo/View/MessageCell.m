//
//  MessageCell.m
//  CHBannerView-Demo
//
//  Created by 张晨晖 on 2019/5/13.
//  Copyright © 2019 张晨晖. All rights reserved.
//

#import "MessageCell.h"

@interface MessageCell ()

@property (nonatomic ,strong) UILabel *label;

@end

@implementation MessageCell

- (void)setText:(NSString *)text {
    _text = text;
    self.label.text = text;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.label = [[UILabel alloc] init];
    [self addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(8);
        make.centerY.equalTo(self);
        make.right.lessThanOrEqualTo(@-8);
    }];
}

@end
