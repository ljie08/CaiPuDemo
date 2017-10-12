//
//  DPViewController.h
//  diupin
//
//  Created by Shendou on 16/2/15.
//  Copyright © 2016年 Shendou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPViewController : UIViewController

@property(nonatomic,readonly,strong) UINavigationItem * dp_navigationItem;

@property(nonatomic,weak) UIView * contentView;

@property(nonatomic,weak)UIView * xyStatusBar;
@property(nonatomic,weak)UINavigationBar * xyNavBar;

-(void)hideTop;

- (void)bringNavBarToFront;

-(void)addBackButton;

- (void)popBack:(id)sender;

@end
