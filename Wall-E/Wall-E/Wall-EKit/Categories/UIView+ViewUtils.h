//
//  UIView+ViewUtils.h
//  Wall-E
//
//  Created by Angle_Yan on 15/6/3.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ViewUtils)
@end


@interface UIView (BorderLine)

typedef enum {
    CHEdgeOrientationTop,
    CHEdgeOrientationLeft,
    CHEdgeOrientationBottom,
    CHEdgeOrientationRight
} CHEdgeOrientation;

- (void)setBorderLineColor:(UIColor *)aColor;
- (void)setBorderLineColor:(UIColor *)aColor edgeOrientation:(CHEdgeOrientation)orientation;
- (void)setBorderLineColor:(UIColor *)aColor edgeOrientation:(CHEdgeOrientation)orientation frame:(CGRect)aFrame;

@end