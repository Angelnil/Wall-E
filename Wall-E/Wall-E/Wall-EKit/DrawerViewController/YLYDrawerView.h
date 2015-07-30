//
//  YLYDrawerView.h
//  YLYDrawerViewController
//
//  Created by Angle_Yan on 15/7/10.
//  Copyright (c) 2015年 JuRongWeiYe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLYDrawerViewAnimatiorManger.h"

@interface YLYDrawerView : UIView

/** 设置灰色透明背景 */
@property (nonatomic, strong) UIView *grayBgView;
/** 左侧的 View */
@property (nonatomic, strong) UIView *leftViewContainer;
/** 右侧的 View */
@property (nonatomic, strong) UIView *rightViewContainer;
/** 中间的 View */
@property (nonatomic, strong) UIView *centerViewContainer;


@property (nonatomic, assign) CGFloat leftViewContainerWidth;
@property (nonatomic, assign) CGFloat rightViewContainerWidth;

- (UIView *)viewContainerForDrawerSide:(DrawerSide)drawerSide;

- (void)willOpenFloatingDrawerViewController:(DrawerSide)drawerSide;
- (void)willCloseFloatingDrawerViewController:(DrawerSide)drawerSide;

@end
