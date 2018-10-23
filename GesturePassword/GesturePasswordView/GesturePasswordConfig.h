//
//  GesturePasswordConfig.h
//  PetCommunity
//
//  Created by jinwenwu on 2017/12/5.
//  Copyright © 2017年 jinwenwu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GesturePasswordConfig : NSObject
@property (nonatomic, assign) CGFloat strokeWidth; //圆弧的宽度
@property (nonatomic, assign) CGFloat circleRadius; //半径
@property (nonatomic, assign) CGFloat centerPointRadius;//中心圆半径
@property (nonatomic, assign) CGFloat lineWidth;//连接线宽度

@property (nonatomic, strong) UIColor *strokeColorNormal;//圆弧的填充颜色（正常）
@property (nonatomic, strong) UIColor *fillColorNormal;//除中心圆点外 其他部分的填充色（正常）
@property (nonatomic, strong) UIColor *centerPointColorNormal;//中心圆点的颜色（正常）
@property (nonatomic, strong) UIColor *lineColorNormal;//线条填充颜色（正常）

@property (nonatomic, strong) UIColor *strokeColorSelected;//圆弧的填充颜色（选择）
@property (nonatomic, strong) UIColor *fillColorSelected;//除中心圆点外 其他部分的填充色（选择）
@property (nonatomic, strong) UIColor *centerPointColorSelected;//中心圆点的颜色（选择）
@property (nonatomic, strong) UIColor *lineColorSelected;//线条填充颜色（选择）

@property (nonatomic, strong) UIColor *strokeColorIncorrect;//圆弧的填充颜色（错误）
@property (nonatomic, strong) UIColor *fillColorIncorrect;//除中心圆点外 其他部分的填充色（错误）
@property (nonatomic, strong) UIColor *centerPointColorIncorrect;//中心圆点的颜色（错误）
@property (nonatomic, strong) UIColor *lineColorIncorrect;//线条填充颜色（错误）

@property (nonatomic, assign) BOOL showCenterPoint;//是否显示中心圆
@property (nonatomic, assign) BOOL fillCenterPoint;//是否填充中心圆

+ (instancetype)sharedInstance;
@end
