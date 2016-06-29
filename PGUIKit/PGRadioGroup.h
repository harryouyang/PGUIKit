//
//  PGRadioGroup.h
//  PGUIKit
//
//  Created by ouyanghua on 16/1/20.
//  Copyright © 2016年 PG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGCheckView.h"

@class PGRadioGroup;
@protocol PGRadioGroupDelegate <NSObject>
@optional
- (void)radioGroup:(PGRadioGroup *)radioGroup didChanged:(PGCheckView *)checkView index:(NSInteger)index;
@end

@interface PGRadioGroup : NSObject<PGCheckViewDelegate>
@property(nonatomic, weak)id<PGRadioGroupDelegate> delegate;
@property(nonatomic, assign)NSInteger curCheckIndex;

- (id)initWithCheckArray:(NSArray *)array;

- (void)addCheckView:(PGCheckView *)checkView;

@end
