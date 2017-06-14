//
//  YPKImageViewController.m
//  DemoPhotoKit
//
//  Created by yxf on 2017/6/12.
//  Copyright © 2017年 yxf. All rights reserved.
//

#import "YPKImageViewController.h"
#import "YPKImageScannerCell.h"
#import "YPKManager.h"
#import "YPKImageModel.h"

@interface YPKImageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

/** image view*/
@property(nonatomic,weak)UICollectionView *imageCollectionView;

/** progressLabel*/
@property(nonatomic,weak)UILabel *progressLabel;

@end

@implementation YPKImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(SCREENWIDTH + 10, SCREENHEIGHT - 64);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH + 10, SCREENHEIGHT - 64)
                                                               collectionViewLayout:layout];
    [self.view addSubview:imageCollectionView];
    imageCollectionView.dataSource = self;
    imageCollectionView.delegate = self;
    imageCollectionView.pagingEnabled = YES;
    [imageCollectionView registerClass:[YPKImageScannerCell class] forCellWithReuseIdentifier:ScannerCellIdentifier];
    _imageCollectionView = imageCollectionView;
    
    UIButton *originButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:originButton];
    [originButton setTitle:@"big image" forState:UIControlStateNormal];
    [originButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [originButton addTarget:self action:@selector(bigImage:) forControlEvents:UIControlEventTouchUpInside];
    originButton.frame = CGRectMake(20, SCREENHEIGHT - 60, 80, 40);
    
    UILabel *progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 64 + 20, 60, 40)];
    [self.view addSubview:progressLabel];
    _progressLabel = progressLabel;
    [self reloadProgressLabel];
    if (self.currentIndex < self.images.count && self.currentIndex >= 0) {
        [imageCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionNone
                                            animated:NO];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom func
-(void)reloadProgressLabel{
    _progressLabel.text = [NSString stringWithFormat:@"%zd/%zd",_currentIndex + 1,_images.count];
}

#pragma mark - action
-(IBAction)bigImage:(id)sender{
    if (_currentIndex>= 0 && _currentIndex < _images.count) {
        YPKImageModel *model = _images[_currentIndex];
        YPKImageScannerCell *cell = (YPKImageScannerCell *)[_imageCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_currentIndex inSection:0]];
        [cell resetImage:model.bigImage];
    }
}

#pragma mark - UICollectionViewDelegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YPKImageScannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ScannerCellIdentifier forIndexPath:indexPath];
    cell.model = _images[indexPath.item];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _images.count;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x + 5;
    NSInteger index = offsetX / (SCREENWIDTH + 10);
    _currentIndex = index;
    [self reloadProgressLabel];
    [_images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *indexPaths = [NSMutableArray array];
        if (idx != index) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
            [indexPaths addObject:indexPath];
        }
        [_imageCollectionView reloadItemsAtIndexPaths:indexPaths];
    }];
}


@end
