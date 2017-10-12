//
//  TKRegisterViewController.m
//  ttkan
//
//  Created by iMac on 16/7/18.
//  Copyright © 2016年 xiangyue. All rights reserved.
//

#import "TKRegisterViewController.h"
#import "YTYUtil.h"
#import "NSTimer+Weak.h"
@interface TKRegisterViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
	NSTimer * _timer;
}
@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, copy)   NSArray     * dataArray;

@property (nonatomic, strong) UITextField * phoneNumTF;

@property (nonatomic, strong) UITextField * passwordTF;

@property (nonatomic, strong) UITextField * verificationTF;

@property (nonatomic, strong) UIButton    * verificationBtn;

@property (nonatomic, strong) UIButton    * registerBtn;

@property (nonatomic, assign) NSInteger     countDown;

@end

@implementation TKRegisterViewController
#pragma  mark -- initUI
- (void)initUI
{
	UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_W, 64)];
	_registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 20, MAIN_SCREEN_W - 30, 44)];
	_registerBtn.layer.masksToBounds = YES;
	_registerBtn.layer.cornerRadius = 5.0;
	_registerBtn.backgroundColor = XY_RGB(124, 212, 252, 1);
	[_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
	[_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
	_registerBtn.enabled = NO;
	[footerView addSubview:_registerBtn];
	self.tableView.tableFooterView = footerView;
	[self.contentView addSubview:self.tableView];
}
#pragma mark -- click
- (void)registerAction
{
	NSString * phoneNumber = self.phoneNumTF.text;
	NSString * password = self.passwordTF.text;
	NSString * verify = self.verificationTF.text;
	if (phoneNumber.length < 11 || ![YTYUtil validateNumberic:phoneNumber]) {
		[SVProgressHUD showErrorWithStatus:@"请填写正确手机号"];
		return;
	}
	if (password.length < 6) {
		[SVProgressHUD showErrorWithStatus:@"账号密码至少6位"];
		return;
	}
	if (verify.length == 0) {
		[SVProgressHUD showErrorWithStatus:@"请填写验证码"];
		return;
	}
	if (![verify isEqualToString:@"1111"]) {
		[SVProgressHUD showErrorWithStatus:@"验证码错误"];
		return;
	}
//	__weak __typeof(self) wself = self;
//	[self prompting:@"正在注册"];
	[SVProgressHUD show];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		NSDictionary * dict = @{@"phoneNum" : phoneNumber,@"password":password};
		NSMutableArray * array = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserNames"]];
		for (NSDictionary * dict in array) {
			NSString * userName = dict[@"phoneNum"];
			if ([phoneNumber isEqualToString:userName]) {
				[SVProgressHUD showErrorWithStatus:@"账号已经注册,请直接登录"];
				return;
			}
		}
		[array addObject:dict];
		[[NSUserDefaults standardUserDefaults] setObject:array forKey:@"UserNames"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[SVProgressHUD dismiss];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:nil];
	});
}
- (void)verificationAction
{
	[self.view endEditing:YES];
	NSString * phoneNumber = self.phoneNumTF.text;
	if (phoneNumber.length < 11 || ![YTYUtil validateNumberic:phoneNumber]) {
		[SVProgressHUD showErrorWithStatus:@"请输入正确手机号"];
		return;
	}
	// 获取验证码
	[self getVeryfyCodeAction];
	self.verificationBtn.enabled = NO;
	_countDown = 60;
	[self updateTimerWithCountDown];
	WS(weakSelf);
	_timer = [NSTimer weak_scheduledTimerWithTimeInterval:1 block:^{
		weakSelf.countDown--;
		[weakSelf updateTimerWithCountDown];
	} repeats:YES];
}
- (void)updateTimerWithCountDown
{
	if (self.countDown < 1) {
		// 销毁定时器
		[self invalidTimer];
		[self.verificationBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
		self.verificationBtn.enabled = YES;
		self.verificationBtn.backgroundColor = XY_RGB(2, 173, 253, 1);
	}else {
		[self.verificationBtn setTitle:[NSString stringWithFormat:@"%ld秒后重发", self.countDown] forState:UIControlStateNormal];
		self.verificationBtn.enabled = NO;
		self.verificationBtn.backgroundColor = XY_RGB(204, 204, 204, 1);
	}
}
- (void)getVeryfyCodeAction
{
//    NSString * phoneNumber = self.phoneNumTF.text;
	[YTYUtil pointAnimationWithText:nil];

}
- (void)invalidTimer
{
	if ([_timer isValid]) {
		[_timer invalidate];
		_timer = nil;
		_countDown = 60;
	}
}
#pragma mark -- lazy
- (UITableView *)tableView
{
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MAIN_SCREEN_W, MAIN_SCREEN_H - 64) style:UITableViewStyleGrouped];
		_tableView.delegate = self;
		_tableView.dataSource = self;
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	}
	return _tableView;
}
- (UIButton *)verificationBtn
{
	if (!_verificationBtn) {
		_verificationBtn = [[UIButton alloc] initWithFrame:CGRectMake(MAIN_SCREEN_W - 82, (44 - 25)/2.0, 70, 25)];
		[_verificationBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
		[_verificationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		_verificationBtn.titleLabel.font = [UIFont systemFontOfSize:12];
		_verificationBtn.backgroundColor = XY_RGB(2, 173, 253, 1);
		_verificationBtn.layer.masksToBounds = YES;
		_verificationBtn.layer.cornerRadius = 5.0;
		[_verificationBtn addTarget:self action:@selector(verificationAction) forControlEvents:UIControlEventTouchUpInside];
	}
	return _verificationBtn;
}
- (UITextField *)phoneNumTF
{
	if (!_phoneNumTF) {
		CGSize size = [@"验证码" sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}];
		_phoneNumTF = [[UITextField alloc] initWithFrame:CGRectMake(25 + size.width, 0, CGRectGetMinX(self.verificationBtn.frame) - 35 - size.width , 44)];
		_phoneNumTF.keyboardType = UIKeyboardTypeNumberPad;
		_phoneNumTF.font = [UIFont systemFontOfSize:13];
		_phoneNumTF.placeholder = @" 请输入手机号";
		_phoneNumTF.clearButtonMode = UITextFieldViewModeWhileEditing;
	}
	return _phoneNumTF;
}
- (UITextField *)passwordTF
{
	if (!_passwordTF) {
		CGSize size = [@"验证码" sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}];
		_passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(25 + size.width, 0, MAIN_SCREEN_W - 35 - size.width, 44)];
		_passwordTF.font = [UIFont systemFontOfSize:13];
		_passwordTF.placeholder = @" 6-18位数字或英文";
		_passwordTF.keyboardType = UIKeyboardTypeASCIICapable;
		_passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
		_passwordTF.secureTextEntry = YES;
		_passwordTF.delegate = self;
	}
	return _passwordTF;
}
- (UITextField *)verificationTF
{
	if (!_verificationTF) {
		_verificationTF = [[UITextField alloc] initWithFrame:self.passwordTF.frame];
		_verificationTF.keyboardType = UIKeyboardTypeNumberPad;
		_verificationTF.font = [UIFont systemFontOfSize:13];
		_verificationTF.placeholder = @" 请输入验证码";
		_verificationTF.clearButtonMode = UITextFieldViewModeWhileEditing;
	}
	return _verificationTF;
}
#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
	NSString * title = self.dataArray[indexPath.row];
	cell.textLabel.font = [UIFont systemFontOfSize:14];
	cell.textLabel.textColor = XY_RGB(42, 42, 42, 1);
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	if ([title isEqualToString:@"账号"]) {
		[cell.contentView addSubview:self.phoneNumTF];
		[cell.contentView addSubview:self.verificationBtn];
		CALayer * lineLayer = [[CALayer alloc] init];
		lineLayer.frame = CGRectMake(0, 43, MAIN_SCREEN_W, 0.8);
		lineLayer.backgroundColor = XY_RGB(235, 235, 235, 1).CGColor;
		[cell.contentView.layer addSublayer:lineLayer];
	}else if ([title isEqualToString:@"密码"])
	{
		[cell.contentView addSubview:self.passwordTF];
		CALayer * lineLayer = [[CALayer alloc] init];
		lineLayer.frame = CGRectMake(0, 43, MAIN_SCREEN_W, 0.8);
		lineLayer.backgroundColor = XY_RGB(235, 235, 235, 1).CGColor;
		[cell.contentView.layer addSublayer:lineLayer];
	}else if ([title isEqualToString:@"验证码"])
	{
		[cell.contentView addSubview:self.verificationTF];
	}
	cell.textLabel.text = title;
	return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//	[tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
	NSString * title = self.dataArray[indexPath.row];
	if ([title isEqualToString:@"账号"]) {
		[self.phoneNumTF becomeFirstResponder];
	}else if ([title isEqualToString:@"密码"])
	{
		[self.passwordTF becomeFirstResponder];
	}else if ([title isEqualToString:@"验证码"])
	{
		[self.verificationTF becomeFirstResponder];
	}
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	[self.view endEditing:YES];
}
#pragma mark -- textfieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	if (![self.passwordTF isEqual:textField]) {
		return YES;
	}
	if ([string length]>0)
	{
		unichar single=[string characterAtIndex:0];//当前输入的字符
		if((single >='a' && single<='z') || (single >='A' && single<='Z') || (single >='0' && single<='9'))
		{
			
		}
		else
		{
			[textField.text stringByReplacingCharactersInRange:range withString:@""];
			return NO;
		}
	}
	return YES;
}
#pragma mark -- NSNotificationCenter
- (void)textFieldTextDidChange:(NSNotification *)notification
{
	NSString * password = self.passwordTF.text;
	if (password.length > 18) {
		self.passwordTF.text = [password substringWithRange:NSMakeRange(0, 18)];
	}
	if (self.phoneNumTF.text.length > 0 && password.length >= 6 && self.verificationTF.text.length > 0) {
		[self.registerBtn setBackgroundColor:XY_RGB(2, 173, 253, 1)];
		_registerBtn.enabled = YES;
	}else
	{
		_registerBtn.backgroundColor = XY_RGB(124, 212, 252, 1);
		_registerBtn.enabled = NO;
	}

}
#pragma mark -- 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"注册";
	self.dataArray= @[@"账号",@"密码",@"验证码"];
	[self initUI];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(textFieldTextDidChange:)
												 name:UITextFieldTextDidChangeNotification
											   object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
	_timer = nil;
	NSLog(@"%s",__func__);
}
@end
