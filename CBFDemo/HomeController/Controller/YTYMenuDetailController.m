//
//  YTYMenuDetailController.m
//  CBFDemo
//
//  Created by iMac on 2017/5/2.
//  Copyright © 2017年 yty. All rights reserved.
//

#import "YTYMenuDetailController.h"
#import "YTYTakeOutModel.h"

@interface YTYMenuDetailController ()

@property (nonatomic, strong) UIImageView * imageView;

@property (nonatomic, strong) UILabel * priceLB;

@property (nonatomic, strong) UILabel * numLB;

@end

@implementation YTYMenuDetailController

- (void)initUI{
	self.imageView = [UIImageView new];
	self.priceLB   = [UILabel new];
	self.numLB     = [UILabel new];
	
	[self.contentView addSubview:self.imageView];
	[self.contentView addSubview:self.priceLB];
	[self.contentView addSubview:self.numLB];
	
	self.imageView.contentMode = UIViewContentModeScaleAspectFill;
	self.imageView.clipsToBounds = YES;
	
	self.priceLB.font = self.numLB.font = [UIFont systemFontOfSize:14.f];
	self.priceLB.textColor = self.numLB.textColor = RGB(155, 155, 155, 1);
	
	[self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(@64);
		make.left.equalTo(@0);
		make.width.equalTo(@(MAIN_SCREEN_W));
		make.height.equalTo(@(200));
	}];
	[self.numLB mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(@15);
		make.top.equalTo(self.imageView.mas_bottom).offset(10.f);
	}];
	[self.priceLB mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(@(-15));
		make.top.equalTo(self.imageView.mas_bottom).offset(10.f);
	}];
}

#pragma mark -- 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
	[self initUI];
	self.imageView.image = [UIImage imageNamed:self.model.iconPath];
	self.title = self.model.title;
	self.priceLB.text = [NSString stringWithFormat:@"单价:%ld",self.model.price];
	self.numLB.text = [NSString stringWithFormat:@"份数:%ld",self.model.orderCount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
