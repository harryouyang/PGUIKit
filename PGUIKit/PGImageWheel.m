//
//  PGImageWheel.m
//  PanguCommonLib
//
//  Created by ouyanghua on 14-2-22.
//  Copyright (c) 2014年 pangu. All rights reserved.
//

#import "PGImageWheel.h"
#import "PGImageView.h"

@interface PGImageWheel ()
{
    UIScrollView *_scrollView;
    UIView *_firstView;
    UIView *_middleView;
    UIView *_lastView;
}
@property(nonatomic, strong)dispatch_source_t timer;
@property(nonatomic, assign)NSInteger sType;
@property(nonatomic, assign)NSInteger currentIndex;

@property(nonatomic, assign)float indicatorPostionHeight;
@property(nonatomic, assign)float viewWidth;
@property(nonatomic, assign)float viewHeight;
@end

@implementation PGImageWheel

- (void)dealloc
{
    if(_timer)
    {
        dispatch_source_cancel(_timer);
    }
    self.delegate = nil;
}

- (void)setIndicatorPosition:(EPageIndicatorPosition)iPosition
{
    _indicatorPosition = iPosition;
    
    if(_pageControl == nil)
        return;
    
    if(self.indicatorPosition == EPageIndicatorPosition_Bottom)
    {
        _pageControl.frame = CGRectMake(self.indicatorPostionHeight, self.bounds.size.height-self.indicatorPostionHeight, self.bounds.size.width-2*self.indicatorPostionHeight, self.indicatorPostionHeight);
    }
    else if(self.indicatorPosition == EPageIndicatorPosition_Top)
    {
        _pageControl.frame = CGRectMake(self.indicatorPostionHeight, 0, self.bounds.size.width-2*self.indicatorPostionHeight, self.indicatorPostionHeight);
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGRect bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _viewWidth = bounds.size.width;
        _viewHeight = bounds.size.height;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height)];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        [_scrollView setDelegate:self];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(_viewWidth * 3, _viewHeight);
        [self addSubview:_scrollView];
        
        //设置单击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [_scrollView addGestureRecognizer:tap];
        
        _firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, _viewHeight)];
        [_scrollView addSubview:_firstView];
        _middleView = [[UIView alloc] initWithFrame:CGRectMake(_viewWidth, 0, _viewWidth, _viewHeight)];
        [_scrollView addSubview:_middleView];
        _lastView = [[UIView alloc] initWithFrame:CGRectMake(_viewWidth*2, 0, _viewWidth, _viewHeight)];
        [_scrollView addSubview:_lastView];
        
        self.bAutoScroll = NO;
        self.timeInterval = 3;
        _sType = 1;
        self.currentIndex = 0;
        self.indicatorPostionHeight = 20;
        
        self.indicatorPosition = EPageIndicatorPosition_Bottom;
        
        _pageControl = [[PGPageControl alloc] initWithFrame:CGRectMake(0, bounds.size.height-self.indicatorPostionHeight, bounds.size.width, self.indicatorPostionHeight)];
        self.pageControl.pageControlStyle = PGPageControlStyleDfault;
        self.pageControl.numberOfPages = 1;
        self.pageControl.currentPage = self.currentIndex;
        self.pageControl.backgroundColor = [UIColor colorWithRed:(float)(72)/255.0 green:(float)(72)/255.0 blue:(float)(72)/255.0 alpha:(0.0)];
        // change color
        [self.pageControl setCoreNormalColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1]];
        [self.pageControl setCoreSelectedColor:[UIColor colorWithRed:0.48 green:0.753 blue:0.815 alpha:1]];
        // change gap width
        [self.pageControl setGapWidth:5];
        // change diameter
        [self.pageControl setDiameter:9];
        [self addSubview:self.pageControl];
    }
    
    return self;
}

-(void)handleTap:(UITapGestureRecognizer*)sender
{
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(imgeWheel:didSelect:)])
    {
        [self.delegate imgeWheel:self didSelect:_currentIndex];
    }
}

- (void)setViewArray:(NSMutableArray *)viewArray
{
    NSAssert((viewArray != nil), @"viewArray is nil");
    
    if(viewArray)
    {
        for(UIView *view in viewArray)
        {
            view.frame = CGRectMake(0, 0, _viewWidth, _viewHeight);
        }
        _arImageView = viewArray;
        _currentIndex = 0; //默认为第0页
        
        _pageControl.numberOfPages = _arImageView.count;
        
        if(self.arImageView.count == 2)
        {
            UIView *v = [self.arImageView objectAtIndex:0];
            if([v isKindOfClass:[PGImageView class]])
            {
                PGImageView *view = [[PGImageView alloc] initWithFrame:v.frame];
                view.image = [((PGImageView *)v).image copy];
                [self.arImageView addObject:view];
                
                v = [self.arImageView objectAtIndex:1];
                view = [[PGImageView alloc] initWithFrame:v.frame];
                view.image = [((PGImageView *)v).image copy];
                [self.arImageView addObject:view];
            }
            else if([v isKindOfClass:[UIImageView class]])
            {
                UIImageView *view = [[UIImageView alloc] initWithFrame:v.frame];
                view.image = [((UIImageView *)v).image copy];
                [self.arImageView addObject:view];
                
                v = [self.arImageView objectAtIndex:1];
                view = [[UIImageView alloc] initWithFrame:v.frame];
                view.image = [((UIImageView *)v).image copy];
                [self.arImageView addObject:view];
            }
            else if([v isKindOfClass:[UIView class]])
            {
                UIView *view = [v copy];
                [self.arImageView addObject:view];
                
                v = [self.arImageView objectAtIndex:1];
                view = [v copy];
                [self.arImageView addObject:view];
            }
        }
    }
    
    [self reloadData];
}

