//
//  PopControllerAnimation.m
//  Wall-E
//
//  Created by Angle_Yan on 15/7/21.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

#import "PopControllerAnimation.h"

@implementation PopControllerAnimation

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext;
{
    return 0.5;
}

// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext;
{
    //1.获取动画的源控制器和目标控制器 源View  目标 View
    UIViewController *fromeVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    //    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *container = [transitionContext containerView];
    
    CGRect toFrame = [transitionContext finalFrameForViewController:toVC];
    
    
    //设置目标控制器的位置和透明度
    toVC.view.frame = toFrame;
    toVC.view.alpha = 0;
    
    //2.添加 toView
    [container insertSubview:toVC.view belowSubview:fromeVC.view];
    //添加的时候一定要注意顺序,这里可以添加还可以死其他的用来辅助动画的控件。
    
    
    //3.动画效果
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        toVC.view.alpha = 1;
    } completion:^(BOOL finished) {
        
        //动画结束之后一定记得
        [transitionContext completeTransition:YES];
    }];
    
}
@end
