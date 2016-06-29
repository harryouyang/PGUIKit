//
//  PGBubbleView.m
//  PGUIKit
//
//  Created by ouyanghua on 16/1/25.
//  Copyright © 2016年 PG. All rights reserved.
//

#import "PGBubbleView.h"

@interface PGBubbleView()<UIGestureRecognizerDelegate>
{
    float arrowWidth;
    float cornerRadius;
    float arrowHeight;
    float maxContentWidth;
    float maxContentHeight;
    
    CGRect visibleRect;
    CGPoint pointInVisibleRect;
    
    CGPoint arrowPt1;
    CGPoint arrowPt2;
    CGPoint arrowPt3;
    
    UIView *shadeView;
    
    ArrowShowStyle arrowShowStyle;
}

- (void)calculateFrameAndContextFrameWithMaxWidth:(float)maxWidth height:(float)maxHeight;
- (void)calculateFrame;
- (void)drawWithPath:(UIBezierPath *)aBezierPath rect:(CGRect)aRect;
- (UIBezierPath *)PopupBezierPath;

@end

@implementation PGBubbleView
@synthesize arrowPoint;
@synthesize arrowType;
@synthesize roundRectBackgroundColor;
@synthesize contentRect;
@synthesize contentView;

#pragma mark -
- (instancetype)init
{
    if(self = [super init])
    {
        self.backgroundColor = [UIColor clearColor];
        arrowWidth = 6.0f;
        arrowHeight = 8.0f;
        cornerRadius = 6.0f;
        maxContentWidth = MaxBubbleViewWidth;
        maxContentHeight = MaxBubbleViewHeight;
        roundRectBackgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
        arrowType = EARROWPOSITIONTYPETOP;
        CGRect rc = [UIScreen mainScreen].applicationFrame;
        visibleRect = CGRectMake(0, 0, rc.size.width, rc.size.height);
        contentRect = CGRectZero;
        
        contentView = [[UIView alloc]initWithFrame:CGRectZero];
        contentView.backgroundColor = [UIColor clearColor];
        contentView.clipsToBounds = YES;
        
        [self insertSubview:contentView atIndex:0];
        
        shadeView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GestureRecongnizer:)];
        tap.delegate = self;
        [shadeView addGestureRecognizer:tap];
        shadeView.hidden=YES;
        shadeView.alpha=0;
        [shadeView addSubview:self];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [roundRectBackgroundColor setFill];
    UIBezierPath *bubblePath = [self PopupBezierPath];
    
    [bubblePath closePath];
    [bubblePath fill];
}

- (void)addSubview:(UIView *)view
{
    [contentView addSubview:view];
}

