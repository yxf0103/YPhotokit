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
#import "KYPhotoSourceManager.h"

@interface KYViewController ()<UIViewControllerTransitioningDelegate,KYAssetsViewControllerDelegate>

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
    [[UIApplication sharedApplication] setStatusBarHidden:NO animated:UIStatusBarAnimationFade];
}

#pragma mark - getter
-(KYScannerPresentModel *)presentModel{
    if (!_presentModel) {
        _presentModel = [[KYScannerPresentModel alloc] init];
        _presentModel.modalType = KYScannerPresentPush;
    }
    return _presentModel;
}

#pragma mark - action
-(void)showImages{
    [KYPhotoSourceManager requestSystemPhotoLibAuth:^(PHAuthorizationStatus statu) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (statu == PHAuthorizationStatusAuthorized) {
                KYPhotoNaviViewController *navi = [KYPhotoNaviViewController photoNavicontroller];
                navi.modalPresentationStyle = UIModalPresentationFullScreen;
                navi.assetVc.assetDelegate = self;
                [self presentViewController:navi animated:YES completion:nil];
            }else{
                NSLog(@"相册未授权");
            }
        });
    }];
}

#pragma mark - KYAssetsViewControllerDelegate
-(void)assetsViewController:(KYAssetsViewController *)assetVc allAssets:(NSArray<KYAssetviewModel *> *)assets selectAssetAtIndex:(NSInteger)index{
    NSMutableArray<KYScannerImage *> *scannerimgs = [NSMutableArray array];
    [assets enumerateObjectsUsingBlock:^(KYAssetviewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        KYScannerImage *image = [[KYScannerImage alloc] init];
        image.originImage = obj.asset.thumImage;
        image.originFrame = obj.originFrame;
        [scannerimgs addObject:image];
    }];
    KYImageScannerViewController *imgVc = [[KYImageScannerViewController alloc] init];
    imgVc.modalPresentationStyle = UIModalPresentationCustom;
    imgVc.transitioningDelegate = self;
    imgVc.modalPresentationCapturesStatusBarAppearance = YES;
    imgVc.scannerDelegate = assetVc;
    imgVc.images = scannerimgs;
    imgVc.index = index;
    
    self.presentModel.touchFrame = scannerimgs[index].originFrame;
    self.presentModel.destFrame = scannerimgs[index].destFrame;
    self.presentModel.touchImage = scannerimgs[index].originImage;
    
    [assetVc presentViewController:imgVc animated:YES completion:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return self.presentModel;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return self.presentModel;
}




@end
