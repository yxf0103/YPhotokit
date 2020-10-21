//
//  KYAssetsViewController.h
//  KYPhotoKit
//
//  Created by yxf on 2018/5/4.
//

#import <UIKit/UIKit.h>
#import "KYAlbum.h"
#import "KYPhotoLoadingDataProtocol.h"
#import "KYImageScannerViewController.h"

@class KYAsset;

@interface KYAssetviewModel : NSObject

/*origin frame in window(if equal to zero,it's not visible in window)*/
@property (nonatomic,assign)CGRect originFrame;

/*asset*/
@property (nonatomic,strong)KYAsset *asset;

@end

@class KYAssetsViewController;
@protocol KYAssetsViewControllerDelegate<NSObject>

@optional
-(void)assetsViewController:(KYAssetsViewController *)assetVc
                  allAssets:(NSArray<KYAssetviewModel *> *)assets
         selectAssetAtIndex:(NSInteger)index;

@end

@interface KYAssetsViewController : UIViewController<KYPhotoLoadingDataProtocol,KYImageScannerViewControllerDelegate>

@property (nonatomic,weak)id<KYAssetsViewControllerDelegate> assetDelegate;


-(instancetype)initWithAlbum:(KYAlbum *)album;

@end
