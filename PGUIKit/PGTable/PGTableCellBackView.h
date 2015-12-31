//
//  PGTableCellBackView.h
//  PanguCommonLib
//
//  Created by ouyanghua on 14-2-22.
//  Copyright (c) 2014年 pangu. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum tableCellGradientDirectionStyle
{
    ETableCellGradientDirectionStyleVertical = 0,
    ETableCellGradientDirectionStyleHorizontal = 1,
    ETableCellGradientDirectionStyleTopLeftToBottomRight,
    ETableCellGradientDirectionStyleBottomLeftToTopRight
}ETableCellGradientDirectionStyle;


@interface PGTableCellBackView : UIView
{
    float       prevLayerHeight;
    float       prevLayerWidth;
}

@property(nonatomic, strong)UIColor *separatorColor;
@property(nonatomic, assign)int dashWidth;
@property(nonatomic, assign)int dashGap;
@property(nonatomic, assign)int dashStroke;
@property(nonatomic, strong)NSArray *backgroundColors;
@property(nonatomic, assign)ETableCellGradientDirectionStyle DirectionStyle;
@property(nonatomic, strong)UIColor *separatorColorV;
@property(nonatomic, assign)int dashWidthV;
@property(nonatomic, assign)int dashGapV;
@property(nonatomic, assign)int dashStrokeV;

@end
