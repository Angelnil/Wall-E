//
//  PushControllerAnimation.m
//  Wall-E
//
//  Created by Angle_Yan on 15/7/21.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

#import "PushControllerAnimation.h"
#import "ONeCollectionViewController.h"
#import "OneDetialViewController.h"

@implementation PushControllerAnimation

// This is used for percent driven interactive transitions, as well as for container controllers that have companion animations that might need to
// synchronize with the main animation.
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext;
{
    return 0.5;
}

// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext;
{
    //1.获取动画的源控制器和目标控制器 源View  目标 View
    ONeCollectionViewController *fromeVC = (ONeCollectionViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    OneDetialViewController *toVC = (OneDetialViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *container = [transitionContext containerView];
    
    CGRect toFrame = [transitionContext finalFrameForViewController:toVC];
    UIView *imageSnapshot = [fromeVC.selectCell.imageView snapshotViewAfterScreenUpdates:NO];
    imageSnapshot.frame = [container convertRect:fromeVC.selectCell.imageView.frame fromView:fromeVC.selectCell];
    
    //设置目标控制器的位置和透明度
    toVC.view.frame = toFrame;
    toVC.view.alpha = 0;
    fromeVC.selectCell.imageView.hidden = YES;
    
    //2.添加 toView
    [container insertSubview:toVC.view belowSubview:fromeVC.view];
    //添加的时候一定要注意顺序,这里可以添加还可以死其他的用来辅助动画的控件。
    [container addSubview:imageSnapshot];
    
    //3.动画效果
    [toVC.imageView layoutIfNeeded];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        imageSnapshot.frame = toVC.imageView.frame;
        toVC.view.alpha = 1;
    } completion:^(BOOL finished) {
        toVC.imageView.image = toVC.image;
        [imageSnapshot removeFromSuperview];
        fromeVC.selectCell.imageView.hidden = NO;
        //动画结束之后一定记得
        [transitionContext completeTransition:YES];
    }];
}

@end
