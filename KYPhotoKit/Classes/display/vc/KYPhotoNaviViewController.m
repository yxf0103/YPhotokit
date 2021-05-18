//
//  KYPhotoNaviViewController.m
//  KYPhotoKit
//
//  Created by yxf on 2018/5/4.
//

#import "KYPhotoNaviViewController.h"
#import "KYAlbumsViewController.h"
#import "KYAssetsViewController.h"
#import "KYPhotoSourceManager.h"

@interface KYPhotoNaviViewController ()

@end

@implementation KYPhotoNaviViewController

+(instancetype)photoNavicontroller{
    KYAlbumsViewController *albumVc = [[KYAlbumsViewController alloc] init];
    KYPhotoNaviViewController *photoVc = [[KYPhotoNaviViewController alloc] initWithRootViewController:albumVc];
    KYAlbum *album = [KYPhotoSourceManager getMyCameraAlbum];
    KYAssetsViewController *assetVc = [[KYAssetsViewController alloc] initWithAlbum:album];
    [photoVc pushViewController:assetVc animated:NO];
    photoVc.assetVc = assetVc;
    return photoVc;
}

-(BOOL)prefersStatusBarHidden{
    UIViewController *topVC = self.topViewController;
    return [topVC prefersStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    UIViewController *topVC = self.topViewController;
    return [topVC preferredStatusBarStyle];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}




@end
