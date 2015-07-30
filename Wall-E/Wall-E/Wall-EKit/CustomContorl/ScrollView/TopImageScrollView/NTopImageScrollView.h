//
//  NTopImageScrollView.h
//  TaiPingLift
//
//  Created by nyezz on 14-6-9.
//  Copyright (c) 2014年 Yanlinyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTopImageScrollView : UIView


- (id)initWithFrame:(CGRect)frame tager:(id)tagerVC imageArray:(NSMutableArray *)imageArray;//自定义初始化方法
- (void)startTimer;
- (void)endTimer;

@end
