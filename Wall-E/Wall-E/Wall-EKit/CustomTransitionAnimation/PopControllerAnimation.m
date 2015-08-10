//
//  PopControllerAnimation.m
//  Wall-E
//
//  Created by Angle_Yan on 15/7/21.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

#import "PopControllerAnimation.h"
#import "ONeCollectionViewController.h"
#import "OneDetialViewController.h"


@implementation PopControllerAnimation

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext;
{
    return 0.5;
}

// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext;
{
    //1.获取动画的源控制器和目标控制器 源View  目标 View
    OneDetialViewController *fromeVC = (OneDetialViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    ONeCollectionViewController *toVC = (ONeCollectionViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
//    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
//    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *container = [transitionContext containerView];
    
    //2.创建一个 Cell 中 imageView 的截图，并把 imageView 隐藏，造成使用户以为移动的就是 imageView 的假象
    CGRect toFrame = [transitionContext finalFrameForViewController:toVC];
    UIView *imageSnapshot = [fromeVC.imageView snapshotViewAfterScreenUpdates:NO];
    imageSnapshot.frame = [container convertRect:fromeVC.imageView.frame fromView:fromeVC.view];

    //设置目标控制器的位置和透明度
    toVC.view.frame = toFrame;
    fromeVC.imageView.hidden = YES;
    toVC.selectCell.imageView.hidden = YES;
    
    //2.添加 toView
    [container insertSubview:toVC.view belowSubview:fromeVC.view];
    //添加的时候一定要注意顺序,这里可以添加还可以死其他的用来辅助动画的控件。
    [container addSubview:imageSnapshot];
    
    //3.动画效果
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromeVC.view.alpha = 0;
        imageSnapshot.frame = [container convertRect:toVC.selectCell.imageView.frame fromView:toVC.selectCell];
    } completion:^(BOOL finished) {
        fromeVC.view.alpha = 1;
        toVC.selectCell.imageView.hidden = NO;
        fromeVC.imageView.hidden = NO;
        [imageSnapshot removeFromSuperview];
        //动画结束之后一定记得 如果涉及到重写边界手势返回的方法，这个地方一定不能写 yes 因为手势涉及到取消
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}
@end
