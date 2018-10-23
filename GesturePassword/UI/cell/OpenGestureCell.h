//
//  OpenGestureCell.h
//  GesturePassword
//
//  Created by 金文武 on 2018/10/23.
//  Copyright © 2018年 金文武. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol OpenGestureCellDelegate <NSObject>
- (void)choiceAction:(UIButton *)sender;
@end

@interface OpenGestureCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *choiceSwitch;
@property (weak, nonatomic) id<OpenGestureCellDelegate> delagate;

- (void)initData:(BOOL)gesSwitch;
@end

NS_ASSUME_NONNULL_END
