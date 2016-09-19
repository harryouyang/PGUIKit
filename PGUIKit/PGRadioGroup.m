//
//  PGRadioGroup.m
//  PGUIKit
//
//  Created by ouyanghua on 16/1/20.
//  Copyright © 2016年 PG. All rights reserved.
//

#import "PGRadioGroup.h"

@interface PGRadioGroup ()
@property(nonatomic, strong)NSMutableArray *arrayChecks;
@end

@implementation PGRadioGroup

- (id)init
{
    if(self = [super init])
    {
        self.arrayChecks = [[NSMutableArray alloc] init];
        _curCheckIndex = -1;
    }
    return self;
}

- (id)initWithCheckArray:(NSArray *)array
{
    if(self = [super init])
    {
        _curCheckIndex = -1;
        self.arrayChecks = [[NSMutableArray alloc] init];
        if(array && array.count > 0)
        {
            [self.arrayChecks addObjectsFromArray:array];
            
            for(PGCheckView *cv in self.arrayChecks)
            {
                cv.delegate = self;
            }
        }
    }
    return self;
}

- (void)addCheckView:(PGCheckView *)checkView
{
    [self.arrayChecks addObject:checkView];
    checkView.delegate = self;
}

- (void)setCurCheckIndex:(NSInteger)curCheckIndex
{
    if(curCheckIndex < 0 || curCheckIndex >= self.arrayChecks.count)
    {
        return;
    }
    
    if(_curCheckIndex == curCheckIndex)
    {
        return;
    }
    
    _curCheckIndex = curCheckIndex;
    
    PGCheckView *curCV = nil;
    
    for(NSInteger i = 0; i < self.arrayChecks.count; i++)
    {
        PGCheckView *cv = [self.arrayChecks objectAtIndex:i];
        if(i == _curCheckIndex)
        {
            cv.bCheck = YES;
            curCV = cv;
        }
        else
        {
            cv.bCheck = NO;
        }
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(radioGroup:didChanged:index:)])
    {
        [self.delegate radioGroup:self didChanged:curCV index:_curCheckIndex];
    }
}

#pragma mark -
- (void)checkView:(PGCheckView *)checkView didChange:(BOOL)bCheck
{
    if(bCheck)
    {
        NSInteger j = 0;
        for(NSInteger i = 0; i < self.arrayChecks.count; i++)
        {
            PGCheckView *cv = [self.arrayChecks objectAtIndex:i];
            if(cv != checkView)
            {
                cv.bCheck = NO;
            }
            else
            {
                j = i;
            }
        }
        
        if(_curCheckIndex != j)
        {
            _curCheckIndex = j;
        
            if(self.delegate && [self.delegate respondsToSelector:@selector(radioGroup:didChanged:index:)])
            {
                [self.delegate radioGroup:self didChanged:checkView index:_curCheckIndex];
            }
        }
    }
}

@end
