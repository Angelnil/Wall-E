//
//  BaseViewController.h
//  Wall-E
//
//  Created by Angle_Yan on 15/3/24.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WeakSelfType __weak __typeof(&*self)

@interface BaseViewController : UIViewController
{
    
}

@property(nonatomic, strong) UIStoryboard *storyBoard;
@property(nonatomic, strong) NSDictionary *params; //显示该视图控制器的时候传入的参数




#pragma mark - push & pop viewcontroller
- (UIViewController *)pushViewController:(NSString *)className;
- (UIViewController *)pushViewController:(NSString *)className withParams:(NSDictionary *)paramDict;
//返回上一级，最多到根
- (UIViewController *)popViewController;
//返回上一级，直到dismiss
- (UIViewController *)backViewController;
//返回到根
- (UIViewController *)popToRootViewController;


#pragma mark - present & dismiss viewcontroller
- (UIViewController *)presentViewController:(NSString *)className;
- (UIViewController *)presentViewController:(NSString *)className withParams:(NSDictionary *)paramDict;
//dismiss on navigationbar（只有在自定义navigationbar上的按钮事件时采用该方法）
- (void)dismissOnPresentedViewController;
//dismiss on presenting（通常情况下用该方法）
- (void)dismissOnPresentingViewController;



#pragma mark -




@end
