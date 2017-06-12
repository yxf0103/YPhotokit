//
//  ViewController.m
//  DemoPhotoKit
//
//  Created by yxf on 2017/6/12.
//  Copyright © 2017年 yxf. All rights reserved.
//

#import "ViewController.h"
#import "YPKManager.h"
#import "YPKImageModel.h"
#import "YPKAlbumModel.h"
#import "YPKImageCell.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

/** image collection*/
@property(nonatomic,weak)UICollectionView *collectionView;

/** photos*/
@property(nonatomic,strong)NSMutableArray *images;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选择图片" style:UIBarButtonItemStyleDone target:self action:@selector(seePhotos:)];
    
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
}


-(IBAction)seePhotos:(id)sender{
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

#pragma mark - images
-(void)photoAuthorizationStatusDenied{
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"请在设置里开启相册访问权限"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
    [alertview show];
}

-(void)photoAuthorizationStatusAuthorized{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray<YPKImageModel *> *images = [[YPKManager shareInstance] getNormalImagesWithUnitSize:CGSizeMake(80, 80)];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.images = [NSMutableArray arrayWithArray:images];
            [self.collectionView reloadData];
        });
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

@end
