//
//  SeeMenu ViewController.m
//  CBFDemo
//
//  Created by iMac on 2017/3/20.
//  Copyright © 2017年 yty. All rights reserved.
//

#import "YTYSeeMenuController.h"
#import "YTYSeeOrderCell.h"
@interface YTYSeeMenuController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UIView * tapView;

@end

@implementation YTYSeeMenuController

#pragma mark -- lazy
- (UITableView *)tableView
{
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MAIN_SCREEN_W, MAIN_SCREEN_H - 64) style:UITableViewStylePlain];
		_tableView.delegate = self;
		_tableView.dataSource = self;
		_tableView.tableFooterView = [UIView new];
	}
	return _tableView;
}

#pragma  mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	YTYSeeOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
	if (!cell) {
		cell = [[YTYSeeOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
	}
	cell.model = self.dataArray[indexPath.row];
	return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 100.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UIImage *)encodeQRImageWithContent:(NSString *)content size:(CGSize)size {
	
	UIImage *codeImage = nil;
	NSData *stringData = [content dataUsingEncoding: NSUTF8StringEncoding];
	//生成
	CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
	[qrFilter setValue:stringData forKey:@"inputMessage"];
	[qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
	
	UIColor *onColor = [UIColor blackColor];
	UIColor *offColor = [UIColor whiteColor];
	//上色
	CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
									   keysAndValues:
							 @"inputImage",qrFilter.outputImage,
							 @"inputColor0",[CIColor colorWithCGColor:onColor.CGColor],
							 @"inputColor1",[CIColor colorWithCGColor:offColor.CGColor],
							 nil];
	
	CIImage *qrImage = colorFilter.outputImage;
	CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
	UIGraphicsBeginImageContext(size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetInterpolationQuality(context, kCGInterpolationNone);
	CGContextScaleCTM(context, 1.0, -1.0);
	CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
	codeImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	CGImageRelease(cgImage);
	return codeImage;
}
#pragma mark --
- (void)tapAction
{
	//	[UIView animateWithDuration:1.f animations:^{
	//		self.tapView.alpha = 0.f;
	//	} completion:^(BOOL finished) {
	[self.tapView removeFromSuperview];
	self.tapView = nil;
	//	}];
}
- (void)jumpencodeQR
{
	UIWindow * window = [[UIApplication sharedApplication].delegate window];
	if ([window viewWithTag:1000123]) {
		return;
	}
	UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_W, MAIN_SCREEN_H)];
	view.tag = 1000123;
	view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
	[view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];
	CGSize size = CGSizeMake(MAIN_SCREEN_W - 120.f, MAIN_SCREEN_W - 120.f);
	NSString * string = @"这里是柴百非Demo";
	UIImage * image = [self encodeQRImageWithContent:string size:size];
	UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((MAIN_SCREEN_W - size.width)/2.f, (MAIN_SCREEN_H - size.height)/2.f, size.width, size.height)];
	imageView.image = image;
	self.tapView = view;
	[view addSubview:imageView];
	[window addSubview:view];
	
}
#pragma mark -- 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"已点";
	UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"结账" style:UIBarButtonItemStyleDone target:self action:@selector(jumpencodeQR)];
	self.dp_navigationItem.rightBarButtonItem = rightItem;
	[self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
