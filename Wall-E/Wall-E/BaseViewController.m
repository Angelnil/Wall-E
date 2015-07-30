//
//  BaseViewController.m
//  Wall-E
//
//  Created by Angle_Yan on 15/3/24.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseNavigationViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - push & pop viewcontroller
- (UIViewController *)pushViewController:(NSString *)className;
{
    return [self pushViewController:className withParams:nil];
}

- (UIViewController *)pushViewController:(NSString *)className withParams:(NSDictionary *)paramDict;
{
    UIViewController *pushedVC = nil;
    //第一步：检查 storyboard 是否存在
    if (!pushedVC ) {
        @try {
            pushedVC = [self.storyBoard instantiateViewControllerWithIdentifier:className];
        }
        @catch (NSException *exception) {
            NSLog(@"class[%@] is not found in %@ storyboard!", className,self.storyBoard);
        }
        @finally {
        }
    }
    //第二步：如果 storyboard 没有，检测是否有class文件 同时兼容用xib布局的情况
    if (!pushedVC) {
        pushedVC = [[NSClassFromString(className) alloc] initWithNibName:nil bundle:nil];
    }
    NSAssert(pushedVC, @"class[%@] is not exists in this project!",className);
    
    //设置传递的内容
    if ([pushedVC isKindOfClass:[BaseViewController class]]) {
        [(BaseViewController *)pushedVC setParams:[NSDictionary dictionaryWithDictionary:paramDict]];
    }
    [self hideKeyboard];
    [self.navigationController pushViewController:pushedVC animated:YES];
    return pushedVC;
}

/*
 * 返回上一层(最多到根)
 * 都是针对在presenting出来的viewController上操作pop，不是在presented上操作pop
 */
- (UIViewController *)popViewController;
{
    if (self.navigationController) {
        //有 navigation
        NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
        UIViewController *popVC = [self.navigationController.viewControllers objectAtIndex:MAX(index-1, 0)];
        [self.navigationController popViewControllerAnimated:YES];
        return popVC;
    } else {
        //没有航导航栏
        UIViewController *presentingVC = self.presentingViewController;//当前呈现的 VC
        [presentingVC dismissViewControllerAnimated:YES completion:nil];
        return presentingVC;
    }
}

/**
 * 返回上一层(自动dismiss根)
 * 都是针对在presenting出来的viewController上操作pop，不是在presented上操作pop
 */
- (UIViewController *)backViewController;
{
    if (self.navigationController) {
        NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
        if (index > 0) {
            UIViewController *popVC = [self.navigationController.viewControllers objectAtIndex:MAX(index-1, 0)];
            [self.navigationController popViewControllerAnimated:YES];
            return popVC;
        } else {
            //已经是根了，自动移除
            UIViewController *dismissVC = self.presentingViewController;
            [dismissVC dismissViewControllerAnimated:YES completion:nil];
            return dismissVC;
        }
    } else {
        //没有 navigation
        UIViewController *dismissVC = self.presentingViewController;
        [dismissVC dismissViewControllerAnimated:YES completion:nil];
        return dismissVC;
    }
}

//返回到根
- (UIViewController *)popToRootViewController;
{
    //有 navigation
    UIViewController *popVC = [self.navigationController.viewControllers objectAtIndex:0];
    [self.navigationController popToRootViewControllerAnimated:YES];
    return popVC;
}


#pragma mark - present & dismiss viewcontroller
- (UIViewController *)presentViewController:(NSString *)className;
{
    return [self presentViewController:className withParams:nil];
}
- (UIViewController *)presentViewController:(NSString *)className withParams:(NSDictionary *)paramDict;
{
    UIViewController *presentVC = nil;
    //检查 storyboard 是否存在
    if (self.storyBoard) {
        @try {
            presentVC = [self.storyBoard instantiateViewControllerWithIdentifier:className];
        }
        @catch (NSException *exception) {
            NSLog(@"class[%@] is not found in %@ storyboard!", className,self.storyBoard);
        }
        @finally {
        }
    }
    if (!presentVC) {
        //第二步：如果 storyboard 没有，检测是否有class文件 同时兼容用xib布局的情况
        presentVC = [[NSClassFromString(className) alloc] initWithNibName:nil bundle:nil];
    }
    NSAssert(presentVC, @"class[%@] is not exists in this project!",className);
    
    
    //创建导航栏
    BaseNavigationViewController *navigation = [[BaseNavigationViewController alloc] initWithRootViewController:presentVC];
    
    [self presentViewController:navigation animated:YES completion:nil];
    return presentVC;
}

//dismiss on navigationbar（只有在自定义navigationbar上的按钮事件时采用该方法）
- (void)dismissOnPresentedViewController;
{
    UIViewController *presentedVC = self.presentedViewController;
    [presentedVC dismissViewControllerAnimated:YES completion:nil];
}
//dismiss on presenting（通常情况下用该方法）
- (void)dismissOnPresentingViewController;
{
    UIViewController *presentingVC = self.presentingViewController;
    [presentingVC dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - 弹出框



- (void)hideKeyboard {
    [self.view endEditing:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
