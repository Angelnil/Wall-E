//
//  NBluePageControl.m
//  TaiPingLift
//
//  Created by nyezz on 14-6-10.
//  Copyright (c) 2014年 Yanlinyan. All rights reserved.
//

#import "NBluePageControl.h"

@implementation NBluePageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self loadingUiInterface];
    }
    return self;
}

#pragma mark -- 初始化用户界面
- (void)loadingUiInterface
{
    //设置页数指示点显示颜色
    self.pageIndicatorTintColor = [UIColor colorWithRed:128/255.0 green:190/255.0 blue:231/255.0 alpha:1];
    self.currentPageIndicatorTintColor = [UIColor colorWithRed:0/255.0 green:77/255.0 blue:163/255.0 alpha:1];
    //设置不可点击
    self.userInteractionEnabled = NO;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
