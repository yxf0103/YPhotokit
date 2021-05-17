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
#import "KYPhotoBaseViewController.h"

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

@interface KYAssetsViewController : KYPhotoBaseViewController<KYPhotoLoadingDataProtocol,KYImageScannerViewControllerDelegate>

@property (nonatomic,weak)id<KYAssetsViewControllerDelegate> assetDelegate;
@property (nonatomic,weak,readonly)UICollectionView *assetCollectionView;
///全部图片
@property (nonatomic,strong,readonly)NSArray *assets;

-(instancetype)initWithAlbum:(KYAlbum *)album;

-(NSArray *)selectedArray;

@end
