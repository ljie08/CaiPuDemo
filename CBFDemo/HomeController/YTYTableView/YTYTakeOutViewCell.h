//
//  TakeOutViewCell.h
//  CBFDemo
//
//  Created by iMac on 2017/2/5.
//  Copyright © 2017年 yty. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YTYTakeOutModel;


@protocol YTYTakeOutViewCellDelegate <NSObject>

@optional
- (void)cellShowCountViewWithPath:(NSIndexPath *)indexPath;
- (void)cellNotShowCountViewWithPath:(NSIndexPath *)indexPath;
- (void)cellOrderAddPath:(NSIndexPath *)indexPath;
- (void)cellOrderSubPath:(NSIndexPath *)indexPath orderModel:(YTYTakeOutModel *)model;
@end
@interface YTYTakeOutViewCell : UITableViewCell
@property (nonatomic,strong) YTYTakeOutModel *model;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,weak) id<YTYTakeOutViewCellDelegate> delegate;

- (instancetype)cellWithTableView:(UITableView *)tableview;
@end
