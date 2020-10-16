//
//  KYAsset.h
//  KYPhotoKit
//
//  Created by yxf on 2018/5/3.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface KYAsset : NSObject

/** asset*/
@property(nonatomic,strong)PHAsset *asset;

/** image,通过asset获取的一个大小为50*50的图片*/
@property(nonatomic,strong)UIImage *image;

/** big image*/
@property(nonatomic,strong)UIImage *bigImage;

/** image info 与asset关系不大*/
@property(nonatomic,strong)NSDictionary *imageInfo;

///从icloud同步图片
@property (nonatomic,strong)void (^pullImageFromICloud)(KYAsset *asset,BOOL isBegin);
@property (nonatomic,assign,readonly)BOOL isInCloud;


-(instancetype)initWithAsset:(PHAsset *)asset
                       image:(UIImage *)image
                   isInCloud:(BOOL)isInCloud
                        info:(NSDictionary *)info NS_DESIGNATED_INITIALIZER;

@end
