//
//  YTYUtil.m
//  ttkan
//
//  Created by iMac on 16/7/21.
//  Copyright © 2016年 xiangyue. All rights reserved.
//

#import "YTYUtil.h"
#import "sys/utsname.h"
#include <sys/sysctl.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
@implementation YTYUtil
//时间戳转日期
+ (NSString *)dateWithformatter:(NSInteger)dateformatter
{
//	NSTimeInterval time=dateformatter;
//	NSDate * detaildate=[NSDate dateWithTimeIntervalSince1970:time];
//	NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
//	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//	NSString * currentDateStr = [dateFormatter stringFromDate:detaildate];
	return [self dateWithTimeInterval:dateformatter formatter:@"yyyy-MM-dd HH:mm"];
}
+ (NSString *)dateWithTimeInterval:(NSInteger)timeInterval formatter:(NSString *)formatter
{
	formatter = formatter.length == 0 ? @"yyyy-MM-dd HH:mm" : formatter;
	NSTimeInterval time=timeInterval;
	NSDate * detaildate=[NSDate dateWithTimeIntervalSince1970:time];
	NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
	[dateFormatter setDateFormat:formatter];
	NSString * currentDateStr = [dateFormatter stringFromDate:detaildate];
	return currentDateStr;
}

+ (CGSize)sizeWithString:(NSString*)string font:(UIFont*)font  width:(float)width {
	
	CGRect rect = [string boundingRectWithSize:CGSizeMake(width,   MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
	return rect.size;
}
+ (BOOL)validateNumberic:(NSString *)numberStr
{
	NSString *pattern =@"^((17[0-9])|(13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
	BOOL isMatch = [pred evaluateWithObject:numberStr];
	return isMatch;
}
+ (void)pointAnimationWithText:(NSString *)text
{
	[self pointAnimationWithText:@"验证码已发送到手机请注意查收" frame:CGRectMake(0, 64, MAIN_SCREEN_W, 30) cornerRadius:0 font:12];
}

+ (void)pointCenterAnimationWithText:(NSString *)text
{
	CGSize size = [text sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}];
	size.width += 10;
	size.height += 10;
	CGRect frame = CGRectMake((MAIN_SCREEN_W - size.width)/2.0, (MAIN_SCREEN_H - size.height)/2.0 - size.height, size.width, size.height);
	[self pointAnimationWithText:text frame:frame cornerRadius:8.f font:15];
}

+ (void)pointAnimationWithText:(NSString *)text frame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius font:(CGFloat)font
{
	NSString * string = text.length == 0 ?  @"验证码已发送到手机请注意查收" : text;
	
	UILabel * label = (UILabel *)[[[UIApplication sharedApplication].delegate window] viewWithTag:111211];
	if (label != nil) {
		[label removeFromSuperview];
	}
	label =  [[UILabel alloc] initWithFrame:frame];
	label.backgroundColor = RGB(42, 42, 42, 0.5);
	label.font = [UIFont systemFontOfSize:font];
	label.textColor = [UIColor whiteColor];
	label.textAlignment = NSTextAlignmentCenter;
	label.text =string;
	label.alpha = 0.f;
	label.layer.masksToBounds = YES;
	label.layer.cornerRadius = cornerRadius;
	label.tag = 111211;
	[[[UIApplication sharedApplication].delegate window] addSubview:label];
	[UIView animateWithDuration:0.5 animations:^{
		label.alpha = 1.f;
	} completion:^(BOOL finished) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
			[UIView animateWithDuration:0.5 animations:^{
				label.alpha = 0.f;
			} completion:^(BOOL finished) {
				[label removeFromSuperview];
			}];
		});
	}];
}

+ (NSInteger)getDate:(NSString *)date
{
	return [self getDate:date format:@""];
}

+ (NSDate *)getNowDate
{
	NSDate * temp_date = [NSDate date];
	NSTimeZone *zone = [NSTimeZone systemTimeZone];
	NSInteger interval = [zone secondsFromGMTForDate: temp_date];
	NSDate *localeDate = [temp_date  dateByAddingTimeInterval: interval];
	return localeDate;
}

