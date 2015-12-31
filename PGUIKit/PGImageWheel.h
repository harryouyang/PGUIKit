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

typedef NS_ENUM(NSUInteger, PageScrollerType){
    EPageScrollerType_Loop,
    EPageScrollerType_Reverse
};

@class PGImageWheel;
@protocol PGImageWheelDelegate <NSObject>
- (void)imgeWheel:(PGImageWheel *)wheel didSelect:(NSInteger)index;
- (void)wheelMove:(PGImageWheel *)wheel current:(NSInteger)index;
@end

@interface PGImageWheel : UIView<UIScrollViewDelegate>
{
    UIScrollView *m_scrollView;
//    EPageIndicatorPosition indicatorPosition;
    
//    BOOL bAutoScroll;
//    NSTimeInterval timeInterval;
    
//    PageScrollerType scrollType;
    
//    id<PGImageWheelDelegate> delegate;
}
@property(nonatomic, strong)NSMutableArray *arImageView;
@property(nonatomic, assign)EPageIndicatorPosition indicatorPosition;
@property(nonatomic, assign)BOOL bAutoScroll;
@property(nonatomic, assign)NSTimeInterval timeInterval;
@property(nonatomic, assign)PageScrollerType scrollType;
@property(nonatomic, weak)id<PGImageWheelDelegate> delegate;
@property(nonatomic, retain)PGPageControl *pageControl;
@property(nonatomic, assign)float indicatorPostionHeight;

- (id)initWithFrame:(CGRect)frame imageArray:(NSArray *)array isShowPageIndicator:(BOOL)bflag;

- (void)setIndicatorPosition:(EPageIndicatorPosition)iPosition;

//flag 是否需要放大显示
- (void)ReSetFrame:(CGRect)rect flag:(BOOL)flag;

- (void)ReSetImageArray:(NSArray *)array;

- (void)scrollPageIndex:(NSInteger)nPageIndex;

- (NSInteger)currentPageIndex;

@end
