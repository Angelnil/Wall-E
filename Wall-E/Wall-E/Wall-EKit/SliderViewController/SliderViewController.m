//
//  SliderViewController.m
//  LeftRightSlider
//
//  Created by heroims on 13-11-27.
//  Copyright (c) 2013年 heroims. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "SliderViewController.h"
#import <sys/utsname.h>

typedef NS_ENUM(NSInteger, RMoveDirection) {
    RMoveDirectionLeft = 0,
    RMoveDirectionRight
};

@interface SliderViewController ()<UIGestureRecognizerDelegate>{
    UIView *_mainContentView;
    UIView *_leftSideView;
    UIView *_rightSideView;
    
    NSMutableDictionary *_controllersDict;
    
    UITapGestureRecognizer *_tapGestureRec;
    UIPanGestureRecognizer *_panGestureRec;
    
    BOOL showingLeft;
    BOOL showingRight;
}

@end

@implementation SliderViewController

-(void)dealloc{
#if __has_feature(objc_arc)
    _mainContentView = nil;
    _leftSideView = nil;
    _rightSideView = nil;
    
    _controllersDict = nil;
    
    _tapGestureRec = nil;
    _panGestureRec = nil;
    
    _LeftVC = nil;
    _RightVC = nil;
    _MainVC = nil;
#else
    [_mainContentView release];
    [_leftSideView release];
    [_rightSideView release];
    
    [_controllersDict release];
    
    [_tapGestureRec release];
    [_panGestureRec release];
    
    [_LeftVC release];
    [_RightVC release];
    [_MainVC release];
    [super dealloc];
#endif

}

+ (SliderViewController*)sharedSliderController
{
    static SliderViewController *sharedSVC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSVC = [[self alloc] init];
    });
    
    return sharedSVC;
}

- (id)initWithCoder:(NSCoder *)decoder {
	if ((self = [super initWithCoder:decoder])) {
        [self setUp];
	}
	return self;
}

- (id)init{
    if (self = [super init]){
        [self setUp];
    }
    return self;
}

- (void)setUp {
    _LeftSContentOffset=_RightSContentOffset=180;
    _LeftSContentScale=_RightSContentScale=0.85;
    _LeftSJudgeOffset=_RightSJudgeOffset=100;
    _LeftSOpenDuration=_RightSOpenDuration=0.4;
    _LeftSCloseDuration=_RightSCloseDuration=0.3;
    _canShowLeft=_canShowRight=YES;
    [self initSubviews];
    _controllersDict = [[NSMutableDictionary alloc] init];
}

- (void)setMainVC:(UIViewController *)MainVC {
    _MainVC = MainVC;
    _MainVC.view.frame = CGRectMake(0, 0, _MainVC.view.frame.size.width, _MainVC.view.frame.size.height);
    [_mainContentView addSubview:_MainVC.view];
    
    _tapGestureRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSideBar)];
    _tapGestureRec.delegate=self;
    [_mainContentView addGestureRecognizer:_tapGestureRec];
    _tapGestureRec.enabled = NO;
    
    _panGestureRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGesture:)];
    [_mainContentView addGestureRecognizer:_panGestureRec];

}

- (UIViewController *)MainVC {
    return _MainVC;
}

- (void)setLeftVC:(UIViewController *)LeftVC {
    if (_canShowLeft&&LeftVC!=nil) {
        _LeftVC = LeftVC;
        [self addChildViewController:LeftVC];
        LeftVC.view.frame=CGRectMake(0, 0, LeftVC.view.frame.size.width, LeftVC.view.frame.size.height);
        [_leftSideView addSubview:LeftVC.view];
    }
}

- (UIViewController *)LeftVC {
    return _LeftVC;
}

- (void)setRightVC:(UIViewController *)RightVC {
    if (_canShowRight&&RightVC!=nil) {
        _RightVC = RightVC;
        [self addChildViewController:RightVC];
        RightVC.view.frame=CGRectMake(0, 0, RightVC.view.frame.size.width, RightVC.view.frame.size.height);
        [_rightSideView addSubview:RightVC.view];
    }
}

-(UIViewController *)RightVC {
    return _RightVC;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=YES;
    
}

#pragma mark - Init

- (void)initSubviews
{
    _rightSideView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_rightSideView];
    
    _leftSideView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_leftSideView];
    
    _mainContentView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_mainContentView];
}


#pragma mark - Actions


