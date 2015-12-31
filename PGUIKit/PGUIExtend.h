//
//  PGUIExtend.h
//  PanguCommonLib
//
//  Created by ouyanghua on 14-2-22.
//  Copyright (c) 2014年 pangu. All rights reserved.
//

#import <UIKit/UIKit.h>

CGRect CGRectMakeWithSize(CGFloat x, CGFloat y, CGSize size);
CGRect CGGetBoundsWithFrame(CGRect frame);
CGPoint CGGetCenterWithFrame(CGRect frame);
UIImage * createImageWithColor(UIColor *color);
UIImage * createCornerRadiusImageWithColor(UIColor *color,NSUInteger cornerRadius);

extern UILabel* (^createLabel)(CGRect frame, UIColor *bgcolor, UIColor *textColor, UIFont *font, NSInteger align);
extern UILabel* (^createAndAddLabel)(UIView *pView, CGRect frame, UIColor *bgcolor, UIColor *textColor, UIFont *font, NSInteger align, NSUInteger tag);

@interface UILabel (pgcreatelabel)
+ (id)createLabel:(CGRect)frame bgColor:(UIColor *)bgcolor textColor:(UIColor *)textColor font:(UIFont *)font align:(NSInteger)align;
+ (id)createAndAddLabel:(UIView *)pView frame:(CGRect)frame bgColor:(UIColor *)bgcolor textColor:(UIColor *)textColor font:(UIFont *)font align:(NSInteger)align tag:(NSUInteger)tag;
@end

@interface UIButton (pgcreatebutton)
+ (id)buttonWithFrame:(CGRect)frame title:(NSString *)szTitle image:(UIImage *)image selImage:(UIImage *)selImage titleColor:(UIColor *)titlecolor titleSelColor:(UIColor *)titleselcolor target:(id)target selector:(SEL)selector;

- (void)extendEventRegion:(UIEdgeInsets)edgeInset;

@end

@interface UIView (ViewExtend)

- (float)GetX;
- (float)GetY;
- (float)GetWidth;
- (float)GetHeight;

@end

@interface UINavigationBar (UINavigationBarExtend)
- (void)SetBackgroundImage:(UIImage *)image;
@end

#pragma mark -
@interface PGUISegmentedControlExtend : UISegmentedControl
@end

#pragma mark -
@interface UIToolbar (UIToolbarExtend)
- (id)initWithFrame:(CGRect)frame bgimage:(UIImage *)bgimage;
- (void)SetBackgroundImage:(UIImage*)image;
@end

#pragma mark -
@interface UISearchBar (UISearchBarExtend)
- (id)initWithFrame:(CGRect)frame bgimage:(UIImage *)bgimage;
- (void)SetBackgroundImage:(UIImage*)image;
@end

@interface PGTransparentToolbar : UIToolbar
@end

#pragma mark -
@interface UIImage (UIImageExtend)

- (id)initWithContentsOfResolutionIndependentFile:(NSString *)path;

+ (UIImage *)imageWithContentsOfResolutionIndependentFile:(NSString *)path;

+ (UIImage *)imageFromImage:(UIImage *)image scaledToSize:(CGSize)newSize;

+ (UIImage *)imageFromView:(UIView *)targetView;

+ (float)CaleFitImageSize:(CGSize)oriimgsize TargetSize:(CGSize)targetimgsize Width:(float*)nInitwidth Height:(float*)nInitheight;

@end
