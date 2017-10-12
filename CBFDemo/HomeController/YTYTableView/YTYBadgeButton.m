//
//  IWBadgeButton.m
//  CBFDemo
//
//  Created by iMac on 2017/2/5.
//  Copyright © 2017年 yty. All rights reserved.
//

#import "YTYBadgeButton.h"

@implementation YTYBadgeButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.userInteractionEnabled = NO;
        UIImage *image = [UIImage imageNamed:@"main_badge"];
        [self setBackgroundImage:[image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:10];
    }
    return self;
}

- (void)setBadgeValue:(NSString *)badgeValue
{
//    _badgeValue = badgeValue;
    _badgeValue = [badgeValue copy];
    
    if ([badgeValue integerValue] > 0) {
        self.hidden = NO;
        // 设置文字
        [self setTitle:badgeValue forState:UIControlStateNormal];
        
        // 设置frame
        CGRect frame = self.frame;
        CGFloat badgeH = self.currentBackgroundImage.size.height;
        CGFloat badgeW = self.currentBackgroundImage.size.width;
        if (badgeValue.length > 1) {
            // 文字的尺寸
            CGSize badgeSize = [badgeValue sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
            badgeW = badgeSize.width + 5;
        }
        frame.size.width = badgeW;
        frame.size.height = badgeH;
        self.frame = frame;
    } else {
        self.hidden = YES;
    }
}

@end
