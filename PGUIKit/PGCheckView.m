//
//  PGCheckView.m
//  PGUIKit
//
//  Created by ouyanghua on 16/1/20.
//  Copyright © 2016年 PG. All rights reserved.
//

#import "PGCheckView.h"

@implementation PGCheckView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.normalBgColor = [UIColor whiteColor];
        self.selBgColor = [UIColor orangeColor];
        self.normalTextColor = [UIColor blackColor];
        self.selTextColor = [UIColor blueColor];
        UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
        [self addGestureRecognizer:gest];
        
        self.bCheck = NO;
        self.bEnable = YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame text:(NSString *)text showIndicate:(BOOL)bShow
{
    if(self = [super initWithFrame:frame])
    {
        self.normalBgColor = [UIColor whiteColor];
        self.selBgColor = [UIColor orangeColor];
        self.normalTextColor = [UIColor blackColor];
        self.selTextColor = [UIColor blueColor];
        UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
        [self addGestureRecognizer:gest];
        
        if(text)
        {
            _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            _textLabel.backgroundColor = [UIColor clearColor];
            _textLabel.text = text;
            [self addSubview:_textLabel];
        }
        
        if(bShow)
        {
            _indicateView = [[UIImageView alloc] initWithFrame:CGRectZero];
            [self addSubview:_indicateView];
        }
        
        self.bCheck = NO;
        self.bEnable = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setBCheck:(BOOL)bCheck
{
    _bCheck = bCheck;
    
    if(_bCheck)
    {
        if(self.textLabel)
        {
            self.textLabel.textColor = self.selTextColor;
        }
        
        if(self.indicateView)
        {
            self.indicateView.image = self.selIndicateImage;
        }
        
        self.backgroundColor = self.selBgColor;
    }
    else
    {
        if(self.textLabel)
        {
            self.textLabel.textColor = self.normalTextColor;
        }
        
        if(self.indicateView)
        {
            self.indicateView.image = self.normalIndicateImage;
        }
        
        self.backgroundColor = self.normalBgColor;
    }
}

- (void)tapHandler:(UITapGestureRecognizer *)gest
{
    if(!self.bEnable)
    {
        return;
    }
    
    if(self.isRadioView && self.bCheck)
    {
        return;
    }
        
    self.bCheck = !self.bCheck;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(checkView:didChange:)])
    {
        [self.delegate checkView:self didChange:self.bCheck];
    }
}

@end
