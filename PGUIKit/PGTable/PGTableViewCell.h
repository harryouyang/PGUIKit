//
//  PGTableViewCell.h
//  PanguCommonLib
//
//  Created by ouyanghua on 14-2-22.
//  Copyright (c) 2014年 pangu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGUIHelper.h"
#import "PGTableCellBackView.h"

#define TABLECELLBACKGROUNDCOLOR RGBCOLOR(245.0,245.0,245.0)
#define TABLECELLSELECTEDCOLOR RGBCOLOR(143.0,193.0,255.0)


@interface PGTableViewCell : UITableViewCell

- (void)SetDashWidth:(int)dashWidth dashGap:(int)dashGap dashStroke:(int)dashStroke;
- (void)SetCellSeparatorColor:(UIColor*)separatorColor;

- (void)SetVerticalDashWidth:(int)dashWidth dashGap:(int)dashGap dashStroke:(int)dashStroke;
- (void)SetVerticalCellSeparatorColor:(UIColor*)separatorColor;

// set the selected background color by providing an array of colors
// requires a list of CGColor
- (void)SetSelectedBackgroundViewGradientColors:(NSArray*)colors;

- (void)SetBackgroundViewGradientColors:(NSArray*)colors;

// set the selected background color gradient direction
- (void)SetSelectionGradientDirection:(ETableCellGradientDirectionStyle)direction;

- (void)SetGradientDirection:(ETableCellGradientDirectionStyle)direction;

@end
