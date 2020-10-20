//
//  KYAssetCell.m
//  KYPhotoKit
//
//  Created by yxf on 2018/5/4.
//

#import "KYAssetCell.h"
#import "KYAsset.h"
#import "KYPhotoSource+Display.h"
#import "KYTagBtn.h"

NSString * const KYAssetCellIdentifier = @"KYAssetCellIdentifier";

@interface KYAssetCell (){
    CAShapeLayer *_maskLayer;
}

/*image*/
@property (nonatomic,weak)UIImageView *ky_imgView;

@property (nonatomic,weak)KYTagBtn *selectBtn;

@end

@implementation KYAssetCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImageView *imgView = [[UIImageView alloc] init];
        [self.contentView addSubview:imgView];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        _ky_imgView = imgView;
        
        KYTagBtn *btn = [KYTagBtn tagBtn];
        [self.contentView addSubview:btn];
        btn.frame = CGRectMake(0, 0, 40, 40);
        [btn addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _selectBtn = btn;
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        self.contentView.layer.mask = layer;
        _maskLayer = layer;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _ky_imgView.frame = self.contentView.bounds;
    _maskLayer.path = [UIBezierPath bezierPathWithRect:self.contentView.bounds].CGPath;
    [_asset setImageToImgView:_ky_imgView];
}

-(void)setAsset:(KYAsset *)asset{
    _asset = asset;
    [asset setImageToImgView:_ky_imgView];
}

-(void)selectBtnClicked:(KYTagBtn *)btn{
    btn.selected = !btn.isSelected;
    btn.number = btn.isSelected;
}

@end

