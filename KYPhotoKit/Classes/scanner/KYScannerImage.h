//
//  KYScannerImage.h
//  KYPhotoKit
//
//  Created by yxf on 2018/5/8.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <KYPhotoKit/KYAsset.h>

@interface KYScannerImage : NSObject

/*image*/
@property (nonatomic,strong)UIImage *originImage;

/*origin frame in window*/
@property (nonatomic,assign)CGRect originFrame;

/*destination frame in window*/
@property (nonatomic,assign,readonly)CGRect destFrame;

///选中状态
@property (nonatomic,assign)BOOL imgSelected;

///图片
@property (nonatomic,strong)KYAsset *asset;

@end