+ (NSInteger)getDate:(NSString *)date format:(NSString *)format
{
	format = format.length == 0 ? @"yy-MM-dd HH:mm" : format;
	NSDateFormatter *df = [[NSDateFormatter alloc] init];//格式化
	[df setDateFormat:format];
	[df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
	NSDate * thedate = [df dateFromString: date];
	return [thedate timeIntervalSince1970];
}

+ (NSString *)dateLineWithDay:(NSTimeInterval)day
{
	return [self dateLineWithDay:day format:@"yyyyMMdd"];
}
+ (NSString *)dateLineWithDay:(NSTimeInterval)day format:(NSString *)format
{
	format = format.length == 0 ? @"yy-MM-dd HH:mm" : format;
	NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
	NSDate * nowDate = [NSDate date];
	NSTimeInterval  interval =24*60*60*day; //day:天数
	NSDate * date1 = [nowDate initWithTimeIntervalSinceNow:interval];
	[dateFormatter setDateFormat:format];
	return [dateFormatter stringFromDate:date1];
}


/*邮箱验证 MODIFIED BY HELENSONG*/
+(BOOL)isValidateEmail:(NSString *)email
{
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	return [emailTest evaluateWithObject:email];
}

/*密码验证 MODIFIED BY HELENSONG*/
+ (BOOL)isValidatePassword:(NSString *)password{
	//密码只能是数字和字母
	NSString *passwordRegex = @"^^[A-Za-z0-9]+$";
	NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passwordRegex];
	//    NSLog(@"phoneTest is %@",phoneTest);
	return [phoneTest evaluateWithObject:password];
}

/*车牌号验证 MODIFIED BY HELENSONG*/
+(BOOL) isValidateCarNo:(NSString*)carNo
{
	NSString *carRegex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
	NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
	//    NSLog(@"carTest is %@",carTest);
	return [carTest evaluateWithObject:carNo];
}

+ (BOOL) isRightdate:(NSString*)date
{
	NSString * dateRegex = @"^(?:(?!0000)[0-9]{4}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-8])|(?:0[13-9]|1[0-2])-(?:29|30)|(?:0[13578]|1[02])-31)|(?:[0-9]{2}(?:0[48]|[2468][048]|[13579][26])|(?:0[48]|[2468][048]|[13579][26])00)-02-29)$";
	
	NSPredicate *dateTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",dateRegex];
	
	return [dateTest evaluateWithObject:date];
}

+ (BOOL)isNumText:(NSString *)str{
	NSString * regex = @"^d{n}$";
	NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	BOOL isMatch = [pred evaluateWithObject:str];
	if (isMatch) {
		return YES;
	}else{
		return NO;
	}
}
+ (BOOL)JuageDoubleNumberic:(NSString *)numberStr//判断是否是包含小数点的
{
	NSString *pattern =@"^(-?\\d+)(\\.\\d+)?$";
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
	BOOL isMatch = [pred evaluateWithObject:numberStr];
	return isMatch;
}//
+ (BOOL)JuageLongNumberic:(NSString *)number//判断是否是正整数
{
	NSString *pattern =@"^[0-9]*$";
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
	BOOL isMatch = [pred evaluateWithObject:number];
	return isMatch;
}

+ (BOOL)isChineseWithStr:(NSString *)str
{
	NSString *match = @"(^[\u4e00-\u9fa5]+$)";
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
	return [predicate evaluateWithObject:str];
}

//+ (BOOL)isURL:(NSString *)url
//{
//	/*
//	 NSString *pattern =@"^((17[0-9])|(13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
//	 NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
//	 BOOL isMatch = [pred evaluateWithObject:numberStr];
//	 return isMatch;
//	 */
//	NSString *urlRegex = @"http[s]*://[[[^/:]&&[a-zA-Z_0-9]]\\.]+(:\\d+)?(/[a-zA-Z_0-9]+)*(/[a-zA-Z_0-9]*([a-zA-Z_0-9]+\\.[a-zA-Z_0-9]+)*)?(\\?(&?[a-zA-Z_0-9]+=[%[a-zA-Z_0-9]-]*)*)*(#[[a-zA-Z_0-9]|-]+)?";
//	NSPredicate* urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
//	BOOL isMatch = [urlTest evaluateWithObject:url];
//
//	return isMatch;
//}

