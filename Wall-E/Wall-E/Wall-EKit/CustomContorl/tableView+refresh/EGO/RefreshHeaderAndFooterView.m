//
//  RefreshHeaderAndFooterView.m
//  Wall-E
//
//  Created by Angle_Yan on 15/5/22.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

#import "RefreshHeaderAndFooterView.h"


@implementation RefreshBaseView


@end


@interface RefreshTableHeaderView (Private)

@end

@implementation RefreshTableHeaderView

- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor  {
    if((self = [super initWithFrame:frame])) {
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        
        _lastUpdatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
        _lastUpdatedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _lastUpdatedLabel.font = [UIFont systemFontOfSize:12.0f];
        _lastUpdatedLabel.textColor = textColor;
        _lastUpdatedLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        _lastUpdatedLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        _lastUpdatedLabel.backgroundColor = [UIColor clearColor];
        _lastUpdatedLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lastUpdatedLabel];
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
        _statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        _statusLabel.textColor = textColor;
        _statusLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        _statusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_statusLabel];
        
        _arrowImage = [CALayer layer];
        _arrowImage.frame = CGRectMake(25.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
        _arrowImage.contents = (id)[UIImage imageNamed:arrow].CGImage;
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            _arrowImage.contentsScale = [[UIScreen mainScreen] scale];
        }
#endif
        
        [[self layer] addSublayer:_arrowImage];
        
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
        [self addSubview:_activityView];
        
        
        [self setState:EGOOPullRefreshNormal];
        
    }
    
    return self;
    
}

- (id)initWithFrame:(CGRect)frame  {
    return [self initWithFrame:frame arrowImageName:@"blueArrow.png" textColor:TEXT_COLOR];
}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
    
    if ([_delegate respondsToSelector:@selector(egoRefreshTableDataSourceLastUpdated:)]) {
        
        NSDate *currentDate = [_delegate egoRefreshTableDataSourceLastUpdated:self];
        NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:currentDate];
        
        
        [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        
        _lastUpdatedLabel.text = [NSString stringWithFormat:@"更新时间: %d分钟之前",(int)time/60];
        [[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } else {
        
        _lastUpdatedLabel.text = nil;
        
    }
    
}

- (void)setState:(EGOPullRefreshState)aState{
    
    switch (aState) {
        case EGOOPullRefreshPulling:
            _statusLabel.text = NSLocalizedString(@"释放立即刷新...", @"Release to refresh status");
            [CATransaction begin];
            [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            [CATransaction commit];
            break;
        case EGOOPullRefreshNormal:
            if (_state == EGOOPullRefreshPulling) {
                [CATransaction begin];
                [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                _arrowImage.transform = CATransform3DIdentity;
                [CATransaction commit];
            }
            _statusLabel.text = NSLocalizedString(@"下拉刷新...", @"Pull down to refresh status");
            [_activityView stopAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = NO;
            _arrowImage.transform = CATransform3DIdentity;
            [CATransaction commit];
            
            [self refreshLastUpdatedDate];
            
            break;
        case EGOOPullRefreshLoading:
            _statusLabel.text = NSLocalizedString(@"加载中...", @"Loading Status");
            [_activityView startAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = YES;
            [CATransaction commit];
            self.pullToRefreshActionHandler();
            break;
        default:
            break;
    }
    
    _state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {
    //	NSLog(@"egoRefreshScrollViewDidScroll scrollView.contentOffset.y= %f", scrollView.contentOffset.y);
    if (_state == EGOOPullRefreshLoading) {
        CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
        offset = MIN(offset, 60);
        scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
    } else if (scrollView.isDragging) {
        BOOL _loading = NO;
        if ([_delegate respondsToSelector:@selector(egoRefreshTableDataSourceIsLoading:)]) {
            _loading = [_delegate egoRefreshTableDataSourceIsLoading:self];
        }
        if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
            [self setState:EGOOPullRefreshNormal];
        } else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_loading) {
            [self setState:EGOOPullRefreshPulling];
        }
        if (scrollView.contentInset.top != 0) {
            scrollView.contentInset = UIEdgeInsetsZero;
        }
    }
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
    //NSLog(@"egoRefreshScrollViewDidEndDragging scrollView.contentOffset.y= %f", scrollView.contentOffset.y);
    BOOL _loading = NO;
    if ([_delegate respondsToSelector:@selector(egoRefreshTableDataSourceIsLoading:)]) {
        _loading = [_delegate egoRefreshTableDataSourceIsLoading:self];
    }
    if (scrollView.contentOffset.y <= - 65.0f && !_loading) {
        if ([_delegate respondsToSelector:@selector(egoRefreshTableDidTriggerRefresh:)]) {
            [_delegate egoRefreshTableDidTriggerRefresh:EGORefreshHeader];
        }
        [self setState:EGOOPullRefreshLoading];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        [UIView commitAnimations];
        
    }
    
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [UIView commitAnimations];
    
    [self setState:EGOOPullRefreshNormal];
    
}

@end





@interface RefreshTableFooterView (Private)
- (void)setState:(EGOPullRefreshState)aState;
@end

@implementation RefreshTableFooterView


- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor  {
    if((self = [super initWithFrame:frame])) {
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        
        _lastUpdatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 40.0f, self.frame.size.width, 20.0f)];
        _lastUpdatedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _lastUpdatedLabel.font = [UIFont systemFontOfSize:12.0f];
        _lastUpdatedLabel.textColor = textColor;
        _lastUpdatedLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        _lastUpdatedLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        _lastUpdatedLabel.backgroundColor = [UIColor clearColor];
        _lastUpdatedLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lastUpdatedLabel];
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 20.0f, self.frame.size.width, 20.0f)];
        _statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        _statusLabel.textColor = textColor;
        _statusLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        _statusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_statusLabel];
        
        _arrowImage = [CALayer layer];
        _arrowImage.frame = CGRectMake(25.0f, 20.0f, 30.0f, 55.0f);
        _arrowImage.contentsGravity = kCAGravityResizeAspect;
        _arrowImage.contents = (id)[UIImage imageNamed:arrow].CGImage;
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            _arrowImage.contentsScale = [[UIScreen mainScreen] scale];
        }
