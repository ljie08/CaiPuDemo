//
//  CCTableView.m
//  CBFDemo
//
//  Created by iMac on 2017/2/5.
//  Copyright © 2017年 yty. All rights reserved.
//

#import "YTYTableView.h"
#import "YTYTakeOutModel.h"
#import "YTYTakeOutViewCell.h"
#import "YTYTakeOutHeader.h"
#import "YTYBadgeButton.h"
#import "YTYShowOrderView.h"

@interface YTYTableView()<UITableViewDataSource,UITableViewDelegate,YTYTakeOutViewCellDelegate>
@property (nonatomic,weak) UITableView *leftTableView;
@property (nonatomic,weak) UITableView *rightTableView;
@property (nonatomic,weak) UILabel *totalPriceLabel;
@property (nonatomic,assign) NSInteger totalPrice;
@property (nonatomic,weak) YTYBadgeButton *badge;
@property (nonatomic,strong) NSMutableArray *orderArray;

@property (nonatomic, strong) NSIndexPath * leftSelectIndex;

@property (nonatomic, strong) NSMutableArray * tempArr;

@property (nonatomic, strong) YTYShowOrderView * showOrderView;

@property (nonatomic, assign) BOOL isClick;



@end

@implementation YTYTableView

- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		self.leftSelectIndex = [NSIndexPath indexPathForRow:0 inSection:0];
		self.orderArray = [NSMutableArray array];
		[self initInterface];
	}
	return self;
}


