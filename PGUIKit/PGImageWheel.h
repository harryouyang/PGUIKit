//
//  PGImageWheel.h
//  PanguCommonLib
//
//  Created by ouyanghua on 14-2-22.
//  Copyright (c) 2014年 pangu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGPageControl.h"

typedef enum PageIndicatorPosition
{
    EPageIndicatorPosition_Bottom = 0,
    EPageIndicatorPosition_Top
}EPageIndicatorPosition;

@class PGImageWheel;
@protocol PGImageWheelDelegate <NSObject>
@optional
- (void)imgeWheel:(PGImageWheel *)wheel didSelect:(NSInteger)index;
- (void)wheelMove:(PGImageWheel *)wheel current:(NSInteger)index;
@end

@interface PGImageWheel : UIView<UIScrollViewDelegate>

@property(nonatomic, weak)id<PGImageWheelDelegate> delegate;

@property(nonatomic, assign)BOOL bAutoScroll;
@property(nonatomic, assign)NSTimeInterval timeInterval;

@property(nonatomic, readonly)NSMutableArray *arImageView;

@property(nonatomic, assign)BOOL isShowPageIndicator;
@property(nonatomic, assign)EPageIndicatorPosition indicatorPosition;
@property(nonatomic, readonly)PGPageControl *pageControl;//

- (id)initWithFrame:(CGRect)frame;

- (void)setViewArray:(NSMutableArray *)viewArray;

@end
