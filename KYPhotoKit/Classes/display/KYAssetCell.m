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

@property (nonatomic,weak)UIButton *selectBtn;

@end

@implementation KYAssetCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImageView *imgView = [[UIImageView alloc] init];
        [self.contentView addSubview:imgView];
        _ky_imgView = imgView;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:btn];
        btn.frame = CGRectMake(0, 0, 40, 40);
        [btn addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _selectBtn = btn;
        
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

-(void)selectBtnClicked:(UIButton *)btn{
    
}

@end

