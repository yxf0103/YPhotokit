//
//  KYAssetsViewController+Scanner.m
//  KYPhotoKit
//
//  Created by yxf on 2021/6/30.
//

#import "KYAssetsViewController+Scanner.h"
#import "KYScannerPresentModel.h"
#import "KYScannerImage.h"
#import "KYAsset+Action.h"
#import <objc/runtime.h>

const char present = 'p';

@interface KYAssetsViewController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic,strong)KYScannerPresentModel *presentModel;

@end

@implementation KYAssetsViewController (Scanner)

-(void)selectIndex:(NSInteger)index allAssets:(NSArray<KYAssetviewModel *> *)assets{
    NSMutableArray<KYScannerImage *> *scannerimgs = [NSMutableArray array];
    [assets enumerateObjectsUsingBlock:^(KYAssetviewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        KYScannerImage *image = [[KYScannerImage alloc] init];
        image.originImage = obj.asset.thumImage;
        image.originFrame = obj.originFrame;
        image.imgSelected = obj.asset.number > 0;
        image.asset = obj.asset;
        [scannerimgs addObject:image];
    }];
    KYImageScannerViewController *imgVc = [[KYImageScannerViewController alloc] init];
    imgVc.modalPresentationStyle = UIModalPresentationCustom;
    imgVc.transitioningDelegate = self;
    imgVc.modalPresentationCapturesStatusBarAppearance = YES;
    imgVc.scannerDelegate = self;
    imgVc.images = scannerimgs;
    imgVc.index = index;
    
    self.presentModel.touchFrame = scannerimgs[index].originFrame;
    self.presentModel.destFrame = scannerimgs[index].destFrame;
    self.presentModel.touchImage = scannerimgs[index].originImage;
    
    [self presentViewController:imgVc animated:YES completion:nil];
}

-(KYScannerPresentModel *)presentModel{
    KYScannerPresentModel * model = objc_getAssociatedObject(self, &present);
    if (!model) {
        model = [[KYScannerPresentModel alloc] init];
        model.modalType = KYScannerPresentPush;
        objc_setAssociatedObject(self, &present, model, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return model;
}

#pragma mark - UIViewControllerTransitioningDelegate
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return self.presentModel;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return self.presentModel;
}


@end
