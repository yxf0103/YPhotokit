//
//  KYAssetCell.m
//  KYPhotoKit
//
//  Created by yxf on 2018/5/4.
//

#import "KYAssetCell.h"
#import "KYAsset.h"

NSString * const KYAssetCellIdentifier = @"KYAssetCellIdentifier";

@interface KYAssetCell ()

/*image*/
@property (nonatomic,weak)UIImageView *ky_imgView;

@end

@implementation KYAssetCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImageView *imgView = [[UIImageView alloc] init];
        [self.contentView addSubview:imgView];
        _ky_imgView = imgView;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _ky_imgView.frame = self.contentView.bounds;
}

-(void)setAsset:(KYAsset *)asset{
    _asset = asset;
    _ky_imgView.image = asset.image;
}

@end

