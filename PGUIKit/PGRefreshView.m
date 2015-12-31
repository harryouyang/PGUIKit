//
//  PGRefreshView.m
//  PanguCommonLib
//
//  Created by ouyanghua on 14-2-22.
//  Copyright (c) 2014年 pangu. All rights reserved.
//

#import "PGRefreshView.h"
#import "PGUIHelper.h"

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f

@implementation PGRefreshView

//@synthesize delegate = _delegate;
@synthesize bShowUpdateTime = _bShowUpdateTime;
//@synthesize nLoadingInsetStop = _nLoadingInsetStop;
//@synthesize nPullingDistance = _nPullingDistance;
@synthesize szLastUpdateKey = _szLastUpdateKey;

- (id)initWithFrame:(CGRect)frame showUpdateTime:(BOOL)bShow
{
    if(self = [super initWithFrame:frame])
    {
        self.szLastUpdateKey = @"lastupdate";
//        _nLoadingInsetStop = 62;
        _bShowUpdateTime = bShow;
//        _nPullingDistance = -62;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        
        [self setState:EPGRefreshNormal];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame showUpdateTime:YES];
}

- (void)reSetIndicativeMarkTop:(float)nHeight
{
    _lastUpdatedLabel.frame=CGRectOffset(_lastUpdatedLabel.frame,0,nHeight);
	_statusLabel.frame=CGRectOffset(_statusLabel.frame,0,nHeight);
	_arrowImage.frame=CGRectOffset(_arrowImage.frame,0,nHeight);
	_activityView.frame=CGRectOffset(_activityView.frame,0,nHeight);
}

- (void)setBShowUpdateTime:(BOOL)bShowUpdateTime
{
    _bShowUpdateTime = bShowUpdateTime;
    
    [_lastUpdatedLabel removeFromSuperview];
    _lastUpdatedLabel=nil;
    [_statusLabel removeFromSuperview];
    _statusLabel=nil;
    [_arrowImage removeFromSuperlayer];
    _arrowImage=nil;
    [_activityView removeFromSuperview];
    _activityView=nil;
    
    void(^timelabel)(CGRect frame)=^(CGRect frame)
	{
		UILabel* label=[[UILabel alloc] initWithFrame:frame];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
	};
    
    void(^textlable)(CGRect frame)=^(CGRect frame)
    {
        UILabel* label = [[UILabel alloc] initWithFrame:frame];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont boldSystemFontOfSize:13.0f];
        label.textColor = TEXT_COLOR;
        label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        label.shadowOffset = CGSizeMake(0.0f, 1.0f);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _statusLabel=label;
    };
    
    if(_bShowUpdateTime==NO)
    {
        CGRect frame=CGRectMake(0,0,CGRectGetWidth(self.frame),CGRectGetHeight(self.frame));
        textlable(frame);
    }
    else
    {
        float nH=CGRectGetHeight(self.frame)/2;
        
        CGSize size = CGSizeZero;
//        if(IOS7)
//        {
            size = [@"国" boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT)
                                      options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                   attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0f]}
                                      context:nil].size;
//        }
//        else
//        {
//            size = [@"国" sizeWithFont:[UIFont boldSystemFontOfSize:13.0f]];
//        }
        CGRect frame=CGRectMake(0,nH-size.height,CGRectGetWidth(self.frame),size.height);
        textlable(frame);
//        if(IOS7)
//        {
            size = [@"国" boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT)
                                      options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                   attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12.0f]}
                                      context:nil].size;
//        }
//        else
//        {
//            size = [@"国" sizeWithFont:[UIFont boldSystemFontOfSize:12.0f]];
//        }
        frame=CGRectMake(0,nH,CGRectGetWidth(self.frame),size.height);
        timelabel(frame);
    }
    
    UIImage* image=[UIImage imageNamed:@"blueArrow.png"];
	CALayer *layer = [CALayer layer];
	layer.frame = CGRectMake(25.0f,(CGRectGetHeight(self.frame)-image.size.height)/2,image.size.width,image.size.height);
    //	layer.contentsGravity = kCAGravityResizeAspect;
	layer.contents = (id)image.CGImage;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
	if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
		layer.contentsScale = [[UIScreen mainScreen] scale];
	}
#endif
    
	[[self layer] addSublayer:layer];
	_arrowImage=layer;
    
	UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	view.frame = CGRectMake(25.0f,(CGRectGetHeight(self.frame)-20)/2, 20.0f, 20.0f);
	[self addSubview:view];
	_activityView = view;
}

- (void)refreshLastUpdatedDate
{
    if ([_delegate respondsToSelector:@selector(refreshTableHeaderDataSourceLastUpdated:)])
	{
		NSDate *date = [_delegate refreshTableHeaderDataSourceLastUpdated:self];
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		_lastUpdatedLabel.text = [NSString stringWithFormat:@"最后更新时间: %@", [formatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:_szLastUpdateKey];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	else
	{
		_lastUpdatedLabel.text = nil;
	}
}

- (void)setState:(EPGRefreshState)aState
{
    switch (aState)
	{
		case EPGRefreshPulling:
		{
			_statusLabel.text=@"释放立即刷新";
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			break;
		}
		case EPGRefreshNormal:
		{
			if (_state == EPGRefreshPulling)
			{
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
            
			_statusLabel.text=@"下拉刷新";
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
            
			if(YES==_bShowUpdateTime)
				[self refreshLastUpdatedDate];
            
			break;
		}
		case EPGRefreshLoading:
		{
			_statusLabel.text=@"刷新中...";
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = YES;
			[CATransaction commit];
            
			break;
		}
        case EPGRefreshStop:
        {
            _statusLabel.text=@"下拉刷新";
            [_activityView stopAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = NO;
            _arrowImage.transform = CATransform3DIdentity;
            [CATransaction commit];
            break;
        }
		default:
			break;
	}
    
	_state = aState;
}


@end
