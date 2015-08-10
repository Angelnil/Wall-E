//
//  OneDetialViewController.m
//  Wall-E
//
//  Created by Angle_Yan on 15/7/22.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

#import "OneDetialViewController.h"
#import "PictureSelectViewController.h"


@interface OneDetialViewController ()

@end

@implementation OneDetialViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)click:(UIButton *)sender {
    PictureSelectViewController *pic = [[PictureSelectViewController alloc] init];
    [self presentViewController:pic animated:YES completion:nil];
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
