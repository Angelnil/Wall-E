//
//  YLYDrawerView.m
//  YLYDrawerViewController
//
//  Created by Angle_Yan on 15/7/10.
//  Copyright (c) 2015年 JuRongWeiYe. All rights reserved.
//

#import "YLYDrawerView.h"

static const CGFloat kJVCenterViewContainerCornerRadius = 5.0;
static const CGFloat kJVDefaultViewContainerWidth = 280.0;


@implementation YLYDrawerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


#pragma mark - View Setup

- (void)setup {
    [self setupLeftViewContainer];
    [self setupRightViewContainer];
    [self setupCenterViewContainer];
}

- (void)setupLeftViewContainer {
    _leftViewContainer = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.leftViewContainer];
}

- (void)setupRightViewContainer {
    _rightViewContainer = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.rightViewContainer];
}

- (void)setupCenterViewContainer {
    _centerViewContainer = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.centerViewContainer];
}

#pragma mark - Reveal Widths

- (void)setLeftViewContainerWidth:(CGFloat)leftViewContainerWidth {
    CGRect oldFrame = self.leftViewContainer.frame;
    oldFrame.origin.x = -leftViewContainerWidth;
    oldFrame.size.width = leftViewContainerWidth;
    self.leftViewContainer.frame = oldFrame;
}

- (void)setRightViewContainerWidth:(CGFloat)rightViewContainerWidth {
    CGRect oldFrame = self.leftViewContainer.frame;
    oldFrame.size.width = rightViewContainerWidth;
    self.leftViewContainer.frame = oldFrame;
}

- (CGFloat)leftViewContainerWidth {
    return self.leftViewContainer.bounds.size.width;
}

- (CGFloat)rightViewContainerWidth {
    return self.rightViewContainer.bounds.size.width;
}

#pragma mark - Helpers

- (UIView *)viewContainerForDrawerSide:(DrawerSide)drawerSide {
    UIView *viewContainer = nil;
    switch (drawerSide) {
        case DrawerSideLeft: viewContainer = self.leftViewContainer; break;
        case DrawerSideRight: viewContainer = self.rightViewContainer; break;
        case DrawerSideNone: viewContainer = self.centerViewContainer; break;
    }
    return viewContainer;
}

#pragma mark - Open/Close Events

- (void)willOpenFloatingDrawerViewController:(DrawerSide)drawerSide {
    switch (drawerSide) {
        case DrawerSideNone:
            //给中间 View 设置圆角和阴影
            [self applyBorderRadiusToCenterViewController];
            [self applyShadowToCenterViewContainer];
            break;
        default:
            break;
    }
}

- (void)willCloseFloatingDrawerViewController:(DrawerSide)drawerSide {
    switch (drawerSide) {
        case DrawerSideNone:
            [self removeBorderRadiusFromCenterViewController];
            [self removeShadowFromCenterViewContainer];
            break;
        default:
            break;
    }
}

#pragma mark - Center View borderRadius_Shadow Related

- (void)applyBorderRadiusToCenterViewController {
    CALayer *centerLayer = self.centerViewContainer.layer;
    centerLayer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.15].CGColor;
    centerLayer.borderWidth = 1.0;
    centerLayer.cornerRadius = kJVCenterViewContainerCornerRadius;
    centerLayer.masksToBounds = YES;
}

- (void)removeBorderRadiusFromCenterViewController {
    // FIXME: Safe? Maybe move this into a property
    CALayer *centerLayer = self.centerViewContainer.layer;
    centerLayer.borderColor = [UIColor clearColor].CGColor;
    centerLayer.borderWidth = 0.0;
    centerLayer.cornerRadius = 0.0;
    centerLayer.masksToBounds = NO;
}

- (void)applyShadowToCenterViewContainer {
    CALayer *layer = self.centerViewContainer.layer;
    layer.shadowRadius  = 20.0;
    layer.shadowColor   = [UIColor blackColor].CGColor;
    layer.shadowOpacity = 0.4;
    layer.shadowOffset  = CGSizeMake(0.0, 0.0);
    layer.masksToBounds = NO;
    [self updateShadowPath];
}

- (void)removeShadowFromCenterViewContainer {
    CALayer *layer = self.centerViewContainer.layer;
    layer.shadowRadius  = 0.0;
    layer.shadowOpacity = 0.0;
}


- (void)updateShadowPath {
    CALayer *layer = self.centerViewContainer.layer;
    CGFloat increase = layer.shadowRadius;
    CGRect centerViewContainerRect = self.centerViewContainer.bounds;
    centerViewContainerRect.origin.x -= increase;
    centerViewContainerRect.origin.y -= increase;
    centerViewContainerRect.size.width  += 2.0 * increase;
    centerViewContainerRect.size.height += 2.0 * increase;
    layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:centerViewContainerRect cornerRadius:kJVCenterViewContainerCornerRadius] CGPath];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateShadowPath];
}

@end

