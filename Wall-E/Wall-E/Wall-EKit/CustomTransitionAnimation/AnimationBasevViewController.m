//
//  AnimationBasevViewController.m
//  Wall-E
//
//  Created by Angle_Yan on 15/8/4.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

#import "AnimationBasevViewController.h"
#import "PushControllerAnimation.h"
#import "PopControllerAnimation.h"



@interface AnimationBasevViewController ()

/** 边界手势滑动 */
@property (nonatomic, weak) UIPercentDrivenInteractiveTransition *percentTransition;

@end

@implementation AnimationBasevViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;
    
    UIScreenEdgePanGestureRecognizer *edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    edgePan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgePan];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


#pragma mark - Navigation
- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer *)panGes {
    
    CGFloat progress = [panGes translationInView:self.view].x / self.view.bounds.size.width;
    if (panGes.state == UIGestureRecognizerStateBegan) {
        UIPercentDrivenInteractiveTransition *tempPercent = [[UIPercentDrivenInteractiveTransition alloc] init];
        self.percentTransition = tempPercent;
        [self.navigationController popViewControllerAnimated:YES];
    } else if (panGes.state == UIGestureRecognizerStateChanged) {
        [self.percentTransition updateInteractiveTransition:progress];
    } else if (panGes.state == UIGestureRecognizerStateEnded || panGes.state == UIGestureRecognizerStateCancelled ) {
        if (progress > 0.5) {
            [self.percentTransition finishInteractiveTransition];
        } else {
            [self.percentTransition cancelInteractiveTransition];
        }
        self.percentTransition = nil;
    }
}

 
 - (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
     
     if (operation == UINavigationControllerOperationPush) {
     return [[PushControllerAnimation alloc] init];
     }
     if (operation == UINavigationControllerOperationPop) {
         return [[PopControllerAnimation alloc] init];
     }

     return nil;
 }

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if ([animationController isKindOfClass:[PopControllerAnimation class]]) {
        return self.percentTransition;
    }
    return nil;
}


@end
