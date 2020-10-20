//
//  KYPhotoSource.m
//  KYPhotoKit
//
//  Created by yxf on 2020/10/19.
//

#import "KYPhotoSource.h"
#import "KYPhotoSourceCache+Memory.h"

@implementation KYPhotoSource{
    NSString *_imgId;
}

-(instancetype)initWithImg:(UIImage *)image identifier:(nonnull NSString *)identifier{
    if (self = [super init]) {
        _image = image;
        _imgId = identifier;
    }
    return self;
}

@end
