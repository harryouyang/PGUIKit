//
//  PGBaseViewController.h
//  PGUIKit
//
//  Created by hql on 15/6/21.
//  Copyright (c) 2015年 pangu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PGBarButtonItemActionBlock)(void);

@interface PGBaseViewController : UIViewController

@property(nonatomic, assign)CGRect mainFrame;
@property(nonatomic, assign)CGRect validFrame;

@property(nonatomic, assign, readonly)CGFloat viewWidth;
@property(nonatomic, assign, readonly)CGFloat viewHeight;

#pragma mark for keyboard
@property(nonatomic, assign)BOOL bkeyboardVisible;
@property(nonatomic, assign)CGRect keyboardFrame;
@property(nonatomic, assign)float nKboffset;

@property(nonatomic, assign)CGPoint point;
@property(nonatomic, assign)float noffset;

/**
 *  统一设置背景图片
 *
 *  @param backgroundImage 目标背景图片
 */
- (void)setupBackgroundImage:(UIImage *)backgroundImage;

/**
 *  push新的控制器到导航控制器
 *
 *  @param newViewController 目标新的控制器对象
 */
- (void)pushNewViewController:(UIViewController *)newViewController;

- (void)popToViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (void)popToRootViewControllerAnimated:(BOOL)animated;

- (void)configureBarbuttonItemImage:(UIImage *)image action:(PGBarButtonItemActionBlock)action;

- (void)configureBarbuttonItemTitle:(NSString *)title action:(PGBarButtonItemActionBlock)action;

+ (CGFloat)getAdapterHeight;

- (CGRect)navBarFrame;

- (UINavigationBar *)navBar;

- (void)setNavTitleAttributes:(NSDictionary *)dicAttributes;

#pragma mark -
- (void)addSimpleTapGesture:(id<UIGestureRecognizerDelegate>)gestureDelegate;

- (void)viewhandleSingleTap:(UITapGestureRecognizer *)gesture;

#pragma mark -
- (void)showDataLoadErrorView;

- (void)hideDataLoadErrorView;

- (void)reloadData;

- (void)errorleftMenuResponse:(id)sender;

- (void)getDataFromNet;

#pragma mark -
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
- (UIViewController *)appRootController;

#pragma mark -
- (void)asyncOnMainQueue:(dispatch_block_t)block;

@end
