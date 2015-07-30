//
//  WEBaseView.h
//  Wall-E
//
//  Created by Angle_Yan on 15/3/2.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

#import <UIKit/UIKit.h>


IB_DESIGNABLE
@interface WEBaseView : UIView
{
    CGFloat _cornerRadius;
    CGFloat _borderWidth;
    UIColor *_borderColor;
}

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

@end