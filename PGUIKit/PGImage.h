//
//  PGImage.h
//  PGUIKit
//
//  Created by ouyanghua on 16/3/8.
//  Copyright © 2016年 PG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PGImage)

/** 将原本3倍尺寸的图片缩放到设备对应尺寸 */
- (UIImage *)scaledImageFrom3x;

- (UIImage *)scaledImageToSize:(CGSize)scaledSize;

@end
