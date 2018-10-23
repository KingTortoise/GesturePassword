//
//  DefineTheme.h
//  PetCommunity
//
//  Created by jinwenwu on 2017/8/8.
//  Copyright © 2017年 jinwenwu. All rights reserved.
//

#ifndef DefineTheme_h
#define DefineTheme_h

#define GESTUREPASSWORDSWITCH  @"PetCommunity_GesturePassword_Switch"
#define USR_LOGIN_SUCCESS_NOTIFY    @"userLoginSuccess"
#define GESTUREPASSWORD  @"PetCommunity_GesturePassword"

#define UIColorFromHexWithAlpha(hexValue,a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:a]
#define UIColorFromHex(hexValue)            UIColorFromHexWithAlpha(hexValue,1.0)
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define PC_COLOR_WHITE    [UIColor whiteColor]
#define PC_COLOR_HIGHTLY_WHITE     RGBA(255, 255, 255, 0.5)
#define PC_COLOR_RED                  UIColorFromHex(0xe94709)
#define PC_SEPARATOR_COLOR           UIColorFromHex(0xcccccc)
#define PC_LABELCOLOR_GRAY           UIColorFromHex(0x666666)
#define PC_COLOR_LGREEN              UICOlorFromHex(0x7FFFD4)


#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
#define MENUVIEWHEIGHT  40

static inline UIEdgeInsets sgm_safeAreaInset(UIViewController *vc) {
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safeArea = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
        if (safeArea.top == 0) {
            return UIEdgeInsetsMake(20, 0, 0, 0);
        }
        return safeArea;
    }
    return UIEdgeInsetsMake(20, 0, 0, 0);
}

#endif /* DefineTheme_h */
