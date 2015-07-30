//
//  RefreshHeaderAndFooterView.h
//  Wall-E
//
//  Created by Angle_Yan on 15/5/22.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f

#define  REFRESH_REGION_HEIGHT 65.0f

//刷新状态
typedef enum{
    EGOOPullRefreshPulling = 0,
    EGOOPullRefreshNormal,
    EGOOPullRefreshLoading,
} EGOPullRefreshState;

//header or footer
typedef enum{
    EGORefreshHeader = 0,
    EGORefreshFooter
} EGORefreshPos;


@class RefreshBaseView;
@protocol RefreshTableViewDelegate <NSObject>
@required
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos;
- (BOOL)egoRefreshTableDataSourceIsLoading:(RefreshBaseView*)view;
@optional
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view;
@end


@interface RefreshBaseView : UIView

- (void)refreshLastUpdatedDate;
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end



/** refresh header View */
@interface RefreshTableHeaderView : RefreshBaseView {
    
    EGOPullRefreshState _state;
    UILabel *_lastUpdatedLabel;
    UILabel *_statusLabel;
    CALayer *_arrowImage;
    UIActivityIndicatorView *_activityView;
}

@property(nonatomic, assign) id <RefreshTableViewDelegate> delegate;
@property(nonatomic, assign) BOOL isRefresh;
@property (nonatomic, copy) void (^pullToRefreshActionHandler)(void);


- (void)setState:(EGOPullRefreshState)aState;
- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor;

@end

/** reloading footer View */
@interface RefreshTableFooterView : RefreshBaseView {
    
    EGOPullRefreshState _state;
    
    UILabel *_lastUpdatedLabel;
    UILabel *_statusLabel;
    CALayer *_arrowImage;
    UIActivityIndicatorView *_activityView;
}

@property(nonatomic,assign) id <RefreshTableViewDelegate> delegate;
@property(nonatomic, assign) BOOL reloading;
@property (nonatomic, copy) void (^pullToLoadingMoreActionHandler)(void);


- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor;

@end

