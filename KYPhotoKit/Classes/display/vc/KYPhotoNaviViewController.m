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

/*appearance*/
@property (nonatomic,strong)UIColor *bgColor;

/*tint*/
@property (nonatomic,strong)UIColor *tintColor;

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

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tintColor = [UINavigationBar appearance].tintColor;
    self.bgColor = [UINavigationBar appearance].backgroundColor;
    [[UINavigationBar appearance] setBackgroundColor:[UIColor redColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UINavigationBar appearance] setBackgroundColor:self.bgColor];
    [[UINavigationBar appearance] setBarTintColor:self.tintColor];
}


@end
