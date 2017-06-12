//
//  YPKImageViewController.m
//  DemoPhotoKit
//
//  Created by yxf on 2017/6/12.
//  Copyright © 2017年 yxf. All rights reserved.
//

#import "YPKImageViewController.h"
#import "YPKImageCell.h"

@interface YPKImageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>



@end

@implementation YPKImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(SCREENWIDTH, SCREENHEIGHT - 64);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64)
                                                               collectionViewLayout:layout];
    [self.view addSubview:imageCollectionView];
    imageCollectionView.dataSource = self;
    imageCollectionView.delegate = self;
    [imageCollectionView registerClass:[YPKImageCell class] forCellWithReuseIdentifier:ImageCellIdentifier];
    
    if (self.images.count > 0 && self.currentIndex < self.images.count && self.currentIndex >= 0) {
        [imageCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YPKImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImageCellIdentifier forIndexPath:indexPath];
    cell.model = _images[indexPath.item];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _images.count;
}

@end
