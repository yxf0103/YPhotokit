//
//  KYPhotoConfig.m
//  KYPhotoKit
//
//  Created by yxf on 2021/6/30.
//

#import "KYPhotoConfig.h"

@implementation KYPhotoConfig

+(instancetype)shareConfig{
    static dispatch_once_t onceToken;
    static KYPhotoConfig *config = nil;
    dispatch_once(&onceToken, ^{
        config = [[self alloc] init];
    });
    return config;
}

-(instancetype)init{
    if (self = [super init]) {
        _showEmptyAlbum = NO;
        _maxCount = 9;
        _doneTitle = @"发送";
    }
    return self;
}

-(void)setMaxCount:(NSInteger)maxCount{
    if (maxCount < 1) {
        return;
    }
    _maxCount = maxCount;
}

@end
