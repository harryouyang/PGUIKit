//
//  PGNavBar.m
//  PGUIKit
//
//  Created by ouyanghua on 15/12/15.
//  Copyright © 2015年 PG. All rights reserved.
//

#import "PGNavBar.h"

@interface PGNavBar ()
@property(nonatomic, assign)float originY;
@property(nonatomic, strong)UIImageView *bgImageView;
@end

@implementation PGNavBar

- (id)initWithFrame:(CGRect)frame left:(UIView *)lView mid:(UIView *)mView right:(UIView *)rView originY:(float)originy;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.leftView = lView;
        if(self.leftView)
            [self addSubview:self.leftView];
        self.midView = mView;
        if(self.midView)
            [self addSubview:self.midView];
        self.rightView = rView;
        if(self.rightView)
            [self addSubview:self.rightView];
        self.originY = originy;
    }
    return self;
}

- (void)setImage:(UIImage *)image originY:(float)oriY
{
    if(image == nil)
        return;
    
    if(_bgImageView == nil)
    {
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, oriY, self.frame.size.width, self.frame.size.height-oriY)];
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self insertSubview:_bgImageView atIndex:0];
    }
    _bgImageView.image = image;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.leftView.frame = CGRectMake(self.leftView.frame.origin.x, self.originY, self.leftView.frame.size.width, 44);
    self.midView.frame = CGRectMake((self.frame.size.width-self.midView.frame.size.width)/2, self.originY, self.midView.frame.size.width, 44);
    self.rightView.frame = CGRectMake(self.frame.size.width-self.rightView.frame.size.width, self.originY, self.rightView.frame.size.width, 44);
}

@end
