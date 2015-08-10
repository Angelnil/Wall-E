//
//  ONeCollectionViewController.m
//  Wall-E
//
//  Created by Angle_Yan on 15/7/22.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

#import "ONeCollectionViewController.h"
#import "OneDetialViewController.h"

@interface ONeCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@end

@implementation ONeCollectionViewController

static NSString * const reuseIdentifier = @"ONeCollectionViewCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width/3, [UIScreen mainScreen].bounds.size.width/3);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;

    self.flowLayout = layout;
    
    self.collectionView.collectionViewLayout = self.flowLayout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:NSStringFromClass([OneDetialViewController class])]) {
        OneDetialViewController *one = (OneDetialViewController *)[segue destinationViewController];
        one.image = self.selectCell.imageView.image;
    }
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 15;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ONeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectCell = (ONeCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
//     1. 用代码直接 push
    OneDetialViewController *one = [[UIStoryboard storyboardWithName:@"Animation" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([OneDetialViewController class])];
    one.image = self.selectCell.imageView.image;
    [self.navigationController pushViewController:one animated:YES];
    
    //2. 用 storyboard 中的 segue 推送
//    [self performSegueWithIdentifier:NSStringFromClass([OneDetialViewController class]) sender:nil];
}


@end
