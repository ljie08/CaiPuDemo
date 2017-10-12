//
//  YTYOrderViewController.m
//  CBFDemo
//
//  Created by iMac on 2017/2/15.
//  Copyright © 2017年 yty. All rights reserved.
//

#import "YTYOrderViewController.h"
#import "YTYTableView.h"
#import "YTYTakeOutModel.h"
#import "YTYMenuDetailController.h"
#import <iflyMSC/iflyMSC.h>
@interface YTYOrderViewController ()<IFlyRecognizerViewDelegate>

@property (nonatomic, strong) NSMutableArray * tableViewData;

@property (strong, nonatomic) YTYTableView *tableView;

@property (nonatomic, strong) NSMutableString * resultStr;

@property (nonatomic, strong) NSMutableArray * foodArr;

@end

@implementation YTYOrderViewController

- (void)initData
{
	self.foodArr = [NSMutableArray new];
	
	self.tableViewData = [NSMutableArray array];
	NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
	[dict1 setValue:@"饮品" forKey:@"title"];
	NSMutableArray *array1 = [NSMutableArray array];
	NSArray * DrinksTitls = @[@"酒",@"饮料"];
	[self.foodArr addObjectsFromArray:DrinksTitls];

	for (NSInteger i = 0; i<DrinksTitls.count; i++) {
		YTYTakeOutModel *model = [[YTYTakeOutModel alloc] init];
		model.price = 99;
		model.title = DrinksTitls[i];
		model.soldCount = 10+i;
		NSInteger index = i;
//		if (index > 1) {
//			index = arc4random() % 2;
//		}
		model.iconPath = [NSString stringWithFormat:@"Drinks%ld.jpg",index];
		[array1 addObject:model];
	}
	[dict1 setValue:array1 forKey:@"content"];
	
	NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
	[dict2 setValue:@"面点" forKey:@"title"];
	NSMutableArray *array2 = [NSMutableArray array];
	NSArray * pastryTitls = @[@"烧麦",@"千层饼",@"烩面",@"麻丸"];
	[self.foodArr addObjectsFromArray:pastryTitls];
	for (NSInteger i = 0; i<pastryTitls.count; i++) {
		YTYTakeOutModel *model = [[YTYTakeOutModel alloc] init];
		model.price = 19+i;
		model.title = pastryTitls[i];
		model.soldCount = 20+i;
		NSInteger index = i;
//		if (index > 3) {
//			index = arc4random() % 4;
//		}
		model.iconPath = [NSString stringWithFormat:@"pastry%ld.jpg",index];
		[array2 addObject:model];
	}
	[dict2 setValue:array2 forKey:@"content"];
	
	NSMutableDictionary *dict3 = [NSMutableDictionary dictionary];
	[dict3 setValue:@"美食" forKey:@"title"];
	NSMutableArray *array3 = [NSMutableArray array];
	NSArray * foodTitls = @[@"剁椒鱼头",@"爆椒鸡丁",@"美极鸭下巴",@"长沙麻仁香酥鸭",@"黄飞鸿猪手",@"香辣仔排",@"香辣鸡翅"];
	[self.foodArr addObjectsFromArray:foodTitls];
	for (NSInteger i = 0; i < foodTitls.count; i++) {
		YTYTakeOutModel *model = [[YTYTakeOutModel alloc] init];
		model.price = 99+i;
		model.title = foodTitls[i];
		model.soldCount = 30+i;
		NSInteger index = i;
//		if (index > 6) {
//			index = arc4random() % 7;
//		}
		model.iconPath = [NSString stringWithFormat:@"Food%ld.jpg",index];
		[array3 addObject:model];
	}
	[dict3 setValue:array3 forKey:@"content"];
	
//	NSMutableDictionary *dict4 = [NSMutableDictionary dictionary];
//	[dict4 setValue:@"麻饼" forKey:@"title"];
//	NSMutableArray *array4 = [NSMutableArray array];
//	for (NSInteger i = 0; i<9; i++) {
//		YTYTakeOutModel *model = [[YTYTakeOutModel alloc] init];
//		model.price = 89+i;
//		model.title = [NSString stringWithFormat:@"麻饼%ld",i];
//		model.soldCount = 40+i;
//		model.iconPath = @"2";
//		[array4 addObject:model];
//	}
//	[dict4 setValue:array4 forKey:@"content"];
	
	[self.tableViewData addObject:dict1];
	[self.tableViewData addObject:dict2];
	[self.tableViewData addObject:dict3];
//	[self.tableViewData addObject:dict4];
}

