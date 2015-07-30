//
//  YLYDrawerViewController.h
//  YLYDrawerViewController
//
//  Created by Angle_Yan on 15/7/10.
//  Copyright (c) 2015年 JuRongWeiYe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLYDrawerView.h"
#import "YLYDrawerViewAnimatiorManger.h"

@interface YLYDrawerViewController : UIViewController

#pragma mark - Managed View Controllers
@property (nonatomic, strong) UIViewController *centerViewController;
@property (nonatomic, strong) UIViewController *leftViewController;
@property (nonatomic, strong) UIViewController *rightViewController;

#pragma mark - Reveal Widths
@property (nonatomic, assign) CGFloat leftDrawerWidth;
@property (nonatomic, assign) CGFloat rightDrawerWidth;

#pragma mark - animation type
@property (nonatomic,assign) DrawerAnimationType leftDrawerAnimationType;
@property (nonatomic,assign) DrawerAnimationType rightDrawerAnimationType;

@property (nonatomic, assign) OpenDrawerGestureMode openDrawerGestureModeMask;
@property (nonatomic, assign) CloseDrawerGestureMode closeDrawerGestureModeMask;

#pragma mark - Interaction

@property (nonatomic, assign, getter=isDragToRevealEnabled) BOOL dragToRevealEnabled;

- (void)openDrawerWithSide:(DrawerSide)drawerSide animated:(BOOL)animated
                completion:(void(^)(BOOL finished))completion;

- (void)closeDrawerWithSide:(DrawerSide)drawerSide animated:(BOOL)animated
                 completion:(void(^)(BOOL finished))completion;

- (void)toggleDrawerWithSide:(DrawerSide)drawerSide animated:(BOOL)animated
                  completion:(void(^)(BOOL finished))completion;

@end
