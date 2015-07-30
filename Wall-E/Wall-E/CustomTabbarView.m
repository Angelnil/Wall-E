//
//  CustomTabbarView.m
//  YLY11_10
//
//  Created by angelnil on 14/12/19.
//  Copyright (c) 2014年 严林燕. All rights reserved.
//

#import "CustomTabbarView.h"

#define ItemNum 4

@implementation CustomTabbarView

- (id)initTabbarViewWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray defatImageArray:(NSArray *)defatImageArray selectImageArray:(NSArray *)selectImageArray;
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customeTabbarSetUI];
    }
    return self;
}


- (void)customeTabbarSetUI {
    
}


@end
