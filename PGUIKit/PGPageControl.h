//
//  PGPageControl.h
//  PanguCommonLib
//
//  Created by ouyanghua on 14-2-22.
//  Copyright (c) 2014年 pangu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    PGPageControlStyleDfault = 0,
    PGPageControlStyleStrokedCircle = 1,
    PGPageControlStylePressed1 = 2,
    PGPageControlStylePressed2 = 3,
    PGPageControlStyleWithPageNumber = 4,
    PGPageControlStyleThumb = 5,
    PGPageControlStyleStrokedSquare = 6,
}PGPageControlStyle;

@interface PGPageControl : UIControl
@property (nonatomic, strong) UIColor *coreNormalColor, *coreSelectedColor;
@property (nonatomic, strong) UIColor *strokeNormalColor, *strokeSelectedColor;
@property (nonatomic, assign) NSInteger currentPage, numberOfPages;
@property (nonatomic, assign) BOOL hidesForSinglePage;
@property (nonatomic, assign) PGPageControlStyle pageControlStyle;
@property (nonatomic, assign) NSInteger strokeWidth, diameter, gapWidth;
@property (nonatomic, strong) UIImage *thumbImage, *selectedThumbImage;
@property (nonatomic, strong) NSMutableDictionary *thumbImageForIndex, *selectedThumbImageForIndex;

- (void)setThumbImage:(UIImage *)aThumbImage forIndex:(NSInteger)index;
- (UIImage *)thumbImageForIndex:(NSInteger)index;
- (void)setSelectedThumbImage:(UIImage *)aSelectedThumbImage forIndex:(NSInteger)index;
- (UIImage *)selectedThumbImageForIndex:(NSInteger)index;


@end
