//
//  PGTableViewCell.m
//  PanguCommonLib
//
//  Created by ouyanghua on 14-2-22.
//  Copyright (c) 2014年 pangu. All rights reserved.
//

#import "PGTableViewCell.h"

@implementation PGTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        PGTableCellBackView *backgroundView = [[PGTableCellBackView alloc] initWithFrame:CGRectZero];
        backgroundView.backgroundColors = [NSArray arrayWithObjects:(id)TABLECELLBACKGROUNDCOLOR.CGColor, nil];
//        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.backgroundView = backgroundView;
        self.backgroundView.backgroundColor = TABLECELLBACKGROUNDCOLOR;
        
        PGTableCellBackView *selectedBackgroundView = [[PGTableCellBackView alloc] initWithFrame:CGRectZero];
        selectedBackgroundView.backgroundColors = [NSArray arrayWithObjects:(id)TABLECELLSELECTEDCOLOR.CGColor, nil];
//        selectedBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.selectedBackgroundView = selectedBackgroundView;
        
        [self SetDashWidth:1 dashGap:0 dashStroke:1];
        [self SetVerticalDashWidth:1 dashGap:0 dashStroke:1];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.selectedBackgroundView setNeedsDisplay];
    [self.backgroundView setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)SetCellSeparatorColor:(UIColor*)separatorColor
{
    ((PGTableCellBackView *)self.selectedBackgroundView).separatorColor = separatorColor;
    ((PGTableCellBackView *)self.backgroundView).separatorColor = separatorColor;
}

- (void)SetVerticalCellSeparatorColor:(UIColor*)separatorColor
{
    ((PGTableCellBackView *)self.backgroundView).separatorColorV = separatorColor;
}

- (void)SetGradientDirection:(ETableCellGradientDirectionStyle)direction
{
    [(PGTableCellBackView *)self.backgroundView setDirectionStyle:direction];
}

- (void)SetSelectionGradientDirection:(ETableCellGradientDirectionStyle)direction
{
    [(PGTableCellBackView *)self.selectedBackgroundView setDirectionStyle:direction];
}

- (void)SetDashWidth:(int)dashWidth dashGap:(int)dashGap dashStroke:(int)dashStroke
{
    PGTableCellBackView *bgView = (PGTableCellBackView *)self.backgroundView;
    PGTableCellBackView *selBgView = (PGTableCellBackView *)self.selectedBackgroundView;
    
    bgView.dashWidth = dashWidth;
    selBgView.dashWidth = dashWidth;
    
    bgView.dashGap = dashGap;
    selBgView.dashGap = dashGap;
    
    bgView.dashStroke = dashStroke;
    selBgView.dashStroke = dashStroke;
}

- (void)SetVerticalDashWidth:(int)dashWidth dashGap:(int)dashGap dashStroke:(int)dashStroke
{
    PGTableCellBackView *bgView = (PGTableCellBackView *)self.backgroundView;
    
    bgView.dashWidthV = dashWidth;
    
    bgView.dashGapV = dashGap;
    
    bgView.dashStrokeV = dashStroke;
}

- (void)SetSelectedBackgroundViewGradientColors:(NSArray*)colors
{
    [(PGTableCellBackView *)self.selectedBackgroundView setBackgroundColors:colors];
}

- (void)SetBackgroundViewGradientColors:(NSArray*)colors
{
    [(PGTableCellBackView *)self.backgroundView setBackgroundColors:colors];
}

@end
