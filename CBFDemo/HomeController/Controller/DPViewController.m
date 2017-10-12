//
//  DPViewController.m
//  diupin
//
//  Created by Shendou on 16/2/15.
//  Copyright © 2016年 Shendou. All rights reserved.
//

#import "DPViewController.h"

@interface DPViewController ()

@end

@implementation DPViewController

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	if ([self isKindOfClass:NSClassFromString(@"DPAdIncomeController")]||
		[self isKindOfClass:NSClassFromString(@"DPMyWalletController")]||
		[self isKindOfClass:NSClassFromString(@"DPMineController")]||
		[self isKindOfClass:NSClassFromString(@"DPScoresCenterController")]) {
		[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
	}else{
		[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
	}
}

-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.automaticallyAdjustsScrollViewInsets = NO;
	self.edgesForExtendedLayout = UIRectEdgeAll;
	
	if ([self.view subviews].count > 0) {       //awakeFromNib
		_contentView = [self.view viewWithTag:1111];
	}else{                                      //nomal
		//1.contectView
		UIView * contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_W, MAIN_SCREEN_H)];
		_contentView = contentView;
		_contentView.backgroundColor = [UIColor whiteColor];
		[self.view addSubview:_contentView];
	}
	
	//2.navbar
	UINavigationBar * xyNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, MAIN_SCREEN_W, 44)];
	_xyNavBar = xyNavBar;
	xyNavBar.translucent = NO;
	xyNavBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//	xyNavBar.backgroundColor = [UIColor redColor];
	xyNavBar.barTintColor = kDPNavColor;
	[self.view addSubview:xyNavBar];
	_dp_navigationItem = [[UINavigationItem alloc] initWithTitle:self.title];
	
	if ([self.navigationController.viewControllers indexOfObject:self] > 0) {
		[self addBackButton];
	}
	
	_xyNavBar.items = @[_dp_navigationItem];
	
	UIView * devide = [[UIView alloc]initWithFrame:CGRectMake(0, 43.5, MAIN_SCREEN_W, 0.5)];
	devide.backgroundColor = kDevideColor;
	[xyNavBar addSubview:devide];
	
	//2.statusBar
	UIView * zcStatusBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_W, 20)];
	_xyStatusBar = zcStatusBar;
	_xyStatusBar.backgroundColor = kDPNavColor;
	_xyStatusBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[self.view addSubview:_xyStatusBar];
}

-(void)addBackButton
{
	UIBarButtonItem * negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	[negativeSpacer setWidth:-22];
	UIButton* btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
	[btnBack setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
	[btnBack addTarget:self action:@selector(popBack:) forControlEvents:UIControlEventTouchUpInside];
	UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
	[backView addSubview:btnBack]; //将btnBack放在backView中，否则会出现btnBack响应区域过大的BUG
	_dp_navigationItem.leftBarButtonItems = @[negativeSpacer,[[UIBarButtonItem alloc] initWithCustomView:backView]];
}

- (void)popBack:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)showCloseButton
{
	[self view];
	self.dp_navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(dismissXYNavigationController:)]];
}

- (void)dismissXYNavigationController:(id)sender
{
	if(self.navigationController)
		[self.navigationController dismissViewControllerAnimated:YES completion:nil];
	else
		[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setTitle:(NSString *)title
{
	[super setTitle:title];
	_dp_navigationItem.title = title;
}

-(void)hideTop;
{
	self.xyNavBar.hidden = YES;
	self.xyStatusBar.hidden = YES;
}

- (void)bringNavBarToFront
{
	[self.view bringSubviewToFront:_xyNavBar];
	[self.view bringSubviewToFront:_xyStatusBar];
}

- (BOOL)shouldAutorotate //当前viewcontroller是否支持转屏
{
	return NO;
}

//- (NSUInteger)supportedInterfaceOrientation//当前viewcontroller支持哪些转屏方向
//{
//	
//}



- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}

@end
