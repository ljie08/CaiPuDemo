//
//  TakeOutViewCell.m
//  CBFDemo
//
//  Created by iMac on 2017/2/5.
//  Copyright © 2017年 yty. All rights reserved.
//

#import "YTYTakeOutViewCell.h"
#import "YTYTakeOutModel.h"

@interface YTYTakeOutViewCell()
@property (nonatomic,weak) UILabel *title;
@property (nonatomic,weak) UILabel *sold;
@property (nonatomic,weak) UILabel *price;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,weak) UILabel *countLabel;
@property (nonatomic,weak) UIView *countView;
@property (nonatomic,weak) UIButton *addButton;
@property (nonatomic,weak) UIImageView *icon;
@end

@implementation YTYTakeOutViewCell

- (instancetype)cellWithTableView:(UITableView *)tableview
{
    static NSString *ID = @"YTYTakeOutViewCell";
    YTYTakeOutViewCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
            
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //左边的图标
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 50, 34)];
        icon.backgroundColor = [UIColor orangeColor];
        self.icon = icon;
        [self.contentView addSubview:icon];
        //右边添加按钮
        UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 20, 20, 20)];
        addButton.backgroundColor = [UIColor orangeColor];
        self.addButton = addButton;
        [addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:addButton];
        
        //计数的view
        UIView *countView = [[UIView alloc] initWithFrame:CGRectMake(180, 40, 100, 25)];
        self.countView = countView;
        [self.contentView addSubview:countView];
        
        UIButton *addCountButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 2.5, 14, 14)];
        addCountButton.backgroundColor = [UIColor orangeColor];
        [addCountButton addTarget:self action:@selector(addCountButtonClick) forControlEvents:UIControlEventTouchUpInside];
		[addCountButton setTitle:@"+" forState:UIControlStateNormal];
        [countView addSubview:addCountButton];
        
        UILabel *count = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(addCountButton.frame)+2, 0, 20, 20)];
        count.textAlignment = NSTextAlignmentCenter;
        count.font = [UIFont systemFontOfSize:13];
        self.countLabel = count;
        [countView addSubview:count];
        
        UIButton *subButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(count.frame)+2, 2.5, 14, 14)];
        subButton.backgroundColor = [UIColor orangeColor];
        [subButton addTarget:self action:@selector(countSubButtonClick) forControlEvents:UIControlEventTouchUpInside];
		[subButton setTitle:@"-" forState:UIControlStateNormal];
        [countView addSubview:subButton];
    }
    return self;
}

- (void)addButtonClick:(UIButton *)button
{
    if ([self.delegate  respondsToSelector:@selector(cellShowCountViewWithPath:)]) {
        [self.delegate cellShowCountViewWithPath:self.indexPath];
    }
    if ([self.delegate  respondsToSelector:@selector(cellOrderAddPath:)]) {
        [self.delegate cellOrderAddPath:self.indexPath];
    }
}

- (void)setModel:(YTYTakeOutModel *)model
{
    _model = model;
//    self.title.text = model.title;
    self.count = model.orderCount<=0?1:model.orderCount;
//    self.sold.text = [NSString stringWithFormat:@"已售%ld份",model.soldCount];
//    self.price.text = [NSString stringWithFormat:@"￥%ld",model.price];
    self.countLabel.text = [NSString stringWithFormat:@"%ld",self.count];
    self.icon.image = [UIImage imageNamed:model.iconPath];
    if (model.showCount) {
        self.addButton.hidden = YES;
        self.countView.hidden = NO;
    }else
    {
        self.addButton.hidden = NO;
        self.countView.hidden = YES;
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [self.model.title drawAtPoint:CGPointMake(CGRectGetMaxX(self.icon.frame)+5,5) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    
    NSString *soldCount = [NSString stringWithFormat:@"已售%ld份",self.model.soldCount];;
    [soldCount drawAtPoint:CGPointMake(CGRectGetMaxX(self.icon.frame)+5,24) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    //画价格
    NSString *price = [NSString stringWithFormat:@"￥%ld",self.model.price];
    [price drawAtPoint:CGPointMake(CGRectGetMaxX(self.icon.frame)+5, 40) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor orangeColor]}];
}

- (void)addCountButtonClick
{
    self.count++;
    self.countLabel.text = [NSString stringWithFormat:@"%ld",self.count];
    if ([self.delegate  respondsToSelector:@selector(cellOrderAddPath:)]) {
        [self.delegate cellOrderAddPath:self.indexPath];
    }
}

- (void)countSubButtonClick
{
    self.count--;
    self.countLabel.text = [NSString stringWithFormat:@"%ld",self.count];
    if (self.count <=0) {
        if ([self.delegate  respondsToSelector:@selector(cellNotShowCountViewWithPath:)]) {
            [self.delegate cellNotShowCountViewWithPath:self.indexPath];
        }
    }
	if ([self.delegate  respondsToSelector:@selector(cellOrderSubPath:orderModel:)]) {
		[self.delegate cellOrderSubPath:self.indexPath orderModel:self.model];
    }
    
}
@end
