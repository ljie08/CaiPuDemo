//
//  HomePageBaseCell.m
//  CBFDemo
//
//  Created by iMac on 2017/2/5.
//  Copyright © 2017年 yty. All rights reserved.
//

#import "HomePageBaseCell.h"

@interface HomePageBaseCell ()

@property (nonatomic, strong) UILabel * titleLB;

@property (nonatomic, strong) UILabel * numberLB;

@property (nonatomic, strong) UILabel * moneyLB;

@property (nonatomic, strong) UILabel * timerLB;

@property (nonatomic, strong) UIView * line;

@end
@implementation HomePageBaseCell

- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		self.titleLB  = [UILabel new];
		self.numberLB = [UILabel new];
		self.moneyLB  = [UILabel new];
		self.timerLB  = [UILabel new];
		self.line     = [UIView new];
		
		[self.contentView addSubview:self.titleLB];
		[self.contentView addSubview:self.numberLB];
		[self.contentView addSubview:self.moneyLB];
		[self.contentView addSubview:self.timerLB];
		[self.contentView addSubview:self.line];
		
		self.contentView.layer.masksToBounds = YES;
		self.contentView.layer.cornerRadius = 8.f;
		
		self.contentView.backgroundColor = [UIColor redColor];
		
		self.titleLB.font = [UIFont systemFontOfSize:13];
		self.numberLB.font = [UIFont systemFontOfSize:11];
		self.moneyLB.font  = [UIFont systemFontOfSize:35];
		self.timerLB.font  = [UIFont systemFontOfSize:11];
		
		self.moneyLB.textColor = [UIColor whiteColor];
		
		self.numberLB.textAlignment = NSTextAlignmentRight;
		
		self.titleLB.text = @"大厅1";
//		self.moneyLB.text = @"¥ 1000.00";
//		self.timerLB.text = @"22:22";
		self.numberLB.text = @"0/4";
		self.line.backgroundColor = [UIColor blackColor];
		[self.titleLB sizeToFit];
		[self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(@15);
			make.top.equalTo(@5);
		}];
		[self.line mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self.titleLB);
			make.right.equalTo(@(-15));
			make.top.equalTo(self.titleLB.mas_bottom).equalTo(@2);
			make.height.equalTo(@0.8f);
		}];
		[self.moneyLB mas_makeConstraints:^(MASConstraintMaker *make) {
//			make.left.and.right.equalTo(self.line);
//			make.top.equalTo(self.line.mas_bottom).equalTo(@10.f);
			make.center.equalTo(self);
		}];
		[self.timerLB mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self.line);
			make.bottom.equalTo(self.mas_bottom).equalTo(@(-10));
			make.width.equalTo(@((CGRectGetWidth(frame) - 30)/2.0));
		}];
		[self.numberLB mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self.line);
			make.bottom.and.width.equalTo(self.timerLB);
		}];
	}
	return self;
}

- (void)setModel:(HomePageModel *)model
{
	_model = model;
	self.titleLB.text = model.type == 1 ? [NSString stringWithFormat:@"大厅%ld",model.index] : [NSString stringWithFormat:@"包间%ld",model.index];
	switch (model.state) {
        case 0:{//清空状态
			self.titleLB.font = [UIFont systemFontOfSize:20];
			[self.titleLB sizeToFit];
			self.contentView.backgroundColor = [UIColor greenColor];
			self.timerLB.hidden = self.line.hidden = self.moneyLB.hidden = YES;
			self.numberLB.text = [NSString stringWithFormat:@"%ld/%ld",model.num,model.maxNum];
			[self.titleLB mas_updateConstraints:^(MASConstraintMaker *make) {
				make.top.equalTo(@((CGRectGetHeight(self.frame) - CGRectGetHeight(self.titleLB.frame))/2.0));
				make.left.equalTo(@((CGRectGetWidth(self.frame) - CGRectGetWidth(self.titleLB.frame))/2.0));
			}];
			self.titleLB.textAlignment = NSTextAlignmentCenter;
			
		}
			break;
		case 1:{//预定255, 215, 0
			self.titleLB.font = [UIFont systemFontOfSize:13];
			self.timerLB.text = model.date;
			self.contentView.backgroundColor = [UIColor colorWithRed:255/255.0 green:215/255.0 blue:0 alpha:1];
			self.timerLB.hidden = self.line.hidden  = NO;
			self.moneyLB.hidden = YES;
			self.titleLB.textAlignment = NSTextAlignmentLeft;
			self.numberLB.text = [NSString stringWithFormat:@"%ld/%ld",model.num,model.maxNum];
			[self.titleLB mas_updateConstraints:^(MASConstraintMaker *make) {
				make.left.equalTo(@15);
				make.top.equalTo(@5);
//				make.center
			}];
		}
			break;
		case 2:{//就餐
			self.titleLB.font = [UIFont systemFontOfSize:13];
			self.titleLB.textAlignment = NSTextAlignmentLeft;
			self.contentView.backgroundColor = [UIColor redColor];
			self.timerLB.hidden = self.line.hidden = self.moneyLB.hidden = NO;
			self.timerLB.text = model.date;
			self.numberLB.text = [NSString stringWithFormat:@"%ld/%ld",model.num,model.maxNum];
			[self setMoney:model.money];
			[self.titleLB mas_updateConstraints:^(MASConstraintMaker *make) {
				make.left.equalTo(@15);
				make.top.equalTo(@5);
			}];
		}
			break;
			
  default:
			break;
	}
}

- (void)setMoney:(CGFloat)money
{
	NSString * string = [NSString stringWithFormat:@"¥ %.2lf",money];
	NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:string];
	[attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:NSMakeRange(0, 1)];
	self.moneyLB.attributedText = attributedString;
}

@end