+ (NSString *)platform{
	size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	char *machine = malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
	free(machine);
	
	if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
	if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
	if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
	if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
	if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
	if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
	if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
	if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
	if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
	if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
	if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
	if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
	if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
	if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
	if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
	if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s Plus (A1549/A1586)";
	if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s (A1549/A1586)";
	if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
	
	if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
	if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
	if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
	if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
	if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
	
	if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
	
	if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
	if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
	if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
	if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
	if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
	if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
	if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
	
	if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
	if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
	if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
	if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
	if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
	if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
	
	if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
	if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
	if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
	if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
	if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
	if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
	
	if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
	if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
	
	return platform;
}
+ (NSString *)currentDateForWeek
{
	NSDate *date = [NSDate date];
	NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
	[dateformatter setDateFormat:@"EEEE"];
	NSString *weekString = [dateformatter stringFromDate:date];
	 /*
	 Monday
	 Tuesday
	 Wednesday
	 Thursday
	 Friday
	 Saturday
	 Sunday
	 */
	if ([weekString isEqualToString:@"Monday"]) {
		return @"周一";
	}else if ([weekString isEqualToString:@"Tuesday"])
	{
		return @"周二";
	}else if ([weekString isEqualToString:@"Wednesday"])
	{
		return @"周三";
	}else if ([weekString isEqualToString:@"Thursday"])
	{
		return @"周四";
	}else if ([weekString isEqualToString:@"Friday"])
	{
		return @"周五";
	}else if ([weekString isEqualToString:@"Saturday"])
	{
		return @"周六";
	}else if ([weekString isEqualToString:@"Sunday"])
	{
		return @"周日";
	}
	return weekString;
}
#define CONTENT_MAX_WIDTH   300.0f


