//
//  YLYPageScrollView.h
//  Wall-E
//
//  Created by Angle_Yan on 15/3/24.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

#import <UIKit/UIKit.h>


@class YLYPageScrollView;
@protocol YLYPageScrollViewDatasource <NSObject>

@required
- (NSInteger)numbersOfPage:(YLYPageScrollView *)pageScrollView;
- (UIView *)pageScrollView:(YLYPageScrollView *)pageScrollView viewForPage:(NSInteger)index;

#pragma mark:TODO-headerView FooterView 的代理
@optional
- (UIView *)headerViewForPageScrollView:(YLYPageScrollView *)pageScrollView;
- (UIView *)footerViewForPageScrollView:(YLYPageScrollView *)pageScrollView;


- (void)pageScrollViewDidScroll:(YLYPageScrollView *)pageScrollView;
- (void)pageScrollViewDidEndDragging:(YLYPageScrollView *)pageScrollView willDecelerate:(BOOL)decelerate;
- (void)pageScrollViewDidEndDecelerating:(YLYPageScrollView *)pageScrollView;
@end



@interface YLYPageScrollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, weak) id<YLYPageScrollViewDatasource> datasource;
@property (nonatomic, assign) NSInteger numbersOfPage;   //页数
@property (nonatomic, assign) NSInteger currentPage;    //当前页面

@property (nonatomic, weak) id centerView;   //当前页面的view


- (id)viewForPage:(NSInteger)page; 


- (id)dequeueReusableViewWithClassName:(Class)className;    //根据类名寻找可重用页面视图

- (void)reloadData; //重新加载数据
- (void)reloadCenterData;   //重新加载中间（即当前）页面的数据
- (void)reloadRightData;
- (void)reloadLeftData;

@end
