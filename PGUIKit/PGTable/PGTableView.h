//
//  PGTableView.h
//  PanguCommonLib
//
//  Created by ouyanghua on 14-2-22.
//  Copyright (c) 2014年 pangu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGUIHelper.h"
#import "PGRefreshView.h"
#import "PGRefreshRotate.h"
#import "PGLoadMoreFootView.h"

#define TABLEBACKGROUNDCOLOR RGBCOLOR(245.0,245.0,245.0)
#define TABLESEPERATORCOLOR RGBCOLOR(116.0,116.0,116.0)
#define TABLECELLSELECTEDCOLOR RGBCOLOR(143.0,193.0,255.0)

#define PGTABLEVIEWCELLHEIGHT       50
#define PGTABLEVIEWSECTIONHEADHEIGHT        24

#define MAINTITLEFONT       [UIFont systemFontOfSize:17]        //21------18---20
#define SUBTITLEFONT        [UIFont systemFontOfSize:14]        //18------13---15
#define THIRDTITLEFONT      [UIFont systemFontOfSize:12]        //15------11---13

@protocol PGTableViewDelegate;
@interface PGTableView : UITableView<PGRefreshViewDelegate,PGLoadMoreFootViewDelegate>

@property(nonatomic, strong)PGBaseRefresh *refreshTableHeaderView;
@property(nonatomic, assign)BOOL bEnableRefreshHead;
@property(nonatomic, weak)id<PGTableViewDelegate> pgDelegate;
@property(nonatomic, assign)BOOL bRemainLoading;

@property(nonatomic, strong)PGLoadMoreFootView *moreView;

@property(nonatomic, assign)NSInteger nNumOfPage;//每次加载的数量
@property(nonatomic, assign)NSInteger nPageIndex;//当前的页数
@property(nonatomic, assign)NSInteger nTotal;//总记录条数
@property(nonatomic, assign)BOOL bLoading;//是否正在加载数据
@property(nonatomic, assign)BOOL bLoadmoring;//是否正在加载更多
@property(nonatomic, assign)CGFloat nEndoffset;//开始拉动时的偏移量

- (void)createRefreshHead;

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView;

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView;

- (void)hideRefreshView:(UIScrollView *)scrollView;

- (void)autoRefreshView:(UIScrollView *)scrollView;

@end


@protocol PGTableViewDelegate <NSObject>

@optional
- (void)refreshTableContent:(PGTableView *)tableView;
- (BOOL)isLoadingRefreshTable;
- (float)refreshIndicativeMarkTop:(PGTableView *)tableView;
- (NSDate *)refreshLastUpdated:(PGTableView *)tableView;

- (void)loadMore:(PGTableView *)tableView;
@end
