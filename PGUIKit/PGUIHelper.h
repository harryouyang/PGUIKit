//
//  PGUIHelper.h
//  PanguCommonLib
//
//  Created by ouyanghua on 14-2-22.
//  Copyright (c) 2014年 pangu. All rights reserved.
//

#ifndef PanguCommonLib_PGUIHelper_h
#define PanguCommonLib_PGUIHelper_h

#define kPathTemp       NSTemporaryDirectory()
#define kPathDocument   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define kPathCache      [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define ScreenHeight    [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth     [[UIScreen mainScreen] bounds].size.width
#define ScreenScale     [UIScreen mainScreen].scale

#define ISIPAD      (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

#define ISIPHONE ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)

#define ISIPHONE5   ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define ISIPHONE4   ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(320, 480), [[UIScreen mainScreen] currentMode].size) : NO)

#define ISIPHONE4S   ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define ISSCREEN35      (ISIPHONE4||ISIPHONE4S)

#define IOS9   ([[[UIDevice currentDevice] systemVersion] compare:@"9.0"] != NSOrderedAscending)

#define IOS8   ([[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending)

#define IOS7   ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)

#define IOS6   ([[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending)

#define FONT(size)  [UIFont systemFontOfSize:(size)]

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(float)(r)/255.0 green:(float)(g)/255.0 blue:(float)(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(float)(r)/255.0 green:(float)(g)/255.0 blue:(float)(b)/255.0 alpha:(a)]


#define UIColorFromRGB(rgbValue) \
[UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:1.0]

#define UIColorFromRGBA(rgbValue, alphaValue) \
[UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

#endif
