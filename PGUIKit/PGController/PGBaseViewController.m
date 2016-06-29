//
//  PGBaseViewController.m
//  PGUIKit
//
//  Created by hql on 15/6/21.
//  Copyright (c) 2015年 pangu. All rights reserved.
//

#import "PGBaseViewController.h"
#import "PGProgressView.h"
#import "PGUIHelper.h"
#import "PGUIExtend.h"
#import "PGAlertView.h"

#define KEYBOARDFRAMEWILLCHANGE2         @"KBWFC"

@interface PGBaseViewController ()
@property(nonatomic, copy)PGBarButtonItemActionBlock barbuttonItemAction;

@property(nonatomic, strong)PGProgressView *progressView;
@property(nonatomic, assign)BOOL bShowProgressView;

@property(nonatomic, strong)UIView *dataLoadErrorView;

@property(nonatomic, strong)NSMutableDictionary *allErrorView;

@end

@implementation PGBaseViewController

- (void)clickedBarButtonItemAction {
    if (self.barbuttonItemAction) {
        self.barbuttonItemAction();
    }
}

#pragma mark - Public Method

- (void)configureBarbuttonItemImage:(UIImage *)image action:(PGBarButtonItemActionBlock)action
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleBordered target:self action:@selector(clickedBarButtonItemAction)];
    self.barbuttonItemAction = action;
}

- (void)configureBarbuttonItemTitle:(NSString *)title action:(PGBarButtonItemActionBlock)action
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleBordered target:self action:@selector(clickedBarButtonItemAction)];
    self.barbuttonItemAction = action;
}

- (void)setupBackgroundImage:(UIImage *)backgroundImage
{
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundImageView.image = backgroundImage;
    [self.view insertSubview:backgroundImageView atIndex:0];
}

- (void)pushNewViewController:(UIViewController *)newViewController
{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    
    [self.navigationController pushViewController:newViewController animated:YES];
}

- (void)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(viewController == nil)
    {
        [self.navigationController popViewControllerAnimated:animated];
    }
    else
    {
        [self.navigationController popToViewController:viewController animated:animated];
    }
}

