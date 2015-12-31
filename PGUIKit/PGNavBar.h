//
//  PGNavBar.h
//  PGUIKit
//
//  Created by ouyanghua on 15/12/15.
//  Copyright © 2015年 PG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGNavBar : UIView

@property(nonatomic, strong)UIView *leftView;
@property(nonatomic, strong)UIView *midView;
@property(nonatomic, strong)UIView *rightView;

- (id)initWithFrame:(CGRect)frame left:(UIView *)lView mid:(UIView *)mView right:(UIView *)rView originY:(float)originy;

- (void)setImage:(UIImage *)image originY:(float)oriY;

@end
