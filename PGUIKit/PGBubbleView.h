//
//  PGBubbleView.h
//  PGUIKit
//
//  Created by ouyanghua on 16/1/25.
//  Copyright © 2016年 PG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define MaxBubbleViewWidth	150
#define MaxBubbleViewHeight	120
#define MinBubbleViewWidth	100
#define MinBubbleViewHeight	40
#define RichWidth			5

typedef enum
{
    EArrowShowStyleLeftTop,
    EArrowShowStyleTopRight,
    EArrowShowStyleRightBottom,
    EArrowShowStyleBottomLeft,
    EArrowShowStyleTopLeft,
    EArrowShowStyleRightTop,
    EArrowShowStyleBottomRight,
    EArrowShowStyleLeftBottom,
    EArrowShowStyleTop,
    EArrowShowStyleRight,
    EArrowShowStyleBottom,
    EArrowShowStyleLeft,
}ArrowShowStyle;

typedef enum
{
    EARROWPOSITIONTYPETOP = EArrowShowStyleTop,
    EARROWPOSITIONTYPERIGHT = EArrowShowStyleRight,
    EARROWPOSITIONTYPEBOTTOM = EArrowShowStyleBottom,
    EARROWPOSITIONTYPELEFT = EArrowShowStyleLeft
}ARROWPOSITIONTYPE;

@interface PGBubbleView : UIView
{
    UIView *contentView;
}
@property(nonatomic, assign)ARROWPOSITIONTYPE arrowType;
@property(nonatomic, readonly)CGPoint arrowPoint;
@property(nonatomic, strong)UIColor *roundRectBackgroundColor;
@property(nonatomic, assign)CGRect contentRect;
@property(nonatomic, strong)UIView *contentView;

- (void)addShadow:(UIColor *)color;

- (void)resetMaxContextWidth:(float)width maxContextHeight:(float)height;

- (void)arrowPoint:(CGPoint)aPoint rootView:(UIView *)view;

- (void)bubbleMenu:(BOOL)bAnimated;

- (void)hidden:(BOOL)bHidden animated:(BOOL)bAnimated;

@end
