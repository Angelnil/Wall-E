//
//  UIScrollView+RefreshScrollView.m
//  YLY11_10
//
//  Created by Angle_Yan on 15/3/13.
//  Copyright (c) 2015年 严林燕. All rights reserved.
//

#import "UIScrollView+RefreshScrollView.h"
#import <objc/runtime.h>


static const int UIScrollViewPullToRefreshView;
static const int UIScrollViewPullToAddMoreView;


@implementation UIScrollView (RefreshScrollView)

@dynamic headerView;
@dynamic footerView;

- (instancetype)initWithFrame:(CGRect )frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)awakeFromNib {
    self.delegate = self;
}



- (void)addPullToRefreshWithActionHandler:(void (^)(void))handler {
    //添加 refreshView
    RefreshTableHeaderView *headerView = self.refreshHeaderView;
    headerView.pullToRefreshActionHandler = handler;
}


- (void)addPullToAddMoreWithActionHandler:(void(^)(void))handler {
    //加载更多
    RefreshTableFooterView *footerView = self.moreFooterView;
    footerView.pullToLoadingMoreActionHandler = handler;
}



//用runTime 类相关联
- (RefreshTableHeaderView *)refreshHeaderView {
    RefreshTableHeaderView *refreshView = objc_getAssociatedObject(self, &UIScrollViewPullToRefreshView);
    if (refreshView == nil) {
        refreshView = [[RefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height)];
        refreshView.delegate = self;
        [refreshView refreshLastUpdatedDate];
        [self addSubview:refreshView];
        objc_setAssociatedObject(self, &UIScrollViewPullToRefreshView, refreshView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
#if !__has_feature(objc_arc)
        [refreshView release];
#endif
    }
    return refreshView;
}


//用runTime 类相关联
- (RefreshTableFooterView *)moreFooterView {
    RefreshTableFooterView *footerView = objc_getAssociatedObject(self, &UIScrollViewPullToAddMoreView);
    if (footerView == nil) {
        //第一次
        CGFloat height = MAX(self.contentSize.height, self.frame.size.height);
        footerView = [[RefreshTableFooterView alloc] initWithFrame:CGRectMake(0, height, self.frame.size.width, self.frame.size.height)];
        footerView.delegate = self;
        [footerView refreshLastUpdatedDate];
        [self addSubview:footerView];
        objc_setAssociatedObject(self, &UIScrollViewPullToAddMoreView, footerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
#if !__has_feature(objc_arc)
        [footerView release];
#endif
    } else {
        //移动位置
        CGFloat height = MAX(self.contentSize.height, self.frame.size.height);
        footerView = [[RefreshTableFooterView alloc] initWithFrame:CGRectMake(0, height, self.frame.size.width, self.frame.size.height)];
    }
    return footerView;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark force to show the refresh headerView
-(void)showRefreshHeader:(BOOL)animated{
    if (animated)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        self.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        // scroll the table view to the top region
        [self scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
        [UIView commitAnimations];
    }
    else
    {
        self.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        [self scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
    }
    RefreshTableHeaderView *headerView = self.refreshHeaderView;
    [headerView setState:EGOOPullRefreshLoading];
}


//===============
//刷新delegate
#pragma mark data reloading methods that must be overide by the subclass
-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
    
    //  should be calling your tableviews data source model to reload
    if (aRefreshPos == EGORefreshHeader) {
        // pull down to refresh data
        RefreshTableHeaderView *headerView = self.refreshHeaderView;
        headerView.isRefresh = YES;
        [self performSelector:@selector(refresh) withObject:nil afterDelay:2.0];
        
    }
    
    if (aRefreshPos == EGORefreshFooter) {
        // pull down to refresh data
        RefreshTableFooterView *footerView = self.moreFooterView;
        footerView.reloading = YES;
        [self performSelector:@selector(getNext) withObject:nil afterDelay:2.0];
    }

    
    // overide, the actual loading data operation is done in the subclass
}

-(void) refresh{
    [self testFinishedLoadData];
    
}

- (void) getNext {
    [self testFinishedLoadData];
}

-(void)testFinishedLoadData{
    
    [self finishReloadingData];
}


#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
    
    //  model should call this when its done loading
    RefreshTableHeaderView *headerView = self.refreshHeaderView;
    if (headerView.isRefresh) {
        [headerView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
    }
    RefreshTableFooterView *footerView = self.moreFooterView;
    if (footerView.reloading) {
        [footerView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
        objc_removeAssociatedObjects(footerView);
        [self moreFooterView];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    RefreshTableHeaderView *headerView = self.refreshHeaderView;
    if (headerView) {
        [headerView egoRefreshScrollViewDidScroll:self];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    RefreshTableHeaderView *headerView = self.refreshHeaderView;
    if (headerView) {
        [headerView egoRefreshScrollViewDidEndDragging:self];
    }
}


#pragma mark -
#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos{
    
    [self beginToReloadData:aRefreshPos];
    
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(EGORefreshPos)aRefreshPos{
    BOOL result = false;
    
    if (aRefreshPos == EGORefreshHeader) {
        // pull down to refresh data
        RefreshTableHeaderView *headerView = self.refreshHeaderView;
        result = headerView.isRefresh;
    }
    
    if (aRefreshPos == EGORefreshFooter) {
        RefreshTableFooterView *footerView = self.moreFooterView;
        result = footerView.reloading;
    }
    
    return result;
}


// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}


@end
