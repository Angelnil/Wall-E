//
//  UIScrollView+ScrollViewTouches.m
//  YLY11_10
//
//  Created by angelnil on 14/12/23.
//  Copyright (c) 2014年 严林燕. All rights reserved.
//

#import "UIScrollView+ScrollViewTouches.h"

@implementation UIScrollView (ScrollViewTouches)

#pragma mark -- 重写Touch方法
//语句[[self nextResponder] touchesBegan:touches withEvent:event]是对touchesBegan方法的行为响应，就是在UIScrollView中调用touchesBegan方法可使重写方法中的tochesBegan响应。
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (!self.dragging) {
        [[self nextResponder] touchesBegan:touches withEvent:event];
    }
}

//touchesMoved和touchesEnded的道理是一样的。
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if (!self.dragging) {
        [[self nextResponder] touchesEnded:touches withEvent:event];
    }
}


@end
