//
//  HomePageBaseController.m
//  CBFDemo
//
//  Created by iMac on 2017/2/5.
//  Copyright © 2017年 yty. All rights reserved.
//

#import "HomePageBaseController.h"
#import "HomePageBaseCell.h"
#import "YTYOrderViewController.h"
#import "YTYSeeMenuController.h"
#import "SingleManager.h"

#define kTopbarHeight 35

@interface HomePageBaseController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) NSIndexPath * selectIndexPath;

@end

@implementation HomePageBaseController

#pragma mark -- lazy
- (UICollectionView *)collectionView
{
	if (!_collectionView) {
		UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
		flowLayout.minimumInteritemSpacing = 20.f;//每行内部cell item的间距
		flowLayout.minimumLineSpacing = 20;//每行的间距
		[flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
		
		_collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,MAIN_SCREEN_W	, MAIN_SCREEN_H - 64) collectionViewLayout:flowLayout];
		_collectionView.backgroundColor = [UIColor whiteColor];
		_collectionView.delegate = self;
		_collectionView.dataSource = self;
		_collectionView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
		_collectionView.showsHorizontalScrollIndicator = NO;
		_collectionView.showsVerticalScrollIndicator = NO;
		[_collectionView registerClass:[HomePageBaseCell class] forCellWithReuseIdentifier:@"HomePageBaseCellid"];
	}
	return _collectionView;
}

#pragma mark -- UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	HomePageBaseCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageBaseCellid" forIndexPath:indexPath];
	cell.model = self.dataArr[indexPath.row];
	cell.indexPath = indexPath;
	return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat width = (MAIN_SCREEN_W - 40)/2.0;
	return CGSizeMake(width, width);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
	return UIEdgeInsetsMake(0,10, 0, 10);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	HomePageModel * model = self.dataArr[indexPath.row];
	self.selectIndexPath = indexPath;
	if (model.state == 0) {
		[self inputNum];
	}else if (model.state == 1){
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
		UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"开单",@"取消预约", nil];
		[actionSheet showInView:self.view];
#pragma clang diagnostic pop
	}else
	{
		YTYSeeMenuController * seeVc = [YTYSeeMenuController new];
		seeVc.indexPath = indexPath;
		NSString * key = model.type == 1 ? @"hallDict":@"roomDict";
		NSDictionary * dict = [[SingleManager shareSingle] typeDictWithKey:key];
		seeVc.dataArray = dict[[NSString stringWithFormat:@"%ld",indexPath.row]];
		[self.navigationController pushViewController:seeVc animated:YES];
	}
}
- (void)jumpOrderVcWithModel:(HomePageModel *)model num:(NSInteger)num
{
	YTYOrderViewController * orderVC = [YTYOrderViewController new];
	orderVC.homeModel = model;
	orderVC.indexPath = self.selectIndexPath;
	__weak typeof(self) weakSelf = self;
	orderVC.reloadController = ^{
		[weakSelf.collectionView reloadData];
//		NSString * key = model.type == 1 ? @"hallDict":@"roomDict";
//		NSDictionary * dict = [[SingleManager shareSingle] typeDictWithKey:key] ;
//		NSLog(@"%@",dict);
	};
	orderVC.number = num;


	[self.navigationController pushViewController:orderVC animated:YES];
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
- (void)inputNum
{
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入用餐人数" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
	alert.alertViewStyle = UIAlertViewStylePlainTextInput;
	UITextField * textfield = [alert textFieldAtIndex:0];
	textfield.keyboardType = UIKeyboardTypeNumberPad;
	
	[alert show];

}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	HomePageModel * model = self.dataArr[self.selectIndexPath.row];
	if (buttonIndex == 0) {
		[self inputNum];
	}else if (buttonIndex == 1)
	{
		__weak typeof(self) weakSelf = self;
		[UIAlertView alertWithTitle:@"提示" message:@"确定取消预约?" okButtonTitle:@"确认" cancelButtonTitle:@"取消" okHandler:^{
			model.state = 0;
			[weakSelf.collectionView reloadData];
		} cancelHandler:nil];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
		return;
	}
	HomePageModel * model = self.dataArr[self.selectIndexPath.row];
	UITextField * textfield = [alertView textFieldAtIndex:0];
	NSLog(@"%@",textfield.text);
	if ([YTYUtil JuageLongNumberic:textfield.text]) {
		NSInteger num = [textfield.text integerValue];
		if (num > model.maxNum) {
			[YTYUtil pointCenterAnimationWithText:[NSString stringWithFormat:@"本餐桌最多%ld人",model.maxNum]];
			return;
		}
		if (num == 0) {
			[YTYUtil pointCenterAnimationWithText:@"请至少选择一人"];
			return;
		}
		[self jumpOrderVcWithModel:model num:num];
	}else
	{
		[YTYUtil pointCenterAnimationWithText:@"请输入正整数"];
	}
}
#pragma clang diagnostic pop
#pragma mark --- 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
	[self.view addSubview:self.collectionView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
