//
//  PGUIKitUtil.h
//  PGUIKit
//
//  Created by hql on 15/6/23.
//  Copyright (c) 2015年 pangu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGUIKitUtil : NSObject

+ (UIFont *)systemFontOfSize:(CGFloat)size;

+ (UIFont *)systemFontOfSize:(CGFloat)size bScale:(BOOL)bScale;

+ (UIView *)createLineFrame:(CGRect)frame lineColor:(UIColor *)color;

+ (UIImage *)createImageWithColor:(UIColor *)color;

+ (UIView *)createDashLineFrame:(CGRect)frame lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

+ (UIImage *)createCornerRadiusImageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;

+ (void)addButtonBackImage:(UIImage *)normalImage sel:(UIImage *)selImage button:(UIButton *)button;

+ (void)setButtonBack:(UIColor *)normalColor selColor:(UIColor *)selColor radius:(float)radius button:(UIButton *)button;

+ (CGRect)CGGetBoundsWithFrame:(CGRect)frame;

+ (CGPoint)CGGetCenterWithFrame:(CGRect)frame;

+ (UIButton *)createButton:(int)tag frame:(CGRect)frame bgColor:(UIColor *)color lineColor:(UIColor *)lineColor title:(NSString *)szTitle titleColor:(UIColor *)titleColor font:(UIFont *)font target:(id)target action:(SEL)action;

+ (UILabel *)createLabel:(NSString *)text frame:(CGRect)frame bgColor:(UIColor *)bgColor titleColor:(UIColor *)titleColor font:(UIFont *)font alignment:(NSTextAlignment)textAlignment;

+ (UITextField *)createTextField:(CGRect)frame placeholder:(NSString *)placeholder keyboardType:(UIKeyboardType)keyboardType rView:(UIView *)rView;

+ (UIViewController *)appRootController;

@end
