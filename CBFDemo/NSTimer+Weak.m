//
//  NSTimer+Weak.m
//  ttkan
//
//  Created by 冯健健-iMac on 16/6/6.
//  Copyright © 2016年 xiangyue. All rights reserved.
//

#import "NSTimer+Weak.h"

@implementation NSTimer (Weak)

+ (NSTimer *)weak_scheduledTimerWithTimeInterval:(NSTimeInterval)ti
										 block:(void(^)())block
									   repeats:(BOOL)repeats{
	
	NSTimer * timer = [self scheduledTimerWithTimeInterval:ti
													target:self
												  selector:@selector(weak_blockInvoke:)
												  userInfo:[block copy]
												   repeats:repeats];
	[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
	return timer;
}
+ (void)weak_blockInvoke:(NSTimer *)timer{
	
	void(^block)() = timer.userInfo;
	if (block) {
		block();
	}
}

@end
