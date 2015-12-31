//
//  PGViewController.m
//  PGUIKit
//
//  Created by ouyanghua on 15/12/15.
//  Copyright © 2015年 PG. All rights reserved.
//

#import "PGViewController.h"
#import "PGUIHelper.h"
#import "PGUIExtend.h"

#define KEYBOARDFRAMEWILLCHANGE         @"KBWFC"

@implementation PGBaseBackgroundView

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if([self.nextResponder isKindOfClass:[PGViewController class]])
    {
        PGViewController *controller = (PGViewController *)self.nextResponder;
        [controller SetViewFrame:frame];
    }
}
@end

////////////////////////////////////////////////////////////////////////////////////////
@implementation PGViewParam

- (id)init
{
    if(self = [super init])
    {
        self.arParam = [[NSMutableArray alloc] init];
    }
    return self;
}

@end


static BOOL s_bFullScreen = NO;

@interface PGViewController ()
@property(nonatomic, strong)NSMutableArray *arSubController;
@end

@implementation PGViewController

- (void)SetViewFrame:(CGRect)frame
{
    self.mainFrame = frame;
}

#pragma mark init
- (id)initWithFrame:(CGRect)frame param:(PGViewParam *)param
{
    if(self = [super init])
    {
        self.mainFrame = frame;
        self.viewParam = param;
        
        self.arSubController = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mainFrame = self.view.frame;
    self.arSubController = [[NSMutableArray alloc] init];
}

//- (void)loadView
//{
//    self.view = [[PGBaseBackgroundView alloc] initWithFrame:self.mainFrame];
//    self.view.frame = self.mainFrame;
//    self.view.clipsToBounds = NO;
//    self.view.backgroundColor = [UIColor whiteColor];
//}

#pragma mark navbar
- (void)createNavigationBar:(id)title titleSize:(CGSize(^)())titleSizeBlock leftbtn:(id)left titleSize:(CGSize(^)())leftSizeBlock rightbtn:(id)right titleSize:(CGSize(^)())rightSizeBlock
{
    if(self.navBar != nil)
    {
        [self.navBar removeFromSuperview];
    }
    
    UIView *midView = nil;
    if(title != nil)
    {
        if([title isKindOfClass:[UIView class]])
        {
            ((UIView *)title).frame = CGRectMakeWithSize(0, 0, titleSizeBlock());
            midView = title;
        }
        else if([title isKindOfClass:[NSString class]] && ((NSString *)title).length > 0)
        {
            UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
            navTitle.frame = CGRectMakeWithSize(0, 0, titleSizeBlock());
            navTitle.backgroundColor = [UIColor clearColor];
            navTitle.text = title;
            navTitle.textColor = [UIColor whiteColor];
            navTitle.font = [UIFont systemFontOfSize:17];
            navTitle.textAlignment = NSTextAlignmentCenter;
            
            midView = navTitle;
        }
    }
    
    UIView *leftView = nil;
    if(left != nil)
    {
        if([left isKindOfClass:[NSString class]] && ((NSString *)left).length > 0)
        {
            UIButton *lbtn = [UIButton buttonWithType:UIButtonTypeCustom];
            lbtn.frame = CGRectMakeWithSize(0, 0, leftSizeBlock());
            lbtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [lbtn setTitleColor:[UIColor colorWithRed:74.0/255.0 green:150.0/255.0 blue:173.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [lbtn setTitle:left forState:UIControlStateNormal];
            [lbtn addTarget:self action:@selector(leftMenuResponse:) forControlEvents:UIControlEventTouchUpInside];
            
            leftView = lbtn;
        }
        else if([left isKindOfClass:[UIImage class]])
        {
            UIButton *lbtn = [UIButton buttonWithType:UIButtonTypeCustom];
            lbtn.frame = CGRectMakeWithSize(0, 0, leftSizeBlock());
            lbtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [lbtn setTitleColor:[UIColor colorWithRed:74.0/255.0 green:150.0/255.0 blue:173.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [lbtn setBackgroundImage:left forState:UIControlStateNormal];
            [lbtn addTarget:self action:@selector(leftMenuResponse:) forControlEvents:UIControlEventTouchUpInside];
            
            leftView = lbtn;
        }
        else if([left isKindOfClass:[UIView class]])
        {
            ((UIView *)left).frame = CGRectMakeWithSize(0, 0, leftSizeBlock());
            
            leftView = left;
        }
    }
    
    UIView *rightView = nil;
    if(right != nil)
    {
        if([right isKindOfClass:[NSString class]] && ((NSString *)right).length > 0)
        {
            UIButton *rbtn = [UIButton buttonWithType:UIButtonTypeCustom];
            rbtn.frame = CGRectMakeWithSize(0, 0, rightSizeBlock());
            rbtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [rbtn setTitleColor:[UIColor colorWithRed:74.0/255.0 green:150.0/255.0 blue:173.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [rbtn setTitle:right forState:UIControlStateNormal];
            [rbtn addTarget:self action:@selector(rightMenuResponse:) forControlEvents:UIControlEventTouchUpInside];
            
            rightView = rbtn;
        }
        else if([right isKindOfClass:[UIImage class]])
        {
            UIButton *rbtn = [UIButton buttonWithType:UIButtonTypeCustom];
            rbtn.frame = CGRectMakeWithSize(0, 0, rightSizeBlock());
            rbtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [rbtn setTitleColor:[UIColor colorWithRed:74.0/255.0 green:150.0/255.0 blue:173.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [rbtn setBackgroundImage:right forState:UIControlStateNormal];
            [rbtn addTarget:self action:@selector(rightMenuResponse:) forControlEvents:UIControlEventTouchUpInside];
            
            rightView = rbtn;
        }
        else if([right isKindOfClass:[UIView class]])
        {
            ((UIView *)right).frame = CGRectMakeWithSize(0, 0, rightSizeBlock());
            
            rightView = right;
        }
    }
    
    self.navBar = [[PGNavBar alloc] initWithFrame:CGRectMake(0, 0, self.mainFrame.size.width, s_bFullScreen ? 44 : (IOS7 ? 64 : 44)) left:leftView mid:midView right:rightView originY:s_bFullScreen ? 0 : (IOS7 ? 20 : 0)];
    self.navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.navBar.backgroundColor = UIColorFromRGB(0x7cb600);
    [self.view addSubview:self.navBar];
}

- (void)setNavBarTitle:(NSString *)szTitle
{
    if(self.navBar != nil)
    {
        if([self.navBar.midView isKindOfClass:[UILabel class]])
        {
            ((UILabel *)self.navBar.midView).text = szTitle;
        }
    }
}

+ (CGFloat)getAdapterHeight
{
    CGFloat adapterHeight = 0;
    if ([[[UIDevice currentDevice] systemVersion] integerValue] < 7.0)
    {
        adapterHeight = 44;
    }
    return adapterHeight;
}

- (CGRect)navBarFrame
{
    CGRect rect = CGRectZero;
    if(self.navBar != nil && !self.navBar.hidden)
    {
        rect = self.navBar.frame;
    }
    
    return rect;
}

- (CGFloat)nNavOriginY
{
    return CGRectGetMaxY([self navBarFrame]);
}

#pragma mark -
- (void)addActionSwipeToPrevView
{
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToPrevViewController:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:swipe];
}

- (void)swipeToPrevViewController:(UISwipeGestureRecognizer *)gesture
{
    [self leftMenuResponse:nil];
}

- (void)leftMenuResponse:(id)sender
{
    [self.parentController popViewControllerWithStyle:EAnimateStyleLeftToRight];
}

- (void)rightMenuResponse:(id)sender
{
}

#pragma mark message
- (void)showTitle:(NSString *)szTitle msg:(NSString *)szMsg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:szTitle message:szMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

- (void)showMsg:(NSString *)szMsg
{
    [self showTitle:nil msg:szMsg];
}

- (void)showProgressView:(NSString *)text
{
    if(self.progressView == nil)
    {
        self.progressView = [[PGProgressView alloc] initBgColor:UIColorFromRGBA(0x858585, 0.8) apla:1.0 font:nil textColor:nil activeColor:[UIColor whiteColor]];
        self.progressView.type = EProgressViewTypeNone;
        self.progressView.layer.cornerRadius = 5.0;
    }
    
    if(!self.bShowProgressView)
    {
        UIView *bgView = [[UIView alloc] initWithFrame:CGGetBoundsWithFrame(self.mainFrame)];
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
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardFrameWillChange:) name:KEYBOARDFRAMEWILLCHANGE object:nil];
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
            [[NSNotificationCenter defaultCenter] removeObserver:self name:KEYBOARDFRAMEWILLCHANGE object:nil];
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
                [[NSNotificationCenter defaultCenter] postNotificationName:KEYBOARDFRAMEWILLCHANGE object:nil userInfo:[noti userInfo]];
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
- (void)willShowViewController { }

- (void)willDisAppearViewController { }

- (void)didShowViewController { }

- (void)didDisAppearViewController { }

- (void)reDidShowViewController { }

- (void)reDidDisAppearViewController { }

- (void)stillShowViewController { }

#pragma mark -
+ (void)fullScreen:(BOOL)bfullScreen
{
    s_bFullScreen = bfullScreen;
}

#pragma mark -
- (void)addSubViewController:(PGViewController *)controller
{
    if(controller != nil)
    {
        [self.arSubController addObject:controller];
        [self.view addSubview:controller.view];
        controller.parentController  = self;
    }
}

- (void)removeSubViewController:(PGViewController *)controller
{
    if(controller != nil)
    {
        [controller.view removeFromSuperview];
        [self.arSubController removeObject:controller];
        controller.parentController = nil;
    }
}

- (void)pushViewController:(PGViewController *)viewController animateStyle:(PGAnimateStyle)animatestyle
{
    __block CGRect frame = viewController.view.frame;
    CGRect rc = viewController.view.frame;
    switch(animatestyle)
    {
        case EAnimateStyleNone:
        {
            break;
        }
        case EAnimateStyleLeftToRight:
        {
            rc.origin.x -= frame.size.width;
            break;
        }
        case EAnimateStyleRightToLeft:
        {
            rc.origin.x += frame.size.width;
            break;
        }
        case EAnimateStyleButtomToTop:
        {
            rc.origin.y += frame.size.height;
            break;
        }
        case EAnimateStyleTopToButtom:
        {
            rc.origin.y -= frame.size.height;
            break;
        }
    }
    
    viewController.view.frame = rc;
    [self addSubViewController:viewController];
    
    __weak PGViewController *weakSelf = self;
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^
     {
         weakSelf.view.userInteractionEnabled = NO;
         viewController.view.frame = frame;
         [weakSelf willDisAppearViewController];
         [viewController willShowViewController];
     } completion:^(BOOL finished)
     {
         if(finished)
         {
             [weakSelf didDisAppearViewController];
             [viewController didShowViewController];
             weakSelf.view.userInteractionEnabled = YES;
         }
     }];
}

- (void)popViewControllerWithStyle:(PGAnimateStyle)animatestyle
{
    if(self.arSubController.count < 1)
    {
        return ;
    }
    
    PGViewController *willAppearViewController = self;
    if(self.arSubController.count >= 2)
    {
        willAppearViewController = [self.arSubController objectAtIndex:self.arSubController.count-2];
    }
    
    PGViewController *viewController = [self.arSubController objectAtIndex:self.arSubController.count -1];
    CGRect frame = viewController.view.frame;
    __block CGRect rc = viewController.view.frame;
    switch(animatestyle)
    {
        case EAnimateStyleNone:
        {
            break;
        }
        case EAnimateStyleLeftToRight:
        {
            rc.origin.x += frame.size.width;
            break;
        }
        case EAnimateStyleRightToLeft:
        {
            rc.origin.x -= frame.size.width;
            break;
        }
        case EAnimateStyleButtomToTop:
        {
            rc.origin.y -= frame.size.height;
            break;
        }
        case EAnimateStyleTopToButtom:
        {
            rc.origin.y += frame.size.height;
            break;
        }
    }
    
    __weak PGViewController *weakSelf = self;
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^
     {
         weakSelf.view.userInteractionEnabled = NO;
         viewController.view.frame = rc;
         
         [viewController willDisAppearViewController];
         [willAppearViewController willShowViewController];
     } completion:^(BOOL finished)
     {
         if(finished)
         {
             [viewController didDisAppearViewController];
             [willAppearViewController didShowViewController];
             
             weakSelf.view.userInteractionEnabled = YES;
             [weakSelf removeSubViewController:viewController];
         }
     }];
}

- (void)popToViewController:(PGViewController *)viewController animateStyle:(PGAnimateStyle)animatestyle
{
    if(self.arSubController.count < 1 || viewController == nil)
    {
        return ;
    }
    
    if(viewController == self)
    {
        [self popToRootViewControllerWithStyle:animatestyle];
    }
    else
    {
        BOOL blag = NO;
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for(NSInteger i = self.arSubController.count -1; i >= 0; i--)
        {
            PGViewController *controller = [self.arSubController objectAtIndex:i];
            if(controller == viewController)
            {
                blag = YES;
                break;
            }
            else
            {
                [array addObject:controller];
            }
        }
        
        if(blag)
        {
            [self popViewController:array willshow:viewController animateStyle:animatestyle];
        }
    }
}

- (void)popToRootViewControllerWithStyle:(PGAnimateStyle)animatestyle
{
    if(self.arSubController.count < 1)
    {
        return ;
    }
    
    [self popViewController:self.arSubController willshow:self animateStyle:animatestyle];
}

- (void)popViewController:(NSArray *)array willshow:(PGViewController *)willShowViewController animateStyle:(PGAnimateStyle)animatestyle
{
    __block CGRect rc = willShowViewController.view.frame;
    CGRect frame = willShowViewController.view.frame;
    switch(animatestyle)
    {
        case EAnimateStyleNone:
        {
            break;
        }
        case EAnimateStyleLeftToRight:
        {
            rc.origin.x += frame.size.width;
            break;
        }
        case EAnimateStyleRightToLeft:
        {
            rc.origin.x -= frame.size.width;
            break;
        }
        case EAnimateStyleButtomToTop:
        {
            rc.origin.y -= frame.size.height;
            break;
        }
        case EAnimateStyleTopToButtom:
        {
            rc.origin.y += frame.size.height;
            break;
        }
    }
    
    __weak PGViewController *weakSelf = self;
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^
     {
         weakSelf.view.userInteractionEnabled = NO;
         for(int i = 0; i < array.count; i++)
         {
             PGViewController *viewController = [array objectAtIndex:0];
             viewController.view.frame = rc;
             [viewController willDisAppearViewController];
         }
         
         [willShowViewController willShowViewController];
     } completion:^(BOOL finished)
     {
         if(finished)
         {
             for(int i = 0; i < array.count; i++)
             {
                 PGViewController *viewController = [array objectAtIndex:0];
                 viewController.view.frame = rc;
                 [viewController didDisAppearViewController];
                 [weakSelf removeSubViewController:viewController];
             }
             [willShowViewController didShowViewController];
             
             weakSelf.view.userInteractionEnabled = YES;
         }
     }];
}

#pragma mark -
- (BOOL)prefersStatusBarHidden
{
    return s_bFullScreen;
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
