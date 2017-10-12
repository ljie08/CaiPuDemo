//
//  TakeOutModel.h
//  CBFDemo
//
//  Created by iMac on 2017/2/5.
//  Copyright © 2017年 yty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTYTakeOutModel : NSObject
/**
 * 食品标题
 */
@property (nonatomic,copy) NSString *title;
/**
 * 食品id
 */
@property (nonatomic,assign) NSInteger foodID;
/**
 * 已经售出的份数
 */
@property (nonatomic,assign) NSInteger soldCount;
/**
 * 价格
 */
@property (nonatomic,assign) NSInteger price;
/**
 * 图像地址
 */
@property (nonatomic,copy) NSString *iconPath;
/**
 * 是否显示份数
 */
@property (nonatomic,assign,getter=IsShowCount) BOOL showCount;
/**
 * 订购的数量
 */
@property (nonatomic,assign) NSInteger orderCount;

@end
