//
//  TKLoginViewController.m
//  ttkan
//
//  Created by iMac on 16/7/18.
//  Copyright © 2016年 xiangyue. All rights reserved.
//

#import "TKLoginViewController.h"
#import "TKRegisterViewController.h"
@interface TKLoginViewController ()<UITableViewDelegate,UITableViewDataSource>
{
	UIView * _footerView;
}
@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UITextField * accountTF;

@property (nonatomic, strong) UITextField * passwordTF;

@property (nonatomic, copy)   NSArray     * dataArray;

@property (nonatomic, strong) UIButton    * loginBtn;
@end
@implementation TKLoginViewController
#pragma mark - initNavBar
- (void)initNavBar
{
	self.dp_navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(clickToRegVC)];
	self.title = @"登录";
}
#pragma mark -- initUI
- (void)initUI
{
	[self.contentView addSubview:self.tableView];
}
#pragma mark -- click
//注册页
- (void)clickToRegVC
{
	TKRegisterViewController * vc = [TKRegisterViewController new];
	[self.navigationController pushViewController:vc animated:YES];
	
}
//忘记密码页
- (void)forgetAction
{
}
//登录
- (void)loginAction
{
	NSString * account = self.accountTF.text;
	NSString * password = self.passwordTF.text;
	if (account.length == 0) {
		[SVProgressHUD showErrorWithStatus:@"账号不能为空"];
		return;
	}
	if (password.length < 6) {
		[SVProgressHUD showErrorWithStatus:@"密码至少6位"];
		return;
	}
	[self loginWithP1:account p2:password login_type:0];

}
- (void)qqLoginAction
{
}
- (void)sinaLoginAction
{

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
- (UITextField *)accountTF
{
	if (!_accountTF) {
		UIFont * font = [UIFont systemFontOfSize:14];
		CGSize   size = [@"账号" sizeWithAttributes:@{NSFontAttributeName : font}];
		_accountTF = [[UITextField alloc] initWithFrame:CGRectMake(25+size.width, 0, MAIN_SCREEN_W - 35 - size.width, 44)];
		_accountTF.placeholder = @" 请输入手机号";
		_accountTF.font = [UIFont systemFontOfSize:13];
		_accountTF.clearButtonMode = UITextFieldViewModeWhileEditing;
	}
	
	return _accountTF;
}
- (UITextField *)passwordTF
{
	if (!_passwordTF) {
		_passwordTF = [[UITextField alloc] initWithFrame:self.accountTF.frame];
		_passwordTF.placeholder = @" 6-18位数字或英文";
		_passwordTF.font = [UIFont systemFontOfSize:13];
		_passwordTF.keyboardType = UIKeyboardTypeASCIICapable;
		_passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
		_passwordTF.secureTextEntry = YES;
	}
	return _passwordTF;
}

#pragma mark -- tableViewDelegate tableViewDataSource
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
		[cell.contentView addSubview:self.accountTF];
		CALayer * lineLayer = [[CALayer alloc] init];
		lineLayer.frame = CGRectMake(0, 43, MAIN_SCREEN_W, 0.8);
		lineLayer.backgroundColor = XY_RGB(235, 235, 235, 1).CGColor;
		[cell.contentView.layer addSublayer:lineLayer];
	}else if ([title isEqualToString:@"密码"])
	{
		[cell.contentView addSubview:self.passwordTF];
	}
	cell.textLabel.text = title;
	return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_W, 30)];
	UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, MAIN_SCREEN_W - 30, 30)];
	label.text = @"账号登录";
	label.textColor = XY_RGB(153, 153, 153, 1);
	label.font = [UIFont systemFontOfSize:12];
	[view addSubview:label];
	return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_W, CGRectGetHeight(tableView.frame) - self.dataArray.count * 44 - 30)];
		_loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 20, MAIN_SCREEN_W - 30, 44)];
		_loginBtn.layer.masksToBounds = YES;
		_loginBtn.layer.cornerRadius = 5.0;
		_loginBtn.backgroundColor = XY_RGB(124, 212, 252, 1);
		[_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
		[_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[_loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
		_loginBtn.enabled = NO;

		UIButton * forgetPW = [[UIButton alloc] init];
		[forgetPW setTitle:@"忘记密码?" forState:UIControlStateNormal];
		[forgetPW setTitleColor:XY_RGB(2, 173, 253,1) forState:UIControlStateNormal];
		forgetPW.titleLabel.font = [UIFont systemFontOfSize:14];
		[forgetPW sizeToFit];
		forgetPW.frame = CGRectMake(CGRectGetMaxX(_loginBtn.frame) - CGRectGetWidth(forgetPW.frame), CGRectGetMaxY(_loginBtn.frame) + 10, CGRectGetWidth(forgetPW.frame), CGRectGetHeight(forgetPW.frame));
		[forgetPW addTarget:self action:@selector(forgetAction) forControlEvents:UIControlEventTouchUpInside];
		[_footerView addSubview:forgetPW];
		[_footerView addSubview:_loginBtn];
	}
	return _footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return CGRectGetHeight(tableView.frame) - self.dataArray.count * 44 - 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 30;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	[self.view endEditing:YES];
}
#pragma mark -- NSNotificationCenter
- (void)textFieldTextDidChange:(NSNotification *)notification
{
	NSString * password = self.passwordTF.text;
	if (password.length > 18) {
		self.passwordTF.text = [password substringWithRange:NSMakeRange(0, 18)];
	}
	if (self.accountTF.text.length > 0 && password.length >= 6) {
		[self.loginBtn setBackgroundColor:XY_RGB(2, 173, 253, 1)];
		_loginBtn.enabled = YES;
	}else
	{
		_loginBtn.backgroundColor = XY_RGB(124, 212, 252, 1);
		_loginBtn.enabled = NO;
	}
}
#pragma mark -- login
- (void)loginWithP1:(NSString *)p1 p2:(NSString *)p2 login_type:(NSInteger)login_type
{
	if (p1.length == 0 || p2.length == 0) {
		[SVProgressHUD showErrorWithStatus:@"授权失败"];
		return;
	}
	[SVProgressHUD show];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		NSArray * array = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserNames"];
		for (NSDictionary * dict in array) {
			NSString * phoneNum = dict[@"phoneNum"];
			NSString * password = dict[@"password"];
			if ([phoneNum isEqualToString:p1] && [password isEqualToString:password] ) {
				[SVProgressHUD dismiss];
				[[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:nil];
				return ;
			}
		}
		[SVProgressHUD showErrorWithStatus:@"账号密码错误"];
	});

}
#pragma mark -- 生命周期
- (void)viewDidLoad
{
	[super viewDidLoad];
	self.dataArray = @[@"账号",@"密码"];
	self.title = @"登录";
	[self initUI];
	[self initNavBar];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(textFieldTextDidChange:)
												 name:UITextFieldTextDidChangeNotification
											   object:nil];
}
- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

@end
