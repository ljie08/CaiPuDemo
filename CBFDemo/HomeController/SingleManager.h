//
//  SingleManager.h
//  CBFDemo
//
//  Created by iMac on 2017/2/20.
//  Copyright © 2017年 yty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleManager : NSObject

+ (instancetype)shareSingle;

@property (nonatomic, strong) NSMutableDictionary * orderDict;

- (NSMutableDictionary *)typeDictWithKey:(NSString *)key;

@end
