//
//  TakeOutHeader.h
//  CBFDemo
//
//  Created by iMac on 2017/2/5.
//  Copyright © 2017年 yty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTYTakeOutHeader : UITableViewHeaderFooterView
@property (nonatomic,copy) NSString *titleStr;
+ (instancetype)headerWithTableView:(UITableView *)tableview;
@end
