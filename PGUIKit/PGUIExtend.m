//
//  PGUIExtend.m
//  PanguCommonLib
//
//  Created by ouyanghua on 14-2-22.
//  Copyright (c) 2014年 pangu. All rights reserved.
//

#import "PGUIExtend.h"

CGRect CGRectMakeWithSize(CGFloat x, CGFloat y, CGSize size)
{
    CGRect rect;
    rect.origin.x = x; rect.origin.y = y;
    rect.size.width = size.width; rect.size.height = size.height;
    return rect;
}

CGRect CGGetBoundsWithFrame(CGRect frame)
{
    return CGRectMake(0, 0, frame.size.width, frame.size.height);
}

CGPoint CGGetCenterWithFrame(CGRect frame)
{
    return CGPointMake(frame.origin.x + frame.size.width/2, frame.origin.y + frame.size.height/2);
}

UIImage * createImageWithColor(UIColor *color)
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

UIImage * createCornerRadiusImageWithColor(UIColor *color,NSUInteger cornerRadius)
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 2*cornerRadius, 2*cornerRadius);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillEllipseInRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


UILabel* (^createLabel)(CGRect frame, UIColor *bgcolor, UIColor *textColor, UIFont *font, NSInteger align) = ^(CGRect frame, UIColor *bgcolor, UIColor *textColor, UIFont *font, NSInteger align)
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    if(bgcolor)
        label.backgroundColor = bgcolor;
    if(font)
        label.font = font;
    if(textColor)
        label.textColor = textColor;
    label.textAlignment = (NSInteger)align;
    return label;
};

UILabel* (^createAndAddLabel)(UIView *pView, CGRect frame, UIColor *bgcolor, UIColor *textColor, UIFont *font, NSInteger align, NSUInteger tag) = ^(UIView *pView, CGRect frame, UIColor *bgcolor, UIColor *textColor, UIFont *font, NSInteger align, NSUInteger tag)
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    if(bgcolor)
        label.backgroundColor = bgcolor;
    if(font)
        label.font = font;
    if(textColor)
        label.textColor = textColor;
    label.textAlignment = (NSInteger)align;
    label.tag = tag;
    if(pView)
        [pView addSubview:label];
    return label;
};

@implementation UILabel (pgcreatelabel)

+ (id)createLabel:(CGRect) frame bgColor:(UIColor *)bgcolor textColor:(UIColor *)textColor font:(UIFont *)font align:(NSInteger)align
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    if(bgcolor)
        label.backgroundColor = bgcolor;
    if(font)
        label.font = font;
    if(textColor)
        label.textColor = textColor;
    label.textAlignment = (NSInteger)align;
    return label;
}

+ (id)createAndAddLabel:(UIView *)pView frame:(CGRect) frame bgColor:(UIColor *)bgcolor textColor:(UIColor *)textColor font:(UIFont *)font align:(NSInteger)align tag:(NSUInteger)tag
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    if(bgcolor)
        label.backgroundColor = bgcolor;
    if(font)
        label.font = font;
    if(textColor)
        label.textColor = textColor;
    label.textAlignment = (NSInteger)align;
    label.tag = tag;
    if(pView)
        [pView addSubview:label];
    return label;
}

@end

@implementation UIButton (pgcreatebutton)

+ (id)buttonWithFrame:(CGRect)frame title:(NSString *)szTitle image:(UIImage *)image selImage:(UIImage *)selImage titleColor:(UIColor *)titlecolor titleSelColor:(UIColor *)titleselcolor target:(id)target selector:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:szTitle forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    button.frame = frame;
    if(image != nil)
    {
        [button setBackgroundImage:image forState:UIControlStateNormal];
    }
    if(selImage != nil)
    {
        [button setBackgroundImage:selImage forState:UIControlStateSelected];
        [button setBackgroundImage:selImage forState:UIControlStateHighlighted];
    }
    
    if(titlecolor != nil)
        [button setTitleColor:titlecolor forState:UIControlStateNormal];
    
    if(titleselcolor != nil)
    {
        [button setTitleColor:titleselcolor forState:UIControlStateSelected];
        [button setTitleColor:titleselcolor forState:UIControlStateHighlighted];
    }
    return button;
}

