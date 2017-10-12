//
//  YTYSeeOrderCell.m
//  CBFDemo
//
//  Created by iMac on 2017/3/20.
//  Copyright © 2017年 yty. All rights reserved.
//

#import "YTYSeeOrderCell.h"

@interface YTYSeeOrderCell ()

@property (nonatomic, strong) UIImageView * picImg;

@property (nonatomic, strong) UILabel * nameLB;

@property (nonatomic, strong) UILabel * numLB;

@property (nonatomic, strong) UILabel * priceLB;

@end

@implementation YTYSeeOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		self.picImg = [[UIImageView alloc] init];
		self.nameLB = [[UILabel alloc] init];
		self.numLB  = [[UILabel alloc] init];
		self.priceLB = [[UILabel alloc] init];
		
		[self.contentView addSubview:self.picImg];
		[self.contentView addSubview:self.nameLB];
		[self.contentView addSubview:self.numLB];
		[self.contentView addSubview:self.priceLB];
		
		self.nameLB.font = [UIFont systemFontOfSize:15];
		self.numLB.font  = [UIFont systemFontOfSize:13.f];
		self.priceLB.font  = [UIFont systemFontOfSize:13.f];
		self.picImg.contentMode = UIViewContentModeScaleAspectFill;
		self.picImg.clipsToBounds = YES;
		
		self.picImg.backgroundColor = [UIColor redColor];
		self.nameLB.text = @"汉堡";
		self.numLB.text = @"2份";
		[self.picImg mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(@15.f);
			make.centerY.equalTo(self.contentView.mas_centerY);
			make.top.equalTo(@10.f);
			make.width.equalTo(@80.f);
		}];
		[self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self.picImg.mas_right).equalTo(@15.f);
			make.top.equalTo(self.picImg.mas_top).equalTo(@5.f);
		}];
		[self.priceLB mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self.nameLB.mas_left);
			make.top.equalTo(self.nameLB.mas_bottom).equalTo(@5.f);
		}];
		[self.numLB mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(@(-10.f));
			make.centerY.equalTo(self.contentView.mas_centerY);
		}];
	}
	return self;
}

- (void)setModel:(YTYTakeOutModel *)model
{
	_model = model;
	self.picImg.image = [UIImage imageNamed:model.iconPath];
	self.nameLB.text = model.title;
	self.numLB.text = [NSString stringWithFormat:@"%ld份",model.orderCount];
	self.priceLB.text = [NSString stringWithFormat:@"¥%ld",model.price];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
