//
//  HomePageRoomController.m
//  CBFDemo
//
//  Created by iMac on 2017/2/5.
//  Copyright © 2017年 yty. All rights reserved.
//

#import "HomePageRoomController.h"

@interface HomePageRoomController ()

@end

@implementation HomePageRoomController

- (void)viewDidLoad {
	NSMutableArray * dataArray = [NSMutableArray new];
	//模拟假数据
	for (NSInteger i = 0; i < 20; i ++) {
		NSMutableDictionary * dic = [NSMutableDictionary new];
		[dic setObject:@"2" forKey:@"type"];//1是大厅 2是包间
		NSInteger remond = arc4random() % 2;// 0 是清空状态  1是预定状态  2是正在用餐
		[dic setObject:@(remond) forKey:@"state"];
		if (remond == 1) {
			[dic setObject:@"08:00" forKey:@"data"];
		}
		NSInteger maxNum = arc4random() % 4 + 2;
		[dic setObject:@(i) forKey:@"index"];
		[dic setObject:@(maxNum) forKey:@"maxNum"];
		HomePageModel * model = [HomePageModel mj_objectWithKeyValues:dic];
		[dataArray addObject:model];
	}
	self.dataArr = [dataArray copy];
	[super viewDidLoad];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
