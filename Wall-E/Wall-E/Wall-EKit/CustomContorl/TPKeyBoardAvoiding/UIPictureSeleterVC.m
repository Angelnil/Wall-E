//
//  UIPictureSeleterVC.m
//  Wall-E
//
//  Created by Angle_Yan on 15/6/5.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

#import "UIPictureSeleterVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PictureItemCollectionViewCell.h"


typedef void(^getOver)(BOOL stop) ;

@interface UIPictureSeleterVC () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *bottomDataSource;

@end


@implementation UIPictureSeleterVC

static NSInteger photesCout = 0;
#define SpaceWidth 5

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.dataSource = [[NSMutableArray alloc] init];
    self.bottomDataSource = [[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view.
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(self.view.bounds.size.width/3, self.view.bounds.size.width/3);
    flowLayout.minimumInteritemSpacing = SpaceWidth;
    flowLayout.minimumLineSpacing = SpaceWidth;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical; //竖直方法发动
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height - 80) collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PictureItemCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass([PictureItemCollectionViewCell class])];
    collectionView.backgroundColor = [UIColor clearColor];
    self.pictureCollectionView = collectionView;
    [self.view addSubview:self.pictureCollectionView];
    
//    //底部显示选择的图片 ScrollView
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(collectionView.frame), self.view.bounds.size.width, 80)];
//    scrollView.backgroundColor = [UIColor grayColor];
//    self.bottomScrollView = scrollView;
//    [self.view addSubview:self.bottomScrollView];
    
    UICollectionViewFlowLayout *bottomflowLayout = [[UICollectionViewFlowLayout alloc] init];
    bottomflowLayout.itemSize = CGSizeMake(80, 80);
    bottomflowLayout.minimumInteritemSpacing = SpaceWidth;
    bottomflowLayout.minimumLineSpacing = SpaceWidth;
    bottomflowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal; //水平方法发动
    
    UICollectionView *bottomCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height - 80) collectionViewLayout:flowLayout];
    bottomCollectionView.delegate = self;
    bottomCollectionView.dataSource = self;
    [bottomCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PictureItemCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass([PictureItemCollectionViewCell class])];
    bottomCollectionView.backgroundColor = [UIColor clearColor];
    self.bottomCollectionView = bottomCollectionView;
    [self.view addSubview:self.bottomCollectionView];

    
    __weak __typeof(&*self) blockSelf = self;
    [self getAllPictureFromLibrary:_dataSource dataOver:^(BOOL stop) {
        if (stop) {
            //需要把第一个位置上防止的图片是照相的图片
            UIImage *image = [UIImage imageNamed:@"camera.png"];
            [blockSelf.dataSource insertObject:image atIndex:0];
            NSLog(@"_dataSource = %@",_dataSource);
            [blockSelf.pictureCollectionView reloadData];
        }
    }];
    
}


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
                    NSLog(@"ALAsset result = %@",result);
//                    NSString *urlstr=[NSString stringWithFormat:@"%@",result.defaultRepresentation.url];//图片的url
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.pictureCollectionView) {
        return self.dataSource.count;
    } else {
        return self.bottomDataSource.count;
    }
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (collectionView == self.pictureCollectionView) {
        return UIEdgeInsetsMake(SpaceWidth, SpaceWidth, SpaceWidth, SpaceWidth);
    } else {
        return UIEdgeInsetsMake(SpaceWidth/2, SpaceWidth/2, SpaceWidth/2, SpaceWidth/2);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.pictureCollectionView) {
        return CGSizeMake((self.view.bounds.size.width-SpaceWidth*4)/3, (self.view.bounds.size.width-SpaceWidth*4)/3);
    } else {
        return CGSizeMake(80, 80);
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.pictureCollectionView) {
        PictureItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PictureItemCollectionViewCell class]) forIndexPath:indexPath];
        cell.picImageView.image = self.dataSource[indexPath.row];
        
        return cell;
    } else {
        PictureItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PictureItemCollectionViewCell class]) forIndexPath:indexPath];
        cell.picImageView.image = self.bottomDataSource[indexPath.row];
        
        return cell;
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (collectionView == self.pictureCollectionView) {
        //展示相册的图片
        if (indexPath.row == 0) {
            //选择的相机拍照
            UIImagePickerController *camera = [[UIImagePickerController alloc] init];
            camera.delegate = self;
            camera.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:camera animated:YES completion:nil];
        } else {
            //选着的是相册
            
            
            
        }
    } else {
        //
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
        [self.pictureCollectionView insertItemsAtIndexPaths:@[([NSIndexPath indexPathForRow:0 inSection:0])]];
        [self.bottomCollectionView insertItemsAtIndexPaths:@[([NSIndexPath indexPathForRow:0 inSection:0])]];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
