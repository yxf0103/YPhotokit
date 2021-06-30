//
//  KYAssetsViewController.h
//  KYPhotoKit
//
//  Created by yxf on 2018/5/4.
//

#import <UIKit/UIKit.h>
#import <KYPhotoKit/KYAlbum.h>
#import <KYPhotoKit/KYPhotoLoadingDataProtocol.h>
#import <KYPhotoKit/KYImageScannerViewController.h>
#import <KYPhotoKit/KYPhotoBaseViewController.h>

@class KYAsset;

@interface KYAssetviewModel : NSObject

/*origin frame in window(if equal to zero,it's not visible in window)*/
@property (nonatomic,assign)CGRect originFrame;

/*asset*/
@property (nonatomic,strong)KYAsset *asset;

@end

@interface KYAssetsViewController : KYPhotoBaseViewController<
KYPhotoLoadingDataProtocol,
KYImageScannerViewControllerDelegate>

@property (nonatomic,weak,readonly)UICollectionView *assetCollectionView;
///全部图片
@property (nonatomic,strong,readonly)NSArray *assets;

-(instancetype)initWithAlbum:(KYAlbum *)album;

-(NSArray *)selectedArray;

@end
