//
//  KYAssetCell.m
//  KYPhotoKit
//
//  Created by yxf on 2018/5/4.
//

#import "KYAssetCell.h"
#import "KYAsset.h"
#import "KYTagBtn.h"
#import "KYAsset+Action.h"
#import "KYPhotoSourceTool.h"
#import "UIImage+SYExtension.h"

NSString * const KYAssetCellIdentifier = @"KYAssetCellIdentifier";

@interface KYAssetCell (){
    CAShapeLayer *_maskLayer;
}

/*image*/
@property (nonatomic,weak)UIImageView *ky_imgView;

@property (nonatomic,weak)KYTagBtn *selectBtn;

@property (nonatomic,weak)UIView *cloudView;
@property (nonatomic,weak)UIButton *cloudBtn;
@property (nonatomic,weak)CALayer *loadingLayer;

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

-(void)addCloudview{
    UIView *cloudView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:cloudView];
    cloudView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    _cloudView = cloudView;
    
    UIButton *cloudBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cloudView addSubview:cloudBtn];
    UIImage *image = [KYPhotoSourceTool imageWithName:@"cloud-download" type:@"png"];
    [cloudBtn setImage:image forState:UIControlStateNormal];
    cloudBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    cloudBtn.frame = CGRectMake(0, 0, 40, 40);
    [cloudBtn addTarget:self action:@selector(cloudBtnClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    _cloudBtn = cloudBtn;
}

-(void)addLoadingLayer{
    CGFloat width = CGRectGetWidth(self.contentView.frame);
    CGFloat height = CGRectGetHeight(self.contentView.frame);
    
    CALayer *aniLayer = [CALayer layer];
    aniLayer.frame = _cloudView.bounds;
    [_cloudView.layer addSublayer:aniLayer];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width / 2.0, height / 2.0)
                                                        radius:15
                                                    startAngle:0
                                                      endAngle:2 *M_PI
                                                     clockwise:YES];
    //背景管道
    CAShapeLayer *bottomLayer = [CAShapeLayer layer];
    bottomLayer.path = path.CGPath;
    bottomLayer.fillColor = [UIColor clearColor].CGColor;
    bottomLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    bottomLayer.lineWidth = 2;
    bottomLayer.strokeStart = 0;
    bottomLayer.strokeEnd = 1.0;
    [aniLayer addSublayer:bottomLayer];
    
    //前景管道
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapeLayer.lineWidth = 2;
    shapeLayer.strokeStart = 0;
    shapeLayer.strokeEnd = 0.33;
    [aniLayer addSublayer:shapeLayer];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _ky_imgView.frame = self.contentView.bounds;
    _cloudView.frame = self.contentView.bounds;
    _cloudBtn.center = CGPointMake(CGRectGetWidth(_cloudView.frame) / 2,
                                   CGRectGetHeight(_cloudView.frame) / 2);
    _maskLayer.path = [UIBezierPath bezierPathWithRect:self.contentView.bounds].CGPath;
}

-(void)setAsset:(KYAsset *)asset{
    _asset = asset;
    __weak typeof(self) ws = self;
    asset.numChanged = ^(KYAsset * _Nonnull asset) {
        ws.selectBtn.number = asset.number;
    };
    asset.selectChanged = ^(KYAsset * _Nonnull asset) {
        !ws.bindSelectAction ? : ws.bindSelectAction(asset,asset.selected);
    };
    _asset.inCloudStatusChanged = ^(BOOL inCloud) {
        
    };
    _asset.thumImageChanged = ^(UIImage *image) {
        ws.ky_imgView.image = image;
    };
    _ky_imgView.image = _asset.thumImage ? : [UIImage defaultImage];
    _selectBtn.number = asset.number;
    if (!asset.inCloud) {
        [self hideLoadingLayer];
        _cloudView.hidden = YES;
        return;
    }
    if (_cloudView == nil) {
        [self addCloudview];
    }
    _cloudView.hidden = NO;
    if (asset.isLoading) {
        _cloudBtn.hidden = YES;
        [self showLoadingLayer];
        return;
    }
    [self hideLoadingLayer];
    _cloudBtn.hidden = NO;
}

//MARK: action
-(void)selectBtnClicked:(KYTagBtn *)btn{
    _asset.selected = !_asset.selected;
}

-(void)cloudBtnClicked:(UIButton *)btn{
    btn.hidden = YES;
    [self showLoadingLayer];
}

//MARK: custom func
-(void)showLoadingLayer{
    if (_loadingLayer == nil) {
        [self addLoadingLayer];
    }
    _loadingLayer.hidden = NO;
    CABasicAnimation *viewAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    viewAnimation.toValue = @(-M_PI * 2);
    viewAnimation.duration = 0.8;
    viewAnimation.repeatCount = MAXFLOAT;
    viewAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_loadingLayer addAnimation:viewAnimation forKey:@"z_animation"];
}

-(void)hideLoadingLayer{
    if (_loadingLayer == nil) {
        return;
    }
    _loadingLayer.hidden = YES;
    [_loadingLayer removeAnimationForKey:@"z_animation"];
}

@end

