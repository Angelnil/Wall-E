//
//  ClickLab.h
//  Wall-E
//
//  Created by Angle_Yan on 15/6/11.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClickLab : UIView

@property (nonatomic,weak) NSString *contentName;
@property (nonatomic,weak) UIColor *nameColor;


- (id)initWitfContent:(NSString *)_name AndColor:(UIColor *)_color;

@end
