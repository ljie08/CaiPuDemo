//
//  ViewController.m
//  CBFDemo
//
//  Created by iMac on 2017/2/4.
//  Copyright © 2017年 yty. All rights reserved.
//

#import "RootViewController.h"
#import "Topbar.h"
#import "HomePageBaseController.h"
#import "HomePageHallController.h"
#import "HomePageRoomController.h"
@interface RootViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic, strong) Topbar * topBar;

@property (nonatomic, assign) NSInteger curIndex;

@end

@implementation RootViewController

#pragma mark -- lazy
- (UIScrollView *)scrollView
{
	if (!_scrollView) {
		_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, MAIN_SCREEN_W, MAIN_SCREEN_H - 64)];
		_scrollView.pagingEnabled = YES;
		_scrollView.delegate = self;
		_scrollView.contentSize = CGSizeMake(MAIN_SCREEN_W * 2.0, 1.f);
		HomePageHallController * hallController = [HomePageHallController new];
		HomePageRoomController * roomController = [HomePageRoomController new];
		[self addChildViewController:hallController];
		[self addChildViewController:roomController];
		hallController.view.frame = CGRectMake(0, 0, MAIN_SCREEN_W, CGRectGetHeight(_scrollView.frame));
		[_scrollView addSubview:hallController.view];
		roomController.view.frame = CGRectMake(MAIN_SCREEN_W, 0, MAIN_SCREEN_W, CGRectGetHeight(_scrollView.frame));
		[_scrollView addSubview:roomController.view];
		[hallController didMoveToParentViewController:self];
		[roomController didMoveToParentViewController:self];
	}
	return _scrollView;
}

- (Topbar *)topBar
{
	if (!_topBar) {
		_topBar = [[Topbar alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_W, kTopbarHeight)];
		_topBar.titles = [@[@"大厅",@"包间"] mutableCopy];
		WS(weakSelf);
		_topBar.blockHandler = ^(Topbar* topBar, NSInteger currentPage)
		{
			if (topBar.currentPage == currentPage) {
				return ;
			}
			weakSelf.curIndex = currentPage;
			topBar.currentPage = currentPage;
			[weakSelf.scrollView setContentOffset:CGPointMake(currentPage * MAIN_SCREEN_W, 0) animated:YES];
		};
		_topBar.doubleClick = ^(NSInteger currentPage){
		};
	}
	return _topBar;
}
#pragma mark -- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGFloat width = scrollView.frame.size.width;
	NSInteger curIndex = scrollView.contentOffset.x / width + 0.3;//0.3提前量
	if (curIndex != _curIndex) {
		_curIndex = curIndex;
		_topBar.currentPage = curIndex;
	}
}

#pragma mark --- 生命周期
- (void)viewDidLoad {
	[super viewDidLoad];
	self.automaticallyAdjustsScrollViewInsets = NO;
	self.navigationController.navigationBar.hidden = YES;
	self.navigationController.navigationBarHidden = YES;
	self.enablePresentationStack = YES;
	[self.contentView addSubview:self.scrollView];
	[self.xyNavBar addSubview:self.topBar];
}
- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end
