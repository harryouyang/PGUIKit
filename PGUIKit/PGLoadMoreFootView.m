//
//  PGLoadMoreFootView.m
//  PanguCommonLib
//
//  Created by ouyanghua on 14-2-22.
//  Copyright (c) 2014年 pangu. All rights reserved.
//

#import "PGLoadMoreFootView.h"
#define EXTENDDISTANCE      20

@interface PGLoadMoreFootView ()
{
    UILabel *m_text;
    UIActivityIndicatorView *m_ai;
}

@property(nonatomic, weak)id<PGLoadMoreFootViewDelegate> m_delegate;

@end

@implementation PGLoadMoreFootView

- (id)initWithFrame:(CGRect)frame Delegate:(id<PGLoadMoreFootViewDelegate>)delegate
{
    if(self =[super initWithFrame:frame])
    {
        self.m_delegate = delegate;
        
        m_text = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width-100)/2,(self.frame.size.height-20)/2,100,20)];
        m_text.backgroundColor = [UIColor clearColor];
        m_text.font = [UIFont systemFontOfSize:14];
        m_text.text = @"上拉加载更多";
        m_text.textAlignment = NSTextAlignmentCenter;
        [self addSubview:m_text];
        
        m_ai = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        m_ai.frame = CGRectMake(50,(self.frame.size.height-m_ai.frame.size.height)/2,m_ai.frame.size.width,m_ai.frame.size.height);
        [self addSubview:m_ai];
        
        [self addTarget:self action:@selector(LoadMoreClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)LoadMoreRefreshScrollViewDidEndDragging:(UIScrollView *)scrollview
{
    if(scrollview.frame.size.height > scrollview.contentSize.height)
        return;
    if(scrollview.contentOffset.y + scrollview.frame.size.height > scrollview.contentSize.height+EXTENDDISTANCE)
    {
        if([self.m_delegate LoadMoreRefreshScrollViewIsLoading:scrollview] == NO)
            [self.m_delegate LoadMoreRefreshScrollViewDidEndDragging:scrollview];
    }
}

- (void)LoadMoreRefreshScrollViewDidScroll:(UIScrollView *)scrollview
{
    if(scrollview.frame.size.height > scrollview.contentSize.height)
        return;
    if([self.m_delegate LoadMoreRefreshScrollViewIsLoading:scrollview] == NO)
    {
        if(scrollview.contentOffset.y + scrollview.frame.size.height > scrollview.contentSize.height+EXTENDDISTANCE)
            m_text.text=@"加载更多";
        else
            m_text.text=@"上拉加载更多";
    }
}

- (void)LoadMoreRefreshScrollViewDidLoading
{
    m_text.text = @"加载中";
    [m_ai startAnimating];
}

- (void)LoadMoreRefreshScrollViewDidFinishLoading
{
    m_text.text = @"上拉加载更多";
    [m_ai stopAnimating];
}

- (void)LoadMoreClick:(id)sender
{
    if([self.m_delegate LoadMoreRefreshScrollViewIsLoading:nil]==NO)
        [self.m_delegate LoadMoreClick:self];
}

- (void)dealloc
{
    self.m_delegate = nil;
}


@end
