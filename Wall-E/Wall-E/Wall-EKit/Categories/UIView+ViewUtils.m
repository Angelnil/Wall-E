//
//  UIView+ViewUtils.m
//  Wall-E
//
//  Created by Angle_Yan on 15/6/3.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

#import "UIView+ViewUtils.h"

@implementation UIView (ViewUtils)

@end



@implementation UIView (BorderLine)
#define LineBorderWidth 0.5
#define kColorDigit (213 / 255)
#define BorderLineGrayColor [UIColor colorWithRed:kColorDigit green:kColorDigit blue:kColorDigit alpha:kColorDigit]

- (void)setBorderLineColor:(UIColor *)aColor {
    if (aColor == nil) {
        aColor = BorderLineGrayColor;
    }
    [self setBorderLineColor:aColor edgeOrientation:CHEdgeOrientationBottom];
    [self setBorderLineColor:aColor edgeOrientation:CHEdgeOrientationTop];
    [self setBorderLineColor:aColor edgeOrientation:CHEdgeOrientationLeft];
    [self setBorderLineColor:aColor edgeOrientation:CHEdgeOrientationRight];
}

- (void)setBorderLineColor:(UIColor *)aColor
           edgeOrientation:(CHEdgeOrientation)orientation {
    [self setBorderLineColor:aColor edgeOrientation:orientation frame:self.bounds];
}

- (void)setBorderLineColor:(UIColor *)aColor edgeOrientation:(CHEdgeOrientation)orientation frame:(CGRect)aFrame
{
    CALayer *line = [[CALayer alloc] init];
    line.backgroundColor = aColor.CGColor;
    
    CGRect lineFrame = CGRectZero;
    if (CHEdgeOrientationTop == orientation) {
        // 上边加线
        lineFrame = CGRectMake(CGRectGetMinX(aFrame),
                               CGRectGetMinY(aFrame),
                               CGRectGetWidth(aFrame),
                               LineBorderWidth);
    } else if (CHEdgeOrientationLeft == orientation) {
        // 左边加线
        lineFrame = CGRectMake(CGRectGetMinX(aFrame),
                               CGRectGetMinY(aFrame),
                               LineBorderWidth,
                               CGRectGetHeight(aFrame));
    } else if (CHEdgeOrientationBottom == orientation) {
        // 底边加线
        lineFrame = CGRectMake(CGRectGetMinX(aFrame),
                               CGRectGetMaxY(aFrame) + LineBorderWidth,
                               CGRectGetWidth(aFrame),
                               LineBorderWidth);
    } else {
        // 右边加线
        lineFrame = CGRectMake(CGRectGetMaxX(aFrame) - LineBorderWidth,
                               CGRectGetMinY(aFrame),
                               LineBorderWidth,
                               CGRectGetHeight(aFrame));
    }
    line.frame = lineFrame;
    [self.layer addSublayer:line];
}



//更新
- (void)layoutSubviews {
    NSArray *layerArray = self.layer.sublayers;
    for (CALayer *lineLayer in layerArray) {
        CGRect frame = lineLayer.frame;
        if (frame.size.width == LineBorderWidth) {
            //只可能是左右的线条
            if (frame.origin.x == CGRectGetMinX(self.bounds)) {
                //左边的
                frame = CGRectMake(CGRectGetMinX(self.bounds),
                                       CGRectGetMinY(self.bounds),
                                       LineBorderWidth,
                                       CGRectGetHeight(self.bounds));
            } else {
                //右边的
                frame = CGRectMake(CGRectGetMaxX(self.bounds) - LineBorderWidth,
                                   CGRectGetMinY(self.bounds),
                                   LineBorderWidth,
                                   CGRectGetHeight(self.bounds));
            }
        }
        if (frame.size.height == LineBorderWidth){
            //上下的线条
            if (frame.origin.y == CGRectGetMinY(self.bounds)) {
                //上边的
                frame = CGRectMake(CGRectGetMinX(self.bounds),
                                       CGRectGetMinY(self.bounds),
                                       CGRectGetWidth(self.bounds),
                                       LineBorderWidth);
            } else {
                //下边的
                frame = CGRectMake(CGRectGetMinX(self.bounds),
                                   CGRectGetMaxY(self.bounds) + LineBorderWidth,
                                   CGRectGetWidth(self.bounds),
                                   LineBorderWidth);
            }
        }
        lineLayer.frame = frame;
    }
}

@end