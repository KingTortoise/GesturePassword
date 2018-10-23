//
//  GesturePasswordViewController.m
//  PetCommunity
//
//  Created by jinwenwu on 2017/9/22.
//  Copyright © 2017年 jinwenwu. All rights reserved.
//

#import "GesturePasswordViewController.h"
#import "GesturePasswordView.h"
#import "AppDelegate.h"
#import "DefineTheme.h"

@interface GesturePasswordViewController ()
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (strong, nonatomic) GesturePasswordView *gesturePasswordView;

@end

@implementation GesturePasswordViewController
#pragma mark LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark BuildView
- (void)initView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    __weak __typeof(&*self) weakSelf = self;
    if (self.status == GesturePasswordStatusSet) {
        self.infoLabel.text = @"请设置手势密码";
        [self.btn setTitle:@"稍后设置" forState:UIControlStateNormal];
        self.topConstraint.constant = 40;
        GesturePasswordView *gesturePasswordView = [GesturePasswordView status:GesturePasswordStatusSet frame:CGRectMake(0, 140, SCREEN_WIDTH, SCREEN_WIDTH-100) onPasswordSet:^() {
            weakSelf.infoLabel.text = @"请重新输入刚才设置的手势密码";
        } onGetCorrectPswd:^ {
            weakSelf.infoLabel.text = @"设置成功";
            [weakSelf setGesturePasswordSwitchOpen];
        } onGetIncorrectPswd:^ {
            weakSelf.infoLabel.text = @"与上一次输入不一致，请重新设置";
        } errorInput:^{
            weakSelf.infoLabel.text = @"请至少连接4个点";
        }];
        [self.view addSubview:gesturePasswordView];
    }else if (self.status == GesturePasswordStatusReset){
        self.infoLabel.text = @"请验证旧密码";
        [self.btn setTitle:@"稍后设置" forState:UIControlStateNormal];
        self.topConstraint.constant = 40;
        GesturePasswordView *gesturePasswordView = [GesturePasswordView status:GesturePasswordStatusReset frame:CGRectMake(0, 140, SCREEN_WIDTH, SCREEN_WIDTH-100) verificationPassword:^{
            weakSelf.infoLabel.text = @"请输入新的手势密码";
        } verificationError:^{
            weakSelf.infoLabel.text = @"旧密码验证错误";
        }  onPasswordSet:^ {
            weakSelf.infoLabel.text = @"请重新输入刚才设置的手势密码";
        } onGetCorrectPswd:^ {
            weakSelf.infoLabel.text = @"设置成功";
            [weakSelf setGesturePasswordSwitchOpen];
        } onGetIncorrectPswd:^ {
            weakSelf.infoLabel.text = @"与上一次输入不一致，请重新设置";
        } errorInput:^{
            weakSelf.infoLabel.text = @"请至少连接4个点";
        }];
        [self.view addSubview:gesturePasswordView];
    }else if (self.status == GesturePasswordStatusLogin){
        self.infoLabel.text = @"请输入手势密码";
        [self.btn setTitle:@"忘记手势密码？" forState:UIControlStateNormal];
        self.topConstraint.constant = 100;
        GesturePasswordView *gesturePasswordView = [GesturePasswordView status:GesturePasswordStatusLogin frame:CGRectMake(0, 200, SCREEN_WIDTH, SCREEN_WIDTH-100) onGetCorrectPswd:^ {
            weakSelf.infoLabel.text = @"解锁成功";
            [weakSelf loginSuccess];
        } onGetIncorrectPswd:^ {
            weakSelf.infoLabel.text = @"密码错误，请重新输入";
        } errorInput:^{
            weakSelf.infoLabel.text = @"请至少连接4个点";
        }];
        [self.view addSubview:gesturePasswordView];
    }
}

#pragma mark Logic
- (void)setGesturePasswordSwitchOpen
{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    [userdefault setObject:@{@"startUpGesturePSD":@(YES)} forKey:GESTUREPASSWORDSWITCH];
    [userdefault synchronize];
    if (self.status == GesturePasswordStatusSet) {
        if ([_delegate respondsToSelector:@selector(updateTableView)]) {
            [_delegate updateTableView];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loginSuccess
{
    NSNotification *notification =[NSNotification notificationWithName:@"userLoginSuccess" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
