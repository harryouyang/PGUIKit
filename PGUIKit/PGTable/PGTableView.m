//
//  PGTableView.m
//  PanguCommonLib
//
//  Created by ouyanghua on 14-2-22.
//  Copyright (c) 2014年 pangu. All rights reserved.
//

#import "PGTableView.h"

@implementation PGTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if(self = [super initWithFrame:frame style:style])
    {
        self.backgroundColor = TABLEBACKGROUNDCOLOR;
        self.separatorColor = TABLESEPERATORCOLOR;
        self.rowHeight = PGTABLEVIEWCELLHEIGHT;
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        self.nNumOfPage = 20;
        self.nTotal = 0;
        self.nPageIndex = 0;
        self.bLoading = NO;
        self.bLoadmoring = NO;
        self.nEndoffset = 0.0f;
    }
    return self;
}

- (void)createRefreshHead
{
    _refreshTableHeaderView = [[PGRefreshRotate alloc] initWithFrame:CGRectMake(0,-80,CGRectGetWidth(self.frame),80)];
    _refreshTableHeaderView.delegate = self;
    [self addSubview:_refreshTableHeaderView];
}

//- (void)createRefreshHead
//{
//    _refreshTableHeaderView = [[PGRefreshView alloc] initWithFrame:CGRectMake(0,-CGRectGetHeight(self.frame),CGRectGetWidth(self.frame),CGRectGetHeight(self.frame)) showUpdateTime:NO];
//    _refreshTableHeaderView.szLastUpdateKey = @"LastUpdateKey";
//    _refreshTableHeaderView.delegate = self;
//    _refreshTableHeaderView.bShowUpdateTime = YES;
//    float marktop = 150.0;
//    if(_pgDelegate != nil && [_pgDelegate respondsToSelector:@selector(refreshIndicativeMarkTop:)])
//    {
//        marktop = [_pgDelegate refreshIndicativeMarkTop:self];
//    }
//    [_refreshTableHeaderView reSetIndicativeMarkTop:marktop];
//    [self addSubview:_refreshTableHeaderView];
//}

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    if(_refreshTableHeaderView != nil)
        [_refreshTableHeaderView PGRefreshScrollViewDidScroll:scrollView];
}

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    if(_refreshTableHeaderView != nil)
        [_refreshTableHeaderView PGRefreshScrollViewDidEndDragging:scrollView closeatOnce:NO];
}

- (void)hideRefreshView:(UIScrollView *)scrollView
{
    if(_refreshTableHeaderView != nil)
        [_refreshTableHeaderView PGRefreshScrollViewDataSourceDidFinishedLoading:scrollView];
}

- (void)autoRefreshView:(UIScrollView *)scrollView
{
    if(_refreshTableHeaderView != nil)
    {
        [_refreshTableHeaderView PGRefreshScrollViewAutoScroll:scrollView];
        [_refreshTableHeaderView PGRefreshScrollViewDidEndDragging:scrollView closeatOnce:_bRemainLoading];
    }
}

- (void)setBEnableRefreshHead:(BOOL)bEnableRefreshHead
{
    _bEnableRefreshHead = bEnableRefreshHead;
    if(!bEnableRefreshHead)
    {
        [_refreshTableHeaderView removeFromSuperview];
        _refreshTableHeaderView = nil;
    }
    else if(bEnableRefreshHead && _refreshTableHeaderView == nil)
    {
        [self createRefreshHead];
    }
}

- (void)dealloc
{
    self.pgDelegate = nil;
}

#pragma mark -
- (void)refreshTableHeaderDidTriggerRefresh:(PGRefreshView *)view
{
    if(!self.bLoading)
    {
        self.bLoading = YES;
        if([_pgDelegate respondsToSelector:@selector(refreshTableContent:)])
            [_pgDelegate refreshTableContent:self];
    }
}

- (BOOL)isLoadingRefreshTableHeaderDataSource:(PGRefreshView *)view
{
    return self.bLoading;
}

- (NSDate *)refreshTableHeaderDataSourceLastUpdated:(PGRefreshView *)view
{
    NSDate *date = [NSDate date];
    if([_pgDelegate respondsToSelector:@selector(refreshLastUpdated:)])
        date = [_pgDelegate refreshLastUpdated:self];
    return date;
}

#pragma mark -
- (BOOL)LoadMoreRefreshScrollViewIsLoading:(UIScrollView *)scrollview
{
    return self.bLoadmoring;
}

- (void)LoadMoreRefreshScrollViewDidEndDragging:(UIScrollView *)scrollview
{
    if(self.bLoadmoring)
        return;
    self.bLoadmoring = YES;
    
    [self.moreView LoadMoreRefreshScrollViewDidLoading];
    
    if([_pgDelegate respondsToSelector:@selector(loadMore:)])
    {
        [_pgDelegate loadMore:self];
    }
}

- (void)LoadMoreClick:(PGLoadMoreFootView *)sender
{
    if(self.bLoadmoring)
        return;
    self.bLoadmoring = YES;
    
    [self.moreView LoadMoreRefreshScrollViewDidLoading];
    
    if([_pgDelegate respondsToSelector:@selector(loadMore:)])
    {
        [_pgDelegate loadMore:self];
    }
}

@end
