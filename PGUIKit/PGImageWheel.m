//
//  PGImageWheel.m
//  PanguCommonLib
//
//  Created by ouyanghua on 14-2-22.
//  Copyright (c) 2014年 pangu. All rights reserved.
//

#import "PGImageWheel.h"
//#import "PGPageControl.h"
#import "PGImageView.h"

@interface PGImageWheel ()
//@property(nonatomic, retain)PGPageControl *pageControl;
@property(nonatomic, strong)dispatch_source_t timer;
@property(nonatomic, assign)NSInteger sType;
@property(nonatomic, assign)NSInteger currentIndex;
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

- (void)ReSetFrame:(CGRect)rect flag:(BOOL)flag
{
    self.frame = rect;
    CGRect bounds = self.bounds;
    m_scrollView.frame = bounds;
    
    for(int i = 0; i < _arImageView.count; i++)
    {
        PGImageView *view = [_arImageView objectAtIndex:i];
        view.frame = CGRectMake(bounds.size.width * i, bounds.origin.y, bounds.size.width, bounds.size.height);
        UIImage *image = view.sImage;
        if(image != nil)
        {
            if(flag)
            {
                view.contentMode = UIViewContentModeScaleToFill;
                
                if(((bounds.size.width > bounds.size.height)&&(image.size.width < image.size.height))||((bounds.size.width < bounds.size.height)&&(image.size.width > image.size.height)))
                {
                    view.image = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationRight];
                }
                else
                {
                    view.image = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationUp];
                }
            }
            else
            {
                view.contentMode = UIViewContentModeScaleAspectFill;
                view.image = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationUp];
            }
        }
    }
    [m_scrollView setContentSize:CGSizeMake(bounds.size.width * _arImageView.count , bounds.size.height)];
    
    if(_pageControl != nil)
    {
        if(self.indicatorPosition == EPageIndicatorPosition_Bottom)
        {
            _pageControl.frame = CGRectMake(self.indicatorPostionHeight, self.bounds.size.height-self.indicatorPostionHeight, self.bounds.size.width-2*self.indicatorPostionHeight, self.indicatorPostionHeight);
        }
        else if(self.indicatorPosition == EPageIndicatorPosition_Top)
        {
            _pageControl.frame = CGRectMake(self.indicatorPostionHeight, 0, self.bounds.size.width-2*self.indicatorPostionHeight, self.indicatorPostionHeight);
        }
        
        self.currentIndex = _pageControl.currentPage;
        [_pageControl setCurrentPage:self.currentIndex];
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(wheelMove:current:)])
        {
            [self.delegate wheelMove:self current:self.currentIndex];
        }
    }
}

- (void)ReSetImageArray:(NSArray *)array
{
    NSInteger count = 1;
    if(array != nil && array.count > 0)
    {
        for(UIView *view in m_scrollView.subviews)
            [view removeFromSuperview];
        
        [_arImageView removeAllObjects];
        
        CGRect bounds = self.bounds;
        [_arImageView addObjectsFromArray:array];
        count = array.count;
        [m_scrollView setContentSize:CGSizeMake(bounds.size.width * count , bounds.size.height)];
        for(int i = 0; i < count; i++)
        {
            UIView *view = [array objectAtIndex:i];
            view.frame = CGRectMake(bounds.size.width * i, bounds.origin.y, bounds.size.width, bounds.size.height);
            view.userInteractionEnabled = YES;
            if([view isKindOfClass:[UIImageView class]])
            {
                view.contentMode = UIViewContentModeScaleToFill;
            }
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subViewClick:)];
            [view addGestureRecognizer:singleTap];
            
            [m_scrollView addSubview:view];
        }
        
        if(_pageControl != nil)
        {
            self.pageControl.numberOfPages = count;
        }
    }
    
}