- (void)showLeftViewController
{
    if (showingLeft) {
        [self closeSideBar];
        return;
    }
    if (!_canShowLeft||_LeftVC==nil) {
        return;
    }
    CGAffineTransform conT = [self transformWithDirection:RMoveDirectionRight];
    
    [self.view sendSubviewToBack:_rightSideView];
    [self configureViewShadowWithDirection:RMoveDirectionRight];
    
    [UIView animateWithDuration:_LeftSCloseDuration delay:0.3 usingSpringWithDamping:0.7 initialSpringVelocity:0.2 options:UIViewAnimationOptionLayoutSubviews animations:^{
        _mainContentView.transform = conT;
    } completion:^(BOOL finished) {
        _tapGestureRec.enabled = YES;
        showingLeft=YES;
        _MainVC.view.userInteractionEnabled=NO;
    }];
}

- (void)showRightViewController
{
    if (showingRight) {
        [self closeSideBar];
        return;
    }
    if (!_canShowRight||_RightVC==nil) {
        return;
    }
    CGAffineTransform conT = [self transformWithDirection:RMoveDirectionLeft];
    
    [self.view sendSubviewToBack:_leftSideView];
    [self configureViewShadowWithDirection:RMoveDirectionLeft];
    
    [UIView animateWithDuration:_RightSOpenDuration delay:0.3 usingSpringWithDamping:0.7 initialSpringVelocity:0.2 options:UIViewAnimationOptionLayoutSubviews animations:^{
        _mainContentView.transform = conT;
    } completion:^(BOOL finished) {
        _tapGestureRec.enabled = YES;
        showingRight=YES;
        _MainVC.view.userInteractionEnabled=NO;
    }];
}

- (void)closeSideBar
{
    [self closeSideBarWithAnimate:YES complete:^(BOOL finished) {}];
}

- (void)closeSideBarWithAnimate:(BOOL)bAnimate complete:(void(^)(BOOL finished))complete
{
    CGAffineTransform oriT = CGAffineTransformIdentity;
    if (bAnimate)
    {
        [UIView animateWithDuration:_mainContentView.transform.tx==_LeftSContentOffset?_LeftSCloseDuration:_RightSCloseDuration
                         animations:^{
                             _mainContentView.transform = oriT;
                         }
                         completion:^(BOOL finished) {
                             _tapGestureRec.enabled = NO;
                             showingRight=NO;
                             showingLeft=NO;
                             _MainVC.view.userInteractionEnabled=YES;
                             complete(finished);
                         }];
    } else {
        _mainContentView.transform = oriT;
        _tapGestureRec.enabled = NO;
        showingRight=NO;
        showingLeft=NO;
        _MainVC.view.userInteractionEnabled=YES;
        complete(YES);
    }
}

- (void)moveViewWithGesture:(UIPanGestureRecognizer *)panGes
{
    static CGFloat currentTranslateX;
    if (panGes.state == UIGestureRecognizerStateBegan)
    {
        currentTranslateX = _mainContentView.transform.tx;
    }
    if (panGes.state == UIGestureRecognizerStateChanged)
    {
        CGFloat transX = [panGes translationInView:_mainContentView].x;
        transX = transX + currentTranslateX;
        CGFloat sca=0;
        
        CGFloat ltransX = (transX - _LeftSContentOffset)/_LeftSContentOffset * _LeftContentViewSContentOffset;
        CGFloat lsca = 1;
        
        if (transX > 0)
        {
            if (!_canShowLeft||_LeftVC==nil) {
                return;
            }

            [self.view sendSubviewToBack:_rightSideView];
            [self configureViewShadowWithDirection:RMoveDirectionRight];
            
            if (_mainContentView.frame.origin.x < _LeftSContentOffset)
            {
                sca = 1 - (_mainContentView.frame.origin.x/_LeftSContentOffset) * (1-_LeftSContentScale);
                lsca = 1 - sca + _LeftSContentScale;
            }
            else
            {
                sca = _LeftSContentScale;
                lsca = 1;
                
                ltransX = 0;
            }
            
            self.changeLeftView(lsca, ltransX);
        }
        else    //transX < 0
        {
            if (!_canShowRight||_RightVC==nil) {
                return;
            }

            [self.view sendSubviewToBack:_leftSideView];
            [self configureViewShadowWithDirection:RMoveDirectionLeft];
            
            if (_mainContentView.frame.origin.x > -_RightSContentOffset)
            {
                sca = 1 - (-_mainContentView.frame.origin.x/_RightSContentOffset) * (1-_RightSContentScale);
            }
            else
            {
                sca = _RightSContentScale;
            }
        }
        CGAffineTransform transS = CGAffineTransformMakeScale(sca, sca);
        CGAffineTransform transT = CGAffineTransformMakeTranslation(transX, 0);
        CGAffineTransform conT = CGAffineTransformConcat(transT, transS);
        _mainContentView.transform = conT;
    }
    else if (panGes.state == UIGestureRecognizerStateEnded)
    {
        CGFloat panX = [panGes translationInView:_mainContentView].x;
        CGFloat finalX = currentTranslateX + panX;
        if (finalX > _LeftSJudgeOffset)
        {
            if (!_canShowLeft||_LeftVC==nil) {
                return;
            }

            CGAffineTransform conT = [self transformWithDirection:RMoveDirectionRight];
            [UIView beginAnimations:nil context:nil];
            _mainContentView.transform = conT;
            [UIView commitAnimations];
            
            showingLeft=YES;
            _MainVC.view.userInteractionEnabled=NO;
            _tapGestureRec.enabled = YES;
            
            [self showLeft:YES];
            
            return;
        }
        if (finalX < -_RightSJudgeOffset)
        {
            if (!_canShowRight||_RightVC==nil) {
                return;
            }

            CGAffineTransform conT = [self transformWithDirection:RMoveDirectionLeft];
            [UIView beginAnimations:nil context:nil];
            _mainContentView.transform = conT;
            [UIView commitAnimations];
            
            showingRight=YES;
            _MainVC.view.userInteractionEnabled=NO;

            _tapGestureRec.enabled = YES;
            
            return;
        }
        else
        {
            CGAffineTransform oriT = CGAffineTransformIdentity;
            [UIView beginAnimations:nil context:nil];
            _mainContentView.transform = oriT;
            [UIView commitAnimations];
            
            [self showLeft:NO];
            
            showingRight=NO;
            showingLeft=NO;
            _MainVC.view.userInteractionEnabled=YES;
            _tapGestureRec.enabled = NO;
        }
    }
}

