//
//  PGUIKitUtil.m
//  PGUIKit
//
//  Created by hql on 15/6/23.
//  Copyright (c) 2015年 pangu. All rights reserved.
//

#import "PGUIKitUtil.h"
#import "PGUIHelper.h"
#import "PGScreenAdapter.h"

@implementation PGUIKitUtil

+ (UIFont *)systemFontOfSize:(CGFloat)size
{
    return [PGUIKitUtil systemFontOfSize:size bScale:YES];
}

+ (UIFont *)systemFontOfSize:(CGFloat)size bScale:(BOOL)bScale
{
    float fontSize = bScale ? 1.15*size : size;//*[UIScreen mainScreen].scale/2.0;
    UIFont *font = [UIFont fontWithName:@"PingFang SC" size:fontSize];
    if(!font)
    {
        font = [UIFont systemFontOfSize:fontSize];
    }
    return font;
}

+ (UIView *)createLineFrame:(CGRect)frame lineColor:(UIColor *)color
{
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = color;
    return line;
}

+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *)createCornerRadiusImageWithColor:(UIColor *)color cornerRadius:(NSUInteger)cornerRadius
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 2*cornerRadius, 2*cornerRadius);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillEllipseInRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (void)addButtonBackImage:(UIImage *)normalImage sel:(UIImage *)selImage button:(UIButton *)button
{
    if(button && [button isKindOfClass:[UIButton class]])
    {
        button.backgroundColor = [UIColor clearColor];
        [button setBackgroundImage:normalImage forState:UIControlStateNormal];
        if(selImage)
        {
            [button setBackgroundImage:selImage forState:UIControlStateSelected];
            [button setBackgroundImage:selImage forState:UIControlStateHighlighted];
        }
    }
}

+ (CGRect)CGGetBoundsWithFrame:(CGRect)frame
{
    return CGRectMake(0, 0, frame.size.width, frame.size.height);
}

+ (CGPoint)CGGetCenterWithFrame:(CGRect)frame
{
    return CGPointMake(frame.origin.x + frame.size.width/2, frame.origin.y + frame.size.height/2);
}

+ (UIButton *)createButton:(int)tag frame:(CGRect)frame bgColor:(UIColor *)color lineColor:(UIColor *)lineColor title:(NSString *)szTitle titleColor:(UIColor *)titleColor font:(UIFont *)font target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.tag = tag;
    btn.frame = frame;
    [btn setBackgroundColor:color];
    if(lineColor)
    {
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = lineColor.CGColor;
        btn.layer.cornerRadius = 6.0f;
    }
    [btn setTitle:szTitle forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

+ (UILabel *)createLabel:(NSString *)text frame:(CGRect)frame bgColor:(UIColor *)bgColor titleColor:(UIColor *)titleColor font:(UIFont *)font alignment:(NSTextAlignment)textAlignment
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = bgColor;
    label.textColor = titleColor;
    label.text = text;
    label.font = font;
    label.textAlignment = textAlignment;
    return label;
}

+ (UITextField *)createTextField:(CGRect)frame placeholder:(NSString *)placeholder keyboardType:(UIKeyboardType)keyboardType rView:(UIView *)rView
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.borderStyle = UITextBorderStyleNone;
    textField.layer.cornerRadius = 6.0;
    textField.layer.borderWidth = 1.0;
    textField.placeholder = placeholder;
    textField.backgroundColor = [UIColor whiteColor];
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.keyboardType = keyboardType;
    textField.textColor = [UIColor blackColor];
    textField.font = [UIFont systemFontOfSize:15];
    textField.returnKeyType = UIReturnKeyDone;
    textField.layer.borderColor = UIColorFromRGB(0x870010).CGColor;
    
    UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, frame.size.height)];
    lv.backgroundColor = [UIColor whiteColor];
    textField.leftView = lv;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    if(rView)
    {
        textField.rightView = rView;
        textField.rightViewMode = UITextFieldViewModeAlways;
    }
    
    return textField;
}

+ (UIViewController *)appRootController
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *rootController = window.rootViewController;
    
    if(rootController == nil)
    {
        NSArray *array = [UIApplication sharedApplication].windows;
        UIWindow *topWindow = [array objectAtIndex:0];
        for(UIView *view in topWindow.subviews)
        {
            if([view.nextResponder isKindOfClass:[UIViewController class]] == YES)
            {
                rootController = (UIViewController *)view.nextResponder;
                break;
            }
        }
    }
    
    return rootController;
}

@end