#endif
        
        [[self layer] addSublayer:_arrowImage];
        
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.frame = CGRectMake(25.0f, 20.0f, 20.0f, 20.0f);
        [self addSubview:_activityView];
        
        
        [self setState:EGOOPullRefreshNormal];
        
    }
    
    return self;
    
}

//默认的刷新图片
- (id)initWithFrame:(CGRect)frame  {
    return [self initWithFrame:frame arrowImageName:@"blueArrow.png" textColor:TEXT_COLOR];
}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
    
    if ([_delegate respondsToSelector:@selector(egoRefreshTableDataSourceLastUpdated:)]) {
        NSDate *date = [_delegate egoRefreshTableDataSourceLastUpdated:self];
        
        [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        
        _lastUpdatedLabel.text = [NSString stringWithFormat:@"上次加载时间: %@", [dateFormatter stringFromDate:date]];
        [[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } else {
        
        _lastUpdatedLabel.text = nil;
        
    }
    
}

- (void)setState:(EGOPullRefreshState)aState{
    
    switch (aState) {
        case EGOOPullRefreshPulling:
            
            _statusLabel.text = NSLocalizedString(@"释放立即加载...", @"Release to load more");
            [CATransaction begin];
            [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            //			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            _arrowImage.transform = CATransform3DIdentity;
            [CATransaction commit];
            
            break;
        case EGOOPullRefreshNormal:
            
            if (_state == EGOOPullRefreshPulling) {
                [CATransaction begin];
                [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                _arrowImage.transform = CATransform3DIdentity;
                [CATransaction commit];
            }
            
            _statusLabel.text = NSLocalizedString(@"上拉加载更多...", @"Pull up to load more");
            [_activityView stopAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = NO;
            //_arrowImage.transform = CATransform3DIdentity;
            _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            [CATransaction commit];
            
            [self refreshLastUpdatedDate];
            
            break;
        case EGOOPullRefreshLoading:
            
            _statusLabel.text = NSLocalizedString(@"加载中...", @"Loading Status");
            [_activityView startAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = YES;
            [CATransaction commit];
            
            break;
        default:
            break;
    }
    
    _state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_state == EGOOPullRefreshLoading) {
        
        CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
        offset = MIN(offset, 60);
        scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, REFRESH_REGION_HEIGHT, 0.0f);
        
    } else if (scrollView.isDragging) {
        
        BOOL _loading = NO;
        if ([_delegate respondsToSelector:@selector(egoRefreshTableDataSourceIsLoading:)]) {
            _loading = [_delegate egoRefreshTableDataSourceIsLoading:self];
        }
        
        if (_state == EGOOPullRefreshPulling &&
            (scrollView.contentOffset.y+scrollView.frame.size.height) < scrollView.contentSize.height+REFRESH_REGION_HEIGHT &&
            scrollView.contentOffset.y > 0.0f && !_loading) {
            [self setState:EGOOPullRefreshNormal];
        } else if (_state == EGOOPullRefreshNormal &&
                   scrollView.contentOffset.y+(scrollView.frame.size.height) > scrollView.contentSize.height+REFRESH_REGION_HEIGHT && !_loading) {
            [self setState:EGOOPullRefreshPulling];
        }
        
        if (scrollView.contentInset.top != 0) {
            scrollView.contentInset = UIEdgeInsetsZero;
        }
        
    }
    
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
    
    BOOL _loading = NO;
    if ([_delegate respondsToSelector:@selector(egoRefreshTableDataSourceIsLoading:)]) {
        _loading = [_delegate egoRefreshTableDataSourceIsLoading:self];
    }
    
    if (scrollView.contentOffset.y+(scrollView.frame.size.height) > scrollView.contentSize.height+REFRESH_REGION_HEIGHT  && !_loading) {
        
        if ([_delegate respondsToSelector:@selector(egoRefreshTableDidTriggerRefresh:)]) {
            [_delegate egoRefreshTableDidTriggerRefresh:EGORefreshFooter];
        }
        
        [self setState:EGOOPullRefreshLoading];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, REFRESH_REGION_HEIGHT, 0.0f);
        [UIView commitAnimations];
    }
    
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [UIView commitAnimations];
    
    [self setState:EGOOPullRefreshNormal];
}

@end
