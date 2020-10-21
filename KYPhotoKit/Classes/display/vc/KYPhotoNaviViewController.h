//
//  KYPhotoNaviViewController.h
//  KYPhotoKit
//
//  Created by yxf on 2018/5/4.
//

#import <UIKit/UIKit.h>
#import "KYAssetsViewController.h"

@protocol KYPhotoNaviViewControllerDelegate<NSObject>

@optional
-(void)assetsViewController:(KYAssetsViewController *)assetVc
                  allAssets:(NSArray<KYAssetviewModel *> *)assets
         selectAssetAtIndex:(NSInteger)index;

@end

@interface KYPhotoNaviViewController : UINavigationController

/*delegate*/
@property (nonatomic,weak)id<KYPhotoNaviViewControllerDelegate> ky_delegate;

+(instancetype)photoNavicontroller;

@end
