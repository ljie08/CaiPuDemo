//
//  NSTimer+Weak.h
//  ttkan
//
//  Created by 冯健健-iMac on 16/6/6.
//  Copyright © 2016年 xiangyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Weak)
+ (NSTimer *)weak_scheduledTimerWithTimeInterval:(NSTimeInterval)ti
										 block:(void(^)())block
									   repeats:(BOOL)repeats;
@end
