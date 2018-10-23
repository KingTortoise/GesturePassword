//
//  OpenGestureCell.m
//  GesturePassword
//
//  Created by 金文武 on 2018/10/23.
//  Copyright © 2018年 金文武. All rights reserved.
//

#import "OpenGestureCell.h"

@implementation OpenGestureCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)initData:(BOOL)gesSwitch
{
    if (gesSwitch) {
        [self.choiceSwitch setOn:YES];
    }else{
        [self.choiceSwitch setOn:NO];
    }
}

- (IBAction)choiceACtion:(id)sender {
    if ([_delagate respondsToSelector:@selector(choiceAction:)]) {
        [_delagate choiceAction:sender];
    }
}

@end
