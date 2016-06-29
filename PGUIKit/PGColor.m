//
//  PGColor.m
//  PGUIKit
//
//  Created by ouyanghua on 16/4/25.
//  Copyright © 2016年 PG. All rights reserved.
//

#import "PGColor.h"

@implementation UIColor (PGColor)

- (UIColor *)lightenByPercentage:(CGFloat)percentage
{
    CGFloat h = 0.0;
    CGFloat s = 0.0;
    CGFloat b = 0.0;
    CGFloat a = 0.0;
    
    [self getHue:&h saturation:&s brightness:&b alpha:&a];
    
    // increase the brightness value, max makes sure brightness does not go below 0 and min ensures that the brightness value does not go above 1.0
    b = MAX(MIN(b + percentage, 1.0), 0.0);
    
    return [UIColor colorWithHue:h saturation:s brightness:b alpha:a];
}

- (UIColor *)darkenByPercentage:(CGFloat)percentage
{
    return [self lightenByPercentage:-percentage];
}

@end
