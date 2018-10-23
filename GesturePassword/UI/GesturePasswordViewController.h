//
//  GesturePasswordViewController.h
//  PetCommunity
//
//  Created by jinwenwu on 2017/9/22.
//  Copyright © 2017年 jinwenwu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GesturePasswordStatus) {
    GesturePasswordStatusSet           = 0,
    GesturePasswordStatusReset         = 1,
    GesturePasswordStatusLogin         = 2,
};

@protocol GesturePasswordVCDelegate <NSObject>
@optional
- (void)updateTableView;
@end

@interface GesturePasswordViewController : UIViewController
@property (nonatomic, assign) GesturePasswordStatus status;
@property (weak, nonatomic) id<GesturePasswordVCDelegate> delegate;
@end
