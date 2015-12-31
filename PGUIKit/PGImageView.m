//
//  PGImageView.m
//  PanguCommonLib
//
//  Created by ouyanghua on 14-2-22.
//  Copyright (c) 2014年 pangu. All rights reserved.
//

#import "PGImageView.h"

@implementation PGImageView

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        self.sImage = image;
        self.image = image;
    }
    return self;
}

@end
