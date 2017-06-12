//
//  YPKAlbumModel.m
//  DemoPhotoKit
//
//  Created by yxf on 2017/6/12.
//  Copyright © 2017年 yxf. All rights reserved.
//

#import "YPKAlbumModel.h"

@implementation YPKAlbumModel

-(instancetype)init{
    return [self initWithAlbum:nil count:0 image:nil];
}

-(instancetype)initWithAlbum:(PHAssetCollection *)album
                       count:(NSInteger)count
                       image:(UIImage *)image{
    self = [super init];
    if (self) {
        self.count = count;
        self.album = album;
        self.coverImage = image;
    }
    return self;
}

@end
