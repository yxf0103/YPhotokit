//
//  KYAsset.h
//  KYPhotoKit
//
//  Created by yxf on 2018/5/3.
//

#import "KYPhotoSource.h"
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface KYAsset : KYPhotoSource

/** asset*/
@property(nonatomic,strong)PHAsset *asset;

/** image info 与asset关系不大*/
@property(nonatomic,strong)NSDictionary *imageInfo;

///从icloud同步图片
@property (nonatomic,assign,readonly)BOOL inCloud;
@property (nonatomic,copy)void (^inCloudStatusChanged)(BOOL inCloud);
@property (nonatomic,copy)void (^thumImageChanged)(UIImage *image);


-(instancetype)initWithAsset:(PHAsset *)asset; NS_DESIGNATED_INITIALIZER;

@end
