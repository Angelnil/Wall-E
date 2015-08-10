//
//  ONeCollectionViewController.h
//  Wall-E
//
//  Created by Angle_Yan on 15/7/22.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ONeCollectionViewCell.h"
#import "AnimationBasevViewController.h"

@interface ONeCollectionViewController : AnimationBasevViewController

/** 选中的 cell */
@property (nonatomic, weak) ONeCollectionViewCell *selectCell;

@end
