//
//  YPKImageModel.h
//  DemoPhotoKit
//
//  Created by yxf on 2017/6/12.
//  Copyright © 2017年 yxf. All rights reserved.
//

#import <Foundation/Foundation.h>

//图片
@interface YPKImageModel : NSObject

/** asset*/
@property(nonatomic,strong)PHAsset *asset;

/** image,通过asset获取的一个大小为50*50的图片*/
@property(nonatomic,strong)UIImage *image;

/** image info 与asset关系不大*/
@property(nonatomic,strong)NSDictionary *imageInfo;

-(instancetype)initWithAsset:(PHAsset *)asset image:(UIImage *)image info:(NSDictionary *)info NS_DESIGNATED_INITIALIZER;

@end
