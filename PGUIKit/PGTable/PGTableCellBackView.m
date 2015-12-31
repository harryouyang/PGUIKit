//
//  PGTableCellBackView.m
//  PanguCommonLib
//
//  Created by ouyanghua on 14-2-22.
//  Copyright (c) 2014年 pangu. All rights reserved.
//

#import "PGTableCellBackView.h"
#import <QuartzCore/QuartzCore.h>

@implementation PGTableCellBackView

- (BOOL)isOpaque
{
    return YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if(self.frame.size.height != prevLayerHeight || self.frame.size.width != prevLayerWidth)
    {
        for (int i=0; i<[self.layer.sublayers count]; i++)
        {
            id layer = [self.layer.sublayers objectAtIndex:i];
            if ([layer isKindOfClass:[CAGradientLayer class]])
            {
                [layer removeFromSuperlayer];
            }
        }
    }
    
    if(_backgroundColors == nil)
    {
        _backgroundColors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:0.9 alpha:1] CGColor],(id)[[UIColor colorWithWhite:0.9 alpha:1] CGColor], nil];
    }
    else if(_backgroundColors.count == 1)
    {
        NSArray *ar = [NSArray arrayWithObjects:[_backgroundColors objectAtIndex:0], [_backgroundColors objectAtIndex:0], nil];
        _backgroundColors = ar;
    }
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0,0,self.frame.size.width-(_separatorColorV != nil ? _dashStrokeV : 0),self.frame.size.height-_dashStroke/2.0);
    if(_DirectionStyle == ETableCellGradientDirectionStyleVertical)
    {
        [gradient setStartPoint:CGPointMake(0, 0)];
        [gradient setEndPoint:CGPointMake(0, 1)];
    }
    else if(_DirectionStyle == ETableCellGradientDirectionStyleHorizontal)
    {
        [gradient setStartPoint:CGPointMake(0, 0)];
        [gradient setEndPoint:CGPointMake(1, 0)];
    }
    else if(_DirectionStyle == ETableCellGradientDirectionStyleTopLeftToBottomRight)
    {
        [gradient setStartPoint:CGPointMake(0, 0)];
        [gradient setEndPoint:CGPointMake(1, 1)];
    }
    else if(_DirectionStyle == ETableCellGradientDirectionStyleBottomLeftToTopRight)
    {
        [gradient setStartPoint:CGPointMake(0, 1)];
        [gradient setEndPoint:CGPointMake(1, 0)];
    }
    [self.layer insertSublayer:gradient atIndex:0];
    gradient.colors = _backgroundColors;
    
    
    if(_separatorColor != nil)
    {
//        _separatorColor = [[UIColor colorWithRed:190/255.0 green:183/255.0 blue:145/255.0 alpha:1] retain];
        CGContextRef c = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(c, [_separatorColor CGColor]);
        CGContextSetLineWidth(c, _dashStroke);
        
        if(_dashGap > 0)
        {
            CGFloat dash[2] = {_dashWidth , _dashGap};
            CGContextSetLineDash(c,0,dash,2);
        }
        
        CGContextBeginPath(c);
        CGContextMoveToPoint(c, 0.0f, rect.size.height-_dashStroke+1);
        CGContextAddLineToPoint(c, rect.size.width, rect.size.height-_dashStroke+1);
        CGContextStrokePath(c);
    }
    
    if(_separatorColorV != nil)
    {
        CGContextRef c = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(c, [_separatorColorV CGColor]);
        CGContextSetLineWidth(c, _dashStrokeV);
        
        if(_dashGap > 0)
        {
            CGFloat dash[2] = {_dashWidthV , _dashGapV};
            CGContextSetLineDash(c,0,dash,2);
        }
        
        CGContextBeginPath(c);
        CGContextMoveToPoint(c, rect.size.width-_dashStrokeV+1, 0.0f);
        CGContextAddLineToPoint(c, rect.size.width-_dashStrokeV+1, rect.size.height-_dashStrokeV+1);
        CGContextStrokePath(c);
    }
    
    prevLayerHeight = self.frame.size.height;
    prevLayerWidth = self.frame.size.width;
    
}
@end
