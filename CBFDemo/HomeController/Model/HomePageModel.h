//
//  HomePageModel.h
//  CBFDemo
//
//  Created by iMac on 2017/2/15.
//  Copyright © 2017年 yty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomePageModel : NSObject

@property (nonatomic, assign) NSInteger type;//1是大厅 2是包间

@property (nonatomic, assign) NSInteger state;// 0 是清空状态  1是预定状态  2是正在用餐

@property (nonatomic, assign) NSInteger num;//餐桌坐几人

@property (nonatomic, assign) NSInteger maxNum;//餐桌最多做多少人

@property (nonatomic, assign) CGFloat money;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, copy)   NSString * date;

@end