- (id)initWithFrame:(CGRect)frame imageArray:(NSArray *)array isShowPageIndicator:(BOOL)bflag
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGRect bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
        m_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height)];
        m_scrollView.pagingEnabled = YES;
        m_scrollView.bounces = NO;
        [m_scrollView setDelegate:self];
        m_scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:m_scrollView];
        
        self.bAutoScroll = NO;
        self.timeInterval = 3;
        _sType = 1;
        self.currentIndex = 0;
        self.indicatorPostionHeight = 20;
        
        self.indicatorPosition = EPageIndicatorPosition_Bottom;
        _arImageView = [[NSMutableArray alloc] init];
        NSInteger count = 1;
        if(array != nil && array.count > 0)
        {
            [_arImageView addObjectsFromArray:array];
            count = array.count;
            [m_scrollView setContentSize:CGSizeMake(bounds.size.width * count , bounds.size.height)];
            for(int i = 0; i < count; i++)
            {
                UIView *view = [array objectAtIndex:i];
                view.frame = CGRectMake(bounds.size.width * i, bounds.origin.y, bounds.size.width, bounds.size.height);
                view.userInteractionEnabled = YES;
                
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subViewClick:)];
                [view addGestureRecognizer:singleTap];
                
                [m_scrollView addSubview:view];
            }
        }
        
        _pageControl = [[PGPageControl alloc] initWithFrame:CGRectMake(0, bounds.size.height-self.indicatorPostionHeight, bounds.size.width, self.indicatorPostionHeight)];
        self.pageControl.pageControlStyle = PGPageControlStyleDfault;
        self.pageControl.numberOfPages = count;
        self.pageControl.currentPage = self.currentIndex;
        self.pageControl.backgroundColor = [UIColor colorWithRed:(float)(72)/255.0 green:(float)(72)/255.0 blue:(float)(72)/255.0 alpha:(0.0)];
        // change color
        [self.pageControl setCoreNormalColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1]];
        [self.pageControl setCoreSelectedColor:[UIColor colorWithRed:0.48 green:0.753 blue:0.815 alpha:1]];
        // change gap width
        [self.pageControl setGapWidth:5];
        // change diameter
        [self.pageControl setDiameter:9];
        [self.pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.pageControl];
        
        if(bflag)
        {
            self.pageControl.hidden = NO;
        }
        else
        {
            self.pageControl.hidden = YES;
        }
    }
    return self;
}

- (void)pageChanged:(PGPageControl *)pageContrl
{
    CGSize viewSize = m_scrollView.frame.size;
    
    CGRect rect = CGRectMake(pageContrl.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    
    [m_scrollView scrollRectToVisible:rect animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    [_pageControl setCurrentPage:offset.x / bounds.size.width];
    self.currentIndex = self.pageControl.currentPage;
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(wheelMove:current:)])
    {
        [self.delegate wheelMove:self current:self.pageControl.currentPage];
    }
}

- (void)scrollPageIndex:(NSInteger)nPageIndex
{
    if(_arImageView != nil && _arImageView.count > 0)
    {
        if(self.scrollType == EPageScrollerType_Loop)
        {
            self.pageControl.currentPage = nPageIndex%_arImageView.count;
        }
        else if(self.scrollType == EPageScrollerType_Reverse)
        {
            self.pageControl.currentPage = nPageIndex%_arImageView.count;
            
            if(nPageIndex == _arImageView.count-1)
            {
                _sType = -1;
            }
            
            if(nPageIndex == 0)
            {
                _sType = 1;
            }
        }
        
        self.currentIndex = self.pageControl.currentPage;
        
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(wheelMove:current:)])
        {
            [self.delegate wheelMove:self current:self.pageControl.currentPage];
        }
    }
}

- (NSInteger)currentPageIndex
{
    NSInteger index = 0;
    if(self.pageControl != nil)
        index = self.pageControl.currentPage;
    return index;
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
                [self scrollPageIndex:[self currentPageIndex]+_sType];
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

- (void)subViewClick:(UITapGestureRecognizer *)gesture
{
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(imgeWheel:didSelect:)])
    {
        [self.delegate imgeWheel:self didSelect:self.pageControl.currentPage];
    }
}


@end
