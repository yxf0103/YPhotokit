//
//  ViewController.m
//  DemoPhotoKit
//
//  Created by yxf on 2017/6/12.
//  Copyright © 2017年 yxf. All rights reserved.
//

#import "YPKImagesViewController.h"
#import "YPKManager.h"
#import "YPKImageModel.h"
#import "YPKAlbumModel.h"
#import "YPKImageCell.h"
#import "YPKImageViewController.h"

@interface YPKImagesViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

/** image collection*/
@property(nonatomic,weak)UICollectionView *collectionView;

/** photos*/
@property(nonatomic,strong)NSMutableArray *images;

/** album*/
@property(nonatomic,strong)YPKAlbumModel *album;

@end

@implementation YPKImagesViewController

+(instancetype)initWithAlbum:(YPKAlbumModel *)album{
    YPKImagesViewController *vc = [[YPKImagesViewController alloc] init];
    if (vc) {
        vc.album = album;
    }
    return vc;
}

-(void)dealloc{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel:)];
    self.navigationItem.title = self.album.album.localizedTitle ? self.album.album.localizedTitle : @"我的相册";
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat length = (SCREENWIDTH - 20) / 3.0;
    layout.itemSize = CGSizeMake(length, length);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    UICollectionView *collectionview = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                                          collectionViewLayout:layout];
    collectionview.backgroundColor = [UIColor whiteColor];
    collectionview.delegate = self;
    collectionview.dataSource = self;
    [collectionview registerClass:[YPKImageCell class] forCellWithReuseIdentifier:ImageCellIdentifier];
    [self.view addSubview:collectionview];
    _collectionView = collectionview;
    
    [self.view bringSubviewToFront:self.indicatorView];
    
    YPKWeakSelf;
    [YPKManager checkAuthorizedStatus:^(PHAuthorizationStatus status) {
        switch (status) {
            case PHAuthorizationStatusDenied:
                [weakSelf photoAuthorizationStatusDenied];
                break;
            case PHAuthorizationStatusAuthorized:
                [weakSelf photoAuthorizationStatusAuthorized];
                break;
            case PHAuthorizationStatusNotDetermined:
                [weakSelf photoAuthorizationStatusNotDetermined];
                break;
            default:
                break;
        }
    }];
    
}


-(IBAction)cancel:(id)sender{
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - images
-(void)photoAuthorizationStatusDenied{
    [self.indicatorView stopAnimating];
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"请在设置里开启相册访问权限"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
    [alertview show];
}

-(void)photoAuthorizationStatusAuthorized{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (self.album) {
            YPKWeakSelf;
            [YPKManager getAlbum:self.album
                      completion:^(NSArray<YPKImageModel *> *images, NSError *error) {
                          [weakSelf.indicatorView stopAnimating];
                          weakSelf.images = [NSMutableArray arrayWithArray:images];
                          [weakSelf.collectionView reloadData];
                      }];
        }else{
            NSArray<YPKImageModel *> *images = [[YPKManager shareInstance] getNormalImagesWithUnitSize:CGSizeMake(80, 80)];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.indicatorView stopAnimating];
                self.images = [NSMutableArray arrayWithArray:images];
                [self.collectionView reloadData];
            });
        }
    });
    
}

-(void)photoAuthorizationStatusNotDetermined{
    YPKWeakSelf;
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            [weakSelf photoAuthorizationStatusAuthorized];
        }
    }];
}


#pragma mark - UICollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YPKImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImageCellIdentifier
                                                                   forIndexPath:indexPath];
    cell.model = self.images[indexPath.item];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _images.count;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    YPKImageViewController *vc = [[YPKImageViewController alloc] init];
    vc.images = self.images;
    vc.currentIndex = indexPath.item;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
