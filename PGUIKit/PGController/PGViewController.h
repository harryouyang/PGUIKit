//
//  PGViewController.h
//  PGUIKit
//
//  Created by ouyanghua on 15/12/15.
//  Copyright © 2015年 PG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGProgressView.h"
#import "PGNavBar.h"

typedef NS_ENUM(NSUInteger, PGAnimateStyle)
{
    EAnimateStyleNone,
    EAnimateStyleLeftToRight,
    EAnimateStyleRightToLeft,
    EAnimateStyleTopToButtom,
    EAnimateStyleButtomToTop
};

#pragma mark -
@interface PGViewParam : NSObject
@property(nonatomic, strong)NSMutableArray *arParam;
@end

#pragma mark -
@interface PGBaseBackgroundView : UIView
@end

@interface PGViewController : UIViewController

@property(nonatomic, assign, readonly)CGFloat nNavOriginY;
@property(nonatomic, strong)PGNavBar *navBar;
@property(nonatomic, assign)CGRect mainFrame;
@property(nonatomic, strong)PGViewParam *viewParam;

@property(nonatomic, assign)BOOL bkeyboardVisible;
@property(nonatomic, assign)CGRect keyboardFrame;
@property(nonatomic, assign)float nKboffset;

@property(nonatomic, strong)PGProgressView *progressView;
@property(nonatomic, assign)BOOL bShowProgressView;

@property(nonatomic, strong)PGViewController *parentController;

- (void)SetViewFrame:(CGRect)frame;

#pragma mark init
- (id)initWithFrame:(CGRect)frame param:(PGViewParam *)param;

#pragma mark navbar
- (void)createNavigationBar:(id)title titleSize:(CGSize(^)())titleSizeBlock leftbtn:(id)left titleSize:(CGSize(^)())leftSizeBlock rightbtn:(id)right titleSize:(CGSize(^)())rightSizeBlock;

- (void)setNavBarTitle:(NSString *)szTitle;

+ (CGFloat)getAdapterHeight;

- (CGRect)navBarFrame;

- (CGFloat)nNavOriginY;

#pragma mark -
- (void)addActionSwipeToPrevView;

- (void)leftMenuResponse:(id)sender;

- (void)rightMenuResponse:(id)sender;

#pragma mark message
- (void)showTitle:(NSString *)szTitle msg:(NSString *)szMsg;

- (void)showMsg:(NSString *)szMsg;

- (void)showProgressView:(NSString *)text;

- (void)endProgressView;

#pragma mark keyboard
- (void)addKeyboardObserver;

- (void)removeKeyboardObserver;

- (BOOL)keyboardWillShow:(NSNotification *)noti;

- (BOOL)keyboardWillHide:(NSNotification *)noti;

- (BOOL)keyboardFrameWillChange:(NSNotification*)noti;

#pragma mark -
- (void)willShowViewController;

- (void)willDisAppearViewController;

- (void)didShowViewController;

- (void)didDisAppearViewController;

- (void)reDidShowViewController;

- (void)reDidDisAppearViewController;

- (void)stillShowViewController;

#pragma mark -
+ (void)fullScreen:(BOOL)bfullScreen;

#pragma mark -
- (void)pushViewController:(PGViewController *)viewController animateStyle:(PGAnimateStyle)animatestyle;

- (void)popViewControllerWithStyle:(PGAnimateStyle)animatestyle;

- (void)popToViewController:(PGViewController *)viewController animateStyle:(PGAnimateStyle)animatestyle;

- (void)popToRootViewControllerWithStyle:(PGAnimateStyle)animatestyle;

#pragma mark -
- (UIViewController *)appRootController;

#pragma mark -
- (void)asyncOnMainQueue:(dispatch_block_t)block;

@end
