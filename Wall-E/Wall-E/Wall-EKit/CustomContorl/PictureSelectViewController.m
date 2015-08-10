//
//  PictureSelectViewController.m
//  Wall-E
//
//  Created by Angle_Yan on 15/8/7.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

#import "PictureSelectViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PictureItemCollectionViewCell.h"


typedef void(^getOver)(BOOL stop) ;
static NSInteger photesCout = 0;
#define SpaceWidth 5


@interface PictureSelectViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *bottomDataSource;



@end

@implementation PictureSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSource = [[NSMutableArray alloc] init];
    self.bottomDataSource = [[NSMutableArray alloc] init];
    
    // 展示图片
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = SpaceWidth;
    flowLayout.minimumLineSpacing = SpaceWidth;
    flowLayout.itemSize = CGSizeMake((self.view.bounds.size.width-4*SpaceWidth)/3, (self.view.bounds.size.width-4*SpaceWidth)/3);
    flowLayout.sectionInset = UIEdgeInsetsMake(SpaceWidth, SpaceWidth, SpaceWidth, SpaceWidth);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical; //竖直方法发动
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,20, self.view.bounds.size.width,self.view.bounds.size.height - 90) collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.bounces = YES;
    collectionView.backgroundColor = [UIColor brownColor];
    [collectionView registerNib:[UINib nibWithNibName:@"PictureItemCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"PictureItemCollectionViewCell"];
    self.pictureCollectionView = collectionView;
    [self.view addSubview:self.pictureCollectionView];
    
    
    
    //底部选中的图片展示
    UICollectionViewFlowLayout *bottomflowLayout = [[UICollectionViewFlowLayout alloc] init];
    bottomflowLayout.minimumInteritemSpacing = SpaceWidth/2;
    bottomflowLayout.minimumLineSpacing = SpaceWidth/2;
    bottomflowLayout.itemSize = CGSizeMake(75, 75);
    bottomflowLayout.sectionInset = UIEdgeInsetsMake(SpaceWidth/2, SpaceWidth/2, SpaceWidth/2, SpaceWidth/2);
    bottomflowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal; //水平方法发动
    
    UICollectionView *bottomCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,self.view.bounds.size.height - 90, self.view.bounds.size.width, 80) collectionViewLayout:bottomflowLayout];
    bottomCollectionView.delegate = self;
    bottomCollectionView.dataSource = self;
    bottomCollectionView.backgroundColor = [UIColor whiteColor];
    [bottomCollectionView registerNib:[UINib nibWithNibName:@"PictureItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PictureItemCollectionViewCell"];
    self.bottomCollectionView = bottomCollectionView;
    [self.view addSubview:self.bottomCollectionView];
    
    
    __weak __typeof(&*self) blockSelf = self;
    [self getAllPictureFromLibrary:_dataSource dataOver:^(BOOL stop) {
        if (stop) {
            //需要把第一个位置上防止的图片是照相的图片
            UIImage *image = [UIImage imageNamed:@"camera.png"];
            [blockSelf.dataSource insertObject:image atIndex:0];
            NSLog(@"_dataSource = %lu",(unsigned long)_dataSource.count);
            [blockSelf.pictureCollectionView reloadData];
        }
    }];

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

/**
 *  获取相册中的所有图片
 *
 *  @param mArr 传入存放相册的数组
 *  @param over 获取完成之后的 block回调
 */
- (void)getAllPictureFromLibrary:(NSMutableArray *)mArr dataOver:(getOver)over {
    
    //异步获取相册中的图片
    dispatch_async(dispatch_get_main_queue(), ^{
        ALAssetsLibraryAccessFailureBlock failBlock = ^(NSError *error) {
            NSLog(@"相册访问失败 =%@", [error localizedDescription]);
            if ([error.localizedDescription rangeOfString:@"Global denied access"].location != NSNotFound) {
                NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
            }else{
                NSLog(@"相册访问失败.");
            }
        };
        
        ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index, BOOL *stop){
            if (result!=NULL) {
                if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                    UIImage *image = [UIImage imageWithCGImage:result.thumbnail];
                    [mArr addObject:image];
                    if (index == photesCout-1) {
                        over(YES);
                    }
                }
            }
        };
        
        ALAssetsLibraryGroupsEnumerationResultsBlock libraryGroupEnumerAtion = ^(ALAssetsGroup *group, BOOL *stop) {
            if (group != nil) {
                NSLog(@"ALAssetsGroup group = %@",group);
                photesCout = group.numberOfAssets;
                [group enumerateAssetsUsingBlock:groupEnumerAtion];
            }
        };
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:libraryGroupEnumerAtion failureBlock:failBlock];
    });
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.pictureCollectionView) {
        return CGSizeMake((self.view.bounds.size.width-4*SpaceWidth)/3, (self.view.bounds.size.width-4*SpaceWidth)/3);
    } else {
        return CGSizeMake(75, 75);
    }
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (collectionView == self.pictureCollectionView) {
        return UIEdgeInsetsMake(SpaceWidth, SpaceWidth, SpaceWidth, SpaceWidth);
    } else {
        return UIEdgeInsetsMake(SpaceWidth/2, SpaceWidth/2, SpaceWidth/2, SpaceWidth/2);
    }
}

#pragma mark -- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.pictureCollectionView) {
        return self.dataSource.count;
    } else {
        return self.bottomDataSource.count;
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.pictureCollectionView) {
        PictureItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PictureItemCollectionViewCell class]) forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PictureItemCollectionViewCell" owner:self options:nil] lastObject];
        }
        cell.picImageView.image = self.dataSource[indexPath.row];
        
        return cell;
    } else {
        PictureItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PictureItemCollectionViewCell class]) forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PictureItemCollectionViewCell" owner:self options:nil] lastObject];
        }
        cell.picImageView.image = self.bottomDataSource[indexPath.row];
        
        return cell;
    }
}

#pragma mark -- UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.pictureCollectionView) {
        //展示相册的图片
        if (indexPath.row == 0) {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ) {
                NSLog(@"照相机不可以用");
                return;
            }
            //选择的相机拍照
            UIImagePickerController *camera = [[UIImagePickerController alloc] init];
            camera.delegate = self;
            camera.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:camera animated:YES completion:nil];
        } else {
            //选着的是图片
            [self.bottomDataSource addObject:self.dataSource[indexPath.row]];
            [self.bottomCollectionView insertItemsAtIndexPaths:@[([NSIndexPath indexPathForRow:self.bottomDataSource.count-1 inSection:0])]];
        }
    } else {
        //移除底部的图片
        [self.bottomDataSource  removeObjectAtIndex:indexPath.row];
        [self.bottomCollectionView deleteItemsAtIndexPaths:@[(indexPath)]];
    }

}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image && [image isKindOfClass:[UIImage class]]) {
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);//讲图片存入相册
        [self.dataSource addObject:image];
        [self.bottomDataSource addObject:image];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        [self.bottomCollectionView insertItemsAtIndexPaths:@[([NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0])]];
        [self.bottomCollectionView insertItemsAtIndexPaths:@[([NSIndexPath indexPathForRow:self.bottomDataSource.count-1 inSection:0])]];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}





@end
