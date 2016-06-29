//
//  PGScreenAdapter.h
//  PGUIKit
//
//  Created by ouyanghua on 15/10/11.
//  Copyright © 2015年 PG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGUIHelper.h"

#define PGDesignToScreenH(v)    PGDesignHeightToScreenHeight(v)

#define PGHeightWith640(height) PGHeightC(640.0, height)
#define PGHeightWith750(height) PGHeightC(750.0, height)
#define PGHeightWith1080(height) PGHeightC(1080.0, height)

@interface PGScreenAdapter : NSObject
@property(nonatomic, assign, readonly)CGFloat nBaseWidth;
@property(nonatomic, assign, readonly)CGFloat nBaseHeight;
@property(nonatomic, assign)CGFloat autoSizeScaleX;
@property(nonatomic, assign)CGFloat autoSizeScaleY;
@property(nonatomic, assign)CGFloat scale;

+ (PGScreenAdapter *)shareInstance;

@end

CG_INLINE CGFloat PGHeightC(CGFloat reference, CGFloat height)
{
    CGFloat adapterHeight = height;
    
    if([[UIScreen mainScreen] currentMode].size.width == 768.0f ||
       [[UIScreen mainScreen] currentMode].size.width == 1536.0f ||
       [[UIScreen mainScreen] currentMode].size.width == 2048.0f)
    {
        adapterHeight = (height * 640.0 ) / reference;
    }
    else
    {
        adapterHeight = (height * [[UIScreen mainScreen] currentMode].size.width) / reference;
    }
    
    return ceil(adapterHeight/[UIScreen mainScreen].scale);
}

CG_INLINE CGFloat PGHeightA(CGFloat height)
{
    CGFloat adapterHeight = height;
    if([[UIScreen mainScreen] currentMode].size.width == 750.0f)
        adapterHeight = height * 1.17;
    if([[UIScreen mainScreen] currentMode].size.width == 1242.0f)
        adapterHeight = height * 1.29;
    return ceil(adapterHeight);
}

CG_INLINE CGFloat PGHeight(CGFloat height)
{
    CGFloat adapterHeight = height;
    return ceil(adapterHeight);
}

CG_INLINE CGFloat PGDesignHeightToScreenHeight(CGFloat height)
{
    return floorf(height * [PGScreenAdapter shareInstance].scale * [PGScreenAdapter shareInstance].autoSizeScaleY);
}

CG_INLINE CGRect PGRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    rect.origin.x = x;
    rect.origin.y = y;
    rect.size.width = floorf(width * [PGScreenAdapter shareInstance].scale * [PGScreenAdapter shareInstance].autoSizeScaleX);
    rect.size.height = floorf(height * [PGScreenAdapter shareInstance].scale * [PGScreenAdapter shareInstance].autoSizeScaleY);
    return rect;
}