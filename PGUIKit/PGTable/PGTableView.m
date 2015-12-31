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
        _dicCellHead = [[NSMutableDictionary alloc] init];
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

- (UIImageView *)createDefaultSectionHead:(NSString *)szTitle image:(UIImage *)image
{
    UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectZero];
    if(image != nil)
    {
        UIImage *stretchimage=[image stretchableImageWithLeftCapWidth:1 topCapHeight:1];
        imageview.image = stretchimage;
    }
    
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(10,0,200,PGTABLEVIEWSECTIONHEADHEIGHT)];
    label.backgroundColor=[UIColor clearColor];
    label.text=szTitle;
    label.font=[UIFont systemFontOfSize:13];
    [imageview addSubview:label];
    
    return imageview;
}

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
//        [_refreshTableHeaderView PGRefreshScrollViewDidEndDragging:scrollView];
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

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath select:(BOOL)bSelect
{
    if(bSelect)
    {
        [self selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    else
    {
        if(indexPath != nil)
            [self deselectRowAtIndexPath:indexPath animated:YES];
//        else
//            indexPath = [self indexPathForSelectedRow];
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

- (void)reloadData
{
    [_dicCellHead removeAllObjects];
    [super reloadData];
}

- (void)dealloc
{
    self.pgDelegate = nil;
}

#pragma mark -
- (void)refreshTableHeaderDidTriggerRefresh:(PGRefreshView *)view
{
    if([_pgDelegate respondsToSelector:@selector(refreshTableContent:)])
        [_pgDelegate refreshTableContent:self];
}

- (BOOL)isLoadingRefreshTableHeaderDataSource:(PGRefreshView *)view
{
    BOOL result = NO;
    if([_pgDelegate respondsToSelector:@selector(isLoadingRefreshTable)])
        result = [_pgDelegate isLoadingRefreshTable];
    
    return result;
}

- (NSDate *)refreshTableHeaderDataSourceLastUpdated:(PGRefreshView *)view
{
    NSDate *date = [NSDate date];
    if([_pgDelegate respondsToSelector:@selector(refreshLastUpdated:)])
        date = [_pgDelegate refreshLastUpdated:self];
    return date;
}

@end
