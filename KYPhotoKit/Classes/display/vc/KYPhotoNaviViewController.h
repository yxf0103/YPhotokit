//
//  KYPhotoNaviViewController.h
//  KYPhotoKit
//
//  Created by yxf on 2018/5/4.
//

#import <UIKit/UIKit.h>

@class KYPhotoNaviViewController,KYAssetviewModel,KYAsset;
@protocol KYImageScannerViewControllerDelegate;

@protocol KYPhotoNaviViewControllerDelegate <NSObject>

///查看图片详情
-(void)photoVc:(KYPhotoNaviViewController *)photoVc
         subVc:(id<KYImageScannerViewControllerDelegate>)subVc
   selectIndex:(NSInteger)index
     allAssets:(NSArray<KYAssetviewModel *> *)assets;

///发送图片
-(void)photoVc:(KYPhotoNaviViewController *)photoVc sendImgs:(NSArray<KYAsset *> *)imgArr;

@end

@interface KYPhotoNaviViewController : UINavigationController

@property (nonatomic,weak)id<KYPhotoNaviViewControllerDelegate> photoDelegate;

+(instancetype)photoNavicontroller;

@end