+ (UIImage *)imageFromString:(NSString *)text withFont:(CGFloat)fontSize icon:(NSString *)icon
{
	UIFont *font = [UIFont systemFontOfSize:fontSize];
	CGSize stringSize = [text boundingRectWithSize:CGSizeMake(CONTENT_MAX_WIDTH,   MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
	UIGraphicsBeginImageContextWithOptions(CGSizeMake(stringSize.width + 20, stringSize.height),NO,0.0);
	CGRect rect = CGRectMake(0, 0, stringSize.width , stringSize.height);
	
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	paragraphStyle.alignment = NSTextAlignmentLeft;
	paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
	paragraphStyle.paragraphSpacing = 2.f;
	
	[text drawInRect:rect withAttributes:@{NSFontAttributeName : font,NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName: [UIColor colorWithRed:1 green:1 blue:1 alpha:1]}];
	// transfer image
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return [self mergeImageWithName:icon image1:image];
}
+ (UIImage *)mergeImageWithName:(NSString *)name image1:(UIImage *)image1
{
	//	UIImage * image1 =  [TestWordImage imageFromText:@[@"开车开车开车"] withFont:15  size:CGSizeMake(100, 100)];
//
	
	UIImage * image2 = [UIImage imageNamed:name];
	image2 = [self TransformtoSize:CGSizeMake(image2.size.width * 2.5, image2.size.height * 2.5) image:image2];
	CGSize size = CGSizeMake(image1.size.width + image2.size.width, image2.size.height > image1.size.height ? image2.size.height : image1.size.height);
	UIGraphicsBeginImageContext(size);
	[image2 drawInRect:CGRectMake(0, (size.height - image2.size.height)/2.f, image2.size.width, image2.size.height)];
	[image1 drawInRect:CGRectMake(image2.size.width, (size.height - image1.size.height)/2.f, image1.size.width, image1.size.height)];
	UIImage *togetherImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, togetherImage.size.width, togetherImage.size.height)];
	view.backgroundColor = RGB(0, 0, 0, 0.5);
	UIImage * image = [self imageWithUIView:view];
	[image drawInRect:CGRectMake(0, 0, togetherImage.size.width, togetherImage.size.height)];
	[togetherImage drawInRect:CGRectMake(0, 0, togetherImage.size.width, togetherImage.size.height)];
	
	UIImage * tempImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return tempImage;
}
+ (UIImage *)imageWithUIView:(UIView *)view
{
	UIGraphicsBeginImageContext(view.bounds.size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[view.layer renderInContext:context];
	
	UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return tImage;
}
//改变uiimage的大小
+ (UIImage *)TransformtoSize:(CGSize)Newsize image:(UIImage *)image
{
	// 创建一个bitmap的context
	UIGraphicsBeginImageContext(Newsize);
	// 绘制改变大小的图片
	[image drawInRect:CGRectMake(0, 0, Newsize.width, Newsize.height)];
	// 从当前context中创建一个改变大小后的图片
	UIImage *TransformedImg=UIGraphicsGetImageFromCurrentImageContext();
	// 使当前的context出堆栈
	UIGraphicsEndImageContext();
	// 返回新的改变大小后的图片
	return TransformedImg;
}
+(NSString *)getUUID
{
	
		//生成一个uuid的方法
	CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
	
	NSString * strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
	
	//将该uuid保存到keychain
	return strUUID;
}

/**
 /////  和当前时间比较
 ////   1）1分钟以内 显示        :    刚刚
 ////   2）1小时以内 显示        :    X分钟前
 ///    3）今天或者昨天 显示      :    今天 09:30   昨天 09:30
 ///    4) 今年显示              :   09月12日
 ///    5) 大于本年      显示    :    2013/09/09
 **/
+ (NSString *)formateWithSecond:(NSInteger)second
{
	return [YTYUtil formateDate:[YTYUtil dateWithformatter:second] withFormate:@"yyyy-MM-dd HH:mm"];
}
+ (NSString *)formateDate:(NSString *)dateString withFormate:(NSString *) formate
{
	@try {
		//实例化一个NSDateFormatter对象
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:formate];
		
		NSDate * nowDate = [NSDate date];
		
		/////  将需要转换的时间转换成 NSDate 对象
		NSDate * needFormatDate = [dateFormatter dateFromString:dateString];
		/////  取当前时间和转换时间两个日期对象的时间间隔
		/////  这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:  typedef double NSTimeInterval;
		NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
		
		//// 再然后，把间隔的秒数折算成天数和小时数：
		
		NSString *dateStr = @"";
		
		if (time<=60) {  //// 1分钟以内的
			dateStr = @"刚刚";
		}else if(time<=60*60){  ////  一个小时以内的
			
			int mins = time/60;
			dateStr = [NSString stringWithFormat:@"%d分钟前",mins];
			
		}else if(time<=60*60*24){   //// 在两天内的
			
			[dateFormatter setDateFormat:@"YYYY/MM/dd"];
			NSString * need_yMd = [dateFormatter stringFromDate:needFormatDate];
			NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
			
			[dateFormatter setDateFormat:@"HH:mm"];
			if ([need_yMd isEqualToString:now_yMd]) {
				//// 在同一天
				dateStr = [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:needFormatDate]];
			}else{
				////  昨天
				dateStr = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:needFormatDate]];
			}
		}else {
			
			[dateFormatter setDateFormat:@"yyyy"];
			NSString * yearStr = [dateFormatter stringFromDate:needFormatDate];
			NSString *nowYear = [dateFormatter stringFromDate:nowDate];
			
			if ([yearStr isEqualToString:nowYear]) {
				////  在同一年
				[dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
				dateStr = [dateFormatter stringFromDate:needFormatDate];
			}else{
				[dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
				dateStr = [dateFormatter stringFromDate:needFormatDate];
			}
		}
		
		return dateStr;
	}
	@catch (NSException *exception) {
		return @"";
	}
	
	
}
//获取视频时长与大小 M
+ (NSDictionary *)getVideoInfoWithSourcePath:(NSString *)path{
	AVURLAsset * asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
	CMTime   time = [asset duration];
	int seconds = ceil(time.value/time.timescale);
	
	long long fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
	CGFloat m = fileSize/1024.f/1024.f;
	return @{@"size" : @(m),
			 @"duration" : @(seconds)};
}
//删除文件
+ (void)removeFile:(NSURL *)fileURL
{
	NSString *filePath = [fileURL path];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:filePath]) {
		NSError *error;
		if ([fileManager removeItemAtPath:filePath error:&error] == NO) {
			NSLog(@"removeItemAtPath %@ error:%@", filePath, error);
		}
	}
}