#pragma mark -
- (void)calculateFrameAndContextFrameWithMaxWidth:(float)maxWidth height:(float)maxHeight
{
    // set frame
    float tempL = pointInVisibleRect.x - maxWidth * 0.5;
    float tempR = visibleRect.size.width - (pointInVisibleRect.x + maxWidth * 0.5);
    float tempT = pointInVisibleRect.y - maxHeight * 0.5;
    float tempB = visibleRect.size.height - (pointInVisibleRect.y + maxHeight * 0.5);
    float x1 = 0.0;
    float y1 = 0.0;
    float x2 = 0.0;
    float y2 = 0.0;
    switch(arrowType)
    {
        case EARROWPOSITIONTYPETOP:
        {
            if(tempL < 0)
                tempL = 0;
            else
            {
                if(tempR < 0)
                {
                    tempL = tempL + tempR;
                    tempL = tempL > 0 ? tempL : 0;
                }
            }
            
            x1 = (pointInVisibleRect.x-tempL) > (arrowWidth + cornerRadius) ? pointInVisibleRect.x-tempL-arrowWidth : 0;
            x2 = pointInVisibleRect.x-tempL+arrowWidth;
            if(x1 != 0)
            {
                x2 = x2+cornerRadius > maxWidth ? maxWidth : x2;
            }
            
            if((pointInVisibleRect.y + maxHeight) > visibleRect.size.height)
            {
                self.frame = CGRectMake(tempL, pointInVisibleRect.y - maxHeight, maxWidth, maxHeight);
                contentRect = CGRectMake(cornerRadius, cornerRadius, contentRect.size.width, contentRect.size.height);
                arrowShowStyle = EArrowShowStyleBottom;
                if(x1 != 0)
                    y1 = maxHeight - arrowHeight;
                else
                {
                    y1 = maxHeight- arrowHeight - cornerRadius;
                    arrowShowStyle = EArrowShowStyleLeftBottom;
                }
                
                if(x2 != maxWidth)
                    y2 = maxHeight - arrowHeight;
                else
                {
                    y2 = maxHeight- arrowHeight - cornerRadius;
                    arrowShowStyle = EArrowShowStyleRightBottom;
                }
                
                arrowPt3 = CGPointMake(pointInVisibleRect.x-tempL, maxHeight);
                arrowPt1 = CGPointMake(x2, y2);
                arrowPt2 = CGPointMake(x1, y1);
            }
            else
            {
                self.frame = CGRectMake(tempL, pointInVisibleRect.y, maxWidth, maxHeight);
                contentRect = CGRectMake(cornerRadius, cornerRadius+arrowHeight, contentRect.size.width, contentRect.size.height);
                arrowShowStyle = EArrowShowStyleTop;
                if(x1 != 0)
                    y1 = arrowHeight;
                else
                {
                    y1 = arrowHeight + cornerRadius;
                    arrowShowStyle = EArrowShowStyleLeftTop;
                }
                
                if(x2 != maxWidth)
                    y2 = arrowHeight;
                else
                {
                    y2 = arrowHeight + cornerRadius;
                    arrowShowStyle = EArrowShowStyleRightTop;
                }
                
                arrowPt3 = CGPointMake(pointInVisibleRect.x-tempL, 0);
                arrowPt1 = CGPointMake(x1, y1);
                arrowPt2 = CGPointMake(x2, y2);
            }
            break;
        }
        case EARROWPOSITIONTYPELEFT:
        {
            if(tempT < 0)
                tempT = 0;
            else
            {
                if(tempB < 0)
                {
                    tempT = tempT + tempB;
                    tempT = tempT > 0 ? tempT : 0;
                }
            }
            
            y1 = (pointInVisibleRect.y-tempT) > (arrowWidth + cornerRadius) ? pointInVisibleRect.y-tempT-arrowWidth : 0;
            y2 = pointInVisibleRect.y-tempT+arrowWidth;
            if(y1 != 0)
            {
                y2 = y2+cornerRadius > maxHeight ? maxHeight : y2;
            }
            
            if((pointInVisibleRect.x + maxWidth) > visibleRect.size.width && (pointInVisibleRect.x - maxWidth) > 0)
            {
                self.frame = CGRectMake(pointInVisibleRect.x - maxWidth, tempT, maxWidth, maxHeight);
                contentRect = CGRectMake(cornerRadius, cornerRadius, contentRect.size.width, contentRect.size.height);
                arrowShowStyle = EArrowShowStyleRight;
                if(y1 != 0)
                    x1 = maxWidth-arrowHeight;
                else
                {
                    x1 = maxWidth-arrowHeight - cornerRadius;
                    arrowShowStyle = EArrowShowStyleTopRight;
                }
                
                if(y2 != maxHeight)
                    x2 = maxWidth-arrowHeight;
                else
                {
                    x2 = maxWidth -arrowHeight - cornerRadius;
                    arrowShowStyle = EArrowShowStyleBottomRight;
                }
                
                arrowPt3 = CGPointMake(maxWidth, pointInVisibleRect.y-tempT);
                arrowPt1 = CGPointMake(x1, y1);
                arrowPt2 = CGPointMake(x2, y2);
            }
            else
            {
                self.frame = CGRectMake(pointInVisibleRect.x, tempT, maxWidth, maxHeight);
                contentRect = CGRectMake(cornerRadius+arrowHeight, cornerRadius, contentRect.size.width, contentRect.size.height);
                arrowShowStyle = EArrowShowStyleLeft;
                if(y1 != 0)
                    x1 = arrowHeight;
                else
                {
                    x1 = arrowHeight + cornerRadius;
                    arrowShowStyle = EArrowShowStyleTopLeft;
                }
                
                if(y2 != maxHeight)
                    x2 = arrowHeight;
                else
                {
                    x2 = arrowHeight + cornerRadius;
                    arrowShowStyle = EArrowShowStyleBottomLeft;
                }
                
                arrowPt3 = CGPointMake(0, pointInVisibleRect.y-tempT);
                arrowPt1 = CGPointMake(x2, y2);
                arrowPt2 = CGPointMake(x1, y1);
            }
            break;
        }
        case EARROWPOSITIONTYPEBOTTOM:
        {
            if(tempL < 0)
                tempL = 0;
            else
            {
                if(tempR < 0)
                {
                    tempL = tempL + tempR;
                    tempL = tempL > 0 ? tempL : 0;
                }
            }
            
            x1 = (pointInVisibleRect.x-tempL) > (arrowWidth + cornerRadius) ? pointInVisibleRect.x-tempL-arrowWidth : 0;
            x2 = pointInVisibleRect.x-tempL+arrowWidth;
            if(x1 != 0)
            {
                x2 = x2+cornerRadius > maxWidth ? maxWidth : x2;
            }
            
            if((pointInVisibleRect.y - maxHeight) > 0)
            {
                self.frame = CGRectMake(tempL, pointInVisibleRect.y - maxHeight, maxWidth, maxHeight);
                contentRect = CGRectMake(cornerRadius, cornerRadius, contentRect.size.width, contentRect.size.height);
                arrowShowStyle = EArrowShowStyleBottom;
                if(x1 != 0)
                    y1 = maxHeight - arrowHeight;
                else
                {
                    y1 = maxHeight- arrowHeight - cornerRadius;
                    arrowShowStyle = EArrowShowStyleLeftBottom;
                }
                
                if(x2 != maxWidth)
                    y2 = maxHeight - arrowHeight;
                else
                {
                    y2 = maxHeight- arrowHeight - cornerRadius;
                    arrowShowStyle = EArrowShowStyleRightBottom;
                }
                
                arrowPt3 = CGPointMake(pointInVisibleRect.x-tempL, maxHeight);
                arrowPt1 = CGPointMake(x2, y2);
                arrowPt2 = CGPointMake(x1, y1);
            }
            else
            {
                self.frame = CGRectMake(tempL, pointInVisibleRect.y, maxWidth, maxHeight);
                contentRect = CGRectMake(cornerRadius, cornerRadius+arrowHeight, contentRect.size.width, contentRect.size.height);
                arrowShowStyle = EArrowShowStyleTop;
                if(x1 != 0)
                    y1 = arrowHeight;
                else
                {
                    y1 = arrowHeight + cornerRadius;
                    arrowShowStyle = EArrowShowStyleLeftTop;
                }
                
                if(x2 != maxWidth)
                    y2 = arrowHeight;
                else
                {
                    y2 = arrowHeight + cornerRadius;
                    arrowShowStyle = EArrowShowStyleRightTop;
                }
                
                arrowPt3 = CGPointMake(pointInVisibleRect.x-tempL, 0);
                arrowPt1 = CGPointMake(x1, y1);
                arrowPt2 = CGPointMake(x2, y2);
            }
            break;
        }
        case EARROWPOSITIONTYPERIGHT:
        {
            if(tempT < 0)
                tempT = 0;
            else
            {
                if(tempB < 0)
                {
                    tempT = tempT + tempB;
                    tempT = tempT > 0 ? tempT : 0;
                }
            }
            
            y1 = (pointInVisibleRect.y-tempT) > (arrowWidth + cornerRadius) ? pointInVisibleRect.y-tempT-arrowWidth : 0;
            y2 = pointInVisibleRect.y-tempT+arrowWidth;
            if(y1 != 0)
            {
                y2 = y2+cornerRadius > maxHeight ? maxHeight : y2;
            }
            
            if((pointInVisibleRect.x - maxWidth) >= 0)
            {
                self.frame = CGRectMake(pointInVisibleRect.x - maxWidth, tempT, maxWidth, maxHeight);
                contentRect = CGRectMake(cornerRadius, cornerRadius, contentRect.size.width, contentRect.size.height);
                arrowShowStyle = EArrowShowStyleRight;
                if(y1 != 0)
                    x1 = maxWidth-arrowHeight;
                else
                {
                    x1 = maxWidth-arrowHeight- cornerRadius;
                    arrowShowStyle = EArrowShowStyleRightTop;
                }
                
                if(y2 != maxHeight)
                    x2 = maxWidth-arrowHeight;
                else
                {
                    x2 = maxWidth -arrowHeight - cornerRadius;
                    arrowShowStyle = EArrowShowStyleRightBottom;
                }
                
                arrowPt3 = CGPointMake(maxWidth, pointInVisibleRect.y-tempT);
                arrowPt1 = CGPointMake(x1, y1);
                arrowPt2 = CGPointMake(x2, y2);
            }
            else
            {
                self.frame = CGRectMake(pointInVisibleRect.x, tempT, maxWidth, maxHeight);
                contentRect = CGRectMake(cornerRadius+arrowHeight, cornerRadius, contentRect.size.width, contentRect.size.height);
                arrowShowStyle = EArrowShowStyleLeft;
                if(y1 != 0)
                    x1 = arrowHeight;
                else
                {
                    x1 = arrowHeight + cornerRadius;
                    arrowShowStyle = EArrowShowStyleLeftTop;
                }
                
                if(y2 != maxHeight)
                    x2 = arrowHeight;
                else
                {
                    x2 = arrowHeight + cornerRadius;
                    arrowShowStyle = EArrowShowStyleLeftBottom;
                }
                
                arrowPt3 = CGPointMake(0, pointInVisibleRect.y-tempT);
                arrowPt1 = CGPointMake(x2, y2);
                arrowPt2 = CGPointMake(x1, y1);
            }
            break;
        }
    }
    
    //    NSLog(@"%f, %f", self.center.x, self.center.y);
    self.center = CGPointMake(self.center.x-(pointInVisibleRect.x-arrowPoint.x), self.center.y-(pointInVisibleRect.y-arrowPoint.y));
    //    NSLog(@"%f, %f", self.center.x, self.center.y);
}

