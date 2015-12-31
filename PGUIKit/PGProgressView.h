//
//  PGProgressView.h
//  PanguCommonLib
//
//  Created by ouyanghua on 14-2-22.
//  Copyright (c) 2014年 pangu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EProgressViewType)
{
    EProgressViewTypeNone = 0,
    EProgressViewTypeForWindow
};

@interface PGProgressView : UIView

@property(nonatomic, assign)EProgressViewType type; //default EProgressViewTypeForWindow

- (id)initBgColor:(UIColor *)color apla:(float)apla font:(UIFont *)font textColor:(UIColor *)tColor activeColor:(UIColor *)aColor;

- (void)showText:(NSString *)text;

@end