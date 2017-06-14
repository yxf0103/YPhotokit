//
//  YPKImageScannerCell.m
//  DemoPhotoKit
//
//  Created by yxf on 2017/6/14.
//  Copyright © 2017年 yxf. All rights reserved.
//

#import "YPKImageScannerCell.h"
#import "YPKImageModel.h"

@interface YPKImageScannerCell ()<UIScrollViewDelegate>

/** bgScrollView*/
@property(nonatomic,weak)UIScrollView *bgScrollView;

/** image*/
@property(nonatomic,weak)UIImageView *imageView;

@end

@implementation YPKImageScannerCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIScrollView *bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64 - 10)];
        [self.contentView addSubview:bgScrollView];
        bgScrollView.maximumZoomScale = 2.0;
        bgScrollView.bouncesZoom = YES;
        bgScrollView.delegate = self;
        bgScrollView.showsVerticalScrollIndicator = NO;
        bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView = bgScrollView;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:bgScrollView.bounds];
        [bgScrollView addSubview:imageView];
        _imageView = imageView;    
    }
    return self;
}

-(void)setModel:(YPKImageModel *)model{
    _model = model;
    _imageView.image = model.image;
    _bgScrollView.zoomScale = 1.0;
}

-(void)resetImage:(UIImage *)bigImage{
    _imageView.image = bigImage;
}

#pragma mark - UIScrollViewDelegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}




@end