- (void)popToRootViewControllerAnimated:(BOOL)animated
{
    [self.navigationController popToRootViewControllerAnimated:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.allErrorView = [[NSMutableDictionary alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

#pragma mark -
+ (CGFloat)getAdapterHeight {
    CGFloat adapterHeight = 0;
    if ([[[UIDevice currentDevice] systemVersion] integerValue] < 7.0) {
        adapterHeight = 44;
    }
    return adapterHeight;
}

- (CGRect)navBarFrame
{
    CGRect rect = CGRectZero;
    if(self.navigationController != nil && !self.navigationController.navigationBar.hidden)
    {
        rect = self.navigationController.navigationBar.frame;
    }
    
    return rect;
}

- (UINavigationBar *)navBar
{
    UINavigationBar *navbar = nil;
    if(self.navigationController != nil)
    {
        navbar = self.navigationController.navigationBar;
    }
    
    return navbar;
}

- (void)setNavTitleAttributes:(NSDictionary *)dicAttributes
{
    UINavigationBar *navBar = [self navBar];
    if(navBar)
    {
        [navBar setTitleTextAttributes:dicAttributes];
    }
}

#pragma mark -
- (CGRect)mainFrame
{
    return [UIApplication sharedApplication].keyWindow.frame;
}

- (CGRect)validFrame
{
    CGRect viewFrame = self.view.bounds;
    
    if(self.navigationController != nil)
    {
        if(self.navigationController.viewControllers.count <= 1)
        {
            if(self.tabBarController != nil)
            {
                viewFrame.size.height -= CGRectGetHeight(self.tabBarController.tabBar.bounds);
            }
        }
        
        viewFrame.size.height -= CGRectGetMaxY(self.navigationController.navigationBar.frame);
        viewFrame.origin.y += CGRectGetMaxY(self.navigationController.navigationBar.frame);
    }
    
    return viewFrame;
}

- (CGFloat)viewWidth
{
    return self.view.frame.size.width;
}

- (CGFloat)viewHeight
{
    return self.view.frame.size.height;
}

#pragma mark -
- (void)addSimpleTapGesture:(id<UIGestureRecognizerDelegate>)gestureDelegate
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewhandleSingleTap:)];
    singleTap.delegate = gestureDelegate;
    [self.view addGestureRecognizer:singleTap];
}

- (void)viewhandleSingleTap:(UITapGestureRecognizer *)gesture
{
    [self.view endEditing:YES];
}

#pragma mark -
- (void)showErrorView:(UIView *)pView flag:(NSString *)viewFlag errorView:(UIView * (^)(void))errorView
{
    if(errorView == nil)
    {
        return;
    }
    
    UIView *view = errorView();
    if(view == nil)
    {
        return;
    }
    
    NSString *szControllerClassName = NSStringFromClass([self class]);
    NSString *szClassName = NSStringFromClass([pView class]);
    NSString *szTag = [NSString stringWithFormat:@"%@_%@",szControllerClassName, szClassName];
    if(viewFlag != nil && viewFlag.length > 0)
    {
        szTag = [NSString stringWithFormat:@"%@_%@_%@",szControllerClassName, szClassName, viewFlag];
    }
    
    [self hideErrorView:szTag];
    
    NSLog(@"<<-----show errorView:  %@ ----->", szTag);
    [pView addSubview:view];
    [self.allErrorView setObject:view forKey:szTag];
}

- (void)hideErrorView:(UIView *)pView flag:(NSString *)viewFlag
{
    NSString *szControllerClassName = NSStringFromClass([self class]);
    NSString *szClassName = NSStringFromClass([pView class]);
    NSString *szTag = [NSString stringWithFormat:@"%@_%@",szControllerClassName, szClassName];
    if(viewFlag != nil && viewFlag.length > 0)
    {
        szTag = [NSString stringWithFormat:@"%@_%@_%@",szControllerClassName, szClassName, viewFlag];
    }
    
    [self hideErrorView:szTag];
}

- (void)hideErrorView:(NSString *)viewFlag
{
    if(viewFlag == nil || viewFlag.length < 1)
    {
        return;
    }
    
    UIView *oldView = [self.allErrorView objectForKey:viewFlag];
    if(oldView != nil)
    {
        NSLog(@"<<-----hide errorView:  %@ ----->", viewFlag);
        [oldView removeFromSuperview];
        [self.allErrorView removeObjectForKey:viewFlag];
    }
}

#pragma mark -
- (void)showDataLoadErrorView
{
    [self showDataLoadErrorView:^UIImage *{
        return [UIImage imageNamed:@"load_error.png"];
    } rect:^CGRect{
        return CGRectMake(0, 0, 36, 36);
    }];
}

- (void)showDataLoadErrorView:(UIImage* (^)(void))imageInfo rect:(CGRect (^)(void))rectInfo
{
    if(_dataLoadErrorView == nil)
    {
        _dataLoadErrorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mainFrame.size.width, self.mainFrame.size.height)];
        _dataLoadErrorView.backgroundColor = UIColorFromRGB(0xdcdbdb);
        [self.view addSubview:_dataLoadErrorView];
        
        UIView *errorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MIN(200, _dataLoadErrorView.frame.size.width), MIN(200, _dataLoadErrorView.frame.size.height))];
        errorView.backgroundColor = _dataLoadErrorView.backgroundColor;
        [_dataLoadErrorView addSubview:errorView];
        errorView.userInteractionEnabled = YES;
        
        CGRect rc = rectInfo();
        UIImageView *errorImage = [[UIImageView alloc] initWithFrame:rc];
        errorImage.image = imageInfo();
        [errorView addSubview:errorImage];
        errorImage.center = errorView.center;
        errorImage.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(errorTap:)];
        [_dataLoadErrorView addGestureRecognizer:gest];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((errorView.frame.size.width-MIN(120, errorView.frame.size.width))/2, CGRectGetMaxY(errorImage.frame)+10, MIN(120, errorView.frame.size.width), 20)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = UIColorFromRGB(0xf9f9f9);
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"点击屏幕，重新加载";
        label.userInteractionEnabled = YES;
        [errorView addSubview:label];
        label.userInteractionEnabled = YES;
        
        if(CGRectGetMaxY(label.frame) > errorView.frame.size.height)
        {
            float y = CGRectGetMaxY(label.frame) - errorView.frame.size.height;
            label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y-y, label.frame.size.width, label.frame.size.height);
            errorImage.frame = CGRectMake(errorImage.frame.origin.x, errorImage.frame.origin.y-y, errorImage.frame.size.width, errorImage.frame.size.height);
        }
        
        errorView.center = CGPointMake(_dataLoadErrorView.frame.size.width/2, _dataLoadErrorView.frame.size.height/2);
    }
    
    _dataLoadErrorView.hidden = NO;
    [self.view bringSubviewToFront:_dataLoadErrorView];
}

