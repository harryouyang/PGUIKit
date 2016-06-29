//
//  PGCheckView.h
//  PGUIKit
//
//  Created by ouyanghua on 16/1/20.
//  Copyright © 2016年 PG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PGCheckView;
@protocol PGCheckViewDelegate <NSObject>
@optional
- (void)checkView:(PGCheckView *)checkView didChange:(BOOL)bCheck;
@end

@interface PGCheckView : UIView
@property(nonatomic, weak)id<PGCheckViewDelegate> delegate;
@property(nonatomic, assign)BOOL bCheck;
@property(nonatomic, strong)NSObject *extendData;

@property(nonatomic, strong)UIColor *normalBgColor;
@property(nonatomic, strong)UIColor *selBgColor;

@property(nonatomic, strong)UIColor *normalTextColor;
@property(nonatomic, strong)UIColor *selTextColor;

@property(nonatomic, strong)UIImage *normalIndicateImage;
@property(nonatomic, strong)UIImage *selIndicateImage;

@property(nonatomic, strong, readonly)UILabel *textLabel;
@property(nonatomic, strong, readonly)UIImageView *indicateView;

@property(nonatomic, assign)BOOL isRadioView;//是否为单选模式

@property(nonatomic, assign)BOOL bEnable;//是否可点击

- (id)initWithFrame:(CGRect)frame text:(NSString *)text showIndicate:(BOOL)bShow;

@end
