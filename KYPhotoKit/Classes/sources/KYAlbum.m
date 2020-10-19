//
//  KYAlbum.m
//  KYPhotoKit
//
//  Created by yxf on 2018/5/3.
//

#import "KYAlbum.h"

@implementation KYAlbum

-(instancetype)init{
    return [self initWithAlbum:nil count:0 image:nil];
}

-(instancetype)initWithAlbum:(PHAssetCollection *)album
                       count:(NSInteger)count
                       image:(UIImage *)image{
    self = [super initWithImg:image];
    if (self) {
        self.count = count;
        self.album = album;
    }
    return self;
}

@end