- (void)errorTap:(UITapGestureRecognizer *)gest
{
    [self reloadData];
}

- (void)errorleftMenuResponse:(id)sender
{
}

- (void)hideDataLoadErrorView
{
    if(_dataLoadErrorView)
    {
        _dataLoadErrorView.hidden = YES;
    }
}

- (void)reloadData
{
}

- (void)retryBtnClicked:(id)sender
{
    [self getDataFromNet];
}

- (void)getDataFromNet
{
}

#pragma mark -
- (void)showTitle:(NSString *)szTitle msg:(NSString *)szMsg
{
    [self showAskAlertTitle:szTitle message:szMsg tag:0 action:nil cancelActionTitle:@"确定" otherActionsTitles:nil];
    
//    if(IOS9)
//    {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:szTitle message:szMsg preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//        [alertController addAction:okAction];
//        [self presentViewController:alertController animated:YES completion:nil];
//    }
//    else
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:szTitle message:szMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alert show];
//    }
}

- (void)showMsg:(NSString *)szMsg
{
    [self showTitle:nil msg:szMsg];
}

- (void)showAskAlertTitle:(NSString *)title message:(NSString *)message tag:(NSInteger)tag action:(PGAlertActionBlock)block cancelActionTitle:(NSString *)cancelTitle otherActionsTitles:(NSString *)actionTitles,...
{
    NSMutableArray *arrayTitles = [[NSMutableArray alloc] init];
    [arrayTitles addObject:cancelTitle];
    
    NSString *szActionTitle = nil;
    va_list argumentList;
    if(actionTitles)
    {
        [arrayTitles addObject:actionTitles];
        va_start(argumentList, actionTitles);
        szActionTitle = va_arg(argumentList, NSString *);
        while(szActionTitle)
        {
            [arrayTitles addObject:szActionTitle];
            szActionTitle = va_arg(argumentList, NSString *);
        }
        
        va_end(argumentList);
    }
    
    if(IOS9)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        for(NSInteger i = 0; i < arrayTitles.count; i++)
        {
            NSString *string = [arrayTitles objectAtIndex:i];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:string style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if(block)
                {
                    block(tag, i);
                }
            }];
            [alertController addAction:okAction];
        }
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        PGAlertView *alert = [[PGAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:actionTitles, nil];
        alert.alertActionBlock = block;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([alertView isKindOfClass:[PGAlertView class]])
    {
        if(((PGAlertView *)alertView).alertActionBlock)
        {
            ((PGAlertView *)alertView).alertActionBlock(alertView.tag, buttonIndex);
        }
    }
}

