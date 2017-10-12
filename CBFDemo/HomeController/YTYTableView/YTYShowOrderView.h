//
//  YTYShowOrderView.h
//  CBFDemo
//
//  Created by iMac on 2017/2/20.
//  Copyright © 2017年 yty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTYTakeOutViewCell.h"

@interface YTYShowOrderView : UIView<YTYTakeOutViewCellDelegate>

@property (nonatomic, strong) NSMutableArray * dataArray; //不用NSArray和Copy是为了让与外部的orderArray保持一致

@property (nonatomic, weak) id<YTYTakeOutViewCellDelegate> delegate;

@property (nonatomic, copy) void(^notShowCount)(YTYTakeOutModel *model);

@property (nonatomic, copy) void(^orderAdd)(YTYTakeOutModel *model);

@property (nonatomic, copy) void(^orderSub)(YTYTakeOutModel *model);

- (void)show;

- (void)dismiss;

@end
/**
 * cell开始订购
 */
/**
 * cell取消订购
 */
/**
 * cell增加订购数量
 */
/**
 * cell减少订购数量
 */
/*
 - (void)cellShowCountViewWithPath:(NSIndexPath *)indexPath;
 - (void)cellNotShowCountViewWithPath:(NSIndexPath *)indexPath;
 - (void)cellOrderAddPath:(NSIndexPath *)indexPath;
 - (void)cellOrderSubPath:(NSIndexPath *)indexPath;
 */
