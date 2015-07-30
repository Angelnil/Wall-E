//
//  TestViewController.m
//  Wall-E
//
//  Created by Angle_Yan on 15/5/22.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

#import "TestViewController.h"
#import "UIScrollView+RefreshScrollView.h"
#import "UIView+ViewUtils.h"
#import "ClickLab.h"

@interface TestViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet ClickLab *lineView;

@end



@implementation TestViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_lineView setBorderLineColor:[UIColor redColor]];
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        NSLog(@"header 123");
    }];
    
    [self.tableView addPullToAddMoreWithActionHandler:^{
        NSLog(@"footer 123");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
