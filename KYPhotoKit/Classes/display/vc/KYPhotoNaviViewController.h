//
//  KYPhotoNaviViewController.h
//  KYPhotoKit
//
//  Created by yxf on 2018/5/4.
//

#import <UIKit/UIKit.h>
#import "KYAssetsViewController.h"

@interface KYPhotoNaviViewController : UINavigationController

@property (nonatomic,weak)KYAssetsViewController *assetVc;

+(instancetype)photoNavicontroller;

@end
