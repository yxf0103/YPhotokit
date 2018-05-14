//
//  KYViewController.m
//  KYPhotoKit
//
//  Created by massyxf on 05/03/2018.
//  Copyright (c) 2018 massyxf. All rights reserved.
//

#import "KYViewController.h"
#import "KYPhotoNaviViewController.h"
#import "KYAssetsViewController.h"
#import "KYImageScannerViewController.h"
#import "KYScannerImage.h"
#import "KYAsset.h"
#import "KYScannerPresentModel.h"

@interface KYViewController ()<UIViewControllerTransitioningDelegate,KYPhotoNaviViewControllerDelegate>

/**/
@property (nonatomic,strong)KYScannerPresentModel *presentModel;

@end

@implementation KYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(showImages) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"相册" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor blueColor];
    btn.frame = CGRectMake(100, 200, 80, 30);

}

#pragma mark - getter
-(KYScannerPresentModel *)presentModel{
    if (!_presentModel) {
        _presentModel = [[KYScannerPresentModel alloc] init];
        _presentModel.modalType = KYScannerPresentPush;
    }
    return _presentModel;
}

-(void)showImages{
    KYPhotoNaviViewController *navi = [KYPhotoNaviViewController photoNavicontroller];
    navi.ky_delegate = self;
    [self presentViewController:navi animated:YES completion:nil];
}

#pragma mark - KYPhotoNaviViewControllerDelegate
-(void)assetsViewController:(KYAssetsViewController *)assetVc allAssets:(NSArray<KYAssetviewModel *> *)assets selectAssetAtIndex:(NSInteger)index{
    NSMutableArray *scannerimgs = [NSMutableArray array];
    [assets enumerateObjectsUsingBlock:^(KYAssetviewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        KYScannerImage *image = [[KYScannerImage alloc] init];
        image.originImage = obj.asset.image;
        image.originFrame = obj.originFrame;
        [scannerimgs addObject:image];
    }];
    KYImageScannerViewController *imgVc = [[KYImageScannerViewController alloc] init];
    imgVc.modalPresentationStyle = UIModalPresentationCustom;
    imgVc.ky_delegate = assetVc;
    imgVc.transitioningDelegate = self;
    imgVc.images = scannerimgs;
    imgVc.index = index;
    [assetVc.navigationController presentViewController:imgVc animated:YES completion:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return self.presentModel;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return self.presentModel;
}




@end
