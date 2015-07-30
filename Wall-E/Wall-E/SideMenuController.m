//
//  SideMenuController.m
//  YLY11_10
//
//  Created by 严林燕 on 14/11/14.
//  Copyright (c) 2014年 严林燕. All rights reserved.
//

#import "SideMenuController.h"

@interface SideMenuController ()<UIGestureRecognizerDelegate>
{
    float _leftViewShowWight;
    float _animationDuration;//动画时间
    BOOL _showBoundsShadow;
    
    CGPoint _startPanPoint;
    CGPoint _lastPanPoint;
    BOOL _panMovingRightOrLeft;
    
    UIButton *_coverButton;//左侧的按钮🔘
    
}

//
@property (strong, nonatomic) UIPanGestureRecognizer *pan;


@end

@implementation SideMenuController

//自定义getter setter 方法
@dynamic needSwipeShowMenu;
@dynamic leftVC ;
@dynamic rootVC ;

- (void)setNeedSwipeShowMenu:(BOOL)needSwipeShowMenu
{
    _needSwipeShowMenu = needSwipeShowMenu;
    if (_needSwipeShowMenu) {
        [self.view addGestureRecognizer:self.pan];
    } else {
        [self.view removeGestureRecognizer:self.pan];
    }
}
- (BOOL)needSwipeShowMenu {
    return self.needSwipeShowMenu;
}

- (void)setLeftVC:(UIViewController *)leftVC
{
    if (_leftVC != leftVC) {
        _leftVC = leftVC;
        _leftVC.view.frame = self.view.bounds;
        [self.view insertSubview:_leftVC.view atIndex:1];
    }
}

- (UIViewController *)leftVC
{
    return self.leftVC;
}

- (void)setRootVC:(CustomTabBarViewController *)rootVC
{
    if (_rootVC != rootVC) {
        _rootVC = rootVC;
        _rootVC.view.frame = self.view.bounds;
        [self.view addSubview:_rootVC.view];
    }
    
}
- (UIViewController *)rootVC
{
    return  self.rootVC;
}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initData];
        
    }
    return self;
}


- (void)initData {
    _leftViewShowWight = 267;
    _animationDuration = 0.35;
    _showBoundsShadow = false;
    
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAnimation:)];
    self.pan.delegate = self;
    _panMovingRightOrLeft = false;//ture 为右滑，即letfVC 出现
    
    _startPanPoint = CGPointZero;
    _coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _coverButton.frame = [UIScreen mainScreen].bounds;
    [_coverButton addTarget:self action:@selector(buttonClickHideSideViewController) forControlEvents:UIControlEventTouchUpInside];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    [self.view insertSubview:imageView atIndex:0];
    self.needSwipeShowMenu = true;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
}


- (void)shawShadows:(BOOL )show {
    self.rootVC.view.layer.shadowOpacity = show ? 0.8 : 0.0;
    if (show) {
        self.rootVC.view.layer.cornerRadius = 4.0;
        self.rootVC.view.layer.shadowOffset = CGSizeZero;
        self.rootVC.view.layer.shadowRadius = 4.0;
        self.rootVC.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.rootVC.view.bounds].CGPath;
    }
}


- (void)showLeftViewController:(BOOL )animation {
    
    float animationTime = 0;
    if (animation) {
        animationTime = abs(_leftViewShowWight - self.rootVC.view.frame.origin.x) / _leftViewShowWight * _animationDuration;
    }
    [UIView animateWithDuration:animationTime animations:^{
        [self layoutCurrentViewWithOffset:_leftViewShowWight];
        [self.rootVC.view addSubview:_coverButton];
        [self shawShadows:_showBoundsShadow];

        
    } completion:^(BOOL finished) {
        
    }];

    
}

- (void)hideSideViewController:(BOOL )animation {
    
//    [self.rootVC showOrhideToolbar:ture];
    [self shawShadows:false];
    float animationTime = 0;
    if (animation) {
        animationTime = abs(self.rootVC.view.frame.origin.x / _leftViewShowWight) * _animationDuration;
    }
    [UIView animateWithDuration:animationTime animations:^{
        [self layoutCurrentViewWithOffset:0];
    } completion:^(BOOL finished) {
        [_coverButton removeFromSuperview];
    }];
    
}


- (void)layoutCurrentViewWithOffset:(CGFloat)xoffset {
    if (_showBoundsShadow) {
        self.rootVC.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.rootVC.view.bounds].CGPath;
    }
    
    float scale = abs(600 - abs(xoffset))/600;
    scale = MAX(scale, 0.8);
    self.rootVC.view.transform = CGAffineTransformMakeScale(scale, scale);
    float totalWidth = self.view.frame.size.width;
    float totalHeight = self.view.frame.size.height;
    if (xoffset > 0) {//右滑，即出现侧边栏
        self.rootVC.view.frame = CGRectMake(xoffset,self.view.bounds.origin.y + (totalHeight * (1 - scale) / 2), totalWidth * scale, totalHeight * scale);
    } else {//做滑，侧边栏下消失
        self.rootVC.view.frame = CGRectMake(self.view.frame.size.width * (1 - scale) + xoffset, self.view.bounds.origin.y + (totalHeight*(1 - scale) / 2), totalWidth * scale, totalHeight * scale);
    }
    
}

- (void)buttonClickHideSideViewController {
    [self hideSideViewController:true];
}


- (void)panAnimation:(UIPanGestureRecognizer *)sender {
    if (self.pan.state == UIGestureRecognizerStateBegan) {
        //    [self.rootVC showOrhideToolbar:ture];
        _startPanPoint = self.rootVC.view.frame.origin;
        if (self.rootVC.view.frame.origin.x == 0) {
            [self shawShadows:_showBoundsShadow];
        }
        return ;
    }
    CGPoint currentPoint = [self.pan translationInView:self.view];
    float xoffSet = _startPanPoint.x + currentPoint.x;
    if (xoffSet > 0) { //右滑 侧边栏
        if (self.leftVC != nil) {
            if (self.leftVC.view.superview != nil) {
                xoffSet = xoffSet > _leftViewShowWight ? _leftViewShowWight : xoffSet;
            }
        } else {
            xoffSet = 0;
        }
    } else if (xoffSet < 0) {//做滑，
        xoffSet = 0;
    }
    
    if (xoffSet !=  self.rootVC.view.frame.origin.x) {
        [self layoutCurrentViewWithOffset:xoffSet];
    }
    
    if (self.pan.state == UIGestureRecognizerStateEnded) {
        if (self.rootVC.view.frame.origin.x != 0 && self.rootVC.view.frame.origin.x != _leftViewShowWight) {
            if( (_startPanPoint.x < currentPoint.x) && self.rootVC.view.frame.origin.x>20 ){
                [self showLeftViewController:true];
            }else{
                [self buttonClickHideSideViewController];
            }
        } else if (self.rootVC.view.frame.origin.x == 0) {
            [self shawShadows:false];
        }
        _lastPanPoint = CGPointZero;
    } else {
        CGPoint velocity = [self.pan velocityInView:self.view];
        if (velocity.x > 0) {
            _panMovingRightOrLeft = true;
        }else if (velocity.x < 0) {
            _panMovingRightOrLeft = false;
        }
    }
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
