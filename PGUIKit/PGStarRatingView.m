//
//  PGStarRatingView.m
//  PGUIKit
//
//  Created by ouyanghua on 16/5/7.
//  Copyright © 2016年 PG. All rights reserved.
//

#import "PGStarRatingView.h"

@interface PGStarRatingView ()
@property(nonatomic, strong)UIView *normolView;
@property(nonatomic, strong)UIView *highLightedView;
@property(nonatomic, strong)UIImage *star;
@property(nonatomic, strong)UIImage *highLightedStar;
@property(nonatomic, assign)CGFloat xSpace;
@property(nonatomic, assign)CGFloat ySpace;
@property(nonatomic, assign)CGSize starSize;
@property(nonatomic, strong)UITapGestureRecognizer *gesture;
@end

@implementation PGStarRatingView

- (id)initWithFrame:(CGRect)frame starSize:(CGSize)starSize xSpace:(CGFloat)xSpace star:(UIImage *)starImage highLightedStar:(UIImage *)highLightedStarImage
{
    if(self = [super initWithFrame:frame])
    {
        self.ySpace = (frame.size.height-starSize.height)/2;
        self.xSpace = xSpace;
        self.starSize = starSize;
        
        self.normolView = [[UIView alloc] initWithFrame:self.bounds];
        self.normolView.clipsToBounds = YES;
        [self addSubview:self.normolView];
        self.highLightedView = [[UIView alloc] initWithFrame:self.bounds];
        self.highLightedView.clipsToBounds = YES;
        [self addSubview:self.highLightedView];
        [self ResetBackgroundColor:[UIColor whiteColor]];
        
        self.star = starImage;
        self.highLightedStar = highLightedStarImage;
        
        [self configSubViews];
        
        self.gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [self.highLightedView addGestureRecognizer:self.gesture];
        self.gesture.enabled = NO;
    }
    
    return self;
}

- (void)tapGesture:(UITapGestureRecognizer *)gestue
{
    CGPoint point = [gestue locationInView:gestue.view];
    NSInteger count = floorf(point.x/(self.starSize.width+self.xSpace));
    CGFloat temp = MIN(point.x - count * (self.starSize.width+self.xSpace), self.starSize.width);
    CGFloat rating = 0.2 * temp/self.starSize.width;
    rating += 0.2 * count;
    
    if(rating > 1)
        rating = 1.0;
    else if(rating < 0)
        rating = 0;
    
    self.rating = rating;
    
    if(self.delegate && [(NSObject *)self.delegate respondsToSelector:@selector(newRating:rating:)])
    {
        [self.delegate newRating:self rating:rating];
    }
}

- (void)resetFrame:(CGRect)frame
{
    self.frame = frame;
    
    [self configSubViews];
}

- (void)setEnable:(BOOL)enable
{
    _enable = enable;
    self.gesture.enabled = enable;
}

- (void)ResetBackgroundColor:(UIColor *)color
{
    self.backgroundColor = color;
    self.normolView.backgroundColor = color;
    self.highLightedView.backgroundColor = color;
}

- (void)configSubViews
{
    for(UIView *v in self.normolView.subviews)
    {
        [v removeFromSuperview];
    }
    
    for(UIView *v in self.highLightedView.subviews)
    {
        [v removeFromSuperview];
    }
    
    for(NSInteger i = 0; i < 5; i++)
    {
        CGRect rect = CGRectMake(i*(self.xSpace+self.starSize.width), self.ySpace, self.starSize.width, self.starSize.height);
        UIImageView *iv = [[UIImageView alloc] initWithImage:self.star];
        iv.frame = rect;
        [self.normolView addSubview:iv];
        
        iv = [[UIImageView alloc] initWithImage:self.highLightedStar];
        iv.frame = rect;
        [self.highLightedView addSubview:iv];
    }
}

- (void)setRating:(float)rating
{
    if(rating > 1)
        rating = 1.0;
    else if(rating < 0)
        rating = 0;
    
    CGFloat maskLength = 0.0;
    CGFloat rate = rating;
    NSInteger count = floorf(rate/0.2);
    rate = rate-count*0.2;
    
    maskLength = count*self.starSize.width+(count-1)*self.xSpace;
    if(self.isFractionalRatingEnabled)
    {
        _rating = rating;
        if(rate > 0)
        {
            maskLength += self.xSpace;
            maskLength += self.starSize.width * (rate/0.2);
        }
    }
    else
    {
        _rating = (NSInteger)rating;
    }
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, maskLength, self.highLightedView.frame.size.height);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:maskLayer.bounds];
    maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = maskPath.CGPath;
    
    self.highLightedView.layer.mask = maskLayer;
}

@end