- (void)showProgressView:(NSString *)text
{
    if(self.progressView == nil)
    {
        if(self.progressViewBlock)
        {
            self.progressView = (PGProgressView *)self.progressViewBlock();
        }
        else
        {
            self.progressView = [[PGProgressView alloc] initBgColor:UIColorFromRGBA(0x858585, 0.8) apla:1.0 font:nil textColor:nil activeColor:[UIColor whiteColor]];
            self.progressView.type = EProgressViewTypeNone;
            self.progressView.layer.cornerRadius = 5.0;
        }
        
    }
    
    if(!self.bShowProgressView)
    {
        NSLog(@"====>>>%@", [NSValue valueWithCGRect:self.mainFrame]);
        UIView *bgView = [[UIView alloc] initWithFrame:CGGetBoundsWithFrame(CGRectMake(0, 0, self.viewWidth, self.viewHeight))];
        bgView.backgroundColor = [UIColor clearColor];
        [bgView addSubview:self.progressView];
        
        [self.view addSubview:bgView];
        
        self.bShowProgressView = YES;
    }
    
    [self.progressView showText:text];
    self.progressView.center = self.progressView.superview.center;
}

- (void)endProgressView
{
    if(self.progressView)
    {
        [self.progressView.superview removeFromSuperview];
        self.bShowProgressView = NO;
    }
}

#pragma mark -
- (void)addKeyboardObserver
{
    if(IOS8)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        if([[[[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."] objectAtIndex:0] intValue]>4)
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardFrameWillChange:) name:KEYBOARDFRAMEWILLCHANGE2 object:nil];
    }
}

- (void)removeKeyboardObserver
{
    if(IOS8)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        if([[[[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."] objectAtIndex:0] intValue]>4)
            [[NSNotificationCenter defaultCenter] removeObserver:self name:KEYBOARDFRAMEWILLCHANGE2 object:nil];
    }
}

- (BOOL)keyboardWillShow:(NSNotification *)noti
{
    CGRect frame=[(NSValue*)[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if(IOS8)
    {
        CGRect rect = [(NSValue *)[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        if(rect.size.height == 0 || _bkeyboardVisible)
            return NO;
        
        _keyboardFrame = rect;
        _bkeyboardVisible = YES;
        _nKboffset = _keyboardFrame.size.height;
    }
    else
    {
        if(_bkeyboardVisible)
        {
            if(frame.size.height != _nKboffset)
                [[NSNotificationCenter defaultCenter] postNotificationName:KEYBOARDFRAMEWILLCHANGE2 object:nil userInfo:[noti userInfo]];
            return NO;
        }
        _keyboardFrame = [(NSValue *)[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        _bkeyboardVisible = YES;
        _nKboffset = _keyboardFrame.size.height;
        
    }
    
    return YES;
}

- (BOOL)keyboardWillHide:(NSNotification *)noti
{
    if(_bkeyboardVisible==NO)
        return NO;
    _bkeyboardVisible = NO;
    return YES;
}

- (BOOL)keyboardFrameWillChange:(NSNotification*)noti
{
    CGRect frame=[(NSValue*)[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if(IOS8)
    {
        if(frame.size.height != 0 && _bkeyboardVisible && CGRectEqualToRect(_keyboardFrame,frame) != YES)
        {
            _keyboardFrame = frame;
            _nKboffset = _keyboardFrame.size.height;
            return YES;
        }
    }
    else
    {
        if(CGRectEqualToRect(_keyboardFrame,frame)!=YES)
        {
            _keyboardFrame = frame;
            _nKboffset = _keyboardFrame.size.height;
            return YES;
        }
    }
    
    return NO;
}

#pragma mark -
- (UIViewController *)appRootController
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *rootController = window.rootViewController;
    
    if(rootController == nil)
    {
        NSArray *array = [UIApplication sharedApplication].windows;
        UIWindow *topWindow = [array objectAtIndex:0];
        for(UIView *view in topWindow.subviews)
        {
            if([view.nextResponder isKindOfClass:[UIViewController class]] == YES)
            {
                rootController = (UIViewController *)view.nextResponder;
                break;
            }
        }
    }
    
    return rootController;
}

#pragma mark -
- (void)asyncOnMainQueue:(dispatch_block_t)block
{
    dispatch_async(dispatch_get_main_queue(), block);
}


@end