- (void)calculateFrame
{
    CGRect rc = [UIScreen mainScreen].applicationFrame;
    //   visibleRect = CGRectMake(0, 0, rc.size.width-5, rc.size.height);
    visibleRect = CGRectMake(0, 0, rc.size.width-5, rc.size.height);
    
    float maxWidth = MAX(pointInVisibleRect.x, visibleRect.size.width - arrowPoint.x) - 2.0 * cornerRadius;
    float maxHeight = MAX(pointInVisibleRect.y, visibleRect.size.height - arrowPoint.y) - 2.0 * cornerRadius;
    
    if(EARROWPOSITIONTYPELEFT == arrowType || EARROWPOSITIONTYPERIGHT == arrowType)
    {
        maxWidth = MAX(pointInVisibleRect.x, visibleRect.size.width - arrowPoint.x) - 2.0 * cornerRadius;
        
        maxWidth = maxWidth - arrowHeight;
        
        maxHeight = visibleRect.size.height - 2.0 * cornerRadius;
    }
    else if(EARROWPOSITIONTYPETOP == arrowType || EARROWPOSITIONTYPEBOTTOM == arrowType)
    {
        maxWidth = visibleRect.size.width - 2.0 * cornerRadius;
        
        maxHeight = MAX(pointInVisibleRect.y, visibleRect.size.height - arrowPoint.y) - 2.0 * cornerRadius;
        
        maxHeight = maxHeight - arrowHeight;
    }
    
    //最大允许的大小
    maxWidth = MIN(maxWidth, maxContentWidth);
    maxHeight = MIN(maxHeight, maxContentHeight);
    
    //实际的大小
    maxWidth = MIN(contentRect.size.width, maxWidth);
    maxHeight = MIN(contentRect.size.height, maxHeight);
    contentRect.size = CGSizeMake(maxWidth, maxHeight);
    
    if(EARROWPOSITIONTYPELEFT == arrowType || EARROWPOSITIONTYPERIGHT == arrowType)
    {
        maxWidth = maxWidth + arrowHeight + 2.0 * cornerRadius;
        maxHeight = maxHeight + 2.0 * cornerRadius;
    }
    else if(EARROWPOSITIONTYPETOP == arrowType || EARROWPOSITIONTYPEBOTTOM == arrowType)
    {
        maxWidth = maxWidth + 2.0 * cornerRadius;
        maxHeight = maxHeight + arrowHeight + 2.0 * cornerRadius;
    }
    
    [self calculateFrameAndContextFrameWithMaxWidth:maxWidth height:maxHeight];
    
    contentView.frame = contentRect ;
}

