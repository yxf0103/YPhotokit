//
//  KYAlbum.m
//  KYPhotoKit
//
//  Created by yxf on 2018/5/3.
//

#import "KYAlbum.h"

@interface KYAlbum ()

@property(nonatomic,strong)PHAssetCollection *album;

@end

@implementation KYAlbum

-(instancetype)init{
    return [self initWithAlbum:nil];
}

-(instancetype)initWithAlbum:(PHAssetCollection *)album {
    self = [super init];
    if (self) {
        _album = album;
    }
    return self;
}

-(UIImage *)thumImage{
    return nil;
}

-(NSString *)sourceId{
    return _album.localIdentifier;
}

@end
