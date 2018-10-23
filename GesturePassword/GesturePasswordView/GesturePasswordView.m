//
//  GesturePasswordView.m
//  PetCommunity
//
//  Created by jinwenwu on 2017/9/22.
//  Copyright © 2017年 jinwenwu. All rights reserved.
//

#import "GesturePasswordView.h"
#import "GesturePasswordButton.h"
#import "GesturePasswordViewController.h"
#import "NSString+AES128.h"
#import "DefineTheme.h"
@interface GesturePasswordView()
@property (nonatomic, strong) NSMutableArray *selectorAry;//存储已经选择的按钮
@property (nonatomic, assign)CGPoint currentPoint;//当前处于哪个按钮范围内
@property (nonatomic, assign)GesturePasswordStatus status;//当前控件器所处状态(设置、重新设置、登录)
@property (nonatomic, assign)NSInteger inputNum;//输入的次数
@property (nonatomic, assign)NSInteger resetInputNum;//重置密码时验证旧密码 输入的次数
@property (nonatomic, strong)NSString *firstPassword;//表示设置密码时 第一次输入的手势密码
@end


@implementation GesturePasswordView

#pragma mark init
+(instancetype)status:(GesturePasswordStatus)status frame:(CGRect)frame onGetCorrectPswd:(void (^)(void))GetCorrectPswd onGetIncorrectPswd:(void (^)(void))GetIncorrectPswd errorInput:(void (^)(void))errorInput
{
    return [self status:status frame:frame onPasswordSet:nil onGetCorrectPswd:GetCorrectPswd onGetIncorrectPswd:GetIncorrectPswd errorInput:errorInput];
}

+(instancetype)status:(GesturePasswordStatus)status frame:(CGRect)frame  onPasswordSet:(void (^)(void))onPasswordSet onGetCorrectPswd:(void (^)(void))GetCorrectPswd onGetIncorrectPswd:(void (^)(void))GetIncorrectPswd errorInput:(void (^)(void))errorInput
{
    return [self status:status frame:frame verificationPassword:nil verificationError:nil onPasswordSet:onPasswordSet onGetCorrectPswd:GetCorrectPswd onGetIncorrectPswd:GetIncorrectPswd errorInput:errorInput];
}

+(instancetype)status:(GesturePasswordStatus)status frame:(CGRect)frame verificationPassword:(void (^)(void))verificationPassword verificationError:(void (^)(void))verificationError onPasswordSet:(void (^)(void))onPasswordSet onGetCorrectPswd:(void (^)(void))GetCorrectPswd onGetIncorrectPswd:(void (^)(void))GetIncorrectPswd errorInput:(void (^)(void))errorInput
{
    GesturePasswordView *gesView = [[GesturePasswordView alloc] initWithFrame:frame];
    gesView.status = status;
    gesView.verificationPassword = verificationPassword;
    gesView.verificationError = verificationError;
    gesView.onPasswordSet = onPasswordSet;
    gesView.onGetCorrectPswd = GetCorrectPswd;
    gesView.onGetIncorrectPswd = GetIncorrectPswd;
    gesView.errorInput = errorInput;
    return gesView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectorAry = [[NSMutableArray alloc] init];
        [self setPropertiesByState:GesturePasswordButtonStateNormal];
        NSInteger size = [GesturePasswordConfig sharedInstance].circleRadius * 2;
        NSInteger margin = (SCREEN_WIDTH - 295)/2;
        float ins = 50;
        for (int i = 0; i < 9; i++) {
            NSInteger row = i/3;
            NSInteger col = i%3;
            GesturePasswordButton *gesturePasswordButton = [[GesturePasswordButton alloc] initWithFrame:CGRectMake(ins+col*size+col*margin, row*size+row*margin, size, size)];
            [gesturePasswordButton setTag:i+1];
            [self addSubview:gesturePasswordButton];
        }
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    if ([self.selectorAry count] == 0) {
        return;
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path setLineWidth:[GesturePasswordConfig sharedInstance].lineWidth];
    [self.lineColor set];
    [path setLineJoinStyle:kCGLineJoinRound];// 设置头尾相接处的样式
    [path setLineCapStyle:kCGLineCapRound];// 设置头尾的样式
    for (NSInteger i = 0; i < self.selectorAry.count; i ++) {
        GesturePasswordButton *btn = self.selectorAry[i];
        if (i == 0) {
            [path moveToPoint:[btn center]];
        }else{
            [path addLineToPoint:[btn center]];
        }
        [btn setNeedsDisplay];
    }
    [path addLineToPoint:self.currentPoint];
    [path stroke];
}