#pragma mark -

- (void)showLeft:(BOOL)bShow
{
    if (bShow)
    {
        [UIView beginAnimations:nil context:nil];
        self.changeLeftView(1, 0);
        [UIView commitAnimations];
    }else
    {
        [UIView beginAnimations:nil context:nil];
        self.changeLeftView(_LeftSContentScale, -_LeftContentViewSContentOffset);
        [UIView commitAnimations];
    }
}

- (CGAffineTransform)transformWithDirection:(RMoveDirection)direction
{
    CGFloat translateX = 0;
    CGFloat transcale = 0;
    switch (direction) {
        case RMoveDirectionLeft:
            translateX = -_RightSContentOffset;
            transcale = _RightSContentScale;
            break;
        case RMoveDirectionRight:
            translateX = _LeftSContentOffset;
            transcale = _LeftSContentScale;
            break;
        default:
            break;
    }
    
    CGAffineTransform transT = CGAffineTransformMakeTranslation(translateX, 0);
    CGAffineTransform scaleT = CGAffineTransformMakeScale(transcale, transcale);
    CGAffineTransform conT = CGAffineTransformConcat(transT, scaleT);
    
    return conT;
}

- (NSString*)deviceWithNumString{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    @try {
        return [deviceString stringByReplacingOccurrencesOfString:@"," withString:@""];
    }
    @catch (NSException *exception) {
        return deviceString;
    }
    @finally {
    }
}

- (void)configureViewShadowWithDirection:(RMoveDirection)direction
{
    if ([[self deviceWithNumString] hasPrefix:@"iPhone"]&&[[[self deviceWithNumString] stringByReplacingOccurrencesOfString:@"iPhone" withString:@""] floatValue]<40) {
        return;
    }
    if ([[self deviceWithNumString] hasPrefix:@"iPod"]&&[[[self deviceWithNumString] stringByReplacingOccurrencesOfString:@"iPod" withString:@""] floatValue]<40) {
        return;
    }
    if ([[self deviceWithNumString] hasPrefix:@"iPad"]&&[[[self deviceWithNumString] stringByReplacingOccurrencesOfString:@"iPad" withString:@""] floatValue]<25) {
        return;
    }

    CGFloat shadowW;
    switch (direction)
    {
        case RMoveDirectionLeft:
            shadowW = 2.0f;
            break;
        case RMoveDirectionRight:
            shadowW = -2.0f;
            break;
        default:
            break;
    }
    _mainContentView.layer.shadowOffset = CGSizeMake(shadowW, 1.0);
    _mainContentView.layer.shadowColor = [UIColor blackColor].CGColor;
    _mainContentView.layer.shadowOpacity = 0.8f;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

@end
