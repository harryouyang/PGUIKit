//
//  PGRefreshRotate.m
//  PGUIKit
//
//  Created by ouyanghua on 15/11/20.
//  Copyright © 2015年 PG. All rights reserved.
//

#import "PGRefreshRotate.h"

#import "PGAnimationSequence.h"
#import "PGAnimationGroup.h"
#import "PGAnimationItem.h"

@interface PGRefreshRotate ()
{
    PGAnimationSequence *_sequence;
}
@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic, assign)CGFloat angle;
@end

@implementation PGRefreshRotate

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.nLoadingInsetStop = 80;
        self.nPullingDistance = -80;
        
        self.angle = 0;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-40)/2, (self.frame.size.height-40)/2, 40, 40)];
        _imageView.image = [UIImage imageNamed:@"refreshRatate.png"];
        
        [self addSubview:_imageView];
        
        __weak PGRefreshRotate *weakSelf = self;
        PGAnimationItem *item = [PGAnimationItem itemWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowUserInteraction animations:^{
            weakSelf.imageView.transform = CGAffineTransformRotate(weakSelf.imageView.transform, M_PI/2);
        }];
        
        PGAnimationGroup *group = [PGAnimationGroup groupWithItems:@[item]];
        
        _sequence = [[PGAnimationSequence alloc] initWithAnimationGroups:@[group] repeat:YES];
    }
    return self;
}

- (void)setState:(EPGRefreshState)aState
{
    [super setState:aState];
    
    switch (aState)
    {
        case EPGRefreshPulling:
        case EPGRefreshNormal:
        case EPGRefreshDragging:
        {
            CGPoint contentOffset = self.scrollView.contentOffset;
            
            CGFloat angle = contentOffset.y * 180.0 / M_PI * 0.001;
            self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, self.angle - angle);
            
            self.angle = angle;
            break;
        }
        case EPGRefreshLoading:
        {
            [_sequence start];
            break;
        }
        case EPGRefreshStop:
        {
            [_sequence stop];
            break;
        }
        default:
            break;
    }
}

@end
