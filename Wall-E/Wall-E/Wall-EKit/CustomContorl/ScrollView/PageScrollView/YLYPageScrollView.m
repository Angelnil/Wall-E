//
//  YLYPageScrollView.m
//  Wall-E
//
//  Created by Angle_Yan on 15/3/24.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

#import "YLYPageScrollView.h"


#define TAG_BASIC 1000
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGTH [UIScreen mainScreen].bounds.size.heigth


@interface YLYPageScrollView  () {
    NSMutableArray *_viewArray;//存放左，中，右三个界面的数组
    NSInteger _currentManagePage;
}

@property (nonatomic, strong) UIView *headerPageView; //额外添加的第一页，不计算在重用里面
@property (nonatomic, strong) UIView *footerPageView; //额外添加的最后一页，不计算在重用里面

@end

@implementation YLYPageScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.pagingEnabled = YES;
        self.bounces = NO;
        _viewArray = [[NSMutableArray alloc] init];
        _currentPage = 0;
        _currentManagePage = 0;
    }
    return self;
}

- (void)awakeFromNib {
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.bounces = NO;
    _viewArray = [NSMutableArray array];
    _currentPage = 0;
}

//重用的方法
- (id)dequeueReusableViewWithClassName:(Class)className {
    
    //当前的View
    for (UIView *subView in _viewArray) {
        if ([subView isKindOfClass:className] && subView.tag == TAG_BASIC+_currentManagePage) {
            return subView;
            break;
        }
    }
    //前后的View
    for (UIView *subView in _viewArray) {
        if ([subView isKindOfClass:className] && abs((int)(subView.tag-TAG_BASIC-self.currentPage)) >=2) {
            return subView;
            break;
        }
    }
    return nil;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    if(!self.delegate) {
        self.delegate = self;
    }
    // Drawing code
    self.numbersOfPage = [self.datasource numbersOfPage:self];
    //数量为0
    if (self.numbersOfPage == 0) {
        return;
    }
    //加载三个View
    [self resetView:self.currentPage-1];
    [self resetView:self.currentPage];
    [self resetView:self.currentPage+1];
    
    //设置 headerView
    [self resetHeaderView];
    //设置 footerView
    [self resetFooterView];
}

- (void)resetView:(NSInteger)index {
    if (index < 0 || index > self.numbersOfPage) {
        return ;
    }
    _currentManagePage = index;
    UIView *view = [self.datasource pageScrollView:self viewForPage:index];
    view.tag = TAG_BASIC+index;
    CGRect frame = view.frame;
    frame.origin.x = index*CGRectGetWidth(self.frame);
    view.frame = frame;
    if (![_viewArray containsObject:view] && _viewArray.count == 3) {
        assert(@"出现bug");
    }
    if (![_viewArray containsObject:view] && view) {
        [self addSubview:view];
        [_viewArray addObject:view];
    }
}

- (void)resetHeaderView {
    if (self.headerPageView == nil) {
        UIView *view = [self.datasource headerViewForPageScrollView:self];
        self.headerPageView = view;
    }
}

- (void)resetFooterView {
    if (self.footerPageView == nil) {
        UIView *view = [self.datasource footerViewForPageScrollView:self];
        self.footerPageView = view;
    }
}


- (void)reloadData {
    self.numbersOfPage = [self.datasource numbersOfPage:self];
    if(!self.delegate)
    {
        self.delegate = self;
    }
    self.hidden = self.numbersOfPage == 0;
    if (self.currentPage >= self.numbersOfPage) {
        self.contentOffset = CGPointMake(CGRectGetWidth(self.frame)*(self.numbersOfPage-1), 0);
    }
    [self resetView:_currentPage-1];
    [self resetView:_currentPage];
    [self resetView:_currentPage+1];
}


- (void)reloadCenterData {
    [self resetView:self.currentPage];
}

- (void)reloadLeftData {
    [self resetView:self.currentPage-1];
}

- (void)reloadRightData {
    [self resetView:self.currentPage+1];
}

- (id)viewForPage:(NSInteger)page {
    for (UIView *subView  in _viewArray) {
        if (subView.tag == page+TAG_BASIC) {
            return subView;
        }
    }
    return nil;
}

#pragma mark - get

- (id)centerView {
    return [self viewForPage:self.currentPage];
}


#pragma mark - Setter

- (void)setNumbersOfPage:(NSInteger)numbersOfPage {
    _numbersOfPage = numbersOfPage;
    self.contentSize = CGSizeMake(self.frame.size.width * (numbersOfPage), self.frame.size.height);
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    self.contentOffset = CGPointMake(CGRectGetWidth(self.frame)*currentPage, 0);
    self.delegate = self;
}


- (void)setHeaderPageView:(UIView *)headerPageView {
    if (headerPageView) {
        self.contentInset = UIEdgeInsetsMake(0, headerPageView.frame.size.width, 0, 0);
        CGRect frame = headerPageView.frame;
        frame.origin.x = -headerPageView.frame.size.width;
        headerPageView.frame = frame;
        [self addSubview:headerPageView];
    }
}

- (void)setFooterPageView:(UIView *)footerPageView {
    if (footerPageView) {
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, footerPageView.frame.size.width);
        CGRect frame = footerPageView.frame;
        frame.origin.x = CGRectGetWidth(self.frame)*(self.numbersOfPage);
        footerPageView.frame = frame;
        [self addSubview:footerPageView];
    }
}


#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.datasource respondsToSelector:@selector(pageScrollViewDidScroll:)])
    {
        [self.datasource pageScrollViewDidScroll:self];
    }
    NSInteger page = scrollView.contentOffset.x/scrollView.frame.size.width;
    CGFloat pageFloat = scrollView.contentOffset.x/scrollView.frame.size.width;
    
    if ((pageFloat-page)>0.5)
    {
        page ++;
    }
    
    if (page != self.currentPage)
    {
        NSInteger dValue = page-self.currentPage;
        _currentPage = page;
        [self resetView:page+dValue];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([self.datasource respondsToSelector:@selector(pageScrollViewDidEndDragging:willDecelerate:)])
    {
        [self.datasource pageScrollViewDidEndDragging:self willDecelerate:decelerate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.datasource respondsToSelector:@selector(pageScrollViewDidEndDecelerating:)])
    {
        [self.datasource pageScrollViewDidEndDecelerating:self];
    }
}


@end
