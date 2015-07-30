//
//  NTopImageScrollView.m
//  TaiPingLift
//
//  Created by nyezz on 14-6-9.
//  Copyright (c) 2014年 Yanlinyan. All rights reserved.
//

#import "NTopImageScrollView.h"
#import "NBluePageControl.h"

@interface NTopImageScrollView () <UIScrollViewDelegate>
{
    UIScrollView *_imageScrollView;//自动更改图片视图
    NBluePageControl *_pageControl;//分页控件
    NSMutableArray *_imageArray;//存放图片名称
    NSMutableArray *_imageViewArray;
    NSInteger _currentIndex;//当前图片索引
}

@property (nonatomic, retain) NSTimer *autoChangeImageTimer;//自动更改图片计时器
@property (nonatomic, retain) UIViewController *VC;

@end

@implementation NTopImageScrollView

- (id)initWithFrame:(CGRect)frame tager:(id)tagerVC imageArray:(NSMutableArray *)imageArray;//自定义初始化方法
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //初始化
        _currentIndex = 0;
        _imageArray = imageArray;
        _imageViewArray = [[NSMutableArray alloc] initWithCapacity:3];
        self.VC = tagerVC;
        
        [self loadingUiInterface];
        [self startTimer];
    }
    return self;
}

#pragma mark -- 初始化用户界面
- (void)loadingUiInterface
{
    //图片自动改变UIScrollView
    _imageScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    //设置代理
    _imageScrollView.delegate = self;
    //设置整页翻动
    _imageScrollView.pagingEnabled = YES;
    //设置水平指示条不显示
    _imageScrollView.showsHorizontalScrollIndicator = NO;
    //设置偏移量
    _imageScrollView.contentOffset = CGPointMake(CGRectGetWidth(self.bounds), 0);
    //设置内容大小
    _imageScrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(self.bounds),self.bounds.size.height);
    //初始化三张图片
    for (int i=0; i<3; i++) {
        NSInteger index = [self indexWithCurrentIndex:_currentIndex + i - 1];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(i*CGRectGetWidth(_imageScrollView.bounds),0, CGRectGetWidth(_imageScrollView.bounds), CGRectGetHeight(_imageScrollView.bounds));
        imageView.tag = 100+index;
        imageView.image = [UIImage imageNamed:_imageArray[index]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToGoodsDetail:)];
        [imageView addGestureRecognizer:tap];
        //放入scrollView中
        [_imageScrollView addSubview:imageView];
        //添加入图片数组中
        [_imageViewArray addObject:imageView];
    }
    [self addSubview:_imageScrollView];
    
    //分页控件UIPageControl
    _pageControl = [[NBluePageControl alloc] initWithFrame:CGRectMake(0, 0, _imageArray.count*20, 10)];
    _pageControl.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds)-10);
    //设置页数
    _pageControl.numberOfPages = _imageArray.count;
    [self addSubview:_pageControl];
}


#pragma mark -- 判断当前索引
- (NSInteger)indexWithCurrentIndex:(NSInteger)currentIndex
{
    //判断索引是否为第一还是最后
    unsigned long i = _imageArray.count - 1;
    if (currentIndex > i) {
        currentIndex = 0;
    }else if (currentIndex < 0){
        currentIndex = i;
    }
    return currentIndex;
}

#pragma mark -- 自动改变ScrollView
- (void)autoChangeScorellView
{
    [_imageScrollView setContentOffset:CGPointMake(CGRectGetWidth(_imageScrollView.bounds) * 2, 0) animated:YES];
}

#pragma mark -- 开启计时器
- (void)startTimer
{
    if (!_autoChangeImageTimer) {
        _autoChangeImageTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(autoChangeScorellView) userInfo:nil repeats:YES];
    }
}

#pragma mark -- 暂停计时器
- (void)endTimer {
    if (_autoChangeImageTimer) {
        NSLog(@"通过通知关闭计时器!");
        //暂停自动调用
        [_autoChangeImageTimer setFireDate:[NSDate distantFuture]];
        
        //销毁计时器
//        [_autoChangeImageTimer invalidate];
//        _autoChangeImageTimer = nil;
    }}


#pragma mark -- 更新scrollView
- (void)updateScrollView:(UIScrollView *)scrollView
{
    BOOL shouldUpdate = NO;//判断是否需要更新
    if (scrollView.contentOffset.x >= CGRectGetWidth(self.bounds) * 2) {//左滑
        //重置当前索引
        _currentIndex = [self indexWithCurrentIndex:_currentIndex + 1];
        shouldUpdate = YES;
    }
    else if (scrollView.contentOffset.x <= 0) {//右滑
        _currentIndex = [self indexWithCurrentIndex:_currentIndex - 1];
        shouldUpdate = YES;
    }
    if (!shouldUpdate) {
        return;
    }
    
    //重新加载三张图片
    for (int i = 0; i < 3; i ++) {
        //得到下标
        NSInteger index = [self indexWithCurrentIndex:_currentIndex + i - 1];
        //得到图片
        UIImageView *imageView = (UIImageView *)_imageViewArray[i];
        [imageView setImage:_imageArray[index]];
        imageView.tag = 100 + index;
    }
    //设置当前显示索引
    [_pageControl setCurrentPage:_currentIndex];
    //复位
    [self resumeScrollView:scrollView];
}

#pragma mark -- scrollView复位
- (void)resumeScrollView:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.bounds), 0) animated:NO];
}

#pragma mark -- <UIScrollViewDelegate>
//当ScrollView滚动时
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateScrollView:scrollView];
}
//当拖拽开始时调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //暂停自动调用
    [_autoChangeImageTimer setFireDate:[NSDate distantFuture]];
}
//当拖拽结束时调用
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //延迟一秒后自动调用
    [_autoChangeImageTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
}


#pragma mark -- 跳转进入商品详情页面
- (void)goToGoodsDetail:(UIButton *)sender
{
    NSLog(@"跳转进入商品详情页面");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