- (YTYTableView *)tableView
{
	if (!_tableView) {
		_tableView = [[YTYTableView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), MAIN_SCREEN_H - 64)];
		__weak typeof(self) weakSelf = self;
		_tableView.placeOrderBlock = ^(NSArray * array){
			NSString * key = weakSelf.homeModel.type == 1 ? @"hallDict":@"roomDict";
			[[[SingleManager shareSingle] typeDictWithKey:key] setValue:array forKey:[NSString stringWithFormat:@"%ld",weakSelf.indexPath.row]];
			weakSelf.homeModel.state = 2;
			if (weakSelf.reloadController) {
                weakSelf.reloadController();
			}
			CGFloat money = 0.f;
			for (YTYTakeOutModel * model in array) {
				money += model.orderCount * model.price;
			}
			weakSelf.homeModel.money = money;
			weakSelf.homeModel.num = weakSelf.number;
			NSString *date = [NSString stringWithFormat:@"%@",[YTYUtil getNowDate]];
			NSArray * tempArr = [date componentsSeparatedByString:@" "];
			weakSelf.homeModel.date = tempArr[1];
			[weakSelf.navigationController popViewControllerAnimated:YES];
		};
		_tableView.showMenuDetailBlock = ^(YTYTakeOutModel *model) {
			YTYMenuDetailController * vc = [YTYMenuDetailController new];
			vc.model = model;
			[weakSelf.navigationController pushViewController:vc animated:YES];
		};
		[self.contentView addSubview:_tableView];
	}
	return _tableView;
}
#pragma mark --click
- (void)speechRecognition
{
	IFlyRecognizerView * view = [[IFlyRecognizerView alloc] initWithCenter:self.contentView.center];
	[view setAutoRotate:YES];
	view.delegate = self;
	[view setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
	//设置听写结果格式为json
	[view setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
	[view start];
	
}

#pragma mark -- IFlyRecognizerViewDelegate

/*!
 *  回调返回识别结果
 *
 *  @param resultArray 识别结果，NSArray的第一个元素为NSDictionary，NSDictionary的key为识别结果，sc为识别结果的置信度
 *  @param isLast      -[out] 是否最后一个结果
 */
- (void)onResult:(NSArray *)resultArray isLast:(BOOL) isLast
{
		NSDictionary *dic = [resultArray objectAtIndex:0];
		
		for (NSString *key in dic) {
			[self.resultStr appendFormat:@"%@",key];
		}
}

/*!
 *  识别结束回调
 *
 *  @param error 识别结束错误码
 */
- (void)onError: (IFlySpeechError *) error{
	
	
	NSScanner *scanner = [NSScanner scannerWithString:self.resultStr];
	[scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
	int number;
	[scanner scanInt:&number];
	NSString *num=[NSString stringWithFormat:@"%d",number];
	
	NSRange index = [self.resultStr rangeOfString:num];
	if (index.location == NSNotFound) {
		number = 1;
	}
	NSInteger nextIndex = index.location + index.length;
	if ((nextIndex +1) < self.resultStr.length) {
		NSString * str = [self.resultStr substringWithRange:NSMakeRange(nextIndex, 1)];
		if ([str isEqualToString:@"份"] || [str isEqualToString:@"个"] || [str isEqualToString:@"。"]) {
		}else
		{
			number = 1;
		}
	}
	NSString * food  = @"";
	for (NSString * foodstr in self.foodArr) {
		if ([self.resultStr rangeOfString:foodstr].location != NSNotFound) {
			food = foodstr;
			break;
		}
	}
	if (food.length == 0) {
		[SVProgressHUD showErrorWithStatus:@"不能识别,或者没有该菜品"];
		return;
	}
	[self.tableView setVoiceStr:food num:number];
	self.resultStr = [NSMutableString new];
	NSLog(@"yty:%@ \n error:%@",self.resultStr,error.errorDesc);
}
#pragma mark -- 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
	self.automaticallyAdjustsScrollViewInsets =	NO;
	self.title = @"点餐";
	self.resultStr = [NSMutableString new];
	UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"语音点餐" style:UIBarButtonItemStyleDone target:self action:@selector(speechRecognition)];
	self.dp_navigationItem.rightBarButtonItem = rightItem;
	[self initData];
	self.tableView.dataArray = self.tableViewData;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
