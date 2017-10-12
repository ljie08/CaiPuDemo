//
//  CCTableView.h
//  CBFDemo
//
//  Created by iMac on 2017/2/5.
//  Copyright © 2017年 yty. All rights reserved.
//
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#import <UIKit/UIKit.h>
@class YTYTakeOutModel;

@interface YTYTableView : UIView

@property (nonatomic,strong) NSArray  *dataArray;

@property (nonatomic, copy) void(^placeOrderBlock)(NSArray * array);

@property (nonatomic, copy) void(^showMenuDetailBlock)(YTYTakeOutModel * model);

@property (nonatomic, copy) NSString * voice_str;

- (void)setVoiceStr:(NSString *)voice_str num:(NSInteger)num;

@end
