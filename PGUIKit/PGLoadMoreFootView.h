//
//  PGLoadMoreFootView.h
//  PanguCommonLib
//
//  Created by ouyanghua on 14-2-22.
//  Copyright (c) 2014年 pangu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PGLoadMoreFootView;

@protocol PGLoadMoreFootViewDelegate<NSObject>

- (BOOL)LoadMoreRefreshScrollViewIsLoading:(UIScrollView *)scrollview;

- (void)LoadMoreRefreshScrollViewDidEndDragging:(UIScrollView *)scrollview;

- (void)LoadMoreClick:(PGLoadMoreFootView *)sender;

@end

@interface PGLoadMoreFootView : UIButton

-(id)initWithFrame:(CGRect)frame Delegate:(id<PGLoadMoreFootViewDelegate>)delegate;

-(void)LoadMoreRefreshScrollViewDidScroll:(UIScrollView *)scrollview;

-(void)LoadMoreRefreshScrollViewDidFinishLoading;

-(void)LoadMoreRefreshScrollViewDidLoading;

-(void)LoadMoreRefreshScrollViewDidEndDragging:(UIScrollView *)scrollview;
@end
