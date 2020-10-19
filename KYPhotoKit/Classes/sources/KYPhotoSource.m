//
//  KYPhotoSource.m
//  KYPhotoKit
//
//  Created by yxf on 2020/10/19.
//

#import "KYPhotoSource.h"

@implementation KYPhotoSource

-(instancetype)initWithImg:(UIImage *)image{
    if (self = [super init]) {
        _image = image;
    }
    return self;
}

@end
