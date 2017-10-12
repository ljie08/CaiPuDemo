//
//  CCCrc32.h
//  TestYty
//
//  Created by iMac on 2016/10/11.
//  Copyright © 2016年 yty. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <zlib.h>
#import <zconf.h>

//需要导入libz.tbd
typedef void(^CCCrc32CompletedHandler)(uLong crc32);  // crc32 == 0 : error
@interface CCCrc32 : NSObject

+ (uLong)crc32WithFilePath:(NSString *)filePath;

+ (uLong)crc32WithURL:(NSURL *)url;

+ (uLong)crc32WithData:(NSData *)data;

// 大文件crc32校验
+ (void)crc32WithFileAtPath:(NSString *)filePath handler:(CCCrc32CompletedHandler)handler;

+ (void)crc32WithURL:(NSURL *)url handler:(CCCrc32CompletedHandler)handler;

+ (void)crc32WithData:(NSData *)data handler:(CCCrc32CompletedHandler)handler;

@end

@interface CCCrc32Inner : NSObject<NSStreamDelegate>

@property (nonatomic, strong) NSInputStream           *inputStream;
@property (nonatomic, assign) uLong                   crc32;
@property (nonatomic, copy  ) CCCrc32CompletedHandler handler;
@property (nonatomic, assign) BOOL                    isFinished;

- (void)crc32WithFileAtPath:(NSString *)filePath handler:(CCCrc32CompletedHandler)handler;

- (void)crc32WithURL:(NSURL *)url handler:(CCCrc32CompletedHandler)handler;

- (void)crc32WithData:(NSData *)data handler:(CCCrc32CompletedHandler)handler;

@end