- (void)reloadData
{
    for(UIView *v in _firstView.subviews)
    {
        [v removeFromSuperview];
    }
    
    for(UIView *v in _middleView.subviews)
    {
        [v removeFromSuperview];
    }
    
    for(UIView *v in _lastView.subviews)
    {
        [v removeFromSuperview];
    }
    
    if(self.arImageView.count == 1)
    {
        _scrollView.scrollEnabled = NO;
        [self setIsShowPageIndicator:NO];
    }
    else
    {
        _scrollView.scrollEnabled = YES;
        [self setIsShowPageIndicator:YES];
    }
    
    if(_currentIndex == 0)
    {
        if(self.arImageView.count == 1)
        {
            [_middleView addSubview:[_arImageView objectAtIndex:_currentIndex]];
        }
        else
        {
            [_firstView addSubview:[_arImageView lastObject]];
            [_middleView addSubview:[_arImageView objectAtIndex:_currentIndex]];
            [_lastView addSubview:[_arImageView objectAtIndex:_currentIndex+1]];
        }
    }
    else if(_currentIndex == _arImageView.count-1)
    {
        [_firstView addSubview:[_arImageView objectAtIndex:_currentIndex-1]];
        [_middleView addSubview:[_arImageView objectAtIndex:_currentIndex]];
        [_lastView addSubview:[_arImageView firstObject]];
    }
    else
    {
        [_firstView addSubview:[_arImageView objectAtIndex:_currentIndex-1]];
        [_middleView addSubview:[_arImageView objectAtIndex:_currentIndex]];
        [_lastView addSubview:[_arImageView objectAtIndex:_currentIndex+1]];
    }
    
    [_pageControl setCurrentPage:self.currentIndex];
    _scrollView.contentOffset = CGPointMake(_viewWidth, 0);
}

- (void)setIsShowPageIndicator:(BOOL)isShowPageIndicator
{
    _isShowPageIndicator = isShowPageIndicator;
    
    if(_isShowPageIndicator)
    {
        self.pageControl.hidden = NO;
    }
    else
    {
        self.pageControl.hidden = YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(_timer)
    {
        dispatch_suspend(_timer);
    }
    
    CGPoint offset = scrollView.contentOffset;
    
    float x = offset.x;
    if(x <= 0)
    {
        if(self.currentIndex - 1 < 0)
        {
            self.currentIndex = _arImageView.count - 1;
        }
        else
        {
            self.currentIndex -= 1;
        }
    }
    
    if(x >= _viewWidth * 2)
    {
        if(self.currentIndex == _arImageView.count - 1)
        {
            self.currentIndex = 0;
        }
        else
        {
            self.currentIndex += 1;
        }
    }
    
    self.currentIndex %= self.pageControl.numberOfPages;
    
    [self reloadData];
    
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(wheelMove:current:)])
    {
        [self.delegate wheelMove:self current:self.currentIndex];
    }
    
    if(_timer)
    {
        dispatch_resume(_timer);
    }
}

- (void)setBAutoScroll:(BOOL)autoScroll
{
    _bAutoScroll = autoScroll;
    
    if(_bAutoScroll)
    {
        if(_timer == nil)
        {
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
            dispatch_source_set_timer(_timer, dispatch_walltime(NULL, self.timeInterval), self.timeInterval*NSEC_PER_SEC, 1*NSEC_PER_SEC);
            dispatch_source_set_event_handler(_timer, ^{
                [self autoShowNextImage];
            });
            
            double delayInSeconds = 4.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                dispatch_resume(_timer);
            });
        }
        else
        {
            dispatch_resume(_timer);
        }
    }
    else
    {
        if(_timer)
        {
            dispatch_resume(_timer);
        }
    }
}

- (void)autoShowNextImage
{
    if(_arImageView.count < 2)
        return;
    
    NSInteger index = _currentIndex+_sType;
    
    if(_sType > 0)
    {
        if(index == _arImageView.count)
        {
            index = 0;
        }
    }
    else
    {
        if(index < 0)
        {
            index = _arImageView.count - 1;
        }
    }
    
    self.currentIndex = index;
    
    self.currentIndex %= self.pageControl.numberOfPages;
    
    [self reloadData];
    
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(wheelMove:current:)])
    {
        [self.delegate wheelMove:self current:self.currentIndex];
    }
}


@end
