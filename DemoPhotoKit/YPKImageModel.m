//
//  YPKImageModel.m
//  DemoPhotoKit
//
//  Created by yxf on 2017/6/12.
//  Copyright © 2017年 yxf. All rights reserved.
//

#import "YPKImageModel.h"
#import "YPKManager.h"
@implementation YPKImageModel

-(instancetype)init{
    return [self initWithAsset:nil image:nil info:nil ];
}

-(instancetype)initWithAsset:(PHAsset *)asset image:(UIImage *)image info:(NSDictionary *)info{
    self = [super init];
    if (self) {
        self.asset = asset;
        self.image = image;
        self.imageInfo = info;
    }
    return self;
}

-(UIImage *)bigImage{
    if (!_bigImage) {
        _bigImage = [YPKManager bigImage:self.asset];
    }
    return _bigImage;
}

@end
