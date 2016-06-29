//
//  PGStarRatingView.h
//  PGUIKit
//
//  Created by ouyanghua on 16/5/7.
//  Copyright © 2016年 PG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PGStarRatingView;
@protocol PGStarRatingViewDelegate
@optional
- (void)newRating:(PGStarRatingView *)starRatingView rating:(float)rating;
@end


@interface PGStarRatingView : UIView
@property(nonatomic, assign)float rating;
@property(nonatomic, weak)id<PGStarRatingViewDelegate> delegate;
@property(nonatomic, assign)BOOL isFractionalRatingEnabled;
@property(nonatomic, assign)BOOL enable;

- (id)initWithFrame:(CGRect)frame
           starSize:(CGSize)starSize
             xSpace:(CGFloat)xSpace
               star:(UIImage *)starImage
    highLightedStar:(UIImage *)highLightedStarImage;

- (void)ResetBackgroundColor:(UIColor *)color;

@end