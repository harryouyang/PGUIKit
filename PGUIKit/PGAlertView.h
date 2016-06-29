//
//  PGAlertView.h
//  PGUIKit
//
//  Created by ouyanghua on 16/1/30.
//  Copyright © 2016年 PG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGAlertView : UIAlertView

@property(nonatomic, copy)void(^alertActionBlock)(NSInteger alertTag, NSInteger actionIndex);

@end
