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


@interface KYAssetsViewController : UIViewController<KYPhotoLoadingDataProtocol,KYImageScannerViewControllerDelegate>

-(instancetype)initWithAlbum:(KYAlbum *)album;


@end
