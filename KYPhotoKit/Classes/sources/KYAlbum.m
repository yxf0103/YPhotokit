//
//  KYAlbum.m
//  KYPhotoKit
//
//  Created by yxf on 2018/5/3.
//

#import "KYAlbum.h"
#import "KYPhotoSourceManager.h"

@interface KYAlbum ()

@property(nonatomic,strong)PHAssetCollection *album;

@property (nonatomic,strong)UIImage *thumImage;

@end

@implementation KYAlbum

-(instancetype)init{
    return [self initWithAlbum:nil assets:nil];
}

-(instancetype)initWithAlbum:(PHAssetCollection *)album assets:(NSArray *)assets{
    self = [super init];
    if (self) {
        _album = album;
        _assets = assets;
    }
    return self;
}

-(UIImage *)thumImage{
    if (!_thumImage) {
        KYAsset *asset = _assets.firstObject;
        if (asset) {
            __weak typeof(self) ws = self;
            [KYPhotoSourceManager getThumImage:asset complete:^(UIImage * _Nullable image) {
                ws.thumImage = image;
                if (ws.thumImageChanged) {
                    ws.thumImageChanged(image);
                }
            }];
        }
    }
    return _thumImage;
}

-(NSString *)sourceId{
    return _album.localIdentifier;
}

-(NSInteger)count{
    return _assets.count;
}

@end
