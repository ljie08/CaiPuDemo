//
//  YTYUtil.h
//  xiangyue3
//
//  Created by iMac on 16/7/1.
//  Copyright © 2016年 Shendou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTYUtil : NSObject


+ (CGSize)sizeWithString:(NSString*)string font:(UIFont*)font  width:(float)width;//根据宽 算label的高度

+ (BOOL)validateNumberic:(NSString *)numberStr;//验证是否是手机号

+ (void)pointAnimationWithText:(NSString *)text;//提示

+ (void)pointAnimationWithText:(NSString *)text frame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius font:(CGFloat)font;

+ (void)pointCenterAnimationWithText:(NSString *)text;

+ (NSString *)dateWithTimeInterval:(NSInteger)timeInterval formatter:(NSString *)formatter;

+ (NSInteger)getDate:(NSString *)date;//字符串日期 转时间戳 固定日期格式

+ (NSInteger)getDate:(NSString *)date format:(NSString *)format; //字符串日期 转时间戳 自定义日期格式

+ (NSString *)dateLineWithDay:(NSTimeInterval)day format:(NSString *)format;//几天后是什么日期 自定义日期格式

+ (NSString *)dateLineWithDay:(NSTimeInterval)day;//几天后是什么日期 固定日期格式

+ (NSDate *)getNowDate;//获取当前时间 因为[NSDate date]获取时间有偏差

+ (NSString *)currentDateForWeek;//获取今天是周几

//改变uiimage的大小
+ (UIImage *)TransformtoSize:(CGSize)Newsize image:(UIImage *)image;

+(BOOL)isValidateEmail:(NSString *)email;

+ (BOOL)isValidatePassword:(NSString *)password;

+(BOOL) isValidateCarNo:(NSString*)carNo;

+ (BOOL) isRightdate:(NSString*)date;

+ (BOOL)isNumText:(NSString *)str;

+ (BOOL)JuageDoubleNumberic:(NSString *)numberStr;//判断是否是包含小数点的

+ (BOOL)JuageLongNumberic:(NSString *)number;//判断是否是正整数

+ (BOOL)isChineseWithStr:(NSString *)str;//是否是汉字

//+ (BOOL)isURL:(NSString *)url;没用````

+ (NSString *)platform;//获取型号

+ (UIImage *)imageFromString:(NSString *)text withFont:(CGFloat)fontSize icon:(NSString *)icon;//水印图片 文字转换图片 并合并图片
//获取UUID
+(NSString *)getUUID;
/**
 /////  和当前时间比较
 ////   1）1分钟以内 显示        :    刚刚
 ////   2）1小时以内 显示        :    X分钟前
 ///    3）今天或者昨天 显示      :    今天 09:30   昨天 09:30
 ///    4) 今年显示              :   09月12日
 ///    5) 大于本年      显示    :    2013/09/09
 **/
+ (NSString *)formateDate:(NSString *)dateString withFormate:(NSString *) formate;

+ (NSString *)formateWithSecond:(NSInteger)second;

+ (NSDictionary *)getVideoInfoWithSourcePath:(NSString *)path;//获取视频时长与大小 M

+ (void)removeFile:(NSURL *)fileURL; // 删除文件夹

//创建文件夹
+ (void)directoryWithPath:(NSString *)path;

//获取视频角度
+ (NSUInteger)degressFromVideoFileWithURL:(NSURL *)url;
//检索字符串位置
//+ (void)kwordsSearchWith:(NSRange)range string:(NSString *)string kword:(NSString *)kword callback:(void(^)(NSArray *array))callback;

+ (void)kwordsSearchWithArray:(NSMutableArray *)array string:(NSString *)string kword:(NSString *)kword callback:(void (^)(NSArray * array))callback;

+ (NSString *)filterChineseWithString:(NSString *)string;//过滤中文

+ (BOOL)isInstallSina;

@end
