//
//  GesturePasswordButton.m
//  PetCommunity
//
//  Created by jinwenwu on 2017/9/22.
//  Copyright © 2017年 jinwenwu. All rights reserved.
//

#import "GesturePasswordButton.h"
#import "GesturePasswordView.h"
#import "GesturePasswordConfig.h"

@implementation GesturePasswordButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    __weak GesturePasswordView *gesView = nil;
    if ([self.superview isKindOfClass:[GesturePasswordView class]]) {
        gesView = (GesturePasswordView *)self.superview;
    }
    CGFloat radius = [GesturePasswordConfig sharedInstance].circleRadius - [GesturePasswordConfig sharedInstance].strokeWidth;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, [GesturePasswordConfig sharedInstance].strokeWidth);
    CGPoint centerPoint = CGPointMake(rect.size.width/2, rect.size.height/2);
    CGFloat startAngle = -((CGFloat)M_PI/2);
    CGFloat endAngle = ((2 * (CGFloat)M_PI) + startAngle);
    [gesView.strokeColor setStroke];
    CGContextAddArc(context, centerPoint.x, centerPoint.y, radius+[GesturePasswordConfig sharedInstance].strokeWidth/2, startAngle, endAngle, 0);
    CGContextStrokePath(context);
    
    if ([GesturePasswordConfig sharedInstance].showCenterPoint) {
        [gesView.fillColor set];//同时设置填充和边框色
        CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, startAngle, endAngle, 0);
        CGContextFillPath(context);
        if ([GesturePasswordConfig sharedInstance].fillCenterPoint) {
            [gesView.centerPointColor set];//同时设置填充和边框色
        }else{
            [gesView.centerPointColor setStroke];//设置边框色
        }
        CGContextAddArc(context, centerPoint.x, centerPoint.y, [GesturePasswordConfig sharedInstance].centerPointRadius, startAngle, endAngle, 0);
        if ([GesturePasswordConfig sharedInstance].fillCenterPoint) {
            CGContextFillPath(context);
        }else{
            CGContextStrokePath(context);
        }
    }
}

@end