#pragma mark touchAction
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    self.currentPoint = point;
    for (GesturePasswordButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, point)) {
            [btn setSelected:YES];
            if (![self.selectorAry containsObject:btn]) {
                [self.selectorAry addObject:btn];
                [self setPropertiesByState:GesturePasswordButtonStateSelected];
            }
        }
    }
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    self.currentPoint = point;
    for (GesturePasswordButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, point)) {
            [btn setSelected:YES];
            if (![self.selectorAry containsObject:btn]) {
                [self.selectorAry addObject:btn];
                [self setPropertiesByState:GesturePasswordButtonStateSelected];
            }
        }
    }
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if (self.selectorAry.count < 4) {
        self.errorInput();
        [self setPropertiesByState:GesturePasswordButtonStateNormal];
    }else if (self.status == GesturePasswordStatusSet) {
        [self setPasswordBlock];
    }else if(self.status == GesturePasswordStatusReset){
        NSString *password = [self getPassword];
        NSString *inputPassword  = [[NSString alloc] init];
        if (self.resetInputNum == 0) {
            for (GesturePasswordButton *btn in self.selectorAry) {
                inputPassword = [inputPassword stringByAppendingFormat:@"%@",@(btn.tag)];
            }
            if ([inputPassword isEqualToString:password]) {
                self.verificationPassword();
                self.resetInputNum += 1;
                [self performSelector:@selector(lockState:) withObject:[NSArray arrayWithObject:[NSNumber numberWithInteger:GesturePasswordButtonStateNormal]] afterDelay:0.3f];
            }else{
                self.verificationError();
                [self setPropertiesByState:GesturePasswordButtonStateIncorrect];
            }
        }else if(self.resetInputNum == 1){
            [self setPasswordBlock];
        }
    }else if(self.status == GesturePasswordStatusLogin){
        NSString *password = [self getPassword];
        NSString *inputPassword  = [[NSString alloc] init];
        for (GesturePasswordButton *btn in self.selectorAry) {
            inputPassword = [inputPassword stringByAppendingFormat:@"%@",@(btn.tag)];
        }
        if ([inputPassword isEqualToString:password]) {
            self.onGetCorrectPswd();
            [self setPropertiesByState:GesturePasswordButtonStateNormal];
        }else{
            self.onGetIncorrectPswd();
            [self setPropertiesByState:GesturePasswordButtonStateIncorrect];
        }
    }
    GesturePasswordButton *btn = [self.selectorAry lastObject];
    [self setCurrentPoint:btn.center];
    [self setNeedsDisplay];
}

#pragma mark Logic
- (void)setPasswordBlock
{
    if (self.inputNum == 0) {
        self.firstPassword = [[NSString alloc] init];
        for (GesturePasswordButton *btn in self.selectorAry) {
            self.firstPassword = [self.firstPassword stringByAppendingFormat:@"%@",@(btn.tag)];
        }
        self.onPasswordSet();
        self.inputNum += 1;
        [self performSelector:@selector(lockState:) withObject:[NSArray arrayWithObject:[NSNumber numberWithInteger:GesturePasswordButtonStateNormal]] afterDelay:0.3f];
    }else{
        NSString *secondPassword = [[NSString alloc] init];
        for (GesturePasswordButton *btn in self.selectorAry) {
            secondPassword = [secondPassword stringByAppendingFormat:@"%@",@(btn.tag)];
        }
        if ([self.firstPassword isEqualToString:secondPassword]) {
            [self savePassWord:secondPassword];
            self.onGetCorrectPswd();
            [self performSelector:@selector(lockState:) withObject:[NSArray arrayWithObject:[NSNumber numberWithInteger:GesturePasswordButtonStateNormal]] afterDelay:0.3f];
        }else{
            self.onGetIncorrectPswd();
            [self setPropertiesByState:GesturePasswordButtonStateIncorrect];
            self.inputNum -= 1;
        }
    }
}

- (void)setPropertiesByState:(GesturePasswordButtonState)buttonState{
    switch (buttonState) {
        case GesturePasswordButtonStateNormal:
            [self setUserInteractionEnabled:YES];
            [self resetButtons];
            self.lineColor = [GesturePasswordConfig sharedInstance].lineColorNormal;
            self.fillColor = [GesturePasswordConfig sharedInstance].fillColorNormal;
            self.strokeColor = [GesturePasswordConfig sharedInstance].strokeColorNormal;
            self.centerPointColor = [GesturePasswordConfig sharedInstance].centerPointColorNormal;
            break;
        case GesturePasswordButtonStateSelected:
            self.lineColor = [GesturePasswordConfig sharedInstance].lineColorSelected;
            self.fillColor = [GesturePasswordConfig sharedInstance].fillColorSelected;
            self.strokeColor = [GesturePasswordConfig sharedInstance].strokeColorSelected;
            self.centerPointColor = [GesturePasswordConfig sharedInstance].centerPointColorSelected;
            break;
        case GesturePasswordButtonStateIncorrect:
            [self setUserInteractionEnabled:NO];
            self.lineColor = [GesturePasswordConfig sharedInstance].lineColorIncorrect;
            self.fillColor = [GesturePasswordConfig sharedInstance].fillColorIncorrect;
            self.strokeColor = [GesturePasswordConfig sharedInstance].strokeColorIncorrect;
            self.centerPointColor = [GesturePasswordConfig sharedInstance].centerPointColorIncorrect;
            [self performSelector:@selector(lockState:) withObject:[NSArray arrayWithObject:[NSNumber numberWithInteger:GesturePasswordButtonStateNormal]] afterDelay:0.5f];
            break;
        default:
            break;
    }
}

- (void)lockState:(NSArray *)states {
    NSNumber *stateNumber = [states objectAtIndex:0];
    [self setPropertiesByState:[stateNumber integerValue]];
}

- (void)resetButtons {
    for (NSInteger i=0; i<[self.selectorAry count]; i++) {
        GesturePasswordButton *button = self.selectorAry[i];
        [button setSelected:NO];
    }
    [self.selectorAry removeAllObjects];
    [self setNeedsDisplay];
}

#pragma mark PasswordProcessing
- (void)savePassWord:(NSString *)password
{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *enPassword = [password entryptAESBase64];
    [userdefault setObject:@{@"password":enPassword} forKey:GESTUREPASSWORD];
    [userdefault synchronize];
}

- (NSString *)getPassword
{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:GESTUREPASSWORD];
    return [[dic objectForKey:@"password"] deentryptAESBase64];
}
@end
