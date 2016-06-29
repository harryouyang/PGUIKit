//
//  PGBaseRefresh.m
//  PGUIKit
//
//  Created by ouyanghua on 15/11/20.
//  Copyright © 2015年 PG. All rights reserved.
//

#import "PGBaseRefresh.h"

@implementation PGBaseRefresh

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        _nLoadingInsetStop = 62;
        _nPullingDistance = -62;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        
        [self setState:EPGRefreshNormal];
    }
    return self;
}

- (void)setState:(EPGRefreshState)state
{
    _state = state;
}

- (UIScrollView *)scrollView
{
    UIScrollView *scrollView = (UIScrollView *)self.superview;
    
    if(![scrollView isKindOfClass:[UIScrollView class]])
        scrollView = nil;
    
    return scrollView;
}

#pragma mark -
#pragma mark ScrollView Methods

- (void)PGRefreshScrollViewAutoScroll:(UIScrollView *)scrollView
{
    scrollView.contentOffset = CGPointMake(0, _nPullingDistance);
    [self setState:EPGRefreshPulling];
}

- (void)PGRefreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_state == EPGRefreshLoading)
    {
        CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
        offset = MIN(offset, _nLoadingInsetStop);
        scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
    }
    else if (scrollView.isDragging)
    {
        BOOL _loading = NO;
        if ([_delegate respondsToSelector:@selector(isLoadingRefreshTableHeaderDataSource:)]) {
            _loading = [_delegate isLoadingRefreshTableHeaderDataSource:self];
        }
        
        if (_state == EPGRefreshPulling && scrollView.contentOffset.y > _nPullingDistance && scrollView.contentOffset.y < 0.0f && !_loading) {
            [self setState:EPGRefreshNormal];
        } else if (_state == EPGRefreshNormal && scrollView.contentOffset.y < _nPullingDistance && !_loading) {
            [self setState:EPGRefreshPulling];
        }
        else {
            [self setState:EPGRefreshDragging];
        }
        
        if (scrollView.contentInset.top != 0) {
            scrollView.contentInset = UIEdgeInsetsZero;
        }
    }
}

- (void)PGRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    [self PGRefreshScrollViewDidEndDragging:scrollView closeatOnce:NO];
}

- (void)PGRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView closeatOnce:(BOOL)bAtOnce
{
    BOOL _loading = NO;
    if ([_delegate respondsToSelector:@selector(isLoadingRefreshTableHeaderDataSource:)])
    {
        _loading = [_delegate isLoadingRefreshTableHeaderDataSource:self];
    }
    
    if (scrollView.contentOffset.y <= _nPullingDistance && !_loading)
    {
        if ([_delegate respondsToSelector:@selector(refreshTableHeaderDidTriggerRefresh:)])
        {
            [_delegate refreshTableHeaderDidTriggerRefresh:self];
        }
        
        if(!bAtOnce)
        {
            [self setState:EPGRefreshLoading];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            scrollView.contentInset = UIEdgeInsetsMake(_nLoadingInsetStop, 0.0f, 0.0f, 0.0f);
            [UIView commitAnimations];
        }
        else
            [self PGRefreshScrollViewDataSourceDidFinishedLoading:scrollView];
    }
}

- (void)PGRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [UIView commitAnimations];
    
    [self setState:EPGRefreshStop];
}

- (void)PGRefreshScrollViewDataSourceDidLoading:(UIScrollView *)scrollView
{
    [self setState:EPGRefreshPulling];
    [self setState:EPGRefreshLoading];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    scrollView.contentInset = UIEdgeInsetsMake(_nLoadingInsetStop, 0.0f, 0.0f, 0.0f);
    [UIView commitAnimations];
    [scrollView setContentOffset:CGPointMake(0,-_nLoadingInsetStop) animated:YES];
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc
{
    self.delegate = nil;
}

@end
