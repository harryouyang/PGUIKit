//
//  PGImageView.h
//  PanguCommonLib
//
//  Created by ouyanghua on 14-2-22.
//  Copyright (c) 2014年 pangu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGImageView : UIImageView

@property(nonatomic, strong)NSString *szUrl;
@property(nonatomic, strong)UIImage *sImage;

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image;

@end
