//
//  YLYDrawerViewAnimatiorManger.h
//  YLYDrawerViewController
//
//  Created by Angle_Yan on 15/7/10.
//  Copyright (c) 2015年 JuRongWeiYe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DrawerSide) {
    DrawerSideNone = 0,
    DrawerSideLeft,
    DrawerSideRight
};

typedef NS_ENUM(NSInteger, DrawerAnimationType){
    DrawerAnimationTypeNone,
    DrawerAnimationTypeSlide,
    DrawerAnimationTypeSlideAndScale,
    DrawerAnimationTypeSwingingDoor,
    DrawerAnimationTypeParallax,
};

typedef NS_OPTIONS(NSInteger, OpenDrawerGestureMode) {
    OpenDrawerGestureModeNone                     = 0,
    OpenDrawerGestureModePanningNavigationBar     = 1 << 1,
    OpenDrawerGestureModePanningCenterView        = 1 << 2,
    OpenDrawerGestureModeBezelPanningCenterView   = 1 << 3,
    OpenDrawerGestureModeAll                      =   OpenDrawerGestureModePanningNavigationBar |
    OpenDrawerGestureModePanningCenterView    |
    OpenDrawerGestureModeBezelPanningCenterView,
};

typedef NS_OPTIONS(NSInteger, CloseDrawerGestureMode) {
    CloseDrawerGestureModeNone                    = 0,
    CloseDrawerGestureModePanningNavigationBar    = 1 << 1,
    CloseDrawerGestureModePanningCenterView       = 1 << 2,
    CloseDrawerGestureModeBezelPanningCenterView  = 1 << 3,
    CloseDrawerGestureModeTapNavigationBar        = 1 << 4,
    CloseDrawerGestureModeTapCenterView           = 1 << 5,
    CloseDrawerGestureModePanningDrawerView       = 1 << 6,
    CloseDrawerGestureModeAll                     =   CloseDrawerGestureModePanningNavigationBar    |
    CloseDrawerGestureModePanningCenterView       |
    CloseDrawerGestureModeBezelPanningCenterView  |
    CloseDrawerGestureModeTapNavigationBar        |
    CloseDrawerGestureModeTapCenterView           |
    CloseDrawerGestureModePanningDrawerView,
};

typedef NS_ENUM(NSInteger, DrawerOpenCenterInteractionMode) {
    DrawerOpenCenterInteractionModeNone,
    DrawerOpenCenterInteractionModeFull,
    DrawerOpenCenterInteractionModeNavigationBarOnly,
};


@interface YLYDrawerViewAnimatiorManger : NSObject

@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, assign) NSTimeInterval animationDelay;
@property (nonatomic, assign) CGFloat springDamping;
@property (nonatomic, assign) CGFloat initialSpringVelocity;


- (void)presentationWithSide:(DrawerSide)drawerSide sideView:(UIView *)sideView
                  centerView:(UIView *)centerView animated:(BOOL)animated completion:(void(^)(BOOL finished))completion;

- (void)dismissWithSide:(DrawerSide)drawerSide sideView:(UIView *)sideView
             centerView:(UIView *)centerView animated:(BOOL)animated completion:(void(^)(BOOL finished))completion;

- (void)willRotateOpenDrawerWithOpenSide:(DrawerSide)drawerSide sideView:(UIView *)sideView centerView:(UIView *)centerView;


- (void)didRotateOpenDrawerWithOpenSide:(DrawerSide)drawerSide sideView:(UIView *)sideView centerView:(UIView *)centerView;



@end