- (void)initInterface
{
    //左边的tableview
    UITableView *leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 0, 70, self.frame.size.height) style:UITableViewStylePlain];
    leftTableView.tag = 1;
    leftTableView.dataSource = self;
    leftTableView.delegate = self;
    self.leftTableView = leftTableView;
    self.leftTableView.tableFooterView = [[UIView alloc] init];
    leftTableView.showsVerticalScrollIndicator = NO;
    if ([leftTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [leftTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([leftTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [leftTableView setLayoutMargins:UIEdgeInsetsZero];
    }

    [self addSubview:leftTableView];
    //右边tableview
    UITableView *rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(80, 0, [UIScreen mainScreen].bounds.size.width-80, self.frame.size.height - 64) style:UITableViewStylePlain];
    rightTableView.tag = 2;
    rightTableView.dataSource = self;
    rightTableView.delegate = self;
    self.rightTableView = rightTableView;
    rightTableView.showsVerticalScrollIndicator = NO;
    if ([rightTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [rightTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([rightTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [rightTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self addSubview:rightTableView];
	[self addSubview:self.showOrderView];
    [self initFooter];
}
/**
 * 界面下方的条形栏
 */
- (void)initFooter
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-49, SCREEN_WIDTH, 49)];
    footer.backgroundColor = [UIColor clearColor];
    CALayer *back = [CALayer layer];
    back.frame = CGRectMake(0, 10, self.frame.size.width,39);
    back.backgroundColor = [UIColor colorWithRed:238/255.0 green:240/255.0 blue:241/255.0 alpha:1].CGColor;
    [footer.layer addSublayer:back];
    [self addSubview:footer];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(25, 0, 34, 34);
    button.layer.cornerRadius = 17;
    button.clipsToBounds = YES;
    [button setImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor orangeColor];
	[button addTarget:self action:@selector(orderClick) forControlEvents:UIControlEventTouchUpInside];

    [footer addSubview:button];
    
    UILabel *totleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button.frame)+6, 24, 200, 10)];
    totleLabel.font = [UIFont systemFontOfSize:11];
    self.totalPriceLabel = totleLabel;
    [footer addSubview:totleLabel];
    
    UIButton *overbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    overbutton.frame = CGRectMake(self.frame.size.width-70, 10, 70, 39);
    overbutton.backgroundColor = [UIColor orangeColor];
    [overbutton setTitle:@"确认" forState:UIControlStateNormal];
    [overbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    overbutton.titleLabel.font = [UIFont systemFontOfSize:9];
    [overbutton addTarget:self action:@selector(overButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:overbutton];
    //购物车右上方的标记
    YTYBadgeButton *badge = [[YTYBadgeButton alloc] initWithFrame:CGRectMake(50, 3, 1, 1)];
    self.badge = badge;
    [footer addSubview:badge];
    
}

- (void)orderClick
{
	if (self.orderArray.count == 0) {
		[YTYUtil pointCenterAnimationWithText:@"请至少选择一样佳肴!"];
		return;
	}
	[self.showOrderView show];
}
- (void)overButtonClick
{
	if (self.orderArray.count == 0) {
		[YTYUtil pointCenterAnimationWithText:@"请至少选择一样佳肴!"];
		return;
	}
	__weak typeof(self) weakSelf = self;
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
	[UIAlertView alertWithTitle:@"提示" message:@"确认开单?" okButtonTitle:@"确定" cancelButtonTitle:@"取消" okHandler:^{
	     [weakSelf placeOder];
	} cancelHandler:nil];
#pragma clang diagnostic pop
}
- (void)placeOder{
	[SVProgressHUD show];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		if (self.placeOrderBlock) {
			self.placeOrderBlock([self.orderArray copy]);
		}
		[SVProgressHUD dismiss];
	});

}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
//	NSUInteger sum;
//	self.tempArr = [NSMutableArray new];
//	for (NSInteger i=0; i<self.dataArray.count; i++) {
//		sum +=[self.dataArray[i][@"content"] count];
//		NSLog(@"%lu",sum);
//		[self.tempArr addObject:@(sum)];
//	}
    [self.leftTableView reloadData];
    [self.rightTableView reloadData];
}
#pragma mark --- lazy
- (YTYShowOrderView *)showOrderView
{
	if (!_showOrderView) {
		_showOrderView = [[YTYShowOrderView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_W, MAIN_SCREEN_H - 39 - 64)];
		_showOrderView.hidden = YES;
		_showOrderView.delegate = self;
		_showOrderView.dataArray = self.orderArray;
		__weak typeof(self) weakSelf = self;
		_showOrderView.orderAdd = ^(YTYTakeOutModel *model){
			[weakSelf cellOrderAddModel:model];
			[weakSelf.rightTableView reloadData];
		};
		_showOrderView.orderSub = ^(YTYTakeOutModel *model){
			[weakSelf cellOrderSubModel:model];
			[weakSelf.rightTableView reloadData];
		};
		_showOrderView.notShowCount = ^(YTYTakeOutModel *model){
			[weakSelf cellNotShowCountViewWithModel:model];
			[weakSelf.rightTableView reloadData];
		};
	}
	return _showOrderView;
}
#pragma mark -- Public
- (void)setVoiceStr:(NSString *)voice_str num:(NSInteger)num
{
//YTYTakeOutModel *model = self.dataArray[indexPath.section][@"content"][indexPath.row];
	BOOL isjudge = NO;
	for (YTYTakeOutModel * model in self.orderArray) {
		if ([model.title isEqualToString:voice_str]) {
			[self changeDataOfVoiceWithModel:model num:num];
			for (NSInteger i = 0; i < self.dataArray.count; i ++) {
				NSDictionary * dict = self.dataArray[i];
				NSArray * array = dict[@"content"];
				NSInteger index = [array indexOfObject:model];
				if (index !=NSNotFound) {
					NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:i];
					[self.rightTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
				}
			}
			isjudge = YES;
			break;
		}
	}
	if (!isjudge) {
		for (NSInteger i = 0; i < self.dataArray.count; i ++) {
			NSDictionary * dict = self.dataArray[i];
			NSArray * array = dict[@"content"];
			for (NSInteger j = 0; j < array.count; j ++) {
				YTYTakeOutModel * model = array[j];
				if ([model.title isEqualToString:voice_str]) {
					[self changeDataOfVoiceWithModel:model num:num];
					NSIndexPath * indexPath = [NSIndexPath indexPathForRow:j inSection:i];
					[self.rightTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
					break;
				}
			}
		}
	}
}

- (void)changeDataOfVoiceWithModel:(YTYTakeOutModel *)model num:(NSInteger)num{
	model.orderCount += num;
	model.showCount = YES;
	self.totalPrice = model.price * num + self.totalPrice;
	[self.orderArray addObject:model];
	[self priceChange];
	[self badgeValue];
}
#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return tableView.tag==1 ? 1 :self.dataArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableView.tag==1 ? self.dataArray.count : [self.dataArray[section][@"content"] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag ==1) {
        static NSString *ID = @"tabkeOutLeftCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsZero];
                
            }
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
        }
		if ([indexPath isEqual:self.leftSelectIndex]) {
			cell.contentView.backgroundColor = [UIColor orangeColor];
		}else
		{
			cell.contentView.backgroundColor = [UIColor colorWithRed:238/255.0 green:240/255.0 blue:241/255.0 alpha:1];
		}
        cell.textLabel.text = self.dataArray[indexPath.row][@"title"];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:11];
 
        return cell;
    }else
    {
        YTYTakeOutViewCell *cell = [[YTYTakeOutViewCell alloc] cellWithTableView:tableView];
        cell.model = self.dataArray[indexPath.section][@"content"][indexPath.row];
        cell.indexPath = indexPath;
        cell.delegate = self;
        return cell;
    }
}
#pragma mark - tableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 2) {
        YTYTakeOutHeader *header = [YTYTakeOutHeader headerWithTableView:tableView];
        header.titleStr = self.dataArray[section][@"title"];
        return header;
    }else return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return tableView.tag == 1 ? 0 : 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.tag== 1 ? 44:60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag ==1) {
		self.leftSelectIndex = indexPath;
		self.isClick = YES;
        [self.rightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] atScrollPosition:UITableViewScrollPositionTop animated:YES];
		[tableView reloadData];
    }else
	{
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		YTYTakeOutModel * model = self.dataArray[indexPath.section][@"content"][indexPath.row];
		if (self.showMenuDetailBlock) {
			self.showMenuDetailBlock(model);
		}
	}
}
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([tableView isEqual:_rightTableView]) {

	}
}


//- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return tableView.tag == 1 ? YES : NO;
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (self.isClick) {
		return;
	}
    CGFloat y = scrollView.contentOffset.y;
   // 60 是右边cell的高度
	
    NSInteger chooseSection=0;
//  NSInteger section = y/60;
//	for (NSInteger i = 0; i < self.tempArr.count; i ++) {
//		NSInteger curMax = [self.tempArr[i] integerValue];
//		NSInteger lastMax = i == 0 ? 0 :  [self.tempArr[i - 1] integerValue];
//		if (section > lastMax && section <= curMax) {
//			chooseSection = i;
//			break;
//		}
//	}
 
	
	NSMutableArray * array = [NSMutableArray array];
	for (NSInteger i=0; i<self.dataArray.count; i++) {
		NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[self.dataArray[i][@"content"] count] - 1 inSection:i];
		UITableViewCell * cell = [self.rightTableView cellForRowAtIndexPath:indexPath];
		[array addObject:@(CGRectGetMaxY(cell.frame))];
	}
	for (NSInteger i = 0; i < array.count; i ++) {
		CGFloat curMax = [array[i] doubleValue];
		CGFloat lastMax = i == 0 ? 0 :  [array[i - 1] doubleValue];
		if (y > lastMax && y <= curMax) {
			chooseSection = i;
			break;
		}
	}
	self.leftSelectIndex = [NSIndexPath indexPathForRow:chooseSection inSection:0];
	[self.leftTableView reloadData];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
	self.isClick = NO;
}


#pragma mark - cell点击

/**
 * cell开始订购
 */
- (void)cellShowCountViewWithPath:(NSIndexPath *)indexPath
{
    YTYTakeOutModel *model = self.dataArray[indexPath.section][@"content"][indexPath.row];
	[self cellshowCountViewWithModel:model];
    [self.rightTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)cellshowCountViewWithModel:(YTYTakeOutModel *)model
{
	model.showCount = YES;
	[self.orderArray addObject:model];
	[self badgeValue];
}
/**
 * cell取消订购
 */
- (void)cellNotShowCountViewWithPath:(NSIndexPath *)indexPath
{
    YTYTakeOutModel *model = self.dataArray[indexPath.section][@"content"][indexPath.row];
	[self cellNotShowCountViewWithModel:model];
	[self.rightTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

}
- (void)cellNotShowCountViewWithModel:(YTYTakeOutModel *)model{
	model.orderCount = 0;
	model.showCount = NO;
	if ([self.orderArray containsObject:model]) {
		[self.orderArray removeObject:model];
	}
	[self badgeValue];
}

/**
 * cell增加订购数量
 */
- (void)cellOrderAddPath:(NSIndexPath *)indexPath
{
    YTYTakeOutModel *model = self.dataArray[indexPath.section][@"content"][indexPath.row];
	[self cellOrderAddModel:model];
}
- (void)cellOrderAddModel:(YTYTakeOutModel *)model
{
	model.orderCount++;
	NSLog(@"%ld",model.orderCount);
	self.totalPrice = model.price + self.totalPrice;
	[self priceChange];
	[self badgeValue];
}
/**
 * cell减少订购数量
 */
- (void)cellOrderSubPath:(NSIndexPath *)indexPath orderModel:(YTYTakeOutModel *)takeOutmodel
{
    YTYTakeOutModel *model = self.dataArray[indexPath.section][@"content"][indexPath.row];
	[self cellOrderSubModel:model];
}
- (void)cellOrderSubModel:(YTYTakeOutModel *)model
{
	if (model.orderCount > 0) {
		model.orderCount--;
	}
	NSLog(@"%ld",model.orderCount);
	self.totalPrice = self.totalPrice - model.price;
	[self priceChange];
	[self badgeValue];
}
/**
 * 总价格变化调用
 */
- (void)priceChange
{
    self.totalPriceLabel.text = [NSString stringWithFormat:@"共￥%ld",self.totalPrice];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.totalPriceLabel.text];
    NSRange range = NSMakeRange(1, self.totalPriceLabel.text.length-1);
    [str addAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor]} range:range];
    self.totalPriceLabel.attributedText = str;
}

- (void)badgeValue
{
	NSInteger count = 0;
	for (YTYTakeOutModel * model  in self.orderArray) {
		count += model.orderCount;
	}
	self.badge.badgeValue = [NSString stringWithFormat:@"%ld",count];
}
@end
