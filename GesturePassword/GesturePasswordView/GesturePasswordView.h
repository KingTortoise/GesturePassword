//
//  GesturePasswordView.h
//  PetCommunity
//
//  Created by jinwenwu on 2017/9/22.
//  Copyright © 2017年 jinwenwu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GesturePasswordViewController.h"
#import "GesturePasswordConfig.h"

typedef NS_ENUM(NSInteger, GesturePasswordButtonState) {
    GesturePasswordButtonStateNormal = 0,
    GesturePasswordButtonStateSelected,
    GesturePasswordButtonStateIncorrect,
};

@interface GesturePasswordView : UIView
@property (nonatomic, strong)UIColor *strokeColor;//圆弧的填充颜色
@property (nonatomic, strong)UIColor *fillColor;//除中心圆点外 其他部分的填充色
@property (nonatomic, strong)UIColor *centerPointColor;//中心圆点的颜色
@property (nonatomic, strong)UIColor *lineColor;//线条填充颜色

@property (nonatomic, copy) void(^verificationPassword)(void);//验证旧密码正确
@property (nonatomic, copy) void(^verificationError)(void);//验证旧密码错误
@property (nonatomic, copy) void(^onPasswordSet)(void);//第一次输入密码
@property (nonatomic, copy) void(^onGetCorrectPswd)(void);//第二次输入密码且和第一次一样
@property (nonatomic, copy) void(^onGetIncorrectPswd)(void);//第二次输入密码且和第一次不一样
@property (nonatomic, copy) void(^errorInput)(void);//手势密码小于四位数

+(instancetype)status:(GesturePasswordStatus)status frame:(CGRect)frame onGetCorrectPswd:(void (^)(void))GetCorrectPswd onGetIncorrectPswd:(void (^)(void))GetIncorrectPswd errorInput:(void (^)(void))errorInput;

+(instancetype)status:(GesturePasswordStatus)status frame:(CGRect)frame  onPasswordSet:(void (^)(void))onPasswordSet onGetCorrectPswd:(void (^)(void))GetCorrectPswd onGetIncorrectPswd:(void (^)(void))GetIncorrectPswd errorInput:(void (^)(void))errorInput;

+(instancetype)status:(GesturePasswordStatus)status frame:(CGRect)frame verificationPassword:(void (^)(void))verificationPassword verificationError:(void (^)(void))verificationError onPasswordSet:(void (^)(void))onPasswordSet onGetCorrectPswd:(void (^)(void))GetCorrectPswd onGetIncorrectPswd:(void (^)(void))GetIncorrectPswd errorInput:(void (^)(void))errorInput;
@end