//创建文件夹
+ (void)directoryWithPath:(NSString *)path
{
	BOOL isDirectory = NO;
	BOOL bo = NO;
	BOOL isEx = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
	if (isEx) {
		
	}else
	{
		bo = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
	}
	if (isEx || bo) {
		return;
	}else
	{
		[self directoryWithPath:path];
	}
}

//获取视频角度
+ (NSUInteger)degressFromVideoFileWithURL:(NSURL *)url
{
	if(url == nil) {
		return 0;
	}
	NSUInteger degress = 0;
	AVAsset *asset = [AVAsset assetWithURL:url];
	NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
	if([tracks count] > 0) {
		AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
		CGAffineTransform t = videoTrack.preferredTransform;
		
		if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
			// Portrait
			degress = 90;
		}else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
			// PortraitUpsideDown
			degress = 270;
		}else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
			// LandscapeRight
			degress = 0;
		}else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
			// LandscapeLeft
			degress = 180;
		}
	}
	return degress;
}
//检索字符串位置
+ (void)kwordsSearchWithArray:(NSMutableArray *)array string:(NSString *)string kword:(NSString *)kword callback:(void (^)(NSArray * array))callback
{
	if (string.length == 0|| kword.length == 0) {
		return;
	}
	NSString * lowercaseString = [string lowercaseString];
	NSString * lowercaseKword  = [kword lowercaseString];
	[self kwordsSearchWithRange:NSMakeRange(0, lowercaseString.length) array:array string:lowercaseString kword:lowercaseKword callback:callback];
}
+ (void)kwordsSearchWithRange:(NSRange)range array:(NSMutableArray *)kwordArray string:(NSString *)string kword:(NSString *)kword callback:(void(^)(NSArray *array))callback
{
	NSRange kwordRange = NSMakeRange(0, 0);
	kwordRange = [string rangeOfString:kword options:NSForcedOrderingSearch range:range];
//	NSLog(@"kwordRange : %@  range:%@",NSStringFromRange(kwordRange),NSStringFromRange(range));
	if (kwordRange.length == 0) {
//		NSLog(@"%@",kwordArray);
		if (callback) {
			callback(kwordArray);
		}
		kwordArray = nil;
		return;
	}
	[kwordArray addObject:[NSValue valueWithRange:kwordRange]];
	[self kwordsSearchWithRange:NSMakeRange(kwordRange.location + kwordRange.length, string.length-kwordRange.location - kwordRange.length) array:kwordArray string:string kword:kword callback:callback];

}
+ (NSString *)filterChineseWithString:(NSString *)string//过滤中文
{
	NSMutableArray * tempArr = [NSMutableArray new];
	if ([string length]>0)
	{
		for (NSInteger i = 0; i < [string length]; i ++) {
			int a = [string characterAtIndex:i];
			if( a > 0x4e00 && a < 0x9fff){
//				NSLog(@"%ld",i);
				[tempArr addObject:@(i)];
			}
		}
	}
	for (NSInteger i = tempArr.count - 1; i >= 0 ; i --) {
		NSNumber * num = tempArr[i];
		string = [string stringByReplacingCharactersInRange:NSMakeRange([num integerValue], 1) withString:@""];
	}
	return string;
}

+ (BOOL)isInstallSina
{
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibosso://wb1714073227"]])
	{
		return YES;
	}else
	{
		return NO;
	}
}

@end
