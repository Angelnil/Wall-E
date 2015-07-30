//
//  YLYDrawerViewController.m
//  YLYDrawerViewController
//
//  Created by Angle_Yan on 15/7/10.
//  Copyright (c) 2015年 JuRongWeiYe. All rights reserved.
//

#import "YLYDrawerViewController.h"
#import "YLYDrawerView.h"

@interface YLYDrawerViewController ()

@property (nonatomic ,weak) YLYDrawerView *drawerView;
@property (nonatomic, assign) DrawerSide currentlyOpenedSide;
@property (nonatomic ,weak) YLYDrawerViewAnimatiorManger *animatiorManger;

@end

@implementation YLYDrawerViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUP];
    }
    return self;
}

- (void)setUP {
    YLYDrawerView *drawerView = [[YLYDrawerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.drawerView = drawerView;
    self.view = self.drawerView;
    
    YLYDrawerViewAnimatiorManger *animatiorManger = [[YLYDrawerViewAnimatiorManger alloc] init];
    self.animatiorManger = animatiorManger;
}

#pragma mark -- 设置 center left right
- (void)setCenterViewController:(UIViewController *)centerViewController {
    if (_centerViewController) {
        _centerViewController = nil;
    }
    _centerViewController = centerViewController;
    [self addChildViewController:_centerViewController];
    self.drawerView.centerViewContainer = _centerViewController.view;
}

- (void)setLeftViewController:(UIViewController *)leftViewController {
    if (_leftViewController) {
        _leftViewController = nil;
    }
    _leftViewController = leftViewController;
    [self addChildViewController:_leftViewController];
    self.drawerView.leftViewContainer = _leftViewController.view;
}

- (void)setRightViewController:(UIViewController *)rightViewController {
    if (_rightViewController) {
        _rightViewController = nil;
    }
    _rightViewController = rightViewController;
    [self addChildViewController:_rightViewController];
    self.drawerView.rightViewContainer = _rightViewController.view;
}

#pragma mark -- 设置左右界面的宽度
- (void)setLeftDrawerWidth:(CGFloat)leftDrawerWidth {
    self.drawerView.leftViewContainerWidth = leftDrawerWidth;
}

- (CGFloat)leftDrawerWidth {
    return self.drawerView.leftViewContainerWidth;
}

- (void)setRightDrawerWidth:(CGFloat)rightDrawerWidth {
    self.drawerView.rightViewContainerWidth = rightDrawerWidth;
}

-(CGFloat)rightDrawerWidth {
    return self.drawerView.rightViewContainerWidth;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Interaction

- (void)openDrawerWithSide:(DrawerSide)drawerSide animated:(BOOL)animated completion:(void(^)(BOOL finished))completion {
    if(self.currentlyOpenedSide != drawerSide) {
        UIView *sideView   = [self.drawerView viewContainerForDrawerSide:drawerSide];
        UIView *centerView = self.drawerView.centerViewContainer;
        
        // First close opened drawer and then open new drawer
        if(self.currentlyOpenedSide != DrawerSideNone) {
            [self closeDrawerWithSide:self.currentlyOpenedSide animated:animated completion:^(BOOL finished) {
                [self.animatiorManger presentationWithSide:drawerSide sideView:sideView centerView:centerView animated:animated completion:completion];
            }];
        } else {
            [self.animatiorManger presentationWithSide:drawerSide sideView:sideView centerView:centerView animated:animated completion:completion];
        }
        [self.drawerView willOpenFloatingDrawerViewController:DrawerSideNone];
    }
    self.currentlyOpenedSide = drawerSide;
}

- (void)closeDrawerWithSide:(DrawerSide)drawerSide animated:(BOOL)animated completion:(void(^)(BOOL finished))completion {
    if(self.currentlyOpenedSide == drawerSide && self.currentlyOpenedSide != DrawerSideNone) {
        UIView *sideView   = [self.drawerView viewContainerForDrawerSide:drawerSide];
        UIView *centerView = self.drawerView.centerViewContainer;
        
        [self.animatiorManger dismissWithSide:drawerSide sideView:sideView centerView:centerView animated:animated completion:completion];
        self.currentlyOpenedSide = DrawerSideNone;
        [self.drawerView willCloseFloatingDrawerViewController:DrawerSideNone];
    }
}

- (void)toggleDrawerWithSide:(DrawerSide)drawerSide animated:(BOOL)animated completion:(void(^)(BOOL finished))completion {
    if(drawerSide != DrawerSideNone) {
        if(drawerSide == self.currentlyOpenedSide) {
            [self closeDrawerWithSide:drawerSide animated:animated completion:completion];
        } else {
            [self openDrawerWithSide:drawerSide animated:animated completion:completion];
        }
    }
}

/*
#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    CGPoint point = [touch locationInView:self.view];
    
    if(self.currentlyOpenedSide == DrawerSideNone){
        OpenDrawerGestureMode possibleOpenGestureModes = [self possibleOpenGestureModesForGestureRecognizer:gestureRecognizer
                                                                                               withTouchPoint:point];
        return ((self.openDrawerGestureModeMask & possibleOpenGestureModes)>0);
    }
    else{
        CloseDrawerGestureMode possibleCloseGestureModes = [self possibleCloseGestureModesForGestureRecognizer:gestureRecognizer
                                                                                                  withTouchPoint:point];
        return ((self.closeDrawerGestureModeMask & possibleCloseGestureModes)>0);
    }
}


#pragma mark Gesture Recogizner Delegate Helpers
-(CloseDrawerGestureMode)possibleCloseGestureModesForGestureRecognizer:(UIGestureRecognizer*)gestureRecognizer withTouchPoint:(CGPoint)point{
    CloseDrawerGestureMode possibleCloseGestureModes = CloseDrawerGestureModeNone;
    if([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]){
        if([self isPointContainedWithinNavigationRect:point]){
            possibleCloseGestureModes |= CloseDrawerGestureModeTapNavigationBar;
        }
        if([self isPointContainedWithinCenterViewContentRect:point]){
            possibleCloseGestureModes |= CloseDrawerGestureModeTapCenterView;
        }
    }
    else if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]){
        if([self isPointContainedWithinNavigationRect:point]){
            possibleCloseGestureModes |= CloseDrawerGestureModePanningNavigationBar;
        }
        if([self isPointContainedWithinCenterViewContentRect:point]){
            possibleCloseGestureModes |= CloseDrawerGestureModePanningCenterView;
        }
        if([self isPointContainedWithinBezelRect:point]){
            possibleCloseGestureModes |= CloseDrawerGestureModeBezelPanningCenterView;
        }
        if([self isPointContainedWithinCenterViewContentRect:point] == NO &&
           [self isPointContainedWithinNavigationRect:point] == NO){
            possibleCloseGestureModes |= CloseDrawerGestureModePanningDrawerView;
        }
    }
    return possibleCloseGestureModes;
}


-(OpenDrawerGestureMode)possibleOpenGestureModesForGestureRecognizer:(UIGestureRecognizer*)gestureRecognizer withTouchPoint:(CGPoint)point{
    OpenDrawerGestureMode possibleOpenGestureModes = OpenDrawerGestureModeNone;
    if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]){
        if([self isPointContainedWithinNavigationRect:point]){
            possibleOpenGestureModes |= OpenDrawerGestureModePanningNavigationBar;
        }
        if([self isPointContainedWithinCenterViewContentRect:point]){
            possibleOpenGestureModes |= OpenDrawerGestureModePanningCenterView;
        }
        if([self isPointContainedWithinBezelRect:point]){
            possibleOpenGestureModes |= OpenDrawerGestureModeBezelPanningCenterView;
        }
    }
    return possibleOpenGestureModes;
}


-(BOOL)isPointContainedWithinNavigationRect:(CGPoint)point{
    CGRect navigationBarRect = CGRectNull;
    if([self.centerViewController isKindOfClass:[UINavigationController class]]){
        UINavigationBar * navBar = [(UINavigationController*)self.centerViewController navigationBar];
        navigationBarRect = [navBar convertRect:navBar.frame toView:self.view];
        navigationBarRect = CGRectIntersection(navigationBarRect,self.view.bounds);
    }
    return CGRectContainsPoint(navigationBarRect,point);
}

-(BOOL)isPointContainedWithinCenterViewContentRect:(CGPoint)point{
    CGRect centerViewContentRect = self.drawerView.centerViewContainer.frame;
    centerViewContentRect = CGRectIntersection(centerViewContentRect,self.view.bounds);
    return (CGRectContainsPoint(centerViewContentRect, point) &&
            [self isPointContainedWithinNavigationRect:point] == NO);
}

-(BOOL)isPointContainedWithinBezelRect:(CGPoint)point{
    CGRect leftBezelRect;
    CGRect tempRect;
    CGRectDivide(self.view.bounds, &leftBezelRect, &tempRect, DrawerBezelRange, CGRectMinXEdge);
    
    CGRect rightBezelRect;
    CGRectDivide(self.view.bounds, &rightBezelRect, &tempRect, DrawerBezelRange, CGRectMaxXEdge);
    
    return ((CGRectContainsPoint(leftBezelRect, point) ||
             CGRectContainsPoint(rightBezelRect, point)) &&
            [self isPointContainedWithinCenterViewContentRect:point]);
}
*/


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
