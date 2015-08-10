//
//  OneDetialViewController.h
//  Wall-E
//
//  Created by Angle_Yan on 15/7/22.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationBasevViewController.h"

@interface OneDetialViewController : AnimationBasevViewController

/** 前一个也传过的图片 */
@property (nonatomic, weak) UIImage *image;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
