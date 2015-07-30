//
//  CustomTabBarViewController.m
//  YLY11_10
//
//  Created by 严林燕 on 14/11/17.
//  Copyright (c) 2014年 严林燕. All rights reserved.
//

#import "CustomTabBarViewController.h"

@interface CustomTabBarViewController ()

@end

@implementation CustomTabBarViewController

//
- (id)initCustomeTabBarViewControllerWithIsCustomeTabbar:(BOOL)isCustome {
    self = [super init];
    if (self) {
        _isCustomTabbar = isCustome;
        if (_isCustomTabbar) {
            [self customTabbarView];

        }
        [self customViewControllers];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)customTabbarView {
    self.tabBar.hidden = YES;
    _tabarView = [[CustomTabbarView alloc] initTabbarViewWithFrame:self.tabBar.frame titleArray:nil defatImageArray:nil selectImageArray:nil];
    [self.view addSubview:self.tabarView];
}

- (void)customViewControllers {
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
