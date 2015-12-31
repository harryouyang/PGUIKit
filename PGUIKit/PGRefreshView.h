//
//  PGRefreshView.h
//  PanguCommonLib
//
//  Created by ouyanghua on 14-2-22.
//  Copyright (c) 2014年 pangu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGBaseRefresh.h"

@interface PGRefreshView : PGBaseRefresh
{
    UILabel     *_lastUpdatedLabel;
    UILabel     *_statusLabel;
    CALayer     *_arrowImage;
    UIActivityIndicatorView     *_activityView;
}

@property(nonatomic, assign)BOOL bShowUpdateTime;
@property(nonatomic, strong)NSString *szLastUpdateKey;

- (id)initWithFrame:(CGRect)frame;

- (id)initWithFrame:(CGRect)frame showUpdateTime:(BOOL)bShow;

- (void)reSetIndicativeMarkTop:(float)nHeight;

- (void)refreshLastUpdatedDate;

@end

