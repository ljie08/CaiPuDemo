//
//  Topbar.m
//  ContainerDemo
//
//  Created by qianfeng on 15/3/3.
//  Copyright (c) 2015年 WeiZhenLiu. All rights reserved.
//

#import "Topbar.h"
#define DIUPIN_COLOR RGB(248,68,97,1.0)

@interface Topbar ()
{
	BOOL _isSignHidden;
}
@property (nonatomic, strong) UIView *markView;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UIColor * normColor;
@property (nonatomic, strong) UIColor * selectColor;
@property (nonatomic, strong) UIColor * lineColor;
@property (nonatomic, strong) CAShapeLayer * shapeLayer;
@end

@implementation Topbar

- (void)setTitles:(NSMutableArray *)titles {
    self.showsHorizontalScrollIndicator = NO;
    _titles = titles;
    self.buttons = [NSMutableArray array];
    CGFloat padding = 10.0;
	self.normColor = RGB(77, 77, 77, 1);
	self.selectColor = RGB(15, 15, 15, 1);
	self.lineColor = RGB(251, 67, 95, 1);
    // CGSize contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
	
	
	self.shapeLayer = [CAShapeLayer layer];
//	self.shapeLayer.backgroundColor = [UIColor redColor].CGColor;
	self.shapeLayer.fillColor = DIUPIN_COLOR.CGColor;
	self.shapeLayer.strokeColor = [UIColor clearColor].CGColor;
	self.shapeLayer.hidden = YES;
	
    for (int i = 0; i < titles.count; i++) {
        if ([_titles[i] isKindOfClass:[NSNull class]]) {
            continue;
        }
        UIButton *button = [[UIButton alloc] init];
		button.titleLabel.font = [UIFont systemFontOfSize:17];
		[button addTarget:self action:@selector(tabButtonTapped:forEvent:) forControlEvents:UIControlEventTouchDown];
		[button addTarget:self action:@selector(repeatBtnTapped:forEvent:) forControlEvents:UIControlEventTouchDownRepeat];
        [button setTitle:_titles[i] forState:UIControlStateNormal];
		[button setTitle:_titles[i] forState:UIControlStateSelected];
        [button setTitleColor:self.normColor forState:UIControlStateNormal];
		[button setTitleColor:self.selectColor forState:UIControlStateSelected];
		button.selected = NO;
		if (i == 0) {
			button.selected = YES;
		}
        // set button frame
        static CGFloat originX = 0;
        CGRect frame = CGRectMake(originX+padding, 0, button.intrinsicContentSize.width, kTopbarHeight);
        button.frame = frame;
        originX      = CGRectGetMaxX(frame) + padding; //originX + padding + button.intrinsicContentSize.width;
		
		if ([_titles[i] isEqualToString:@"关注"]) {
			self.shapeLayer.frame = CGRectMake( CGRectGetWidth(button.frame),  5.f, 5.f, 5.f);
			UIBezierPath * circularPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 6, 6)];
			self.shapeLayer.path = circularPath.CGPath;
			[button.layer addSublayer:self.shapeLayer];
		}
		
        [self addSubview:button];
        [self.buttons addObject:button];
    }
    
    self.contentSize = CGSizeMake(CGRectGetMaxX([self.buttons.lastObject frame]) + padding, self.frame.size.height);
	
	if (CGRectGetWidth(self.frame) > self.contentSize.width) {
		self.frame = CGRectMake((MAIN_SCREEN_W - self.contentSize.width)/2.0, CGRectGetMinY(self.frame), self.contentSize.width, CGRectGetHeight(self.frame));
	}
	
    // mark view
    UIButton *firstButton = self.buttons.firstObject;
    CGRect frame = firstButton.frame;
    self.markView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, CGRectGetMaxY(frame)-2, frame.size.width, 2)];
    _markView.backgroundColor = self.lineColor;
    [self addSubview:_markView];
}

- (void)tabButtonTapped:(UIButton *)sender forEvent:(UIEvent *)event {
	[self performSelector:@selector(buttonClick:) withObject:sender afterDelay:0.12];
}

- (void)repeatBtnTapped:(UIButton *)sender forEvent:(UIEvent *)event {
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(buttonClick:) object:sender];
	
	if (_currentPage != [self.buttons indexOfObject:sender]) {
		[self buttonClick:sender];
	}else
	{
		if (self.doubleClick) {
			self.doubleClick([self.buttons indexOfObject:sender]);
		}
	}
	NSLog(@"双击操作");
}

- (void)buttonClick:(id)sender {
    if (_blockHandler) {
        _blockHandler(self,[self.buttons indexOfObject:sender]);
    }
	_currentPage = [self.buttons indexOfObject:sender];
}

// overwrite setter of property: selectedIndex
- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
	for (UIButton * btn in _buttons) {
		btn.selected = NO;
	}
//	[SVProgressHUD showProgress:(float)];
    UIButton *button = [_buttons objectAtIndex:_currentPage];
	button.selected = YES;
    CGRect frame = button.frame;
    frame.origin.x -= 5;
    frame.size.width += 10;
    [self scrollRectToVisible:frame animated:YES];

	if ((self.contentSize.width - button.center.x) < CGRectGetWidth(self.frame)/2.0) {
		[self setContentOffset:CGPointMake(self.contentSize.width - CGRectGetWidth(self.bounds), 0) animated:YES];
	}else if (button.center.x < CGRectGetWidth(self.frame)/2.0)
	{
		[self setContentOffset:CGPointMake(0, 0) animated:YES];
	}else
	{
		[self setContentOffset:CGPointMake(button.center.x - CGRectGetWidth(self.frame)/2.0, 0) animated:YES];
	}
	
    [UIView animateWithDuration:0.25f animations:^{
        self.markView.frame = CGRectMake(button.frame.origin.x, CGRectGetMinY(self.markView.frame), button.frame.size.width, CGRectGetHeight(self.markView.frame));
    } completion:nil];
}

- (void)setIsSignHidden:(BOOL)isSignHidden
{
	_isSignHidden = isSignHidden;
	self.shapeLayer.hidden = isSignHidden;
}
- (BOOL)isSignHidden
{
	return self.shapeLayer.hidden;
}

@end
