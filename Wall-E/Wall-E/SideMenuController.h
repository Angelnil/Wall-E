//
//  SideMenuController.h
//  YLY11_10
//
//  Created by 严林燕 on 14/11/14.
//  Copyright (c) 2014年 严林燕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBarViewController.h"


@interface SideMenuController : UIViewController
{
    BOOL _needSwipeShowMenu;
    UIViewController *_leftVC;
    CustomTabBarViewController *_rootVC;
}

@property (assign, nonatomic) BOOL needSwipeShowMenu;
@property (strong, nonatomic) UIViewController *leftVC;
@property (strong, nonatomic) CustomTabBarViewController *rootVC;

@end