- (void)extendEventRegion:(UIEdgeInsets)edgeInset
{
    if(self.superview != nil)
    {
        CGRect sRC = self.frame;
        CGRect rect = CGRectMake(sRC.origin.x-edgeInset.left, sRC.origin.y-edgeInset.top, sRC.size.width+edgeInset.left+edgeInset.right, sRC.size.height+edgeInset.top+edgeInset.bottom);
        UIView *eventView = [[UIView alloc] initWithFrame:rect];
        eventView.backgroundColor = [UIColor clearColor];
//        eventView.alpha = 0.02;
        [self.superview insertSubview:eventView belowSubview:self];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(eventViewTap:)];
        [eventView addGestureRecognizer:singleTap];
    }
}

- (void)eventViewTap:(UITapGestureRecognizer *)gesture
{
    if(!self.enabled)
        return;
    NSSet *set = [self allTargets];
    if(set != nil && set.allObjects != nil && set.allObjects.count > 0)
    {
        id target = [set.allObjects objectAtIndex:0];
        NSArray *array = [self actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
        if(array != nil && array.count > 0 && !self.hidden)
        {
            [target performSelectorOnMainThread:NSSelectorFromString([array objectAtIndex:0]) withObject:self waitUntilDone:NO];
        }
    }
}

@end

@implementation UIView (ViewExtend)

- (float)GetX
{
    return self.frame.origin.x;
}

- (float)GetY
{
    return self.frame.origin.y;
}

- (float)GetWidth
{
    return self.frame.size.width;
}

- (float)GetHeight
{
    return self.frame.size.height;
}

@end

@implementation UINavigationBar (UINavigationBarExtend)

//UIImageView *backgroundView = nil;

-(void)SetBackgroundImage:(UIImage*)image
{
    if(image!=nil)
	{
        if([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]==YES)
        {
            [self setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        }
        else
        {
            UIView* view=[self viewWithTag:9999];
            [view removeFromSuperview];
            UIImageView * backgroundView = [[UIImageView alloc] initWithImage:image];
            backgroundView.tag=9999;
            backgroundView.frame = CGRectMake(0.f, 0.f, self.frame.size.width, self.frame.size.height);
            backgroundView.autoresizingMask  = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [self insertSubview:backgroundView atIndex:0];
        }
    }
}

@end

///////////////////////////////////////////////////
#pragma mark -
@implementation UIToolbar (UIToolbarExtend)

- (id)initWithFrame:(CGRect)frame bgimage:(UIImage *)bgimage
{
    self = [super initWithFrame:frame];
    [self SetBackgroundImage:bgimage];
    return self;
}

- (void)SetBackgroundImage:(UIImage*)image
{
    NSArray* ar=self.subviews;
    for(UIView* v in ar)
    {
        if([v isKindOfClass:[NSClassFromString(@"_UIToolbarBackground") class]])
        {
            [v removeFromSuperview];
            break;
        }
    }
    UIImageView* imageview=[[UIImageView alloc]initWithImage:image];
    imageview.frame=self.bounds;
    imageview.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self addSubview:imageview];
}

@end

//////////////////////////////////////////////////////
#pragma mark -
@implementation UISearchBar (UISearchBarExtend)

- (id)initWithFrame:(CGRect)frame bgimage:(UIImage *)bgimage
{
    self = [self initWithFrame:frame];
    [self SetBackgroundImage:bgimage];
    return self;
}

- (void)SetBackgroundImage:(UIImage*)image
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if([self respondsToSelector:@selector(barTintColor)])
    {
        float iosversion7_1 = 7.1;
        if(version >= iosversion7_1)
        {
            [[[[self.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
            [self setBackgroundColor:[UIColor clearColor]];
        }
        else
        {
            [self setBarTintColor:[UIColor clearColor]];
            [self setBackgroundColor:[UIColor clearColor]];
        }
    }
    else
    {
        [[self.subviews objectAtIndex:0] removeFromSuperview];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    
    if(nil!=image)
    {
        UIImageView* imageview = [[UIImageView alloc]initWithImage:image];
        imageview.frame=self.bounds;
        imageview.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:imageview];
    }
    
    if([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        for(id cc in [self subviews])
        {
            for (UIView *view in [cc subviews])
            {
                if ([NSStringFromClass(view.class)                 isEqualToString:@"UINavigationButton"])
                {
                    UIButton *btn = (UIButton *)view;
                    [btn setTitle:@"取消" forState:UIControlStateNormal];
                }
            }
            
        }
    }
    else
    {
        for(id cc in [self subviews])
        {
            if([cc isKindOfClass:[UIButton class]])
            {
                UIButton *btn = (UIButton *)cc;
                [btn setTitle:@"取消"  forState:UIControlStateNormal];
            }
        }
    }
}

@end

//////////////////////////////////////////////////////
#pragma mark -
@implementation PGTransparentToolbar

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.backgroundColor=[UIColor clearColor];
    
    return self;
}

-(void)drawRect:(CGRect)rect
{
}

@end

#pragma mark -
@implementation PGUISegmentedControlExtend

- (id)initWithItems:(NSArray *)items
{
    if(self = [super initWithItems:items])
    {
        self.tintColor = [UIColor colorWithRed:65.0/255.0 green:157.0/255.0 blue:229.0/255.0 alpha:1];
        self.alpha = 0.8;
    }
    return self;
}

@end


#pragma mark -

@implementation UIImage (UIImageExtend)

- (id)initWithContentsOfResolutionIndependentFile:(NSString *)path
{
    if ( [[[UIDevice currentDevice] systemVersion] intValue] >= 4 && [[UIScreen mainScreen] scale] == 2.0 ) {
        return [self initWithCGImage:[[UIImage imageWithData:[NSData dataWithContentsOfFile:path]] CGImage] scale:2.0 orientation:UIImageOrientationUp];
    }
    return [self initWithData:[NSData dataWithContentsOfFile:path]];
}

+ (UIImage*)imageWithContentsOfResolutionIndependentFile:(NSString *)path
{
    return [[UIImage alloc] initWithContentsOfResolutionIndependentFile:path];
}

//get a thumnail
+ (UIImage *)imageFromImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
	UIGraphicsBeginImageContext(newSize);
	[image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

//get a screenshot
+ (UIImage *)imageFromView:(UIView *)targetView
{
    UIGraphicsBeginImageContextWithOptions(targetView.frame.size, NO, 0.0);
    
    [targetView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (float)CaleFitImageSize:(CGSize)oriimgsize TargetSize:(CGSize)targetimgsize Width:(float*)nInitwidth Height:(float*)nInitheight
{
	float width = 0.0;
	float height = 0.0;
	float wmul = 0.0;
	float hmul = 0.0;
	float mul = 1.0;
	float w = targetimgsize.width;
	float h = targetimgsize.height;
	CGSize imgsize = oriimgsize;
	if(imgsize.width > w)
    {
		wmul = w/imgsize.width;
        mul = wmul;
    }
	if(imgsize.height>h)
    {
		hmul = h/imgsize.height;
        mul = hmul;
    }
	if(wmul != 0.0 && 0.0 == hmul)
	{
		width = w;
		height = imgsize.height * wmul;
	}
	else if(0.0 == wmul && hmul != 0.0)
	{
		width = imgsize.width * hmul;
		height = h;
	}
	else if(0.0 != wmul && 0.0 != hmul)
	{
		mul = MIN(wmul,hmul);
		width = imgsize.width*mul;
		height = imgsize.height*mul;
	}
	else
	{
		width = imgsize.width;
		height = imgsize.height;
	}
	*nInitwidth = width;
	*nInitheight = height;
	
	return mul;
}

@end
