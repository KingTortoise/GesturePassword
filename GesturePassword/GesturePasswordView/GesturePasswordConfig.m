//
//  GesturePasswordConfig.m
//  PetCommunity
//
//  Created by jinwenwu on 2017/12/5.
//  Copyright © 2017年 jinwenwu. All rights reserved.
//

#import "GesturePasswordConfig.h"
#import "DefineTheme.h"

@implementation GesturePasswordConfig
+ (instancetype)sharedInstance
{
    static GesturePasswordConfig *config = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        config = [GesturePasswordConfig new];
        config.strokeWidth = 1.0f; //圆弧的宽度
        config.circleRadius = 65/2; //半径
        config.centerPointRadius = 10.f;//中心圆半径
        config.lineWidth = 2.f;//连接线宽度
        
        config.strokeColorNormal = [UIColor whiteColor];;//圆弧的填充颜色（正常）
        config.fillColorNormal = [UIColor whiteColor];;//除中心圆点外 其他部分的填充色（正常）
        config.centerPointColorNormal = PC_SEPARATOR_COLOR;;//中心圆点的颜色（正常）
        config.lineColorNormal = [UIColor whiteColor];;//线条填充颜色（正常）
        
        config.strokeColorSelected = UIColorFromHex(0xd7f7eb);//圆弧的填充颜色（选择）
        config.fillColorSelected = UIColorFromHex(0xd7f7eb);//除中心圆点外 其他部分的填充色（选择）
        config.centerPointColorSelected = UIColorFromHex(0x35d59b);//中心圆点的颜色（选择）
        config.lineColorSelected = UIColorFromHex(0x35d59b);//线条填充颜色（选择）
        
        config.strokeColorIncorrect = UIColorFromHex(0xfdddd6);//圆弧的填充颜色（错误）
        config.fillColorIncorrect = UIColorFromHex(0xfdddd6);//除中心圆点外 其他部分的填充色（错误）
        config.centerPointColorIncorrect = UIColorFromHex(0xf75730);//中心圆点的颜色（错误）
        config.lineColorIncorrect = UIColorFromHex(0xf75730);//线条填充颜色（错误）
        
        config.showCenterPoint = YES;//是否显示中心圆
        config.fillCenterPoint = YES;//是否填充中心圆
    });
    return config;
}
@end
