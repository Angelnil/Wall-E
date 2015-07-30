//
//  CustomTabBarViewController.h
//  YLY11_10
//
//  Created by 严林燕 on 14/11/17.
//  Copyright (c) 2014年 严林燕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabbarView.h"

@interface CustomTabBarViewController : UITabBarController

@property (assign , nonatomic) BOOL isCustomTabbar;

@property (strong , nonatomic) CustomTabbarView *tabarView;

- (id)initCustomeTabBarViewControllerWithIsCustomeTabbar:(BOOL)isCustome;

@end
