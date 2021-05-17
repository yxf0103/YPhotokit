//
//  KYAsset.m
//  KYPhotoKit
//
//  Created by yxf on 2018/5/3.
//

#import "KYAsset.h"
#import "KYPhotoSourceManager.h"

@interface KYAsset ()

@property (nonatomic,strong)UIImage *thumImage;
@property (nonatomic,assign)BOOL inCloud;

@end

@implementation KYAsset

@synthesize thumImage = _thumImage;

-(instancetype)init{
    return [self initWithAsset:nil];
}

-(instancetype)initWithAsset:(PHAsset *)asset{
    self = [super init];
    if (self) {
        _asset = asset;
    }
    return self;
}

//MARK: setter
-(void)setInCloud:(BOOL)inCloud{
    if (_inCloud != inCloud) {
        _inCloud = inCloud;
        !_inCloudStatusChanged ? : _inCloudStatusChanged(inCloud);
    }
}

-(void)setThumImage:(UIImage *)thumImage{
    _thumImage = thumImage;
    !_thumImageChanged ? : _thumImageChanged(thumImage);
}


//MARK: getter
-(UIImage *)thumImage{
    if (!_thumImage) {
        KYPhotoSourceManager *manager = [KYPhotoSourceManager shareInstance];
        CGSize size = manager.smallSize;
        __weak typeof(self) ws = self;
        [KYPhotoSourceManager getLocalImage:self size:size complete:^(UIImage * _Nullable image) {
            if (image) {
                ws.thumImage = image;
                ws.inCloud = NO;
                return;
            }
            ws.inCloud = YES;
            [KYPhotoSourceManager getCloudImage:ws size:CGSizeMake(100, 100) complete:^(UIImage * _Nullable image) {
                ws.thumImage = image;
            }];
        }];
    }
    return _thumImage;
}


@end
