//
//  YTYShowOrderView.m
//  CBFDemo
//
//  Created by iMac on 2017/2/20.
//  Copyright © 2017年 yty. All rights reserved.
//

#import "YTYShowOrderView.h"
#import "YTYTakeOutViewCell.h"

@interface YTYShowOrderView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation YTYShowOrderView

- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = RGB(0, 0, 0, 0.5);
		[self addSubview:self.tableView];
		[self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];
	}
	return self;
}
//- (void)setDataArray:(NSArray *)dataArray
//{
//	_dataArray = dataArray;
//}
#pragma mark -- lazy
- (UITableView *)tableView
{
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)/2.0, MAIN_SCREEN_W, CGRectGetHeight(self.frame)/2.0) style:UITableViewStyleGrouped];
		_tableView.delegate = self;
		_tableView.dataSource = self;
	}
	return _tableView;
}
#pragma mark -- UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	YTYTakeOutViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
	if (!cell) {
		cell = [[YTYTakeOutViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
	}
	cell.model = self.dataArray[indexPath.row];
	cell.indexPath = indexPath;
	cell.delegate = self;
	return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 10.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60.f;
}
#pragma mark ----

/**
 * cell取消订购
 */
- (void)cellNotShowCountViewWithPath:(NSIndexPath *)indexPath
{
	YTYTakeOutModel * model = self.dataArray[indexPath.row];
	if (self.notShowCount) {
		self.notShowCount(model);
	}
	if (self.dataArray.count == 0) {
		self.hidden = YES;
	}
	[self.tableView reloadData];
}
/**
 * cell增加订购数量
 */
- (void)cellOrderAddPath:(NSIndexPath *)indexPath
{
	YTYTakeOutModel * model = self.dataArray[indexPath.row];
	if (self.orderAdd) {
		self.orderAdd(model);
	}
}
/**
 * cell减少订购数量
 */
- (void)cellOrderSubPath:(NSIndexPath *)indexPath orderModel:(YTYTakeOutModel *)takeOutmodel
{
//	YTYTakeOutModel * model = count > 0 ? self.dataArray[indexPath.row] : nil;
	if (self.orderSub) {
		self.orderSub(takeOutmodel);
	}
}

#pragma mark -- click
- (void)tapAction
{
	[self dismiss];
}
- (void)show{
	[self.tableView reloadData];
	_tableView.frame = CGRectMake(0, CGRectGetHeight(self.frame), MAIN_SCREEN_W, CGRectGetHeight(self.frame)/2.0);
	[UIView animateWithDuration:0.3 animations:^{
		_tableView.frame = CGRectMake(0, CGRectGetHeight(self.frame)/2.0, MAIN_SCREEN_W, CGRectGetHeight(self.frame)/2.0);
	}];
	self.hidden = NO;
}

- (void)dismiss{
	[UIView animateWithDuration:0.3 animations:^{
		_tableView.frame = CGRectMake(0, CGRectGetHeight(self.frame), MAIN_SCREEN_W, CGRectGetHeight(self.frame)/2.0);
	} completion:^(BOOL finished) {
		self.hidden = YES;
	}];
}

@end
