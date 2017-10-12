//
//  YTYOrderViewController.h
//  CBFDemo
//
//  Created by iMac on 2017/2/15.
//  Copyright © 2017年 yty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPViewController.h"
#import "HomePageModel.h"
@interface YTYOrderViewController : DPViewController

@property (nonatomic, strong) HomePageModel * homeModel;

@property (nonatomic, strong) NSIndexPath * indexPath;

@property (nonatomic, assign) NSInteger number;

@property (nonatomic, copy) void(^reloadController)(void);

@end
