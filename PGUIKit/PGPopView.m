//
//  PGPopView.m
//  PGUIKit
//
//  Created by ouyanghua on 16/1/25.
//  Copyright © 2016年 PG. All rights reserved.
//

#import "PGPopView.h"

#define DEFAULTWIDTH    140
#define DEFAULTHEIGHT   140
#define MAXWIDTH    300
#define MAXHEIGHT   400

@implementation PGPopView

- (instancetype)initWithContentWidth:(float)width height:(float)height
{
    if(self = [super init])
    {
        [super resetMaxContextWidth:MAXWIDTH maxContextHeight:MAXHEIGHT];
        self.roundRectBackgroundColor = [UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1.0];
        self.contentRect = CGRectMake(0, 0, width, height);
    }
    return self;
}

- (instancetype)init
{
    return [self initWithContentWidth:DEFAULTWIDTH height:DEFAULTHEIGHT];
}

- (void)setContentView:(UIView *)aContentView
{
    if(contentView != nil)
    {
        [contentView removeFromSuperview];
    }
    
    contentView = aContentView;
    if(aContentView != nil)
    {
        [self addSubview:aContentView];
    }
}

@end
