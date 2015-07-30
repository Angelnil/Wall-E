//
//  UIScrollView+RefreshScrollView.h
//  YLY11_10
//
//  Created by Angle_Yan on 15/3/13.
//  Copyright (c) 2015年 严林燕. All rights reserved.
//
//typedef <#returnType#>(^<#name#>)(<#arguments#>);



#import <UIKit/UIKit.h>
#import "RefreshHeaderAndFooterView.h"


@class RefreshTableHeaderView;
@class RefreshTableFooterView;


@interface UIScrollView (RefreshScrollView) <RefreshTableViewDelegate,UIScrollViewDelegate>

@property (nonatomic, retain) RefreshTableHeaderView *headerView;
@property (nonatomic, retain) RefreshTableFooterView *footerView;


- (void)addPullToRefreshWithActionHandler:(void(^)(void))handler;
- (void)addPullToAddMoreWithActionHandler:(void(^)(void))handler;


@end
