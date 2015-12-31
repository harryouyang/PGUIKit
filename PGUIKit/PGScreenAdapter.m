//
//  PGScreenAdapter.m
//  PGUIKit
//
//  Created by ouyanghua on 15/10/11.
//  Copyright © 2015年 PG. All rights reserved.
//

#import "PGScreenAdapter.h"

//CG_INLINE CGFloat PGDesignHeightToScreenHeight(CGFloat height)
//{
//    return height * [PGScreenAdapter shareInstance].scale * [PGScreenAdapter shareInstance].autoSizeScaleY;
//}
//
//CG_INLINE CGRect PGRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
//{
//    CGRect rect;
//    rect.origin.x = x;
//    rect.origin.y = y;
//    rect.size.width = width * [PGScreenAdapter shareInstance].scale * [PGScreenAdapter shareInstance].autoSizeScaleX;
//    rect.size.height = height * [PGScreenAdapter shareInstance].scale * [PGScreenAdapter shareInstance].autoSizeScaleY;
//    return rect;
//}

static PGScreenAdapter * s_screenAdapter = nil;
@implementation PGScreenAdapter

+ (PGScreenAdapter *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_screenAdapter = [[PGScreenAdapter alloc] init];
    });
    return s_screenAdapter;
}

- (id)init
{
    if(self = [super init])
    {
        _nBaseWidth = 320.0f;
        _nBaseHeight = 568.0f;
        if(ScreenHeight > 480)
        {
            _autoSizeScaleX = ScreenWidth / _nBaseWidth;
            _autoSizeScaleY = ScreenHeight / _nBaseHeight;
            _scale = 1.0;
        }
        else
        {
            _autoSizeScaleX = 1.0;
            _autoSizeScaleY = 1.0;
        }
    }
    return self;
}

@end
