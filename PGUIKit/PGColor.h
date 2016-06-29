//
//  PGColor.h
//  PGUIKit
//
//  Created by ouyanghua on 16/4/25.
//  Copyright © 2016年 PG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (PGColor)

- (UIColor *)lightenByPercentage:(CGFloat)percentage;

- (UIColor *)darkenByPercentage:(CGFloat)percentage;

@end