- (void)drawWithPath:(UIBezierPath *)aBezierPath rect:(CGRect)aRect
{
    int count = (arrowShowStyle < EArrowShowStyleTop) ? 3 : 4;
    for(int i=0; i<count; i++)
    {
        switch((arrowShowStyle+i)%4)
        {
            case EArrowShowStyleLeftTop:
            case EArrowShowStyleTopLeft:
            case EArrowShowStyleTop:
            {
                [aBezierPath addLineToPoint:CGPointMake(aRect.origin.x+aRect.size.width-cornerRadius, aRect.origin.y)];
                [aBezierPath addArcWithCenter:CGPointMake(aRect.origin.x+aRect.size.width-cornerRadius, aRect.origin.y+cornerRadius) radius:cornerRadius startAngle:M_PI_2*3 endAngle:M_PI_2*4 clockwise:YES];
                break;
            }
            case EArrowShowStyleTopRight:
            case EArrowShowStyleRightTop:
            case EArrowShowStyleRight:
            {
                [aBezierPath addLineToPoint:CGPointMake(aRect.origin.x+aRect.size.width, aRect.origin.y+aRect.size.height-cornerRadius)];
                [aBezierPath addArcWithCenter:CGPointMake(aRect.origin.x+aRect.size.width-cornerRadius, aRect.origin.y+aRect.size.height-cornerRadius) radius:cornerRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
                break;
            }
            case EArrowShowStyleRightBottom:
            case EArrowShowStyleBottomRight:
            case EArrowShowStyleBottom:
            {
                [aBezierPath addLineToPoint:CGPointMake(aRect.origin.x+cornerRadius, aRect.origin.y+aRect.size.height)];
                [aBezierPath addArcWithCenter:CGPointMake(aRect.origin.x+cornerRadius, aRect.origin.y+aRect.size.height-cornerRadius) radius:cornerRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
                break;
            }
            case EArrowShowStyleBottomLeft:
            case EArrowShowStyleLeftBottom:
            case EArrowShowStyleLeft:
            {
                [aBezierPath addLineToPoint:CGPointMake(aRect.origin.x, aRect.origin.y+cornerRadius)];
                [aBezierPath addArcWithCenter:CGPointMake(aRect.origin.x+cornerRadius, aRect.origin.y+cornerRadius) radius:cornerRadius startAngle:M_PI endAngle:M_PI_2*3 clockwise:YES];
                break;
            }
        }
    }
}

- (UIBezierPath *)PopupBezierPath
{
    UIBezierPath *bubblePath = [UIBezierPath bezierPath];
    
    [bubblePath moveToPoint:arrowPt1];
    [bubblePath addLineToPoint:arrowPt3];
    [bubblePath addLineToPoint:arrowPt2];
    
    CGRect rc = CGRectMake(contentRect.origin.x-cornerRadius, contentRect.origin.y-cornerRadius, contentRect.size.width+2*cornerRadius, contentRect.size.height+2*cornerRadius);
    [self drawWithPath:bubblePath rect:rc];
    
    return bubblePath;
}

- (void)setContentRect:(CGRect)aContentRect
{
    contentRect.size = aContentRect.size;
    [self calculateFrame];
}

#pragma mark -
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point=[touch locationInView:shadeView];
    if(YES==CGRectContainsPoint(self.frame,point))
        return NO;
    return YES;
}

-(void)GestureRecongnizer:(UITapGestureRecognizer*)gr
{
    [self hidden:YES animated:YES];
}

#pragma mark -
- (void)addShadow:(UIColor *)color
{
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    self.layer.shadowRadius = cornerRadius;
    self.layer.masksToBounds = NO;
    self.layer.shadowPath = [self PopupBezierPath].CGPath;
}

- (void)resetMaxContextWidth:(float)width maxContextHeight:(float)height
{
    maxContentWidth = width;
    maxContentHeight = height;
}

- (void)arrowPoint:(CGPoint)aPoint rootView:(UIView *)view
{
    arrowPoint = aPoint;
    if(nil != view)
    {
        pointInVisibleRect = [view convertPoint:arrowPoint toView:[UIApplication sharedApplication].keyWindow];
        CGRect staRect = [UIApplication sharedApplication].statusBarFrame;
        pointInVisibleRect = CGPointMake(pointInVisibleRect.x, pointInVisibleRect.y - CGRectGetHeight(staRect));
    }
    else
        pointInVisibleRect = aPoint;
    
    [self calculateFrame];
}

- (void)bubbleMenu:(BOOL)bAnimated
{
    [self hidden:!shadeView.hidden animated:bAnimated];
}

- (void)hidden:(BOOL)bHidden animated:(BOOL)bAnimated
{
    void(^fun)()=^
    {
        shadeView.hidden=bHidden;
        shadeView.alpha=!bHidden;
    };
    
    if(NO==bAnimated)
    {
        if(NO==bHidden)
        {
            UIView* view=[UIApplication sharedApplication].keyWindow;
            [view addSubview:shadeView];
        }
        else
            [shadeView removeFromSuperview];
        fun();
    }
    else
    {
        if(NO==bHidden)
        {
            UIView* view=[UIApplication sharedApplication].keyWindow;
            [view addSubview:shadeView];
            shadeView.hidden=NO;
        }
        [UIView animateWithDuration:0.3 animations:^
         {
             shadeView.alpha=!bHidden;
         } completion:^(BOOL finished)
         {
             fun();
             if(YES==bHidden)
                 [shadeView removeFromSuperview];
         }];
    }
}

@end
