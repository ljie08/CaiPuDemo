//
//  SingleManager.m
//  CBFDemo
//
//  Created by iMac on 2017/2/20.
//  Copyright © 2017年 yty. All rights reserved.
//

#import "SingleManager.h"

@implementation SingleManager
+ (instancetype)shareSingle {
	static SingleManager *manager;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		manager = [[self alloc] init];
		manager.orderDict = [NSMutableDictionary new];
		NSMutableDictionary * hallDict = [NSMutableDictionary new];
		NSMutableDictionary * roomDict = [NSMutableDictionary new];
		[manager.orderDict setValue:hallDict forKey:@"hallDict"];
		[manager.orderDict setValue:roomDict forKey:@"roomDict"];
	});
	return manager;
}
- (NSMutableDictionary *)typeDictWithKey:(NSString *)key
{

	return [self.orderDict objectForKey:key];
}
@end
