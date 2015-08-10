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
    
    //2.创建一个 Cell 中 imageView 的截图，并把 imageView 隐藏，造成使用户以为移动的就是 imageView 的假象
    CGRect toFrame = [transitionContext finalFrameForViewController:toVC];
    UIView *imageSnapshot = [fromeVC.selectCell.imageView snapshotViewAfterScreenUpdates:NO];
    imageSnapshot.frame = [container convertRect:fromeVC.selectCell.imageView.frame fromView:fromeVC.selectCell];
    
    //3.设置目标控制器的位置o，并把透明度设为0，在后面的动画中慢慢显示出来变为1
    toVC.view.frame = toFrame;
    toVC.view.alpha = 0;
    fromeVC.selectCell.imageView.hidden = YES;
    
    //4.都添加到 container 中。注意顺序不能错了
    [container addSubview:toVC.view];
    //添加的时候一定要注意顺序,这里可以添加还可以死其他的用来辅助动画的控件。
    [container addSubview:imageSnapshot];
    
    //5.执行动画
    /*
     这时avatarImageView.frame的值只是跟在IB中一样的，
     如果换成屏幕尺寸不同的模拟器运行时avatarImageView会先移动到IB中的frame,动画结束后才会突然变成正确的frame。
     所以需要在动画执行前执行一次toVC.avatarImageView.layoutIfNeeded() update一次frame
     */
    [toVC.imageView layoutIfNeeded];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        imageSnapshot.frame = toVC.imageView.frame;
        toVC.view.alpha = 1;
    } completion:^(BOOL finished) {
        toVC.imageView.image = toVC.image;
        fromeVC.selectCell.imageView.hidden = NO;
        
        [imageSnapshot removeFromSuperview];
        //一定要记得动画完成后执行此方法，让系统管理 navigation
        [transitionContext completeTransition:YES];
    }];
}

@end
