//
//  DPNavigationController.m
//  xiangyue3
//
//  Created by Shendou on 15/11/18.
//  Copyright (c) 2015年 Shendou. All rights reserved.
//

#import "DPNavigationController.h"

// 让navController.topViewController来决定手势返回是否有效
@interface DPNavigationControllerGestureBackDelegater : NSObject
<UIGestureRecognizerDelegate>
@property(nonatomic,weak,nullable) DPNavigationController* navController;
@end
@implementation DPNavigationControllerGestureBackDelegater

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
	UIViewController* c = _navController.topViewController;
	if(c)
	{
		if([c respondsToSelector:@selector(gestureRecognizerShouldBegin:)])
		{
			return [((id<UIGestureRecognizerDelegate>)c) gestureRecognizerShouldBegin:gestureRecognizer];
		}
	}
	return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
	UIViewController* c = _navController.topViewController;
	if(c)
	{
		if([c respondsToSelector:@selector(gestureRecognizer:shouldReceiveTouch:)])
		{
			return [((id<UIGestureRecognizerDelegate>)c) gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
		}
	}
	return YES;
}

@end

@interface DPNavigationController ()
@end

@implementation DPNavigationController
{
	DPNavigationControllerGestureBackDelegater* gestureBackDelegater;
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		[self setNavigationBarHidden:YES];
	}
	return self;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		[self setNavigationBarHidden:YES];
	}
	return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self setNavigationBarHidden:YES];
	}
	return self;
}
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
	self = [super initWithRootViewController:rootViewController];
	if (self) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[self setNavigationBarHidden:YES];
		});
	}
	return self;
}

- (instancetype)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass
{
	self = [super initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass];
	if (self) {
		[self setNavigationBarHidden:YES];
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	gestureBackDelegater = [[DPNavigationControllerGestureBackDelegater alloc] init];
	gestureBackDelegater.navController = self;
	self.interactivePopGestureRecognizer.delegate = gestureBackDelegater;
}

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated
{
	[super setNavigationBarHidden:YES animated:NO];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
	UIViewController* c = self.topViewController;
	if(c)
	{
		return [c supportedInterfaceOrientations];
	}
	return [super supportedInterfaceOrientations];
}

@end
