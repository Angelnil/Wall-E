//
//  WEBaseView.m
//  Wall-E
//
//  Created by Angle_Yan on 15/3/2.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

#import "WEBaseView.h"

IB_DESIGNABLE
@interface WEBaseView()

@end


@implementation WEBaseView

@synthesize cornerRadius = _cornerRadius;
@synthesize borderColor = _borderColor;
@synthesize borderWidth = _borderWidth;

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = _cornerRadius;
    self.layer.masksToBounds = self.cornerRadius > 0.0;
}

-(CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = _borderColor.CGColor;
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.layer.borderWidth = _borderWidth;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}


#if TARGET_INTERFACE_BUILDER

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self propertyDefaultValues];
}

#else

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self propertyDefaultValues];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self propertyDefaultValues];
    }
    return self;
}

#endif

- (void)propertyDefaultValues {
    self.cornerRadius = 0.0;
    self.borderWidth = 0.0;
    self.borderColor = [UIColor clearColor];
    self.layer.borderWidth = self.borderWidth;
    self.layer.borderColor = self.borderColor.CGColor;
    self.layer.cornerRadius = self.cornerRadius;
    self.layer.masksToBounds = self.cornerRadius > 0.0;
}

@end



