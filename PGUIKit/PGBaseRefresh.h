//
//  PGBaseRefresh.h
//  PGUIKit
//
//  Created by ouyanghua on 15/11/20.
//  Copyright © 2015年 PG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum
{
    EPGRefreshPulling = 0,
    EPGRefreshNormal,
    EPGRefreshLoading,
    EPGRefreshStop,
    EPGRefreshDragging,
}EPGRefreshState;

@protocol PGRefreshViewDelegate;
@interface PGBaseRefresh : UIView
{
    EPGRefreshState _state;
    __weak id<PGRefreshViewDelegate> _delegate;
}

@property(nonatomic, weak)id<PGRefreshViewDelegate> delegate;
@property(nonatomic, assign)EPGRefreshState state;
@property(nonatomic, assign)float nLoadingInsetStop;
@property(nonatomic, assign)float nPullingDistance;
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UIImageView *imageView;

- (void)setState:(EPGRefreshState)state;

- (void)PGRefreshScrollViewAutoScroll:(UIScrollView *)scrollView;

- (void)PGRefreshScrollViewDidScroll:(UIScrollView *)scrollView;

- (void)PGRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;

- (void)PGRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView closeatOnce:(BOOL)bAtOnce;

- (void)PGRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

- (void)PGRefreshScrollViewDataSourceDidLoading:(UIScrollView *)scrollView;

@end


@protocol PGRefreshViewDelegate <NSObject>

- (void)refreshTableHeaderDidTriggerRefresh:(PGBaseRefresh *)view;

- (BOOL)isLoadingRefreshTableHeaderDataSource:(PGBaseRefresh *)view;

@optional
- (NSDate *)refreshTableHeaderDataSourceLastUpdated:(PGBaseRefresh *)view;


@end