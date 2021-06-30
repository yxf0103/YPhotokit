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

///选择了图片
-(void)photoVc:(KYPhotoNaviViewController *)photoVc selectImgs:(NSArray<KYAsset *> *)imgArr;

@optional
///查看图片详情
-(void)photoVc:(KYPhotoNaviViewController *)photoVc
         subVc:(id<KYImageScannerViewControllerDelegate>)subVc
   selectIndex:(NSInteger)index
     allAssets:(NSArray<KYAssetviewModel *> *)assets;

@end

@interface KYPhotoNaviViewController : UINavigationController

@property (nonatomic,weak)id<KYPhotoNaviViewControllerDelegate> photoDelegate;

+(instancetype)photoNavicontroller;

@end
